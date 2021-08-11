@istest
private class CaseJobNewTest{
    // TEST METHOD //
    @istest
    private static void testPg() {
        // create 2 jobs and a Case
        Account a = new Account(name = 'test');
        insert a;
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        SFDC_Job__c j1 = new SFDC_Job__c(Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No' );
        jobs.add(j1);        
        SFDC_Job__c j2 = new SFDC_Job__c(Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        jobs.add(j2);
        insert jobs;

        Case c = new Case(subject = 'test');
        insert c;
        
        // initiate page
        PageReference pageRef = Page.CaseJobNew;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getparameters().put('id', c.id);
        ApexPages.StandardController con = new ApexPages.StandardController(c);
        CaseJobNew ext = new CaseJobNew(con);
  
        // try saving with no data in comments to hit failures
        string results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        
        // fill in first row
        ext.jobs[0].job__c = j1.id;
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
        ext.add();
        ext.jobs[1].job__c = j2.id;
       
        // test exception handling
        ext.isTest = true;
        // save but come back with error message
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        
        // now  save properly
        ext.istest = false;
        results = 'start';
        try { results = ext.save().getURL(); }
        catch (Exception e) {results = 'fail';}
        system.debug(results);
        system.assertequals(results, '/'+c.id);
        // there should be 2 job link recs
        system.assertequals([select count() from case_job_link__c], 2);
       
             
    } 
}