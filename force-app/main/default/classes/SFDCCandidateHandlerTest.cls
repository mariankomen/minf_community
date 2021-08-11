@isTest class SFDCCandidateHandlerTest {
	
    @testSetup static void unitSetup(){
        List<TalemetrySettings__c> tSettingList = TestClassUtil.getTalemetrySettings();
        insert tSettingList;
        
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', ltas__c = userinfo.getuserid(), 
                                           Job_Role_Title__c = 'test',ft_or_pt__c = 'Part Time',job_description__c = 'sample default description');
        insert job1;
    }
    
    static testMethod void Job_Candidate_Trigger_Test() {
        SFDC_Job__c job1 = [select id, name, ltas__c from SFDC_Job__c Limit 1];
		// test that ltas is maintained when changed on job
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TalemetryRetrieveResultAsyncTest.MockHttpResponseGenerator());
            job1.ltas__c = null;
        	update job1;
        Test.stopTest();
        
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last', recruiter_summary_on_candidate__c = 'test summary', sfdc_candidate_email__c = 'test@test.com');
        insert can1;
        
        can1 = [select id, first_name__c, last_name__c, name, recruiter_summary_on_candidate__c, sfdc_candidate_email__c from SFDC_Candidate__c where id = :can1.id];
          
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates', sent_by__c = 'Jeff Summers');
        insert jc1;
        jc1 = [select id, name, candidate__c, sent_by__c, sent_by_lookup__c, sent_by_lookup__r.name, ltas__c, recruiter_summary_on_candidate__c, email__c from SFDC_Job_Candidate__c where id = :jc1.id];
        //system.assertequals(jc1.name, 'Job#'+job1.name+' - '+can1.Last_Name__c);
        //system.assertequals(jc1.sent_by__c, jc1.sent_by_lookup__r.name);
        //system.assertequals(jc1.recruiter_summary_on_candidate__c, 'test summary');
        //system.assertequals(jc1.email__c, 'test@test.com'); 
        //system.assertequals(jc1.ltas__c, job1.ltas__c);      
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Hired', sent_by__c = 'Jeff Summers');
        insert jc2; 

        // create another sysadmin user to test the sent by name changes
        Profile pa = [select id from Profile where name = 'System Administrator'];
        User admin = new User(firstname='test', lastname = 'admin user', email='niki@vankerksolutions.com',
            username = 'adminniki@mfg.com', alias='testadmi', communitynickname='testadmin', EmailEncodingKey = 'ISO-8859-1', 
            LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pa.id, user_classification__c = 'Demo Related');
        insert admin;
                         
        // test that it resets when changed
        jc1.sent_by__c = 'test admin user';
        update jc1;
        jc1 = [select id, name, candidate__c, sent_by__c, sent_by_lookup__c, sent_by_lookup__r.name from SFDC_Job_Candidate__c where id = :jc1.id]; 
        //system.assertequals('test admin user', jc1.sent_by_lookup__r.name);  
        
        // test that recruiter summary and email is copied down if changed
        can1.recruiter_summary_on_candidate__c = 'different summary';
        can1.sfdc_candidate_email__c = null;
        can1.Escalated_Reference_Check__c = true;
        can1.Phone_Screen_Content_URL__c = 'https://www.google.com';
        can1.Resume_Content_URL__c = 'https://www.google.com';
        update can1;
        can1 = [select id, first_name__c, last_name__c, name, recruiter_summary_on_candidate__c from SFDC_Candidate__c where id = :can1.id];
        System.debug('Candidate after update: '+can1);
        jc1 = [select id, recruiter_summary_on_candidate__c, email__c, Escalated_Reference_Check__c from SFDC_Job_Candidate__c where id = :jc1.id];
        System.debug('JC after Candidate update: '+jc1);
        //system.assertequals(jc1.recruiter_summary_on_candidate__c, 'different summary'); 
        //system.assertequals(jc1.email__c, null);    
        System.assert(jc1.Escalated_Reference_Check__c);
        
        jc1 = [select id, name, ltas__c from SFDC_Job_Candidate__c where id = :jc1.id];
        //system.assertequals(jc1.ltas__c, null);
        
        // test that background check URL is maintained on Can Rec if it has a value
        system.debug('starting BC test');
        Reminder_Util.firstRun = true;
        jc1.background_check_results_URL__c = 'www.salesforce.com';
        update jc1;
        can1 = [select id, background_check_results_URL__c from SFDC_Candidate__c where id = :can1.id];
        ////system.assertequals('www.salesforce.com', can1.background_check_results_URL__c); 
        Reminder_Util.firstRun = true;
        // change it out and it should update on can rec
        jc1.background_check_results_URL__c = 'www.mindfieldgroup.com';
        update jc1;
        can1 = [select id, background_check_results_URL__c from SFDC_Candidate__c where id = :can1.id];
        ////system.assertequals('www.mindfieldgroup.com',can1.background_check_results_URL__c); 
        Reminder_Util.firstRun = true;
        // null it out and it should stay on can rec
        jc1.background_check_results_URL__c = '';
        update jc1;
        can1 = [select id, background_check_results_URL__c from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals('www.mindfieldgroup.com',can1.background_check_results_URL__c);                                
    }
}