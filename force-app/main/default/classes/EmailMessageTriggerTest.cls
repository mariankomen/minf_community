@isTest class EmailMessageTriggerTest {
    static testMethod void unitTestOne() {
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        EmailMessage outGoingMail= new EmailMessage();
         outGoingMail.fromaddress='test@test.com';
         outGoingMail.toAddress = 'tes1t@test.com';
         outGoingMail.subject = 'Opt Out Test Message';
         outGoingMail.TextBody= 'This is the message body BR-Interno.';
         outGoingMail.RelatedToId = applicant.id;
         insert outGoingMail;        
    }
    
    static testMethod void unitTestTwo() {
        SFDC_Job__c j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', Job_Title_for_Role__c = 'job title',
                                        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
        insert j;
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        Applicant_Job_Apps__c appJobs  = TestClassUtil.getApplicantJobApps(applicant.Id, j.Id);
        insert appJobs;
        
        EmailMessage outGoingMail= new EmailMessage();
         outGoingMail.fromaddress='test@test.com';
         outGoingMail.toAddress = 'tes1t@test.com';
         outGoingMail.subject = 'Opt Out Test Message';
         outGoingMail.TextBody= 'This is the message body BR-Interno.';
         outGoingMail.RelatedToId = appJobs.id;
         insert outGoingMail;       
    }
}