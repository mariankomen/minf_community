@isTest
public class Job_Workflow_Tim_Hortons_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Tim Hortons - NSM').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
        
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = '0957016 BC Ltd.');
            jobs.add(j0);
            
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Multiplex Food Services Inc.');
            jobs.add(j1);
            
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Tim Hortons - Ondemand');
            jobs.add(j2);
            
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Store Manager',  Banner_of_Store__c = 'Tim Hortons - Ondemand');
            jobs.add(j3);
            
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant General Manager',  Banner_of_Store__c = 'Tim Hortons - Ondemand');
            jobs.add(j4);
            
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'QSR Group Inc');
            jobs.add(j5);
            
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'R.A.F Holdings Ltd');
            jobs.add(j6);
            
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Branison Holdings Inc');
            jobs.add(j7);
            
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Churchill Foods Ltd');
            jobs.add(j8);
            
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'I&G Bismarketing Ltd');
            jobs.add(j9);
            
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = 'I&G Bismarketing Ltd');
            jobs.add(j10);
            
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = '1008904 BC Ltd');
            jobs.add(j11);
            
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = '1008904 BC Ltd');
            jobs.add(j12);
            
            
            
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Interwest Restaurants Inc');
            jobs.add(j13);
            
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = 'Interwest Restaurants Inc');
            jobs.add(j14);
            
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = '474722BCLTD');
            jobs.add(j15);
            
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = '474722BCLTD');
            jobs.add(j16);
            
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'Kesther Enterprises Ltd');
            jobs.add(j17);
            
            SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member',  Banner_of_Store__c = 'GB Emett Holdings');
            jobs.add(j18);
            
            SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Restaurant Team Member - Graveyard',  Banner_of_Store__c = 'GB Emett Holdings');
            jobs.add(j19);
            
            SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = 'GB Emett Holdings');
            jobs.add(j20);
            
             SFDC_Job__c j21 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Restaurant Manager',  Banner_of_Store__c = 'GB Emett Holdings');
            jobs.add(j21);
                  
            insert jobs;
        }
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'TH-2');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'TH-3');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'TH-4');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'TH-4');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'TH-1');
        
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'TH-1');
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'TH-4');
        system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'TH-2');
        
    }
}