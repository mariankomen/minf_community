@istest
private class SFDCJobCandidateTriggerHandlerTest 
{
    @testSetup static void setup()
    {
        List<TalemetrySettings__c> tSettingList = TestClassUtil.getTalemetrySettings();
        insert tSettingList;
        
        Id accLocationRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        
        Account a = new Account(name = 'test portal', store_number__c = '1500', RecordTypeId=accLocationRTId);
        insert a;
        
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='test@test.com');
        insert c;
        
        Contract ctr = new Contract(AccountId=a.Id, Status='Draft', Service_Type__c='Candidate Sourcing', Contract_Type__c='OnDemand');
        ctr.StartDate = System.today();
        ctr.ContractTerm = 1;
        ctr.Industry__c = 'Grocery';
        ctr.Expected_Profits__c = 10;
        insert ctr;
        
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        Id CurrUserId = userinfo.getuserid();
        
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='test@test.com',
                          username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
                          EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
                          profileid = p.id, job_approver_1__c = CurrUserId , job_approver_2__c = CurrUserId , job_approver_3__c = CurrUserId ,
                          hr_user_approver__c =CurrUserId, user_classification__c = 'HR User - Standard' );
        insert u;
        
        Id jobRTId = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName().get('Glentel').getRecordTypeId();
       
       	SFDC_Job__c j = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', Job_Title_for_Role__c = 'job title',
                                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
                                Contract__c=ctr.Id, RecordTypeId=jobRTId, ft_or_pt__c = 'Part Time',job_description__c = 'sample default description');
            insert j;
        
        Applicant__c applicant = new Applicant__c();
        applicant.First_Name__c = 'TEST';
        applicant.Last_Name__c = 'TESTER';
        insert applicant;
        
        Applicant_Job_Apps__c AppJobs  = new Applicant_Job_Apps__c();         
        AppJobs.Applicant__c = applicant.id;
        AppJobs.Job__c = j.id;
        insert AppJobs;
        
        Hiring_Manager_Availability__c hma = new Hiring_Manager_Availability__c();
        hma.Hiring_Managers_Store__c = a.Id;
        insert hma;
        
        Candidate_Interview__c ci = new Candidate_Interview__c();
        ci.Name = 'test@test.com';
        ci.Job__c = AppJobs.Job__c;
        ci.Hiring_Manager_Availability__c = hma.Id;
        ci.Start_Date__c = System.now();
        insert ci;
    }
    
    @isTest static void testMethod2() {
        
        Applicant_Job_Apps__c AppJobs  = [select id, Job__c from  Applicant_Job_Apps__c limit 1 ];
        
        Contract ctr = [SELECT Id, AccountId FROM Contract Limit 1];
        
        SFDC_Candidate__c candidateRecord = new SFDC_Candidate__c(Name = 'test candidate', SFDC_Candidate_Email__c = 'test@test.com');
        insert candidateRecord;
        
        
        List<Target_Volume__c> tvList = new List<Target_Volume__c>();
        Target_Volume__c tv = new Target_Volume__c(Month_Targeted__c=System.today(), 
                                                   Number_of_Hires_Frontline__c=1, Frontline_Price__c=1,
                                                   Number_of_Hires_Frontline_1__c=1, Frontline_1_Price__c=1,
                                                   Number_of_Hires_Frontline_2__c=1, Frontline_2_Price__c=1,
                                                   Number_of_Hires_Specialty_1__c=1, Specialty_1_Price__c=1,
                                                   Number_of_Hires_Specialty_2__c=1, Specialty_2_Price__c=1,
                                                   Number_of_Hires_Management_1__c=1, Management_1_Price__c=1,
                                                   Number_of_Hires_Management_2__c=1, Management_2_Price__c=1,
                                                   Admin_Fee__c=1,
                                                   Contract__c=ctr.Id);
        tvList.add(tv);
        tv = new Target_Volume__c(Month_Targeted__c=System.today(), 
                                  Number_of_Hires_Frontline__c=2, Frontline_Price__c=2,
                                  Number_of_Hires_Frontline_1__c=2, Frontline_1_Price__c=2,
                                  Number_of_Hires_Frontline_2__c=2, Frontline_2_Price__c=2,
                                  Number_of_Hires_Specialty_1__c=2, Specialty_1_Price__c=2,
                                  Number_of_Hires_Specialty_2__c=2, Specialty_2_Price__c=2,
                                  Number_of_Hires_Management_1__c=2, Management_1_Price__c=2,
                                  Number_of_Hires_Management_2__c=2, Management_2_Price__c=2,
                                  Admin_Fee__c=1,
                                  Contract__c=ctr.Id);
        tvList.add(tv);
        insert tvList;
        
        Id jobRTId = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName().get('Glentel').getRecordTypeId();
        Job_Record_Type__c glentel = new Job_Record_Type__c(name = 'Glentel', record_type_id__c = jobRTId);
        insert glentel;
        // create a Blacklist with email match
        Blacklist__c b1 = new Blacklist__c(name = 'testlast', first_name__c = 'first', email__c = 'testlast@test.com', 
                                           Phone__c='2345678901',Postal_Code__c='23415');
        insert b1;
        // link to glentel jrt
        List<Blacklist_Job_Type__c> bJTypeList = new List<Blacklist_Job_Type__c>();
        Blacklist_Job_Type__c bjt1 = new Blacklist_Job_Type__c(blacklist__c = b1.id, job_record_type__c = glentel.id);
        bJTypeList.add(bjt1);
        bjt1 = new Blacklist_Job_Type__c(blacklist__c = b1.id, job_record_type__c = glentel.id);
        bJTypeList.add(bjt1);
        insert bJTypeList;
        
        Job_Point__c jp1 = new Job_Point__c(Client__c = 'Glentel', job_title__c = 'test1', banner_of_store__c = 'b1', point_allocation__c = 5);
        insert jp1;
        
        SFDC_Job_Candidate__c candidate  = new SFDC_Job_Candidate__c ();
        candidate.SFDC_Job__c = AppJobs.Job__c;
        candidate.Candidate__c = candidateRecord.id;
        candidate.sent_by__c = 'test portal user';
        candidate.Status__c = 'Rejected';
        insert candidate;
        
        AppJobs.Candidate_Link_to_HirePortal_Record__c = candidate.id;
        update AppJobs;
        
        candidate.Candidate_Eligible_to_Work_in_Canada__c = 'No';
        candidate.Status__c = 'Hired';
        candidate.Sent_By__c = null;
        update candidate;
    }
    
    @isTest static void testMethod1() {
        Applicant_Job_Apps__c AppJobs  = [select id, Job__c from  Applicant_Job_Apps__c limit 1 ];
        
        SFDC_Candidate__c candidateRecord = new SFDC_Candidate__c(Name = 'test candidate', SFDC_Candidate_Email__c = 'test@test.com');
        insert candidateRecord;
        
        SFDC_Job_Candidate__c candidate  = new SFDC_Job_Candidate__c ();
        candidate.SFDC_Job__c = AppJobs.Job__c;
        candidate.Candidate__c = candidateRecord.id;
        candidate.sent_by__c = 'test portal user';
        candidate.Status__c = 'Hired';
        insert candidate;
        
        delete candidate;
    }
}