@istest
    private class TestReminderUtil{
    @istest
    static void TestReminder_Insert() {
        /*
    
        // create base records
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'Test', last_name__c = 'Sample');
        cans.add(can1);
        SFDC_Candidate__c can2 = new SFDC_Candidate__c(first_name__c = 'Test2', last_name__c = 'Sample');
        cans.add(can2);
        insert cans;
        SFDC_Job__c job = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No',Job_Role_Title__c = 'test');
        insert job;
        
        // add 2 Candidates to Job, 1 with Qualified and one with something else
        // first with my english user being the job owner
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(candidate__c = can1.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(candidate__c = can2.id, sfdc_job__c= job.id, status__c = 'Rejected');
        jcs.add(jc2);
        insert jcs;        
        
        // find all reminders linked to job - should only be 1
        integer cnt = [select count() from MFG_Reminder__c where sfdc_job__c = :job.id];
        //system.assertequals(cnt, 1);
        MFG_Reminder__c english = [select id, name, description__c, due_date__c, type__c from MFG_Reminder__c where sfdc_job__c = :job.id];
        system.debug('english reminder: '+english);
                
        // add another Candidates to Job as french user
        User me = [select id, languagelocalekey from User where id = :userinfo.getuserid()];
        me.languagelocalekey = 'fr';
        update me;
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c(candidate__c = can2.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        insert jc3;        
        
        // find reminders linked to job candidate
        MFG_Reminder__c french = [select id, name, description__c, due_date__c, type__c from MFG_Reminder__c where sfdc_job_candidate__c = :jc3.id];
        system.debug('french reminder: '+french);
        */
    }
    
    // test code to ensure reminders are generated for each update with changed Interview status
    @istest
    static void TestReminder_Update() {
        /*
        // create base records
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'Test', last_name__c = 'Sample');
        cans.add(can1);
        SFDC_Candidate__c can2 = new SFDC_Candidate__c(first_name__c = 'Test2', last_name__c = 'Sample');
        cans.add(can2);
        insert cans;
        SFDC_Job__c job = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test');
        insert job;
        
        // add 2 Candidates to Job
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(candidate__c = can1.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(candidate__c = can2.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        jcs.add(jc2);
        insert jcs;        
        system.debug('after adding 2 Qualified Candidates to job we have these reminders: '+[select id, status__c, due_date__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id]);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
        // should have created 2 reminders
        // now update each to inteviewing with date 5 days in future
        jc1.Status__c = 'Interviewing/Background Check';
        jc1.interview_date__c = date.today().adddays(5);
        jc2.Status__c = 'Interviewing/Background Check';
        jc2.interview_date__c = date.today().adddays(5);   
        update jcs;
        //system.assertequals(4, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id]);        
        system.debug('after updating both status to interviewing we have these reminders: '+[select id, status__c, due_date__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
             
        // find all reminders linked to job with due date 6 days out
        date dueDate = date.today().adddays(6);
        integer cnt = [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and due_date__c = :dueDate];
        //system.assertequals(cnt, 2);
        
        // now update both - one is moved to 6 days in future, one is hired.  Should only create 1 additional reminder, now 5 in total
        jc1.Interview_Date__c = date.today().adddays(6);
        jc2.status__c = 'Hired';
        update jcs;
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
        
        // find all reminders linked to job with due date 7 days out
        dueDate = date.today().adddays(7);
        cnt = [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and due_date__c = :dueDate];
        //system.assertequals(cnt, 1);
        MFG_Reminder__c english = [select id, name, description__c, due_date__c, type__c from MFG_Reminder__c where sfdc_job__c = :job.id and due_date__c = :dueDate];
        system.debug('english reminder: '+english);
        
        // find total  num reminders, should be 5
        cnt = [select count() from MFG_Reminder__c where sfdc_job__c = :job.id];
        //system.assertequals(cnt, 5);
        
        // test french user
        User me = [select id, languagelocalekey from User where id = :userinfo.getuserid()];
        me.languagelocalekey = 'fr';
        update me;
        jc1.Interview_Date__c = date.today().adddays(6);        
        update jc1;
        
        // find reminders linked to job candidate
        MFG_Reminder__c french = [select id, name, description__c, due_date__c, type__c from MFG_Reminder__c where sfdc_job_candidate__c = :jc1.id and status__c = 'New'];
        system.debug('french reminder: '+french);
        */
    }
    // test code to ensure reminders are generated for each update with left message
    @istest
    static void TestReminder_Message() {
        /*
        // create base records
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'Test', last_name__c = 'Sample');
        cans.add(can1);
        SFDC_Candidate__c can2 = new SFDC_Candidate__c(first_name__c = 'Test2', last_name__c = 'Sample');
        cans.add(can2);
        insert cans;
        SFDC_Job__c job = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No',Job_Role_Title__c = 'test');
        insert job;
        
        // add 2 Candidates to Job
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(candidate__c = can1.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(candidate__c = can2.id, sfdc_job__c= job.id, status__c = 'Qualified Candidates');
        jcs.add(jc2);
        insert jcs;        
        system.debug('after adding 2 Qualified Candidates to job we have these reminders: '+[select id, status__c, due_date__c, type__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Initial Update']);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
        // should have created 2 reminders
        // now update with candidate message date set in both
        jc1.candidate_message_date__c = date.today();
        jc2.candidate_message_date__c = date.today();
        update jcs;
        // should have 2 new reminders created
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Message']);        
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Initial Update' and status__c = 'Complete']);
        system.debug('after updating both with message dates we have these reminders: '+[select id, status__c, due_date__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
        
        // now change the message dates -> should close the first 2 and create 2 more
        jc1.candidate_message_date__c = date.today().adddays(1);
        jc2.candidate_message_date__c = date.today().adddays(1);
        update jcs;
        // should have 4 Message reminders created
        //system.assertequals(4, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Message']);        
        system.debug('after updating both with new message dates we have these reminders: '+[select id, status__c, due_date__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
                        
        // now update each to inteviewing with date 5 days in future to show message closed
        jc1.Status__c = 'Interviewing/Background Check';
        jc1.interview_date__c = date.today().adddays(5);
        jc2.Status__c = 'Interviewing/Background Check';
        jc2.interview_date__c = date.today().adddays(5);   
        update jcs;
        //system.assertequals(2, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Interview']);        
        // should have 4 message reminders completed
        //system.assertequals(4, [select count() from MFG_Reminder__c where sfdc_job__c = :job.id and type__c = 'Message' and status__c = 'Complete']);  
        system.debug('after updating both status to interviewing we have these reminders: '+[select id, status__c, due_date__c from MFG_Reminder__c where sfdc_job__c = :job.id]);
        // reset 'firstRun' boolean since static and test method is in the same class
        firstRun = true;
        */
    }

    
    // test code for translation function
    @istest
    static void TestTranslations() {
        //system.assertequals(TranslateJobTitle('Operations Manager'), 'Directeur opérations');
        //system.assertequals(TranslateJobTitle('Product Process Manager'), 'Directeur de processus de produit');
        //system.assertequals(TranslateJobTitle('Sales Manager'), 'Directeur commercial');
        //system.assertequals(TranslateJobTitle('General Manager'), 'Directeur général');
        //system.assertequals(TranslateJobTitle('no match'), 'no match');
        //system.assertequals(TranslateJobTitle(''), '');
    }      
    }