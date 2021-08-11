/*************************
Class: Candidate Record Alert
Purpose: Extension for VF page.  Collect email addresses and comments and send email template out with details from Candidate and Job Candidate (if valid)


Created: Mar 29/12 by Niki Vankerk, Vankerk Solutions, Inc
Modification Log:
         June 30/12, Niki Vankerk: changed to handle Candidates without a valid Job linked. 
         Mar 19/13, NV: add logic to use different set of templates if found job is Job Posting Only
         Mar 29/13: hard code Task to Jeff's user
         
*************************/
public class CandidateRecordAlerts {

    private final SFDC_Candidate__c can; // Candidate we are launched from
    private List<string> JobStatus;      // valid Job status list
    private List<string> notJCStatus;    // invalid Job Candidate status list
    private SFDC_Job_Candidate__c js {get; set;}  // candidate to be used when redirecting to CandidateAlerts page
    private Map<string, string> pageParms {get; set;} // track incoming page parameters
    // variables needed if we are going to run email off Candidate only
    private Id EmailWhatId {get; set;}  // set to either Candidate or Job Candidate if we have one
    private Id TemplateId {get; set;}
    public boolean TempMissing {get; set;}
    public string emailAddresses {get; set;}
    public string Comments {get; set;}
    private List<Contact> cons {get; set;}
    public boolean emailComplete {get; set;}
    private string lang {get; set;}    
    
    // set up variables
    public CandidateRecordAlerts (ApexPages.StandardController controller) {
        this.can = (SFDC_Candidate__c)controller.getRecord();
        // build list of valid statuses to use when searching for a Job Candidate record
        // EDIT HERE if you wish to change the valid statuses for either
        this.JobStatus = new string[]{'Candidates Sent/Awaiting Hire', 'Open/Active Job', 'Open/Active Job - Talent Connect',
            'Candidates Sent/Awaiting Hire for New Store', 'Open/Active Job for New Store', 'Additional Candidate(s) Required'};
        this.notJCStatus = new string[]{'Hired', 'Rejected'};
        
        // grab the page parameters to add to our redirect URL later
        pageParms = ApexPages.currentpage().getparameters();
        
        // start with empty records
        js = new SFDC_Job_Candidate__c();
        try {
            // query Job Candidate table for most recently modified candidate
            js = [select id, sfdc_job__c, sfdc_job__r.department__c, sfdc_job__r.OWF_Department__c, sla_level__c from SFDC_Job_Candidate__c where candidate__c = :can.id and
                sfdc_job__r.job_status__c in :JobStatus and status__c not in :notJCStatus order by lastmodifieddate desc limit 1];
            EmailWhatId = js.id;
        } catch (Exception e) {
            EmailWhatId = can.id;
        }
        
        emailAddresses = null;
        comments = null;
        cons = new List<Contact>();
        TemplateId = null;  
        emailComplete = false;
        // look for the template based on parameters in page 
        lang = UserInfo.getLanguage();
        string IdParm;
        // if we found a Job Candidate, look for regular template parameters
        if (js != null && js.id != null) {
            // if the found job sla is Job Posting Only, look for parameters with postingOnly
            if (js.sla_level__c == 'Job Posting Only')
                IdParm = ApexPages.currentpage().getparameters().get((lang == 'fr' ? 'FR_template_postonly' : 'template_postonly')); 
            // if we don't have the Id parameter set yet, try with the basic template, in case we didn't specify the Job Post only template correctly it won't fail
            if (IdParm == null)
                IdParm = ApexPages.currentpage().getparameters().get((lang == 'fr' ? 'FR_template' : 'template'));        
        // otherwise look for the NoJob parms
        } else
            IdParm = ApexPages.currentpage().getparameters().get((lang == 'fr' ? 'FR_NoJobTemplate' : 'NoJobTemplate'));
        List<EmailTemplate> temp = new List<EmailTemplate>();
        temp = [select id, name from EmailTemplate where id= :IdParm limit 1];
        tempMissing = false;
        if (temp.size() != 1)  {
            tempMissing = true;
        }   
        else TemplateId = temp[0].id;          
    }

    // fired from Send Email button on the VF page, we check for at least some email address.  then create a temp Contact for each address,
    //    send the emails, create a single task and then delete contacts
    public PageReference sendAlert() {

        try {
            // test that we have email addresses
            if (emailAddresses == null || emailAddresses == '' ) {
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, (lang == 'fr' ? 'Veuillez entrer au moins une adresse de courriel' : 'Please enter at least one email address')));
                return null;
            } // if no addresses entered
            // break out each address by the comma and create new basic Contacts
            string[] recip = emailAddresses.split(',', -1);
            // system.debug('recipients: '+recip);
            cons = new List<Contact>();
            for (string r : recip) {
                Cons.add(new Contact(email = r, lastname = r, description = comments));
            }
            insert Cons;
            // now cycle through each Contact to create a set of emails
            Messaging.SingleEmailMessage[] mails = new Messaging.SingleEmailMessage[]{};
            for (Contact c : Cons) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(templateId);
                mail.settargetobjectid(c.id);
                mail.setWhatId(EmailWhatid);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }

            //system.debug('mails being sent: '+mails);
            List<Messaging.SendEmailResult> res = Messaging.sendEmail( mails, false);
            if (!res[0].issuccess()) {
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, (lang == 'fr' ? 'Erreur survenue durant l’envoi du courriel de profil du candidat' : 'Error sending Candidate Profile email: ') 
                                                                                      +res[0].geterrors()[0].getmessage()));
                cleanupContacts();
                return null;
            }
            // create Task to record email if we have a Job Candidate matched - don't if we only have the Candidate Record
            if (js != null && js.id != null) {
                // find Jeff's user by email, else grab current user
                User u;
                try { u = [select id, username from User where username = 'jeff.summers@mindfieldgroup.ca']; }
                catch (Exception e) { u = [select id, username, contact.ownerid from User where id = :UserInfo.getUserId()]; }            
                Task t = new Task(whatid = js.id, subject = 'Email: '+mails[0].getSubject(), type = 'Outbound Email', 
                    description = 'Email sent to the following address(es): '+emailAddresses+'\n\n'+ mails[0].getplaintextbody(), 
                    status = 'Completed', activitydate = date.today());
                // if we found jeff, use him as owner
                if (u.username == 'jeff.summers@mindfieldgroup.ca')
                    t.ownerid = u.id;
                // if user is not a SF user, set owner to the contact's owner   
                else if (UserInfo.getUserType() != 'Standard')
                    t.ownerid = u.contact.ownerid;
                insert t;
                //system.debug('new task: '+t);
            } // if we are creating a task
            
            // delete the contacts now
            cleanupContacts();
            emailComplete = true;
            return null;
        } catch (Exception e) {
            cleanupContacts();
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, 'Error sending Candidate Alert email: '+e));
            return null;
        }
    
    }
    
    // helper method to delete any temporary Contact that was inserted for the email send
    private void cleanupContacts() {
        Cons = [select id from Contact where id in :cons];
        if (Cons.size() > 0) delete cons;
    }
    }