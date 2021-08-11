/***************************
Class: BackCheck Email Handler
Description: processing emails coming in with Background Check details.  Carefully formed email is parsed for Candidate Name, Store Name and Background Check Results URL
    If a Candidate can be found by full name match, job store name match and under correct job type, update the most recent Candidate with URL and create task with email.
    Errors are sent to MFG email addresses with issue and attached email body.

Created: Jan 13/12, Vankerk Solutions
Modification log:
    June 5/12: updated Client/URL start/end labels for new email formatting, removed job record type filter for valid clients
    Jan 16/13: updates to test method for new system deploy
    Dec 4/13: updated start/end labels for new email formatting with *
    
***************************/
global class BackCheckEmailHandler implements Messaging.InboundEmailHandler {
      
      // ENGLISH start and end labels used to find details in the email body.  Change here if the body text is adjusted in the future
      static final string CANDIDATE_START_LABEL = 'The file you have submitted for *';
      static final string CANDIDATE_END_LABEL = '* is now';
      static final string CLIENT_START_LABEL = 'Location:* ';
      static final string CLIENT_END_LABEL = '\n';
      static final string URL_START_LABEL = 'View This Report:*\n';
      static final string URL_END_LABEL = '\n*View All Files';
      // FRENCH start and end labels used to find details in the email body.  Change here if the body text is adjusted in the future
      static final string CANDIDATE_START_LABEL_FR = 'Le dossier que vous avez soumis pour *';
      static final string CANDIDATE_END_LABEL_FR = '* est maintenant';
      static final string CLIENT_START_LABEL_FR = 'Adresse :* ';
      static final string CLIENT_END_LABEL_FR = '  *Contact';
      static final string URL_START_LABEL_FR = 'Voir ce rapport :*\n';
      static final string URL_END_LABEL_FR = '\n*Voir tous les dossiers';
      
      // method to search through text to find values between the provided start and end labels
      public static String getFieldValue(String plainTextBody, String startLabel, String endLabel) {
          Integer startPos = plainTextBody.indexOf(startLabel);
          Integer endPos = plainTextBody.indexOf(endLabel, startPos+startLabel.length());
          // if both positions were found, set return value
          string fValue;
          if (startPos > 0 && endPos > 0)
              fValue = plainTextBody.substring(startPos+startLabel.length(), endPos);
          //system.debug('field value: '+fvalue);
          return fValue;
      }
      
      public static Messaging.InboundEmail BCEmail {get; set;}
      // set of job record types that are valid for this backcheck processing - used when searching for candidates against jobs for these clients
      //  use full 18 character record type Id values here
      private static set<Id> ValidClients {get; set;}
      
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          BCEmail = email;
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          // pull required values out of the email body
          system.debug('incoming plain text body: '+email.plaintextbody);
          string CanName = getFieldValue(email.plainTextBody, CANDIDATE_START_LABEL, CANDIDATE_END_LABEL);
          // or remove * from search terms if blank
          if (CanName == null)
              CanName = getFieldValue(email.plainTextBody, CANDIDATE_START_LABEL.replace('*', ''), CANDIDATE_END_LABEL.replace('*', ''));
          // or look for french if blank
          if (CanName == null)
              CanName = getFieldValue(email.plainTextBody, CANDIDATE_START_LABEL_FR, CANDIDATE_END_LABEL_FR);
          
          string Store = getFieldValue(email.plainTextBody, CLIENT_START_LABEL, CLIENT_END_LABEL);
          // or remove * from search terms if blank
          if (Store == null) 
              Store = getFieldValue(email.plainTextBody, CLIENT_START_LABEL.replace('*', ''), CLIENT_END_LABEL.replace('*', ''));
          // or look for french if blank
          if (Store == null) {
              Store = getFieldValue(email.plainTextBody, CLIENT_START_LABEL_FR, CLIENT_END_LABEL_FR);
              // french email body in text puts a carriage return in the string so replace it with a space
              if (Store != null && Store.contains('\n'))
                  Store = Store.replace('\n', ' ');
          }
          
          string BCURL = getFieldValue(email.plainTextBody, URL_START_LABEL, URL_END_LABEL);
          // or remove * from search terms if blank
          if (BCURL == null)
              BCURL = getFieldValue(email.plainTextBody, URL_START_LABEL.replace('*', ''), URL_END_LABEL.replace('*', ''));
          // or look for french if blank
          if (BCURL == null)
              BCURL = getFieldValue(email.plainTextBody, URL_START_LABEL_FR, URL_END_LABEL_FR);
          
          // if we can't find CanName, Store or BCURL, go straight to exception with this error
          if (CanName == '' || Store == '' || BCURL == '' || CanName == null || Store == null || BCURL == null)
              sendError('Could not find a required piece of information from the attached email:\n\nCandidate Name: '+CanName+ '\nStore: '+store+'\nBackCheck URL: '+BCURL);
          // else call method to update Candidate BC URL
          else ProcessBackCheck(CanName, Store, BCURL);
          
          return result;
      }

    // method to take in a Candidate, Store and the URL and update the Candidate, adding a task with the email contents
    private static void ProcessBackCheck(string CanName, string Store, string BCURL){
        try {
            SFDC_Job_Candidate__c can;
            Id JobId;
            // cycle through JC where the candidate full name matches and store name from job matches, order by create date desc
            for (SFDC_Job_Candidate__c c : [select id, sfdc_job__c from SFDC_Job_Candidate__c where sfdc_job__r.store__r.Backcheck_Match_Name__c = :Store and candidate__r.name = :CanName
                                            and status__c != 'Rejected' and status__c != 'Hired' order by createddate desc]) {
                can = new SFDC_Job_Candidate__c(Background_Check_Results_URL__c = BCURL, id = c.id);
                JobId = c.sfdc_job__c;
                break;
            } // end loop
            // if we found a candidate, update it now
            if (can != null) {
                update can;
                // if we have a jobId, create a task with the email plain text body
                if (jobId != null) {
                    Task t = new Task(whatid = can.id, status = 'Completed', activitydate = date.today(), type = 'Other',
                                      subject = 'Background Check Results Email', description = BCEmail.plaintextbody);
                    insert t;
                }
            } // if we found a Candidate 
            else
                sendError('Could not find a matching Candidate at the specified store to update.  See attachment for details.\n\nCandidate Name: '+CanName+ '\nStore: '+store+' \nBackCheck URL: '+BCURL);
        } 
        catch (Exception e) {
            sendError('Unexpected error encountered when processing the attached Background Check Results email.  Error message: '+e.getstacktracestring()+ ': '+e);
        }
    }
       
    // function to create and send an email with error message, the BackCheck Email sent as HTML attachment  
    private static void sendError(string errorMsg){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // list email recipients here - look for custom setting
        Set<string> addys = BackCheckErrorEmail__c.getall().keyset();
        // move set of addresses into a list
        String[] toAddresses = new String[]{};
        toAddresses.addall(addys); 
        // if we didn't find any, default to Jeff
        if (toAddresses.size() == 0)
            toAddresses.add('jeff.summers@mindfieldgroup.com');
        mail.setToAddresses(toAddresses); 
        mail.setSubject('Salesforce BackCheck Processing Error');
        mail.setPlainTextBody(errorMsg);
        // create html attachment using the original email body if we have one
        if (BCEmail != null) {
            Messaging.EmailFileAttachment ebody = new Messaging.EmailFileAttachment();
            ebody.setbody(blob.valueof( BCEmail.htmlbody == null ? BCEmail.plaintextbody : BCEmail.htmlbody) );
            ebody.setcontenttype('text/html');
            ebody.setfilename('BackCheck Email body.htm');
            ebody.setinline(false);
          //  mail.setFileattachments(new Messaging.EmailFileAttachment[] {ebody});
            // create text attachment with plaintext
            Messaging.EmailFileAttachment ebody2 = new Messaging.EmailFileAttachment();
            ebody2.setbody(blob.valueof( BCEmail.plaintextbody) );
            ebody2.setcontenttype('text/plain');
            ebody2.setfilename('BackCheck Email body Plain Text.txt');
            ebody2.setinline(false);
            mail.setFileattachments(new Messaging.EmailFileAttachment[] {ebody, ebody2});            
        }
        // send the message
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    

  }