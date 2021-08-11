@isTest
public class MFG_JobCandidateSelector_Test {
 @isTest
    public static void getSObjectFieldListTest(){ 
        MFG_JobCandidateSelector selector = new MFG_JobCandidateSelector();
        System.Test.startTest();
        system.assert(!selector.getSObjectFieldList().isEmpty());
        System.Test.stopTest();
    }
        @isTest
    public static void getSObjectTypeTest(){
        MFG_JobCandidateSelector selector = new MFG_JobCandidateSelector();
        System.Test.startTest();
        system.assertEquals( SFDC_Job_Candidate__c.sObjectType, selector.getSObjectType()) ;
        System.Test.stopTest();
    }
    @isTest
    public static void selectByIdTest(){
        SFDC_Job__c job=(SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        SFDC_Job_Candidate__c jcandidate=(SFDC_Job_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id),true);  
        

        MFG_JobCandidateSelector selector = new MFG_JobCandidateSelector();
        System.Test.startTest();
        System.assertEquals(1, selector.selectById(new Set<id>{jcandidate.id}).size());
        System.Test.stopTest();
    }
     @isTest
    public static void selectAllDisplayed_Test(){
     
        SFDC_Job__c job=(SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        SFDC_Job_Candidate__c jcandidate=(SFDC_Job_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id),true);  
        MFG_JobCandidateSelector selector = new MFG_JobCandidateSelector();
        System.Test.startTest();
        System.assertEquals(1, selector.selectByStatus('').size());
        System.Test.stopTest();
    }
}