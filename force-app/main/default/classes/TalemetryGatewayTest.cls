@isTest class TalemetryGatewayTest {
    
    @testSetup static void unitSetup(){
        List<TalemetrySettings__c> tSettingList = TestClassUtil.getTalemetrySettings();
        insert tSettingList;
        
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', job_name__c = 'Test', Job_Role_Title__c = 'test', 
                                           Specific_Candidate_Preference__c = 'No', Number_Of_Hours_Per_Week__c ='0 to 8 hours',
                                           FT_or_PT__c ='Part Time', Job_Description__c='test');
        insert job1;
    }
    
    static testMethod void unitTestOne(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TalemetryRetrieveResultAsyncTest.MockHttpResponseGenerator());
            SFDC_Job__c j = [Select Id,Job_Status__c,Job_Title__c, Name,Link_to_Career_Site_Posting__c,Recruiter_Assigned__c,Career_Site_Language__c,Job_Owner_Alias__c,Location_Store_Country__c,Location_Store_Postal_Code_Zip_Code__c,Location_Store_Province_State__c,Location_Store_City__c,Location_Store_Address__c,FT_or_PT__c,Job_Description__c,Hot_Job__c,Job_Role__c,Job_Category__c,Client_Career_Site__c,Online_Posting__c FROM SFDC_Job__c Limit 1]; 
        j.Job_Description__c ='test';   
        //update j;
        TalemetryGateway.apiCallout(Json.serialize(j),false);
        Test.stopTest();

		 Applicant__c applicant = TestClassUtil.getApplicant();
        insert applicant;
        
       Applicant_Job_Apps__c appJobs  = TestClassUtil.getApplicantJobApps(applicant.Id, j.Id);
        insert appJobs;
        TalemetryGateway.getProfileURL(appJobs.Id,'Applicant_Job_Apps__c');
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = documents[0].id, LinkedEntityId = applicant.Id);
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        TalemetryGateway.getRelatedFiles(appJobs.Id);
		
    }
    
    static testMethod void Job_ReminderTesting(){
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TalemetryRetrieveResultAsyncTest.MockHttpResponseGenerator());
            SFDC_Job__c j = [SELECT Id FROM SFDC_Job__c Limit 1]; 
            j.Last_Talemetry_TxnId__c='141111b1-5f57-4c74-b8b8-ce30969be1fc';
            j.LastTalemetrySyncStatus__c='Pending';
            update j;
            
            TalemetryRetrieveResultAsync trRA = new TalemetryRetrieveResultAsync();
            trRA.execute(null);
        Test.stopTest();
    }
    static testMethod void test2(){
        Applicant__c applicant = TestClassUtil.getApplicant();
        applicant.Last_Talemetry_TxnId__c = 'test';
        insert applicant;
        SFDC_Job__c j = [SELECT Id FROM SFDC_Job__c Limit 1]; 
        
        SFDC_Candidate__c can = new SFDC_Candidate__c(name = 'test');
        insert can;
        
        SFDC_Job_Candidate__c jc = new SFDC_Job_Candidate__c(status__c = 'Qualified Candidates', Date_Candidate_Sent__c = date.today().adddays(-10), candidate__c = can.id, 
            sfdc_job__c = j.id);
        insert jc;

        
        Applicant_Job_Apps__c appJobs  = TestClassUtil.getApplicantJobApps(applicant.Id, j.Id);
        insert appJobs;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TalemetryRetrieveResultAsyncTest.MockHttpResponseGenerator());
        	TalemetryGateway.getProfileURL(appJobs.Id,'Applicant_Job_Apps__c');
        
        j.Job_Status__c = 'Closed';
        j.Job_Description__c = 'test1';
        j.ltas__c = UserInfo.getUserId();
        j.X1st_Level_Manager__c = UserInfo.getUserId();
        update j;
        Test.stopTest();
    }
}