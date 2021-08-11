@isTest
public class Job_Workflow_Wendys_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Wendys - NSM').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
        
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Crew Member',  Banner_of_Store__c = 'QSR Group Inc');
            jobs.add(j0);
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Crew Member',  Banner_of_Store__c = 'Wendys - Ondemand');
            jobs.add(j1);
            
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Manager',  Banner_of_Store__c = 'QSR Group Inc');
            jobs.add(j2);
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Manager',  Banner_of_Store__c = 'Wendys - Ondemand');
            jobs.add(j3);
            
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'General Manager',  Banner_of_Store__c = 'QSR Group Inc');
            jobs.add(j4);
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'General Manager',  Banner_of_Store__c = 'Wendys - Ondemand');
            jobs.add(j5);
            
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shift Supervisor',  Banner_of_Store__c = 'QSR Group Inc');
            jobs.add(j6);
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shift Supervisor',  Banner_of_Store__c = 'Wendys - Ondemand');
            jobs.add(j7);
                  
            insert jobs;
        }
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'WEN-1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'WEN-1');
        
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'WEN-2');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'WEN-2');
        
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'WEN-3');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'WEN-3');
        
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'WEN-4');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'WEN-4');
        
    }
}