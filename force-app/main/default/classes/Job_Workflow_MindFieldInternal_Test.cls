@isTest
public class Job_Workflow_MindFieldInternal_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('MindField Internal').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 
            // MindField Internal's Senior Talent Acquisition Specialist
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Recruiter', Banner_of_Store__c = 'MindField Internal', FT_or_PT__c = 'Full Time', department__c = 'test', Num_of_Days_for_Delivery_Agreement__c = 999, Num_of_Candidates_for_Delivery_Agreement__c = 999);
            jobs.add(j0);
            // MindField Internal's Talent Acquisition Specialist
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Candidate Contact Representative', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 999, Num_of_Candidates_for_Delivery_Agreement__c = 999);
            jobs.add(j1);
            // MindField Internal's Talent Marketing Coordinator
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Candidate Sourcing Coordinator', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 999, Num_of_Candidates_for_Delivery_Agreement__c = 999);
            jobs.add(j2);
            // MindField Internal's Customer Success Specialist
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Experience Specialist', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 999, Num_of_Candidates_for_Delivery_Agreement__c = 999);
            jobs.add(j3);
            // MindField Internal's Reference Checker
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Candidate Reference Specialist', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);
            // MindField Internal's Account Manager
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Recruitment Operations Manager', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);
            // MindField Internal's Account Manager
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Bilingual Candidate Contact Rep', Banner_of_Store__c = 'MindField Internal', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);
            
                    
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c from SFDC_Job__c where id in :jobs order by id];

        // MindField Internal's Senior Talent Acquisition Specialist
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'MFG-1');
        system.assertequals(jobs[0].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Talent Acquisition Specialist
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'MFG-2');
        system.assertequals(jobs[1].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Talent Marketing Coordinator
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'MFG-3');
        system.assertequals(jobs[2].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Customer Success Specialist
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'MFG-4');
        system.assertequals(jobs[3].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Reference Checker
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'MFG-5');
        system.assertequals(jobs[4].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Reference Checker
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'MFG-6');
        system.assertequals(jobs[5].SLA_Level__c, 'Job Posting Only');
        // MindField Internal's Reference Checker
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'MFG-7');
        system.assertequals(jobs[6].SLA_Level__c, 'Job Posting Only');
    }
}