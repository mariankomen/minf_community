@isTest
public class Job_Workflow_COBS_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('COBS Bread').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
            // Cobs Bread Bakery Manager
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Bakery Manager',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j0);
            // Cobs Bread Assistant Bakery Manager
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Bakery Manager',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j1);
            // Cobs Bread Brand Ambassador
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Brand Ambassador Team Member',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j2);
            // Cobs Bread Baker
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Baker',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j3);                        
            // Cobs Bread Production Manager
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Production Manager',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j4);        
            // Cobs Bread Support Services Technician
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Support Services Technician',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j5);
            // Cobs Bread Junior Support Services Technician
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Junior Support Services Technician',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j6);
            // Cobs Receptionist & Finance Assistant
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Receptionist & Finance Assistant',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j7);
            // Cobs Junior Accountant
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Junior Accountant',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j8);
            // Cobs Junior Accountant OnDemand
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Junior Accountant', Banner_of_Store__c = 'COBS Support Office',  
                SLA_Level__c = 'Store Project - Included in RPO Billing', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id, MindField_Job_Type__c = 'TalentConnect - Promote Post');
            jobs.add(j9);
            // Cobs Sales Assistant
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Assistant',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j10);
            // Cobs Sales Team Leader
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Team Leader',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j11);
            // Cobs Sales Team Leader
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Graphic Designer',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j12);
            // Cobs Sales Manager
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Manager',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j13);
            // Cobs Lead Baker
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Lead Baker',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j14);    
            // Cobs Manage to Own
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Manage to Own',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j15);
            // Cobs Manage to Own
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Management Trainee',  Banner_of_Store__c = 'Cobs Store Level');
            jobs.add(j16);
            // Cobs Manage to Own
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Projects Assistant',  Banner_of_Store__c = 'COBS Support Office');
            jobs.add(j17);     
                                                   
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c from SFDC_Job__c where id in :jobs order by id];
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'COB - 1');
        system.assertequals(jobs[1].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[1].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'COB - 3');
        system.assertequals(jobs[3].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'COB - 5');
        system.assertequals(jobs[4].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[5].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'COB - 6');
        system.assertequals(jobs[6].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[6].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'COB - 8');
        system.assertequals(jobs[7].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[8].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'COB - 9');
        //system.assertequals(jobs[9].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[9].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[10].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'COB - 11');
        system.assertequals(jobs[11].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'COB - 12');
        system.assertequals(jobs[12].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'COB - 10');
        system.assertequals(jobs[13].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'COB - 13');            
        system.assertequals(jobs[14].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'COB - 14');
        system.assertequals(jobs[15].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'COB - 15');
        system.assertequals(jobs[16].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'COB - 16');
        system.assertequals(jobs[17].SLA_Level__c, 'Job Posting Only');
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'COB - 17');
    }
}