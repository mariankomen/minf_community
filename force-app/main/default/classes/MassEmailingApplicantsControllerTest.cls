@istest
private class MassEmailingApplicantsControllerTest 
{
    @testSetup static void setup()
    {
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
         system.runas(u) {
             j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', Job_Title_for_Role__c = 'job title',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
             insert j;
         }
		 
		 Applicant__c applicant = new Applicant__c(Email__c= 'test@gamil.com');
         insert applicant;

         Applicant_Job_Apps__c AppJobs  = new Applicant_Job_Apps__c();         
         AppJobs.Applicant__c = applicant.id;
         AppJobs.Job__c = j.id;
         insert AppJobs;

	}
    
    
    @isTest static void testMethod1() 
    {        
        list<Applicant_Job_Apps__c> AppJobs  = [select id,Job__c, Job__r.Name, Applicant__c, Applicant__r.First_Name__c, Applicant__r.Last_Name__c, Applicant__r.Email__c from  Applicant_Job_Apps__c ];                
        update AppJobs;
        
        Test.startTest();
  		Test.setCurrentPage(Page.MassEmailingApplicants);
  		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(AppJobs);
  		stdSetController.setSelected(AppJobs);
  		MassEmailingApplicantsController ext = new MassEmailingApplicantsController(stdSetController);        
        MassEmailingApplicantsController.getRecords( Json.serialize(AppJobs)  );
        MassEmailingApplicantsController.sendEmail(Json.serialize(AppJobs),'{"from":"'+UserInfo.getUserEmail()+'","subject":"a subject","body":"this is the body"}' );
        MassEmailingApplicantsController.getMergefields('Contact related to the Job : {!SFDC_Job__c.Contact__r.LastName} {!SFDC_Job__c.Contact__r.FirstName}');
 		Test.stopTest();

	}

}