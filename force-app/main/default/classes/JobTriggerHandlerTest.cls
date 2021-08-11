@istest
private class JobTriggerHandlerTest 
{
    @testSetup static void setup()
    {
        List<TalemetrySettings__c> tSettingList = TestClassUtil.getTalemetrySettings();
        insert tSettingList;
        
		Account a = new Account(name = 'test portal', store_number__c = '1500');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='test@test.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        Id CurrUserId = userinfo.getuserid();
        
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='test@test.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, job_approver_1__c = CurrUserId , job_approver_2__c = CurrUserId , job_approver_3__c = CurrUserId ,
            hr_user_approver__c =CurrUserId, user_classification__c = 'HR User - Standard' );
        insert u;
         
         SFDC_Job__c j = new SFDC_Job__c();
         System.runas(u) {
             j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', 
                                 Job_Title_for_Role__c = 'job title', Num_of_Days_for_Delivery_Agreement__c = 1, 
                                 Num_of_Candidates_for_Delivery_Agreement__c = 1,FT_or_PT__c ='Part Time', Job_Description__c='test');
             insert j;
         }
		 
		 Applicant__c applicant = new Applicant__c();
         applicant.First_Name__c = 'TEST';
         applicant.Last_Name__c = 'TESTER';         
         insert applicant;

         Applicant_Job_Apps__c AppJobs  = new Applicant_Job_Apps__c();         
         AppJobs.Applicant__c = applicant.id;
         AppJobs.Job__c = j.id;
         AppJobs.Status__c = 'New';
         insert AppJobs;
	}
    
    @istest static void testCloseJob()
    {
        SFDC_Job__c job = [select id from SFDC_Job__c limit 1];
        job.Job_Status__c = 'Filled Closed Job';
        update job;
        
        //system.assertEquals('Job Filled', [select Declined_Reason_by_MFG__c from Applicant_Job_Apps__c limit 1 ].Declined_Reason_by_MFG__c);
    }

}