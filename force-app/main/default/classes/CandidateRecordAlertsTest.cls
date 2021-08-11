@istest
private class CandidateRecordAlertsTest{
@istest
private static void testPg() {
       
        // create test Job, Candidate Rec and Candidate
        // create a portal user 
        Account a = new Account(name = 'test portal', store_number__c = '1500');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        Id CurrUserId = userinfo.getuserid();
        
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, job_approver_1__c = CurrUserId , job_approver_2__c = CurrUserId , job_approver_3__c = CurrUserId ,
            hr_user_approver__c =CurrUserId, user_classification__c = 'HR User - Standard' );
        insert u;
         
         // create job and candidate record
         SFDC_Candidate__c can = new SFDC_Candidate__c(first_name__c = 'test', last_name__c = 'testlast', SFDC_candidate_email__c = 'testlast@test.com');
         insert can;
         SFDC_Job__c j = new SFDC_Job__c();
         system.runas(u) {
             j = new SFDC_Job__c(job_name__c = 'Test1', Job_Title_for_Role__c = 'job title', job_status__c = 'test', Specific_Candidate_Preference__c = 'No',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
             insert j;
         }
         SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = j.id, candidate__c = can.id);
         insert jc1;
         
        Test.setCurrentPage(Page.CandidateRecordAlerts);
        // test without template
        ApexPages.StandardController con = new ApexPages.StandardController(can);
        CandidateRecordAlerts ext = new CandidateRecordAlerts(con);
        system.assert(ext.tempMissing);
        // add a valid Candidate based template but missing email address value
        ApexPages.currentPage().getParameters().put('template', '00XU0000000E5W7');
        ApexPages.currentPage().getParameters().put('NoJobTemplate', '00XU0000000E5W7');
        ext = new CandidateRecordAlerts(con);
        ext.sendAlert();
        system.assert(!ext.emailComplete );

        // try with all required fields to pass
        ext.emailAddresses = 'niki@vankerksolutions.com, nvankerk@hotmail.com';
        ext.sendAlert();
        system.assert(ext.emailComplete);
        
        // now try page without valid JC record
        delete jc1;
        ext = new CandidateRecordAlerts(con);
        ext.sendAlert();
        
    }   
    
  
       
}