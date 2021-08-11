/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Trigger_Test {

    // used by tests for OnDemand jobs that need an Oportunity created
    static Opportunity opp {get; set;}
    static {
        // create Account
        Account a = new Account(name = 'test');
        insert a;
        opp = new Opportunity(name = 'test', accountid = a.id, stagename = 'Initial', closedate = date.today());
        insert opp;
    }
    
    static testMethod void Candidate_insert_Test() {
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last');
        insert can1;
        
        can1 = [select id, first_name__c, last_name__c, name from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals(can1.first_name__c+' '+can1.last_name__c, can1.name);
        
        // test it works if first/last are null
        can1.First_Name__c = '';
        can1.Last_Name__c = '';
        update can1;
        
        can1 = [select id, first_name__c, last_name__c, name from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals(can1.id, can1.name);
        
    }

    static testMethod void Job_Candidate_Trigger_Test() {
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last', recruiter_summary_on_candidate__c = 'test summary', sfdc_candidate_email__c = 'test@test.com');
        insert can1;
        can1 = [select id, first_name__c, last_name__c, name, recruiter_summary_on_candidate__c, sfdc_candidate_email__c from SFDC_Candidate__c where id = :can1.id];
                
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', ltas__c = userinfo.getuserid(), Job_Role_Title__c = 'test');
        insert job1;
        job1 = [select id, name, ltas__c from SFDC_Job__c where id = :job1.id];

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
        update can1;
        can1 = [select id, first_name__c, last_name__c, name, recruiter_summary_on_candidate__c from SFDC_Candidate__c where id = :can1.id];
        system.debug('Candidate after update: '+can1);
        jc1 = [select id, recruiter_summary_on_candidate__c, email__c, Escalated_Reference_Check__c from SFDC_Job_Candidate__c where id = :jc1.id];
        system.debug('JC after Candidate update: '+jc1);
        //system.assertequals(jc1.recruiter_summary_on_candidate__c, 'different summary'); 
        //system.assertequals(jc1.email__c, null);    
        system.assert(jc1.Escalated_Reference_Check__c);
        
        // test that ltas is maintained when changed on job
        job1.ltas__c = null;
        update job1;
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
    
    static testMethod void Job_ReminderTesting(){
        // create a candidate and job, add to job to create open Reminders
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last');
        insert can1;
        can1 = [select id, first_name__c, last_name__c, name from SFDC_Candidate__c where id = :can1.id];
                
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', Job_Role_Title__c = 'test');
        insert job1;
        job1 = [select id, name from SFDC_Job__c where id = :job1.id];

        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates');
        insert jc1;
        jc1 = [select id, name, status__c from SFDC_Job_Candidate__c where id = :jc1.id];
        ////system.assertequals(1, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c <> 'Complete']);     
        // reset this boolean since we are running test methods without reloading util.
        Reminder_Util.firstRun = true;
                
        // now change to Interviewing and should be 1 completed reminder, one new one
        jc1.Status__c = 'Interviewing/Background Check';
        jc1.Interview_Date__c = date.today().adddays(2);
        update jc1;
        ////system.assertequals(1, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c <> 'Complete']);     
        ////system.assertequals(1, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c = 'Complete']);      
        
        // reset this boolean since we are running test methods without reloading util.
        Reminder_Util.firstRun = true;
        // now change interview date and should be 2 completed reminder, one new one
        jc1.Interview_Date__c = date.today().adddays(3);
        update jc1;
        //system.assertequals(1, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c <> 'Complete']);     
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c = 'Complete']); 
                
        // now update job status to Not Filled/Job Re-Opened and check that reminder has been completed
        job1.job_status__c = 'Not Filled/Job Re-Opened';
        update job1;
        //system.assertequals(0, [select count() from MFG_Reminder__c where sfdc_job__c = :job1.id and status__c <> 'Complete']);     
    }

    // test after insert of Job Candidate to change Candidate ownership based on Job ownership
    static testMethod void JobCandidate_OwnershipTesting(){
        // create a sysadmin user to avoid mixed dml errors when we deactivate a user
        Profile pa = [select id from Profile where name = 'System Administrator'];
        User admin = new User(firstname='test', lastname = 'admin user', email='niki@vankerksolutions.com',
            username = 'adminniki@mfg.com', alias='testadmi', communitynickname='testadmin', EmailEncodingKey = 'ISO-8859-1', 
            LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pa.id, user_classification__c = 'Demo Related');
        // create 2 new users, 1 that we can deactivate
        Account a = new Account(name = 'test portal');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u;
        
        // quick test of User before insert/update trigger that sets portal user's storeid value
        u = [select id, contactid, store_id__c, contact.accountid from user where id = :u.id];
        system.debug('users store id value is: '+u.store_id__c+' and accountid: '+u.contact.accountid);
        //system.assertequals(u.store_id__c, u.contact.accountid);
      //  //system.assertequals(u.store_id__c, string.valueof(u.contact.accountid).left(15));
        
        Contact c2 = new Contact(accountid = a.id, lastname = 'test contact2', email='niki2@vankerksolutions.com');
        insert c2;
        User u2 = new User(contactid = c2.id, firstname='test', lastname = 'portal user2', email='niki2@vankerksolutions.com',
            username = '2sample2@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u2;        
        // get MFG Demo for job record type
        RecordType rt = [select id from recordtype where name = 'MFG Demo' and sobjecttype = 'SFDC_Job__c'];
        // create a candidate owned by u1
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last', ownerid = u.id);
        insert can1;
        can1 = [select id, first_name__c, last_name__c, name, ownerid from SFDC_Candidate__c where id = :can1.id];
        // create job owned by u2        
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', recordtypeid = rt.id, ownerid = u2.id, Job_Role_Title__c = 'test');
        insert job1;
        job1 = [select id, name, ownerid from SFDC_Job__c where id = :job1.id];
        
        // now add jc owned by me - should change the can1 owner to u2
        //system.assertequals(can1.ownerid, u.id);
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates');
        insert jc1;
        can1 = [select id, first_name__c, last_name__c, name, ownerid from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals(can1.ownerid, u2.id); 
        // put owner back to u
        can1.ownerid = u.id;
        update can1;
        can1 = [select id, first_name__c, last_name__c, name, ownerid from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals(can1.ownerid, u.id);   
             
        // now deactivate the job owner u2 and add jc - should remain as u
        system.runas(admin) {
            u2.isactive = false;
            update u2;
        }
        u2 = [select id, isactive from user where id = :u2.id];
        job1 = [select id, name, ownerid, owner.isactive from SFDC_Job__c where id = :job1.id];    
        system.assert(!job1.owner.isactive); 
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates');
        insert jc2;
        can1 = [select id, first_name__c, last_name__c, name, ownerid from SFDC_Candidate__c where id = :can1.id];
        //system.assertequals(can1.ownerid, u.id);   
        
                  
    }
    
    static testMethod void JobOwnerRef_testInsert(){
        // add a job owner ref with invalid ID
        Job_Owner_Reference__c jr = new Job_Owner_Reference__c(job_record_type_id__c = 'asdb');
        boolean err = false;
        try {insert jr;}
        catch (Exception e) {err = true;}
        system.assert(err);
        // now try with bad id
        jr = new Job_Owner_Reference__c(job_record_type_id__c = '01230000000J23r');
        err = false;
        try {insert jr;}
        catch (Exception e) {err = true;}
        system.assert(err);
        // now add actual value but long version
        id GoodRecType = [select id from recordtype where name = 'MFG Demo' and sobjecttype = 'SFDC_Job__c' limit 1].id;
        jr = new Job_Owner_Reference__c(job_record_type_id__c = GoodRecType);
        err = false;
        try {insert jr;}
        catch (Exception e) {err = true;}
        system.assert(err);
        // now add actual value short version
        jr = new Job_Owner_Reference__c(job_record_type_name__c = 'MFG OnDemand');
        err = false;
        try {insert jr;}
        catch (Exception e) {err = true;}
        system.assert(!err);
    }    

    // test Job insert when cloned from another
    static testMethod void JobClone(){
        // create new user
        Account a = new Account(name = 'test portal');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u;
        
        // get MFG Demo for job record type
        RecordType rt = [select id from recordtype where name = 'MFG Demo' and sobjecttype = 'SFDC_Job__c'];
        system.runas(u) {
            // create original job        
            SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', recordtypeid = rt.id, ownerid = u.id, Job_Title_for_Role__c = 'test');
            insert job1;
            job1 = [select id, name, ownerid from SFDC_Job__c where id = :job1.id];
            
            // now add a job that indicates it was cloned from job1
            SFDC_Job__c job2 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test2', recordtypeid = rt.id, ownerid = u.id, created_by_cloning_existing_job__c = true,
                cloned_job_id__c = job1.name, Job_Title_for_Role__c = 'test');
            insert job2;
            job2 = [select id, name, job_comments__c, created_by_cloning_existing_job__c, cloned_job_id__c from SFDC_Job__c where id = :job2.id];
            job1 = [select id, name, job_comments__c from SFDC_Job__c where id = :job1.id];
            // job comments are set regarding the cloned job
            system.assert(job1.job_comments__c != null);
            // as of Sept 2012 we are leaving the cloning fields in place so they can be used as approval entry criteria for AN
            //system.assert(!job2.created_by_cloning_existing_job__c);
            //system.assert(job2.cloned_job_id__c == null);
         }        
    }

    //test setting Approver/Managers when Account/User values change
    static testMethod void Approver_ManagerTests(){
        Id currUser = userInfo.GetUserId();
        // create a sysadmin user to avoid mixed dml errors when we deactivate a user
        Profile pa = [select id from Profile where name = 'System Administrator'];
        User admin = new User(firstname='test', lastname = 'admin user', email='niki@vankerksolutions.com',
            username = 'adminniki@mfg.com', alias='testadmi', communitynickname='testadmin', EmailEncodingKey = 'ISO-8859-1', 
            LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pa.id, user_classification__c = 'Demo Related');
                   
        // create new user
        Account a = new Account(name = 'test portal', X1st_Level_Manager__c = currUser, X1st_Level_Manager_Type__c = 'test', X2nd_Level_Manager__c = currUser, X2nd_Level_Manager_Type__c = 'test', X3rd_Level_Manager__c = currUser, X3rd_Level_Manager_type__c = 'test',X4th_Level_Manager__c = currUser, X4th_Level_Manager_type__c = 'test', X5th_Level_Manager__c = currUser, X5th_Level_Manager_type__c = 'test',X1st_Level_Access__c = currUser, X2nd_Level_Access__c = currUser, HR_User_Usual__c = currUser);
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'COBS Breads HirePortal Store User EN'];
        // first user has current testing user as approvers
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), user_classification__c = 'Demo Related', 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, job_approver_1__c = currUser, job_approver_2__c = currUser, job_approver_3__c = currUser, hr_user_approver__c = currUser);
        insert u;
        // second user 
        Contact c2 = new Contact(accountid = a.id, lastname = 'test2 contact', email='niki@vankerksolutions.com');
        insert c2;        
        User u2 = new User(contactid = c2.id, firstname='test2', lastname = 'portal user2', email='niki@vankerksolutions.com',
            username = 'sample2@mfg.com', alias='testab2', communitynickname='testab2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'Demo Related');
        insert u2;        
        // get MFG Demo for job record type - use MindField_Managers now since MFG Demo starts job approvals which messes up our results
       // RecordType rt = [select id from recordtype where name = 'MindField Managers' and sobjecttype = 'SFDC_Job__c'];
        // create 2 candidates
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last', ownerid = u.id);
        insert can1;
        SFDC_Candidate__c can2 = new SFDC_Candidate__c(first_name__c = 'Second', last_Name__c = 'Last', ownerid = u.id);
        insert can2;
        
        List<Open_Job_Statuses__c> os = Open_Job_Statuses__c.getall().values();       
        if (os.size() == 0) {
            Open_Job_Statuses__c o = new Open_Job_Statuses__c(name = '1', status_name__c = 'Open/Active Job');
            insert o;
            Open_Job_Statuses__c o2 = new Open_Job_Statuses__c(name = '2', status_name__c = 'Candidates Sent/Awaiting Hire');
            insert o2;
            
        }
        
        SFDC_Job__c job1;
        SFDC_Job__c job2;
        system.runas(u) {
            // create a first open job        
            job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', ownerid = u.id, Job_Role_Title__c = 'test', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'test', Store_Address__c = 'test');
            insert job1;
            job1 = [select id, name, job_status__c, ownerid, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, approver_1__c,
                    approver_2__c, approver_3__c, hr_user_approver__c, X4th_Level_Manager__c, X5th_Level_Manager__c, X1st_Level_Access__c, X2nd_Level_Access__c from SFDC_Job__c where id = :job1.id];
            if (job1.job_status__c == 'Job Awaiting Approval') { job1.job_status__c = 'Open/Active Job'; update job1;}
            // show that all 8 approver/mgr jobs are set to currUser
            system.debug('job 1 after manager changes: '+job1);
            system.assert(job1.X1st_Level_Manager__c == currUser && job1.X2nd_Level_Manager__c == currUser && job1.X3rd_Level_Manager__c == currUser &&
               job1.HR_User_Usual__c == currUser && job1.approver_1__c == currUser && job1.approver_2__c == currUser && job1.approver_3__c == currUser && job1.hr_user_approver__c == currUser && job1.X4th_Level_Manager__c == currUser && job1.X5th_Level_Manager__c == currUser && job1.X1st_Level_Access__c == currUser && job1.X2nd_Level_Access__c == currUser);
            // now add a job that is closed
            job2 = new SFDC_Job__c(Specific_Candidate_Preference__c = 'No', job_name__c = 'Test2', ownerid = u.id, job_status__c = 'Not Filled/Job Re-Opened', Job_Role_Title__c = 'test', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'test');
            insert job2;
            job2 = [select id, name, job_status__c, ownerid, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, approver_1__c,
                    approver_2__c, approver_3__c, hr_user_approver__c, X4th_Level_Manager__c, X5th_Level_Manager__c, X1st_Level_Access__c, X2nd_Level_Access__c from SFDC_Job__c where id = :job2.id];
            if (job2.job_status__c == 'Job Awaiting Approval') { job2.job_status__c = 'Not Filled/Job Re-Opened'; update job2;}
         } // end run As portal user                        
        //job1.Job_Linked_to_Specific_Opportunity__c = opp.id;
        //update job1;
        // add 2 candidates to job - should also get the Manager values copied down
        list<SFDC_Job_Candidate__c> cans = new list<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(SFDC_Job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates');
        cans.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(SFDC_Job__c = job1.id, candidate__c = can2.id, status__c='Qualified Candidates');
        cans.add(jc2);  
        insert cans;
        cans = [select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, X4th_Level_Manager__c, X5th_Level_Manager__c,X1st_Level_Access__c, X2nd_Level_Access__c,  HR_User_Usual__c from SFDC_Job_Candidate__c where
            sfdc_job__c = :job1.id];
        system.debug('Job Candidates after being added to Job 1: '+cans);
        system.assert(cans[0].X1st_Level_Manager__c == currUser && cans[0].X2nd_Level_Manager__c == currUser && cans[1].X3rd_Level_Manager__c == currUser &&
           cans[1].HR_User_Usual__c == currUser);
        // Candidates should also get manager/owner settings
        can1 = [select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, ownerid from SFDC_Candidate__c where
            id = :can1.id];
        system.debug('Can1 values after being added to Job1: '+can1);
        system.assert(can1.X1st_Level_Manager__c == currUser && can1.X2nd_Level_Manager__c == currUser && can1.X3rd_Level_Manager__c == currUser &&
           can1.HR_User_Usual__c == currUser && can1.ownerid == u.id);  
                    

        // add 2 candidates to job2
        list<SFDC_Job_Candidate__c> cans2 = new list<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c(SFDC_Job__c = job2.id, candidate__c = can1.id, status__c='Qualified Candidates');
        cans2.add(jc3);
        SFDC_Job_Candidate__c jc4 = new SFDC_Job_Candidate__c(SFDC_Job__c = job2.id, candidate__c = can2.id, status__c='Qualified Candidates');
        cans2.add(jc4);  
        insert cans2;


         // now update the users approvers to u2 and account managers to u
         test.starttest();
         system.debug('job 1 before manager changes: '+job1);   
         system.runas(admin) {
             u.job_approver_1__c = u2.id;
             u.job_approver_2__c = u2.id;
             u.job_approver_3__c = u2.id;
             u.hr_user_approver__c = u2.id; 
             update u;
         }
         a.X1st_Level_Manager__c = u.id;
         a.X2nd_Level_Manager__c = u.id;
         a.X3rd_Level_Manager__c = u.id;
         a.X4th_Level_Manager__c = u.id;
         a.X5th_Level_Manager__c = u.id;
         a.X1st_Level_Access__c = u.id;
         a.X2nd_Level_Access__c = u.id;
         a.HR_User_Usual__c = u.id;
         update a;
         job1.ltas__c = userinfo.getuserid();
         update job1;
         system.debug('job 1 after manager changes - Stop 1: '+job1);
         test.stoptest();
         
         // now job1 should have approvers = u2, managers = u and cans with managers u
        job1 = [select id, name, job_status__c, ownerid, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, approver_1__c,
                approver_2__c, approver_3__c, hr_user_approver__c, ltas__c, (select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, 
                HR_User_Usual__c from SFDC_Job_Candidates__r) from SFDC_Job__c where id = :job1.id];
        system.debug('job 1 after manager changes: '+job1);
        //system.assert(job1.approver_1__c == u2.id && job1.approver_2__c == u2.id && job1.approver_3__c == u2.id && 
          // job1.hr_user_approver__c == u2.id && job1.X1st_Level_Manager__c == u.id && job1.X2nd_Level_Manager__c == u.id && job1.X3rd_Level_Manager__c == u.id &&
           //job1.HR_User_Usual__c == u.id);
        //system.assert(job1.SFDC_Job_Candidates__r[0].X1st_Level_Manager__c == u.id && job1.SFDC_Job_Candidates__r[0].X2nd_Level_Manager__c == u.id && 
         //  job1.SFDC_Job_Candidates__r[1].X3rd_Level_Manager__c == u.id && job1.SFDC_Job_Candidates__r[1].HR_User_Usual__c == u.id);
         // job 2 should have no changes as it is not open
        job2 = [select id, job_status__c, name, ownerid, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, approver_1__c,
                approver_2__c, approver_3__c, hr_user_approver__c, (select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, 
                HR_User_Usual__c from SFDC_Job_Candidates__r) from SFDC_Job__c where id = :job2.id];
        system.debug('Current User is: '+curruser+' and U2: '+u2.id+' and U: '+u.id);
        system.debug('Job2 after manager change on user: '+job2);
        system.assert(job2.approver_1__c == currUser);
        system.assert(job2.approver_2__c == currUser);
        system.assert(job2.approver_3__c == currUser);
        system.assert(job2.hr_user_approver__c == currUser);
        system.assert(job2.X1st_Level_Manager__c == currUser);
        system.assert(job2.X2nd_Level_Manager__c == currUser);
        system.assert(job2.X3rd_Level_Manager__c == currUser);
        system.assert(job2.HR_User_Usual__c == currUser );
        system.assert(job2.SFDC_Job_Candidates__r[0].X1st_Level_Manager__c == currUser && job2.SFDC_Job_Candidates__r[0].X2nd_Level_Manager__c ==currUser && 
           job2.SFDC_Job_Candidates__r[1].X3rd_Level_Manager__c == currUser  && job2.SFDC_Job_Candidates__r[1].HR_User_Usual__c == currUser );
        // Candidates should also get manager changes applied to Job1
        can1 = [select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, HR_User_Usual__c, ownerid from SFDC_Candidate__c where
            id = :can1.id];
        system.debug('after account mgrs were changed, candidate 1 should have new options: '+can1+' // where job1 owner is: '+job1.ownerid+' and mgr 1 is : '+job1.X1st_Level_Manager__c);
        //system.assert(can1.X1st_Level_Manager__c == u.id && can1.X2nd_Level_Manager__c == u.id && can1.X3rd_Level_Manager__c == u.id &&
          // can1.HR_User_Usual__c == u.id && can1.ownerid == u.id);  
           
       // candidate 1 should have the same ltas as job 1 does now - current user
       jc1 = [select id, ltas__c from SFDC_Job_Candidate__c where id = :jc1.id];
       system.assert(jc1.ltas__c == userinfo.getuserid());
    }
    
    
    // test methods for the triggers on Blacklist and Job Record Type objects
    private static testmethod void testBlacklist() {
        // create 2 JRT records
        Job_Record_Type__c jrt1 = new Job_Record_Type__c(name = 'test1', record_type_id__c = 'abc');
        insert jrt1;
        Job_Record_Type__c jrt2 = new Job_Record_Type__c(name = 'test2', record_type_id__c = 'abcd');
        insert jrt2;  
        integer JRTCnt = [select count() from Job_Record_Type__c];
        
        // add a Blacklist with 'apply to all clients' checked and should create 2 Blacklist Job Type records
        Blacklist__c b1 = new Blacklist__c(name = 'last', first_name__c = 'first', email__c = 'testing123@mfg.com', apply_to_all_clients__c = true);
        insert b1;
        //system.assertequals(JRTCnt, [select count() from Blacklist_Job_Type__c where blacklist__c = :b1.id]);
        
        // add a new JRT and it should create a third link to b1
        Job_Record_Type__c jrt3 = new Job_Record_Type__c(name = 'test3', record_type_id__c = 'abcde');
        insert jrt3;
        //system.assertequals(JRTCnt +1, [select count() from Blacklist_Job_Type__c where blacklist__c = :b1.id]);
              
    }
  
    // tests reference reviewed check on candidate when 2 ref are complete, ref linked to candidate and auto text replacement
    static testMethod void Reference_Reviewed_Trigger_Test() {
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'First', last_Name__c = 'Last');
        insert can1;
        can1 = [select id, first_name__c, last_name__c, name from SFDC_Candidate__c where id = :can1.id];
                
        SFDC_Job__c job1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', Job_Role_Title__c = 'test');
        insert job1;
        // add a JC in qualified candidates
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates', sent_by__c = 'Jeff Summers');
        insert jc1;    
        // add open status setting values
        Open_Job_Statuses__c o1 = new Open_Job_Statuses__c (name = 'test', status_name__c = 'Open/Active Job');
        insert o1;
        // add a second JC in qualified candidates
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(sfdc_job__c = job1.id, candidate__c = can1.id, status__c='Qualified Candidates', sent_by__c = 'Jeff Summers', 
            Candidate_Status_Notes_if_applicable__c = 'second candidate added');
        insert jc2; 
        system.debug('about toa dd reference');
        // add a Reference record for the can rec, also test that hd email will move if valid format
        References__c r1 = new References__c(candidate_record__c = can1.id, email__c = 'abc@test.com');
        insert r1;
        
        r1 = [select id, candidate__c, candidate_record__c, hiredesk_email__c, email__c from References__c where id = :r1.id];
        // test that hd email moved
        //system.assertequals(r1.email__c, r1.hiredesk_email__c, 'hiredesk email moved over');
        // can't really test which candidate is linked since they are added so close together in test method
        ////system.assertequals(r1.candidate__c, jc2.id);                
        // now test checking the Ref reviewed box
        r1.reference_reviewed__c = true;
        //** need to update based on latest criteria for 'completed'
        r1.Reference_Completed_Successfully__c = 'Completed';        
        update r1;      
        // look up candidate that was linked - should NOT have the checkbox checked
        SFDC_Job_Candidate__c linked = [select id, references_all_reviewed__c from SFDC_Job_Candidate__c where id = :r1.candidate__c];
        system.assert(!linked.references_all_reviewed__c);
        // add a second reference to meet our minimum of 2 (also add bad email address into hd email
        References__c r2 = new References__c(candidate_record__c = can1.id, Reference_Completed_Successfully__c = 'Completed', type__c = 'Past Manager', first_name__c = 'John', email__c = 'abcdef@test');
        insert r2; 
        // now Candidate should be checked
        linked = [select id, references_all_reviewed__c from SFDC_Job_Candidate__c where id = :linked.id];
        system.assert(linked.references_all_reviewed__c); 
        // test that hd email not moved
        r2 = [select id, candidate__c, candidate_record__c, hiredesk_email__c, email__c from References__c where id = :r2.id];
        system.assertnotequals(r2.email__c, r2.hiredesk_email__c, 'hiredesk email not moved over');        
        // test FGL autotext past
        r2.FGL_Applicant_Attendance__c = 'y; extra text';
        r2.fgl_applicant_job_duties__c = 'Y; more text';
        r2.fgl_would_you_rehire__c = 'Y;';
        update r2;        
        r2 = [select id, FGL_Applicant_Attendance__c, fgl_applicant_job_duties__c, fgl_would_you_rehire__c from References__c where id = :r2.id];
        system.debug('reference auto text is: ');
        system.assert(!r2.FGL_Applicant_Attendance__c.startswith('y;') );
        system.assert(r2.FGL_Applicant_Attendance__c.endswith('extra text') );
        system.assert(r2.FGL_Applicant_Attendance__c.contains(' were ') );  
        //system.assertequals(r2.fgl_applicant_job_duties__c, 'First was responsible for more text');
        r2.type__c = 'Current Manager';
        r2.fgl_applicant_team_player__c= 'y;';
        update r2;
        r2 = [select id, fgl_applicant_team_player__c from References__c where id = :r2.id];
        system.assert(r2.fgl_applicant_team_player__c.startswith('Yes, First is a team player'));
    }
    
    static testmethod void testCaseTrigger() {
        // create new user
        Account parenta = new Account(name = 'parent');
        insert parenta;
        Account a = new Account(name = 'test portal', parentid = parenta.id);
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), user_classification__c = 'Demo Related', 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id);
        insert u;
        // insert job then case linked to job
        SFDC_Job__c job1 = new SFDC_Job__c(ownerid = u.id, job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test', Job_Role_Title__c = 'test');
        insert job1;    
        job1 = [select id, name from SFDC_Job__c where id = :job1.id];
        SFDC_Job__c job2 = new SFDC_Job__c(ownerid = u.id, job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', job_name__c = 'Test2', Job_Role_Title__c = 'test');
        insert job2; 
        job2 = [select id, name from SFDC_Job__c where id = :job2.id];
        Case ca = new Case(subject = 'test',Case_Is_Related_to_Specific_Job__c = job1.id );
        insert ca;
        
        // should be a job case link record created
        //system.assertequals(1, [select count() from Case_Job_link__c where case__c = :ca.id]);
        ca = [select id, Case_Is_Related_to_Specific_account__c, case_parent_account__c from Case where id = :ca.id];
        //system.assertequals(ca.Case_Is_Related_to_Specific_account__c, a.id);
        //system.assertequals(ca.case_parent_account__c, parenta.id);
        
        // now create case linked directly to accoutn a with no case
        Case c1 = new Case(accountid = a.id, subject = 'test parent');
        insert c1;
        c1 = [select id, Case_Is_Related_to_Specific_account__c, case_parent_account__c from Case where id = :c1.id];
        //system.assertequals(c1.Case_Is_Related_to_Specific_account__c, null);
        //system.assertequals(c1.case_parent_account__c, parenta.id);
        
        // now create a case with both jobs listed in case related to job (recruiter)
        Case c2 = new Case(subject = 'test2',Case_is_Related_to_Job_from_Recruiters__c = job1.name +', '+job2.name,
                            Recruiter_MFG_Employee_Id_Text__c = Userinfo.getuserid(), suppliedemail = 'test@test.com');
        insert c2;            
        //system.assertequals(2, [select count() from Case_Job_link__c where case__c = :c2.id]);
        // user id should be set and mfg email
        c2 = [select id, Recruiter_MFG_Employee__c, Recruiter_MFG_Employee_email__c from case where id = :c2.id];
        //system.assertequals(userinfo.getuserid(), c2.Recruiter_MFG_Employee__c);
        //system.assertequals('test@test.com', c2.Recruiter_MFG_Employee_email__c);
    }

    static testmethod void testJobPointNamingTrigger() {
        // create new point records
        list<job_point__c> jps = new list<job_point__c>();
        // get some valid job recs
        map<Id, RecordType> RecTypeMapbyID = new Map<Id, RecordType>([select id, name from recordtype where SobjectType='SFDC_Job__c' and isactive = true]);
        list<RecordType> rts = RecTypeMapbyID.values();
        RecordType RecordTypeA  = rts[1];
        RecordType RecordTypeB  = rts[2];
        RecordType RecordTypeC  = rts[3];
        // add job points with client names and some with record type ids
        job_point__c j1 = new job_point__c(client__c = RecordTypea.name, job_title__c = 'test1', banner_of_store__c = 'b1');
        jps.add(j1);
        job_point__c j2 = new job_point__c(client__c = RecordTypeb.name, job_title__c = 'test2', banner_of_store__c = 'b2');
        jps.add(j2);
        job_point__c j3 = new job_point__c(client__c = RecordTypec.name, job_title__c = 'test3', banner_of_store__c = 'b3');
        jps.add(j3);
        job_point__c j4 = new job_point__c(record_type_id__c = RecordTypea.id, job_title__c = 'test4');
        jps.add(j4);
        job_point__c j5 = new job_point__c(record_type_id__c = RecordTypeb.id, job_title__c = 'test5');
        jps.add(j5);
        job_point__c j6 = new job_point__c(record_type_id__c = RecordTypec.id, job_title__c = 'test6');
        jps.add(j6);
        insert jps;
        jps = [select  id, client__c, record_type_id__c, name, match_key__c from job_point__c where id in :jps order by job_title__c];
        // check each have client/rec type and name/match key set
        //system.assertequals(jps[0].record_type_id__c, RecordTypea.id);
        //system.assertequals(jps[0].name, jps[0].client__c + ' - b1 - test1');
        //system.assertequals(jps[1].record_type_id__c, RecordTypeb.id);
        //system.assertequals(jps[1].match_key__c, jps[1].client__c + ' - b2 - test2');
        //system.assertequals(jps[2].record_type_id__c, RecordTypec.id);
        //system.assertequals(jps[2].name, jps[2].client__c + ' - b3 - test3');
        //system.assertequals(jps[3].client__c, RecordTypea.name);
        //system.assertequals(jps[3].name, jps[3].client__c + ' - test4');
        //system.assertequals(jps[4].client__c, RecordTypeb.name);
        //system.assertequals(jps[4].match_key__c, jps[4].client__c + ' - test5');
        //system.assertequals(jps[5].client__c, RecordTypec.name);
        //system.assertequals(jps[5].name, jps[5].client__c + ' - test6');
        // now update job title for updated name
        jps[0].job_title__c = 'test1abc';
        jps[1].job_title__c = 'test2abc';
        update new list<job_point__c>{jps[0], jps[1]};
        jps = [select  id, client__c, record_type_id__c, name, match_key__c from job_point__c where id in :jps order by job_title__c];
        //system.assertequals(jps[0].name, jps[0].client__c + ' - b1 - test1abc');
        //system.assertequals(jps[1].match_key__c, jps[1].client__c + ' - b2 - test2abc');        
        
    }
    
    
}