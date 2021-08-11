@isTest
public class MFG_ScheduledInterviewsController_Test {
    
    
    
    @isTest
    public static void getSchInterviewsTestempty(){
        System.Test.StartTest();
        List<MFG_ScheduledInterviewsController.ScheduledInterview> ScheduledInterviewtrue  =MFG_ScheduledInterviewsController.getSchInterviews(true);
        List<MFG_ScheduledInterviewsController.ScheduledInterview> ScheduledInterviewfalse  =MFG_ScheduledInterviewsController.getSchInterviews(false);
        System.Test.StopTest();
    }
    @isTest
    public static void getSchInterviewsTest(){ 
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId(); 
        
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(RecordTypeId=recordTypeId),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false);       
        
        
        Hiring_Manager_Availability__c hra=new Hiring_Manager_Availability__c();
        hra.Start_Date__c=system.today();
        hra.End_Date__c=system.today().addDays(90);
        hra.Interviewer_s_Available__c =10;
        hra.Interview_Duration__c='60';
        system.debug(acc.id);
        hra.Hiring_Managers_Store__c=acc.id;
        insert hra;
        SFDC_Job__c job = (SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        SFDC_Job_Candidate__c jcandidateoutstanding=(SFDC_Job_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id,Status__c='Interviewing'),true);
        
        Candidate_Interview__c ci=new Candidate_Interview__c();
        ci.Hiring_Manager_Availability__c=hra.id;
        ci.Start_Date__c=system.now();
        ci.Job_Candidate__c=jcandidateoutstanding.id;
        ci.Job__c=job.id;
        
        Candidate_Interview__c ci2=new Candidate_Interview__c();
        ci2.Hiring_Manager_Availability__c=hra.id;
        ci2.Start_Date__c=system.now();
        ci2.Job_Candidate__c=jcandidateoutstanding.id;
        ci2.Job__c=job.id;
        insert ci2;
        insert ci;
        
        System.runAs(user){
            System.Test.StartTest();
            
            List<MFG_ScheduledInterviewsController.ScheduledInterview> ScheduledInterviewtrue  =MFG_ScheduledInterviewsController.getSchInterviews(true);
            List<MFG_ScheduledInterviewsController.ScheduledInterview> ScheduledInterviewtruef  =MFG_ScheduledInterviewsController.getSchInterviews(false);
            system.assertEquals(False, ScheduledInterviewtrue.isEmpty());
            system.assertEquals(0, ScheduledInterviewtruef.size());
            System.Test.StopTest();
        } 
    }
}