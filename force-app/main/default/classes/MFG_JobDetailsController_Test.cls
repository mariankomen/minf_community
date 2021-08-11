@isTest
public class MFG_JobDetailsController_Test {
     @isTest
    public static void initJobDeails_Test(){
     
        SFDC_Job__c job=(SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        List<SFDC_Job_Candidate__c> jcandidateRej=(List<SFDC_Job_Candidate__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id,Status__c='Rejected'),2,null,true);
        List<SFDC_Job_Candidate__c> jcandidateoutstanding=(List<SFDC_Job_Candidate__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id,Status__c='Interviewing'),3,null,true);
        List<SFDC_Job_Candidate__c> jcandidateaccepted=(List<SFDC_Job_Candidate__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id,Status__c='Hired'),4,null,true);
        MFG_JobCandidateSelector selector = new MFG_JobCandidateSelector();
        System.Test.startTest();
        MFG_JobDetailsController.Job sfdcjob=MFG_JobDetailsController.initJobDeails(job.Id);
        system.assertEquals(3, sfdcjob.outstanding.size());
        system.assertEquals(4, sfdcjob.accepted.size());
        system.assertEquals(2, sfdcjob.rejected.size());
        
        System.Test.stopTest();
    }
}