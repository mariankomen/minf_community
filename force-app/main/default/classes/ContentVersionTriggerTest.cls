@isTest class ContentVersionTriggerTest {
    static testMethod void unitTestOne() {
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        ContentNote cn = new ContentNote(Title = 'test1');
        cn.Content = Blob.valueOf('Please work');
        insert cn;
        
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = cn.id, LinkedEntityId = applicant.Id);
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        ContentVersion cv = new ContentVersion(); 
        cv.ContentDocumentId = cn.Id;
        cv.PathOnClient = 'test1.snote';
        cv.versiondata = Blob.valueOf('Test Content Data');
        insert cv; 
    }
    
    static testMethod void unitTestTwo() {
        SFDC_Job__c j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', Job_Title_for_Role__c = 'job title',
                                        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
        insert j;
        
        
        Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
        Applicant_Job_Apps__c appJobs  = TestClassUtil.getApplicantJobApps(applicant.Id, j.Id);
        insert appJobs;
        
        ContentNote cn = new ContentNote(Title = 'test1');
        String body = 'Please work';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert cn;
        
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = cn.id, LinkedEntityId = appJobs.Id);
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        ContentVersion cv = new ContentVersion(); 
        cv.ContentDocumentId = cn.Id;
        cv.PathOnClient = 'test1.snote';
        cv.versiondata = Blob.valueOf('Test Content Data');
        insert cv; 
    }
}