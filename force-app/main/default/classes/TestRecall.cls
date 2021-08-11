@istest
private class TestRecall{
    @istest
    static void testPg(){
        // add in Akzo Job and it should go into an Approval Process
        SFDC_Job__c j = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = '012U00000009QqV', Job_Role_Title__c = 'test');
        test.starttest();
        insert j;
        test.stoptest();
        system.debug([select id, name, job_status__c from SFDC_job__c where id = :j.id]);
        
        // instantiate the page
        ApexPages.StandardController std = new ApexPages.StandardController(j);
        RecallApprovals ext = new RecallApprovals(std);
        
        // launch with no id value to get null
        ext.autoRun();
        // now set the id value and get a Page Ref back
        ApexPages.currentPage().getParameters().put('id', j.id);
        string result = ext.autoRun().getURL();
        system.assert(result.endswith('/'+j.id));
        // check that job status has changed
        j = [select id, job_status__c from SFDC_Job__c where id = :j.id];
        system.debug('job after approval code runs: '+ j);

    }
}