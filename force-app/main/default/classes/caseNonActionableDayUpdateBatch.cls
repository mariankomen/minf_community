// Enhancement: Add Actionable Days
//Date: August 15th, 2017
//Author: Justin Medwid and Jami Silzer
//Description: Scheduled Job to update Case Field "NonActionable Days" when a job is in status "on hold" or it is a weekend

global class caseNonActionableDayUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        // Generate your string query on any object here with limit 10000
        
        Date d = System.today();
        Datetime dt = (DateTime)d;
        String dayOfWeek = dt.format('EEEE'); //Monday, Tuesday, Wednesday, etc.
        //get current date of week
        
        String Query = '';
        
        //Take this out for now....just grab items on hold
        //if(dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday') {
        //    Query = 'SELECT ID, Actionable_Days__c FROM Case WHERE status != \'Closed\' AND RecordTypeId = \'012U00000009elZ\'';
            //query for saturday and sundays where tickets are open and belong to mfg helpdesk
        //} else {
            //query for on hold tickets and belong to mfg helpdesk
            Query = 'SELECT ID, NonActionable_Days__c FROM Case WHERE status = \'On Hold\' AND RecordTypeId = \'012U00000009elZ\'';
        //}
             
    
         
         return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Case> caselist) {
    
         for (Case cUpdate : caselist) {
             Decimal checkNull = cUpdate.NonActionable_Days__c;
              If(checkNull == null) {
                  checkNull = 0.00;    
                  //Nonactionable days of case is checked and if null, it is turned into a 0        
              }
            cUpdate.NonActionable_Days__c = checkNull + 1;
            //increment of nonactionable days of case
         }
         update caselist;
    }
    
     global void finish(Database.BatchableContext BC ) {}
     
}