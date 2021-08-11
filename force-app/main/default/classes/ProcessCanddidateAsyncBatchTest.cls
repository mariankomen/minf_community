@isTest public class ProcessCanddidateAsyncBatchTest {
    
    @isTest public static void test1(){
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
            tl.Transaction_Id__c = 'aba';
            tl.StatusNumber__c  = '0';
            tl.Type__c= 'CanddidateAsync';  
            tl.Status__c = 'Processing';
		insert tl;
        Test.startTest();
        ProcessCanddidateAsyncBatch.scheduleJob();
        Test.stopTest() ;
    }
    
}