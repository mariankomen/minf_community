// Enhancement: Add Days in lieu to jobs

global class Job_DaysInLieuUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
 
        
        //query for jobs
        String Query = 'SELECT ID, Name, Days_In_Lieu__c ' + 
                        'FROM SFDC_Job__C ' +
                        'WHERE Job_In_Lieu_Checkbox__c = TRUE'; 
                                                               
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    
      global void execute(Database.BatchableContext BC, List<SFDC_Job__c> joblist) {
        //update jobs
        for (SFDC_Job__c jUpdate : joblist) {
            Decimal checkNull = jUpdate.Days_In_Lieu__c;
            If(checkNull == null) {
                checkNull = 0.00;            
            }
            jUpdate.Days_In_Lieu__c = checkNull + 1;
        }
        update joblist;
    }
    global void finish(Database.BatchableContext BC ) {
}
 }