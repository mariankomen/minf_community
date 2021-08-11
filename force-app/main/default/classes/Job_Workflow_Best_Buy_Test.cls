@isTest
public class Job_Workflow_Best_Buy_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Best Buy').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 

            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Geek Squad Technicians – DC', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);
            
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Geek Squad Technicians – DC', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);
            
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Product Process Specialist – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);
            
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Solutions Advisor – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);

            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Warehouse Associate – DC', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);
            
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Customer Service Specialist', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);
            
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Customer Experience Associate - CHQ', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);
            
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Seasonal Retail Associate', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);
            
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Counter Intelligence Agent', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j8);
            
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sr. Administration – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j9);
            
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Team Lead – DC', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j10);
                     
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sr. Advisor – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j11);
            
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Precinct Chief – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12);
                     
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Team Lead (Supervisor) – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13);
            
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Supervisor – DC', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j14);
                         
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Assistant Store Leader – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j15);
                        
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Leader – Retail', 
            FT_or_PT__c = 'Full Time', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j16);

                    
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c from SFDC_Job__c where id in :jobs order by id];

        // Mark's Sales Associate
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'BB-2');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'BB-2');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'BB-3');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'BB-4');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'BB-5');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'BB-6');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'BB-7');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'BB-8');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'BB-9');
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'BB-10');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'BB-11');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'BB-12');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'BB-13');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'BB-14');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'BB-15');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'BB-16');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'BB-17');

    }
}