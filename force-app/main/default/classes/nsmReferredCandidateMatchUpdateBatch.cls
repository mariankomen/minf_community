//Project: New Service Model - Referred Candidates
//Date: August 2, 2017
//Author: Jeff Perron
//Description: Flag if referred candidate is matched with qualified candidate.
//Log Update:
//Sept 9, 2017 - Updated query to get jobs by closed not filled in addition to closed filled
         
//Update Jan 2018, this functionality is not required anymore.
//Removed from scheduledNewServiceModel 

global class nsmReferredCandidateMatchUpdateBatch implements Database.Batchable<sObject> {

    global nsmReferredCandidateMatchUpdateBatch() {
    
    }

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
       // get candidates and jobs associated with so we can compare, looking for referred candidate
       //just check jobs closed within the last 5 days
         String Query = 'SELECT ID, SFDC_Job__r.Specific_Candidate_Name__c, SFDC_Job__r.Specific_Candidate_Email__c, SFDC_Job__r.Specific_Candidate_Phone_Number__c, SFDC_Job__r.Specific_Candidate_Phone_Number_2nd__c, ' +
                        '       Candidate__r.Name, Candidate__r.SFDC_Candidate_Email__c, Candidate__r.Primary_Phone__c, Candidate__r.Secondary_Phone__c, ' +
                        '       SFDC_Job__r.Id, SFDC_Job__r.Job_Status__c, SFDC_Job__r.Date_Job_Filled__c, SFDC_Job__r.Date_Job_Not_Filled_by_Store__c ' + 
                        'FROM SFDC_Job_Candidate__c ' +
                        'WHERE (SFDC_Job__r.Date_Job_Filled__c=LAST_N_DAYS:5 OR SFDC_Job__r.Date_Job_Not_Filled_by_Store__c=LAST_N_DAYS:5) AND ' +
                        '      SFDC_Job__r.Using_New_Service_Model__c=true';
                                   
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List<SFDC_Job_Candidate__c> canlist) {
        Map<Id, List<SFDC_Job_Candidate__c>> m1 = new Map<Id, List<SFDC_Job_Candidate__c>>();
        
        m1 = BuildMap(canlist); //build map out
    
        for (String sKey : m1.keySet()) {
            FindCandidateMatchAndUpdate(m1.get(sKey)); //update as bulk job
        }
    }
     

    global void finish(Database.BatchableContext BC ) {
        // Logic to be Executed at finish
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                         TotalJobItems, CreatedBy.Email
                         FROM AsyncApexJob WHERE Id =: BC.getJobId()];

        if(a.NumberOfErrors>0) { //just send email if failure
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Referrence Candidate Match Update ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }
   
   //helper method to mass update found bulk jobs
   private void FindCandidateMatchAndUpdate(List<SFDC_Job_Candidate__c> canlist) {
          
       for (SFDC_Job_Candidate__c c : canlist) {
       
           //try matching on email
           if(!String.isEmpty(c.SFDC_Job__r.Specific_Candidate_Email__c) && !String.isEmpty(c.Candidate__r.SFDC_Candidate_Email__c) &&
              c.SFDC_Job__r.Specific_Candidate_Email__c.equalsIgnoreCase(c.Candidate__r.SFDC_Candidate_Email__c))
           {
               c.Referred_Candidate_Match__c=true;
           }
           //try matching on phone number, primary
           else if(!String.isEmpty(c.SFDC_Job__r.Specific_Candidate_Phone_Number__c) && !String.isEmpty(c.Candidate__r.Primary_Phone__c) &&
                   StripOnlyNumericFromPhone(c.SFDC_Job__r.Specific_Candidate_Phone_Number__c).equals(StripOnlyNumericFromPhone(c.Candidate__r.Primary_Phone__c))) 
           {
               c.Referred_Candidate_Match__c=true;
           }
           //try matching on phone number, secondary
           else if(!String.isEmpty(c.SFDC_Job__r.Specific_Candidate_Phone_Number_2nd__c) && !String.isEmpty(c.Candidate__r.Secondary_Phone__c) &&
                   StripOnlyNumericFromPhone(c.SFDC_Job__r.Specific_Candidate_Phone_Number_2nd__c).equals(StripOnlyNumericFromPhone(c.Candidate__r.Secondary_Phone__c))) 
           {
               c.Referred_Candidate_Match__c=true;
           }
           //try matching on name
           else if(!String.isEmpty(c.SFDC_Job__r.Specific_Candidate_Name__c) && !String.isEmpty(c.Candidate__r.Name) &&
                   FindFirstAndLastName(c.SFDC_Job__r.Specific_Candidate_Name__c).equalsIgnoreCase(FindFirstAndLastName(c.Candidate__r.Name)))
           {
               c.Referred_Candidate_Match__c=true;
           }
       }
       update canlist;
   }
   
   //group candidates by jobs for easy comparision
   private Map<Id, List<SFDC_Job_Candidate__c>> BuildMap(List<SFDC_Job_Candidate__c> canlist) {
       //build list of bulk jobs
        Map<Id, List<SFDC_Job_Candidate__c>> m1 = new Map<Id, List<SFDC_Job_Candidate__c>>();
    
        //loop through and candidates by job id 
        for (SFDC_Job_Candidate__c c : canlist) {
            if(!String.isEmpty(c.SFDC_Job__r.Specific_Candidate_Name__c)) { //if we have no name then dont bother trying to match
                //if we dont have key yet, create new job list and add job by key value
                if(!m1.containsKey(c.SFDC_Job__r.Id))
                {
                    List<SFDC_Job_Candidate__c> cl = new List<SFDC_Job_Candidate__c>();
                    cl.add(c);
                    m1.put(c.SFDC_Job__r.Id, cl);
                }
                else //found key, add to existing list
                {
                    m1.get(c.SFDC_Job__r.Id).add(c);
                }
            }
        }
        return m1;
   }
   
   //parse out middle name, just want first and last
   //eg: Spencer T. Fangman gives back SpencerFangman
   private String FindFirstAndLastName(String sName) {
       List<String> parts = sName.split(' ');
       return parts[0] + parts[parts.size()-1]; 
   }
   
   //parse out non numeric and take last 10 digits
   //eg: +1 (250) 5867728 gives back 2505867728
   private String StripOnlyNumericFromPhone(String sPhone) {
       String numericString = '';
       integer strLength = sPhone.length();
       
       for(integer i=0; i<sPhone.length(); i++) {
           String s= sPhone.mid(i,1);
           if(s.isNumeric()){
            numericString +=s;
           }
       }
       return numericString.right(10);
   }
   
}