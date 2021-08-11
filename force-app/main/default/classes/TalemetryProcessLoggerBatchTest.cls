@isTest
public class TalemetryProcessLoggerBatchTest {
    static testmethod void test1(){
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
        tl = TalemetryParseResponseUtil.getLogging('Trigger TaskHandler', 'task trigger', null);
        tl.Status__c = 'Pending';
        tl.Applicant_Id__c = applicant.id;
        insert tl;
         Test.startTest();
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', job_name__c = 'Test', Job_Role_Title__c = 'test', 
                                           Specific_Candidate_Preference__c = 'No', Number_Of_Hours_Per_Week__c ='0 to 8 hours',
                                           FT_or_PT__c ='Part Time', Job_Description__c='test');
        Insert job1;
        job1.Job_Description__c = 'Test';
        job1.job_status__c = 'Not Filled/Job Re-opened';
        Update job1; 
        
        TalemetryProcessLoggerBatch.scheduleJob();
        TalemetryProcessLoggerBatch c = new TalemetryProcessLoggerBatch();
        Database.executeBatch(c);
        Test.stopTest();
    }
    static testmethod void test2(){
        
        Test.startTest();
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', job_name__c = 'Test', Job_Role_Title__c = 'test', 
                                           Specific_Candidate_Preference__c = 'No', Number_Of_Hours_Per_Week__c ='0 to 8 hours',
                                           FT_or_PT__c ='Part Time', Job_Description__c='test');
        Insert job1;
        job1.Job_Description__c = 'Test';
        job1.job_status__c = 'Filled Closed Job';
        Update job1;  
        job1.job_status__c = 'Open/Active Job - Talent Connect';
        Update job1; 
        TalemetryProcessLoggerBatch.scheduleJob();
        TalemetryProcessLoggerBatch c = new TalemetryProcessLoggerBatch();
        Database.executeBatch(c);
        Test.stopTest();
    }
}