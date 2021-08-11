@isTest class TaskTriggerTest {
    static testMethod void unitTestOne() {
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        Task tsk = new Task(Subject = 'Trigger testing task 0001', WhatId = applicant.Id,Type = 'Call');
		insert tsk;
    }
    
    static testMethod void unitTestTwo() {
        SFDC_Job__c j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', Job_Title_for_Role__c = 'job title',
                                        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
        insert j;
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        Applicant_Job_Apps__c appJobs  = TestClassUtil.getApplicantJobApps(applicant.Id, j.Id);
        insert appJobs;
        
        Task tsk = new Task(Subject = 'Task on Application Job', WhatId = appJobs.Id,Type = 'Call');
		insert tsk;
    }
}