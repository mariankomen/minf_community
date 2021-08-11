@isTest class DeleteTalemetryLoggerBatchTest {

    testMethod static void unitTestOne(){
        List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
        Talemetry_Logger__c log;
        for(integer i=0;i<10;i++){
			log = new Talemetry_Logger__c ();
            log.Error_Message__c = 'test'+i;
            log.Request__c = 'test'+i;
            log.Response__c = 'test'+i;
            log.Webservice__c = 'test'+i;
            loggerList.add(log);
        } 
        
        insert loggerList;
        
        
        Datetime dt = System.now().addDays(-10);
        for(Talemetry_Logger__c logger:loggerList){
            Test.setCreatedDate(logger.Id, dt);
        }
        
        Database.executeBatch(new DeleteTalemetryLoggerBatch());
        DeleteTalemetryLoggerBatch.scheduleJob();
        System.Schedule('DeleteTalemetryLoggerBatch1 '+System.now(),'0 0 5 * * ?',new DeleteTalemetryLoggerBatch());
    }
}