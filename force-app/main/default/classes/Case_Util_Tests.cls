/***********
test methods for Case Util class

***********/

@istest
public class Case_Util_Tests{

    // tests process email messages for Case
    static testMethod void processEmails(){
        // create case and case email
        Case c1 = new Case(subject = 'sample case subject', status = 'New');
        insert c1;
        List<Task> ts = new List<Task>();
        Task t1 = new Task(whatid = c1.id, subject = 'test');
        ts.add(t1);
        Task t2 = new Task(whatid = c1.id, subject = 'test2');
        ts.add(t2);
        Task t3 = new Task(whatid = c1.id, subject = 'test3');
        ts.add(t3);        
        insert ts;
        List<EmailMessage> msgs = new List<EmailMessage>();
        // first test with no matching text in body
        EmailMessage em = new EmailMessage(activityid = t1.id, fromaddress = 'jeff.summers@mindfieldgroup.com',
                                           Fromname = 'Jeff Summers', messagedate = date.today(), parentid = c1.id,
                                           textbody = 'sample response from recruiter\nHere is my email text to include');
        msgs.add(em);
        // next test with [cid in body
        EmailMessage em2 = new EmailMessage(activityid = t1.id, fromaddress = 'jeff.summers@mindfieldgroup.com',
                                           Fromname = 'Jeff Summers', messagedate = date.today(), parentid = c1.id,
                                           textbody = 'sample response from recruiter\nHere is my email text to include'+
                                           'and here is From: SalesForce Case Updates with other stuff afterwards ');
        msgs.add(em2);        
        // next test with From Case Updates in body
        EmailMessage em3 = new EmailMessage(activityid = t1.id, fromaddress = 'jeff.summers@mindfieldgroup.com',
                                           Fromname = 'Jeff Summers', messagedate = date.today(), parentid = c1.id,
                                           textbody = 'sample response from recruiter\nHere is my email text to include'+
                                           'and here is [cid with other stuff afterwards From: SalesForce Case Updates testing');
        msgs.add(em3);
        test.starttest();
        // insert msgs
        insert msgs;
        // should be 3 case comments
        system.assertequals(3, [select count() from CaseComment where parentid = :c1.id]);
        // should be 3 email msgs
        system.assertequals(3, [select count() from EmailMessage where parentid = :c1.id]);
        test.stoptest();
        // after future method runs, no more msgs
        system.assertequals(0, [select count() from EmailMessage where parentid = :c1.id]);        
    }
    
    // tests rebuild case linked to job (recruiter) field on Case with case job links
    static testMethod void buildRecruiterField(){
        // create 2 jobs for testing
        SFDC_Job__c job1 = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' );
        insert job1; 
        job1 = [select id, name from SFDC_Job__c where id = :job1.id];
        SFDC_Job__c job2 = new SFDC_Job__c(job_name__c = 'Test1', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' );
        insert job2;         
        job2 = [select id, name from SFDC_Job__c where id = :job2.id];
        // create case with 1 job in text field
        Case c1 = new Case(subject = 'sample case subject', status = 'New', Case_is_Related_to_Job_from_Recruiters__c = job1.name);
        insert c1;
        // should have created a job case link due to trigger
        c1 = [select id, Case_is_Related_to_Job_from_Recruiters__c, (select id from case_job_links__r) from Case where id = :c1.id];
        system.assertequals(c1.case_job_links__r.size(), 1);
        // now add new case job link to job 2
        Case_job_link__c cj = new Case_Job_link__c(case__c = c1.id, job__c = job2.id);
        insert cj;
        c1 = [select id, Case_is_Related_to_Job_from_Recruiters__c, (select id from case_job_links__r) from Case where id = :c1.id];
        system.assertequals(c1.case_job_links__r.size(), 2);
        system.assertequals(c1.Case_is_Related_to_Job_from_Recruiters__c, job1.name+','+job2.name);    
        
    }  
    
    // test before insert trigger on case to set recruiter field for helpdesk cases
    static testmethod void HelpDeskCaseRecruiterLink() {
        // MFG HelpDesk record type id
        Id MFGHelpDeskRecId;
        try {
            Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
            if (rtMapByName.containskey('MFG Helpdesk'))
                MFGHelpDeskRecId = rtMapByName.get('MFG Helpdesk').getrecordtypeid();
        } catch (Exception e) {}
        
        // need users for testing manually created cases: 
        // 1. as Gary - 005U0000002htDUIAY (should not link) 
        Case c1 = new Case(subject = 'test1', recordtypeid = MFGHelpDeskRecId);
        User gary = [select id from user where id = '005U0000001dhAZ'];
        system.runas(gary) {
            insert c1;
        }
        c1 = [select id, subject, recruiter_mfg_employee__c , createdbyid from case where id = :c1.id];
        system.assertequals(c1.recruiter_mfg_employee__c , null);
        
        //  2. as new user (should link)
        Profile p = [select id from profile where name = 'System Administrator'];
        User u_admin = new User(firstname='u_mfg1', lastname = 'user', email='niki@vankerksolutions.com', profileid = p.id,
            username = 'sample@mfg.helpdesk', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles');
        insert u_admin;
        Case c2 = new Case(subject = 'test2', recordtypeid = MFGHelpDeskRecId);
        system.runas(u_admin) {
            insert c2;
        }
        c2 = [select id, subject, recruiter_mfg_employee__c , createdbyid from case where id = :c2.id];
        system.assertequals(c2.recruiter_mfg_employee__c , u_admin.id); 
        
        // as new user but already filled out recruiter field with other name
        Case c3 = new Case(subject = 'test3', recordtypeid = MFGHelpDeskRecId, recruiter_mfg_employee__c = gary.id);
        system.runas(u_admin) {
            insert c3;
        }
        c3 = [select id, subject, recruiter_mfg_employee__c , createdbyid from case where id = :c3.id];
        system.assertequals(c3.recruiter_mfg_employee__c , gary.id); 
        
        //  now test the email to case by settig suppliedname for the new uadmin user
        Case c4 = new Case(subject = 'test3', recordtypeid = MFGHelpDeskRecId, suppliedname = 'u_mfg1 user', suppliedemail = 'niki@vankerksolutions.com');
        insert c4;
        c4 = [select id, subject, recruiter_mfg_employee__c , createdbyid from case where id = :c4.id];
        system.assertequals(c4.recruiter_mfg_employee__c , u_admin.id);                       
    }      
}