@isTest class ApplicantTriggerTest {
	static testMethod void unitTestOne() {
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        update applicant;
    }
}