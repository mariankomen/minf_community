@isTest
public class MFG_JobListController_Test {
    @isTest
    public static void getNotificationsTest(){ 
        List<SFDC_Job__c> jobsOpen = (List<SFDC_Job__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job__c(Job_Status__c='Open/Active Job'),10,null,true);
        List<SFDC_Job__c> jobsNotOpen = (List<SFDC_Job__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job__c(Job_Status__c='Job Approved'),20,null,true);
        
        system.Test.startTest();
        MFG_JobListController.Jobs jobs=  MFG_JobListController.getCurrentUserJobs();
        system.assertEquals(10, jobs.open.size());
        system.assertEquals(20, jobs.completed.size());
        system.Test.stopTest();
    }
    
    
}