@isTest 
public class TalemetryLoggerDeleteRecordsBatchTest {

    @testsetup
    static void testdata(){
        Talemetry_Logger__c logger = new Talemetry_Logger__c();
        insert logger;
        system.debug([select id, createddate from Talemetry_Logger__c where Id=: logger.Id]);
        Datetime yesterday = Datetime.now().addDays(-10);
        Test.setCreatedDate(logger.Id, yesterday);        
        system.debug([select id, createddate from Talemetry_Logger__c where Id=: logger.Id]);
    }
    
    @isTest
    static void test1() {
        TalemetryLoggerDeleteRecordsBatch trRA = new TalemetryLoggerDeleteRecordsBatch();
        trRA.execute(null);
        //Database.executeBatch(new TalemetryLoggerDeleteRecordsBatch());
    }
    
}