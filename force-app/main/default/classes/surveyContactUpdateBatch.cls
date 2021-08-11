//Project: Q4 ROCK, customer survey
//Date: Oct 2018
//Author: Jeff Perron
//Description: Updates new contact field, Contact.Portal_User_Last_Login__c, with what we have in user.
// This allows us to filter contactsfor mass emails.
         

global class surveyContactUpdateBatch implements Database.Batchable<sObject> {

    global surveyContactUpdateBatch() {
   
    }

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // get all active contacts who have logged into the system
        String Query = 'SELECT ID, LastLoginDate, ContactId, HM_Portal_Language__c ' + 
                        'FROM User ' +
                        'WHERE ContactId<>NULL AND LastLoginDate<>NULL AND IsActive=true' +
                               (Test.isRunningTest() ? ' LIMIT 200' : '');
                                   
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List<User> userlist) {
        List<Contact> clToUpdate = new List<Contact>();
        
        for (User u : userlist) { //loop throught results and set last login on contact
            clToUpdate.Add(new Contact(Id=u.ContactId, Portal_User_Last_Login__c=u.LastLoginDate, Portal_User_Language__c=u.HM_Portal_Language__c));
        }
        
        if(clToUpdate.Size() > 0) { //update
            update clToUpdate;
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
            mail.setSubject('Contact Last Login Bulk Update ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }
   
   
}