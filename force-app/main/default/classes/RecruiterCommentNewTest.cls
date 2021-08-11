// TEST METHOD //
 @istest
 private class RecruiterCommentNewTest{
    @istest
    private static void testPg() {
        // create 2 jobs
        Account a = new Account(name = 'test');
        insert a;
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No',Job_Role_Title__c = 'test');
        jobs.add(j1);
        SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No',Job_Role_Title__c = 'test');
        jobs.add(j2);
        insert jobs;
        
        // initiate page
        PageReference pageRef = Page.RecruiterCommentNew;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getparameters().put('jid', j1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(new Recruiter_comment__c());
        RecruiterCommentNew ext = new RecruiterCommentNew(con);
        // first row in jobs list should have j1 in it
        system.assertequals(ext.jobs[0].job__c, j1.id);  
        // try saving with no data in comments to hit failures
        string results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        
        // test add/delete rows in job
        // test with non-number first
        ext.rownum = 'test';
        results = 'start';
        try { results = ext.add().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass'); 
        // test with a blank rownum and it should add 1
        ext.rownum = null;
        ext.add();
        // numrows should be 2
        system.assertequals(ext.numrows, 2);   
        // test del
        ext.del();
        // numrows should be 1
        system.assertequals(ext.numrows, 1);
        
        // fill in all fields but test exception handling
        ext.comment.shortlisted_candidates__c = 1;
        ext.comment.calls__c = 1;
        ext.comment.voicemails__c = 1;
        ext.comment.number_of_candidates_rejected__c = 1; 
        ext.comment.most_common_rejection_reasons__c = 'test';
        ext.isTest = true;
        // save but come back with error message
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        // comment id should be null
        system.assertequals(ext.comment.id, null);
        
        // now add second job link and save properly
        ext.istest = false;
        ext.add();
        ext.jobs[1].job__c = j2.id;
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'fail';}
        system.debug(results);
        system.assertequals(results, '/'+j1.id);
        // there should be 2 job link recs and 1 comment
        system.assertequals([select count() from Job_recruiter_comment__c], 2);
        system.assertequals([select count() from recruiter_comment__c], 1);
        
        // test triggers on comments to update job date field
        // both jobs should have today's date now
        jobs = [select id, Date_Last_Recruiter_Comment_Posted__c from SFDC_Job__c where id in :jobs];
        system.assertequals(jobs[0].Date_Last_Recruiter_Comment_Posted__c, date.today());
        system.assertequals(jobs[1].Date_Last_Recruiter_Comment_Posted__c, date.today());
        // create 3rd job and add link to comment
        SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No',Job_Role_Title__c = 'test');
        insert j3;
        Job_Recruiter_comment__c jrc = new Job_Recruiter_Comment__c(job__c = j3.id, recruiter_comment__c = ext.comment.id);
        insert jrc;
        j3 = [select id, Date_Last_Recruiter_Comment_Posted__c from SFDC_Job__c where id = :j3.id];
        system.assertequals(j3.Date_Last_Recruiter_Comment_Posted__c, date.today());
        // clear date on j3 and then update comment calls field for reset
        j3.Date_Last_Recruiter_Comment_Posted__c = null;
        update j3;
        j3 = [select id, Date_Last_Recruiter_Comment_Posted__c from SFDC_Job__c where id = :j3.id];
        system.assertequals(j3.Date_Last_Recruiter_Comment_Posted__c, null); 
        ext.comment.calls__c = 4;
        update ext.comment;
        j3 = [select id, Date_Last_Recruiter_Comment_Posted__c from SFDC_Job__c where id = :j3.id];
        system.assertequals(j3.Date_Last_Recruiter_Comment_Posted__c, date.today());               
    } 
    }