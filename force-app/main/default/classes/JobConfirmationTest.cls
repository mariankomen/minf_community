@istest
    private class JobConfirmationTest{
    @isTest
    private static void testpg(){
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Job_Role_Title__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert j1;
        // set up page with newid parameter
        PageReference pageRef = Page.JobConfirmation;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getparameters().put('newid', j1.id);
        JobConfirmation ext = new JobConfirmation();
        // job should be set to j1
        system.assertequals(ext.job.id, j1.id);
        
        // try without newid parameter
        pageRef = Page.JobConfirmation;
        Test.setCurrentPage(pageRef);
        ext = new JobConfirmation();
        // job should be empty
        system.assertequals(ext.job.id, null);
    }
    }