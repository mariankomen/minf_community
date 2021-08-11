//Project: New Service Model - Bulk Job Recognition
//Date: August 2, 2017
//Author: Jeff Perron
//Description: Flag job as bulk if status is open or additional candidates required if 5 or more jobs and have same title, 
//             location, client with 7 consecutive days. 
         

global class nsmBulkJobRecognitionUpdateBatch implements Database.Batchable<sObject> {

    global nsmBulkJobRecognitionUpdateBatch() {
   
    }

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // get jobs created between start and end dates that are open or additonal candidates required
        String Query = 'SELECT ID, Name, Job_Status__c,Create_Date_Time__c, Job_Title_for_Role__c, Job_Title_for_Banner__c, Store__c, Record_Type_Developer_Name__c, recordtypeid, Bulk_Job__c, Using_New_Service_Model__c ' + 
                        'FROM SFDC_Job__c ' +
                        'WHERE Create_Date_Time__c=LAST_N_DAYS:7 AND ' +
                        '      Using_New_Service_Model__c=true AND ' +
                        '      (Job_Status__c LIKE \'Open/Active Job\' OR Job_Status__c LIKE \'Additional Candidate(s) Required\')';
                                   
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List<SFDC_Job__c> joblist) {
        Map<String, List<SFDC_Job__c >> m1 = new Map<String, List<SFDC_Job__c >>();
        
        m1 = BuildMap(joblist); //build map out
        
        for (String sKey : m1.keySet()) {
            //loop for 5 or more grouped jobs
            if(m1.get(sKey).Size() >= 5) {
                UpdateAsBulkJob(m1.get(sKey)); //update as bulk job
            }
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
            mail.setSubject('Job Bulk Update ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }
   
   //helper method to mass update found bulk jobs
   private void UpdateAsBulkJob(List<SFDC_Job__c> joblist) {
       for (SFDC_Job__c j : joblist) {
           j.Bulk_Job__c=true;
       }
       update joblist;
   }
   
   //helper method to find and group jobs considered as bulk
   private Map<String, List<SFDC_Job__c>> BuildMap(List<SFDC_Job__c> joblist) {
       //build list of bulk jobs
        Map<String, List<SFDC_Job__c>> m1 = new Map<String, List<SFDC_Job__c>>();
    
        //loop through and group jobs by location and job title 
        for (SFDC_Job__c j : joblist) {
        
            if(j.Store__c != null) { //should have store but if doesn't exclude, also using NSM
        
                if( //should have job title else dont include
                   (j.Record_Type_Developer_Name__c=='Marks' && !string.IsBlank(j.Job_Title_for_Role__c)) ||
                   (j.Record_Type_Developer_Name__c!='Marks' && !string.IsBlank(j.Job_Title_for_Banner__c))
                  ) {
        
                    string key = '';
            
                    if(j.Record_Type_Developer_Name__c=='Marks') //Marks uses different job title field
                    {
                        key = j.Job_Title_for_Role__c + j.Store__c;
                    }
                    else {
                        key = j.Job_Title_for_Banner__c + j.Store__c;
                    }
            
                    //if we dont have key yet, create new job list and add job by key value
                    if(!m1.containsKey(key))
                    {
                        List<SFDC_Job__c> jl = new List<SFDC_Job__c>();
                        jl.add(j);
                        m1.put(key, jl);
                    }
                    else //found key, add to existing list
                    {
                        m1.get(key).add(j);
                    }
                }        
            }        
        }
        return m1;
   }
   
}