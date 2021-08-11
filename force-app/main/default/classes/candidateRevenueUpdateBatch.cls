//Project: ER 00184048, Candidate Revenue Update
//Date: July 2
//Author: Jeff Perron
//Description: Candidate revenue value is only entered when candidate is hired. 
//             We need a mechanism so this will be updated incase a target volume changes sometime between hire and recruiter bonus calc. 
         

global class candidateRevenueUpdateBatch implements Database.Batchable<sObject> {

    global candidateRevenueUpdateBatch() {
   
    }

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //get all candidates hired within the last 60 days
        String Query = 'SELECT ID, Datetime_Candidate_Hired__c, Revenue_Earned__c, Status__c, SFDC_Job__c, SFDC_Job__r.Record_Type_Developer_Name__c ' + 
                        'FROM SFDC_Job_Candidate__c ' +
                        'WHERE Status__c=\'Hired\' AND Datetime_Candidate_Hired__c=LAST_N_DAYS:60';
                                   
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List<SFDC_Job_Candidate__c> jclist) {
        List<SFDC_Job_Candidate__c> jcToUpdate = new List<SFDC_Job_Candidate__c>();
               
        for (SFDC_Job_Candidate__c jc : jclist) { //loop throught results and revenue
            //find latest target volume
            decimal dPrice = NewServiceModel_Util.FindTargetVolumePrice(jc.SFDC_Job__c, jc.Datetime_Candidate_Hired__c, (jc.SFDC_Job__r.Record_Type_Developer_Name__c=='FGL_Sports'));
            
            //if value not the same, update
            if(dPrice<>jc.Revenue_Earned__c) {
                jcToUpdate.Add(new SFDC_Job_Candidate__c(Id=jc.Id, Revenue_Earned__c=dPrice));
            }
        }
        
        if(jcToUpdate.Size() > 0) { //update
            update jcToUpdate;
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
            mail.setSubject('Recruiter revenue earned ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }
   
   
}