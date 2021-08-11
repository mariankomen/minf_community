/*******************************
Class: Candidate Sharing Recalc Last hour
Purpose: This class is a batch class to calculate sharing for candidates that have been modified in the last hour.

Created: Feb 6/12 by Niki Vankerk, Vankerk Solutions, Inc
Modification Log:
          Jan 27/2013: No longer need sharing so have commented out method call- can delete class anytime.

**********************************/
global class CandidateSharingRecalcLastHour implements Database.Batchable<sObject> {
    
    // The start method is called at the beginning of a sharing recalculation.  
    // This methods returns a SOQL query locator containing the records to be recalculated.  
    // This method must be global.  
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        datetime hrAgo = datetime.now().addhours(-9); // 8 hours for GMT plus 1 more to go an hour back.
        //system.debug('hr ago is: '+hrago);
        return Database.getQueryLocator([SELECT Id FROM SFDC_Candidate__c where portal_accounts_linked__c = 'Yes' and lastmodifieddate > :hrAgo]);  
    }
    
    // The executeBatch method is called for each chunk of records returned from start.    
    // This method must be global.  
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try {
            // Create a map for the chunk of records passed into method.  
            //system.debug('starting batch with scope size: '+scope.size()+' and records: '+scope);
            Map<ID, SFDC_Candidate__c> canMap = new Map<ID, SFDC_Candidate__c>((List<SFDC_Candidate__c>)scope);  
            Set<Id> canIds = canMap.keyset();
            // call job util method to create Candidate sharing
            //Job_Util.CreateCandidateSharing(canIds);
        
        } catch(Exception e) {
           // Send an email to the Apex job's submitter on failure.  
            emailHelper('MFG Apex Candidate Sharing Recalculation Error', 'The Apex Candidate sharing recalculation threw the following exception: ' + 
                        e.getstacktracestring() +', '+e);
        }
    }
    
    // The finish method is called at the end of a sharing recalculation.  
    // This method must be global.  
    
    global void finish(Database.BatchableContext BC){  
        // Send an email to the Apex job's submitter notifying of job completion.  
        //emailHelper('MFG Apex Candidate Sharing Recalculation Completed', 'The Apex sharing recalculation finished processing');
    }
    
    // helper method for sending error or completion email
    private void emailHelper(string emailSubject, string emailBody) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'niki@vankerksolutions.com'}; 
        mail.setToAddresses(toAddresses); 
        mail.setSubject('MFG Apex Job Sharing Recalculation');
        mail.setPlainTextBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }    
}