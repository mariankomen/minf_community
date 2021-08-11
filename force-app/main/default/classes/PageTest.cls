@IsTest
    private class PageTest{
    
        @IsTest
        static void PageTest(){
        // Create test records now
        Open_Job_Statuses__c o1 = new Open_Job_Statuses__c(name = '100', status_name__c = 'test');
        insert o1;
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        insert(can1);    
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        // can 2 added to the jobs so job status is not chnaged by workflow
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        insert(can2);
        // j1 will have correct status, j2 incorrect
        SFDC_Job__c j1 = new SFDC_Job__c(Job_Role_Title__c = 'test', job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert j1;
        SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'Job Filled', Job_Role_Title__c = 'test',Specific_Candidate_Preference__c = 'No');
        insert j2;
        
        // create job can records between candidate to each job
        // jc1 will have wrong status 
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(sfdc_job__c = j1.id, candidate__c = can1.id, status__c='Rejected');
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(sfdc_job__c = j1.id, candidate__c = can2.id, status__c='Qualified Candidates');
        jcs.add(jc2); 
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c(sfdc_job__c = j2.id, candidate__c = can1.id, status__c='Qualified Candidates');
        jcs.add(jc3); 
        insert jcs;

        j1 = [select id, job_status__c from SFDC_Job__c where id = :j1.id];
        j2 = [select id, job_status__c from SFDC_Job__c where id = :j2.id];
        system.debug('jobs after candidate inserts: '+j1+' and job 2: '+j2);
                        
        // launch page for Candidate 1 - should remain at page with error message, go into Exception
        ApexPages.StandardController controller = new ApexPages.StandardController(can1);
        CandidatePageUpdate ext = new CandidatePageUpdate(controller);
        // launching function should return null, so test for it
        system.assert(ext.FindJobSubmission() == null);
        
        // now change jc1 to a valid status and should work
        jc1.status__c = 'Qualified Candidates';
        update jc1;
        
        // query for job statuses and jc statuses
        j1 = [select id, job_status__c from SFDC_Job__c where id = :j1.id];
        j2 = [select id, job_status__c from SFDC_Job__c where id = :j2.id];
        system.debug('jobs are now: '+j1+' and job 2: '+j2);
        can1 = [select id, (select id, status__c from Candidates_Submitted_to_Job1__r) from SFDC_Candidate__c where id = :can1.id];
        system.debug('candidate job submissions: '+can1.Candidates_Submitted_to_Job1__r);
        
        // relaunch page to test that URL goes to UpdateCandidate page
        controller = new ApexPages.StandardController(can1);
        ext = new CandidatePageUpdate(controller);
        // launching function should return updateCandidate page with j1.id as id parameter, so test for it
        string pg = ext.FindJobSubmission().getURL();
        system.debug('URL for working example is: '+pg);
        system.assert(pg.contains('id='+j1.id));
        system.assert(pg.contains('feature='+can1.id));
    }    
    }