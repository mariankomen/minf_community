@istest
private class JobBroadcastNewTest{
    @istest
    private static void testPg() {
        // create 2 jobs
        Account a = new Account(name = 'test');
        insert a;
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        SFDC_Job__c j1 = new SFDC_Job__c(Job_Role_Title__c = 'test' ,job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        jobs.add(j1);        
        SFDC_Job__c j2 = new SFDC_Job__c(Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        jobs.add(j2);
        SFDC_Job__c j1dup = new SFDC_Job__c(Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        jobs.add(j1dup);
        SFDC_Job__c j1dupdup = new SFDC_Job__c(Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        jobs.add(j1dupdup);        
        insert jobs;
        // add dup to j1
        j1.Duplicate_Job__c = j1dup.id;
        update j1;
        // add dup to j1dup
        j1dup.Duplicate_Job__c = j1dupdup.id;
        update j1dup;        
        // initiate page
        PageReference pageRef = Page.JobBroadcastNew;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getparameters().put('jid', j1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(new Job_Broadcasting__c());
        JobBroadcastNew ext = new JobBroadcastNew(con);
        // first row in jobs list should have j1 in it
        system.assertequals(ext.jobs[0].job__c, j1.id);
        // second row should have j1dup
        system.assertequals(ext.jobs[1].job__c, j1dup.id);  
        // third row should have j1dupdup
        system.assertequals(ext.jobs[2].job__c, j1dupdup.id);
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
        // numrows should be 4
        system.assertequals(ext.numrows, 4);   
        // test del
        ext.del();
        // numrows should be 3
        system.assertequals(ext.numrows, 3);
        
        // try save with no values
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        // comment id should be null
        system.assertequals(ext.broadcast.id, null);
        
        // fill in all fields but test exception handling
        ext.broadcast.medium__c = 'Job Board';
        ext.broadcast.job_board__c = 'test';
        ext.broadcast.new_refresh__c = 'New';
        ext.isTest = true;
        // save but come back with error message
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        // comment id should be null
        system.assertequals(ext.broadcast.id, null);
        
        // now save properly using save and new
        ext.istest = false;
        results = 'start';
        try { results = ext.save_new().getURL(); }
        catch (Exception e) {results = 'fail';}
        system.debug(results);
        // save and new brings us back to this page, not the Job
        system.assertequals(results, '/apex/jobbroadcastnew?jid='+j1.id);
        // there should be 2 job link recs and 1 comment
        system.assertequals([select count() from Job_broadcasting_link__c], 3);
        system.assertequals([select count() from Job_broadcasting__c], 1);
        
        // test triggers that update job date field
        // both jobs should have today's date now
        //jobs = [select id, Date_Job_Last_Posted_Refreshed__c from SFDC_Job__c where id in :jobs];
        //system.assertequals(jobs[0].Date_Job_Last_Posted_Refreshed__c, date.today());
        //system.assertequals(jobs[2].Date_Job_Last_Posted_Refreshed__c, date.today());
               
    } 
}