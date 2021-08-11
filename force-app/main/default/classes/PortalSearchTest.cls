// TEST METHOD //
 @istest
 private class PortalSearchTest{
 @istest
    private static void testPg(){
        PageReference pageRef = Page.PortalSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentpage().getparameters().put('searchTerms', 'testing');
        PortalSearch con = new PortalSearch();
        // searchterms should have defaulted
        system.assertequals(con.searchterms, 'testing');
        // initial search function will call search
        con.initialsearch();
        // with more time, add jobs/candidates to test that the queries are working as expected
        
        // test sort logic for jobs
        // get MFG Demo rec type
        id MFGDemo = [select id, name from recordtype where developername = 'MFG_Demo' and sobjecttype = 'SFDC_Job__C' limit 1].id;        
        list<SFDC_Job__c> jobs = new list<SFDC_Job__c>();
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',
                                            recordtypeid = MFGDemo, Name_of_Person_Submitting_Request__c= 'example one');
        jobs.add(j1);
        SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',
                                            recordtypeid = MFGDemo, Name_of_Person_Submitting_Request__c= 'example two');
        jobs.add(j2);  
        insert jobs;
        con.jobsortby = 'Name_of_Person_Submitting_Request__c';
        con.jobsortdir = 'DESC';
        con.JobRecs = jobs;
        con.sortjoblist();
        system.assertequals(con.jobrecs[0].Name_of_Person_Submitting_Request__c, 'example two');  
        con.jobsortdir = 'ASC';
        con.sortjoblist();
        system.assertequals(con.jobrecs[0].Name_of_Person_Submitting_Request__c, 'example one');             
    }
    }