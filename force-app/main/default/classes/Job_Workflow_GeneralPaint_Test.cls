@isTest
public class Job_Workflow_GeneralPaint_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('General Paint').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
            // Store Associate
            SFDC_Job__c j0 = new SFDC_Job__c(Job_Title_for_Role__c = 'Customer Service Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);
            // Summer Student
            SFDC_Job__c j1 = new SFDC_Job__c(Job_Title_for_Role__c = 'Summer Student', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);
            // Store Associate - Forklift
            SFDC_Job__c j2 = new SFDC_Job__c(Job_Title_for_Role__c = 'Forklift Customer Service Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);
            // Full Time Customer Service Representative
            SFDC_Job__c j3 = new SFDC_Job__c(Job_Title_for_Role__c = 'Full Time Customer Service Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);
            // Store Associate - Heavy Lifting
            SFDC_Job__c j4 = new SFDC_Job__c(Job_Title_for_Role__c = 'Heavy Lifting Customer Service Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);
            // Store Manager
            SFDC_Job__c j5 = new SFDC_Job__c(Job_Title_for_Role__c = 'Store Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);
             // Assistant Store Manager
            SFDC_Job__c j6 = new SFDC_Job__c(Job_Title_for_Role__c = 'Assistant Store Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);
             // Outside Sales Representative
            SFDC_Job__c j7 = new SFDC_Job__c(Job_Title_for_Role__c = 'Outside Sales Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);
            // Other
            SFDC_Job__c j8 = new SFDC_Job__c(Job_Title_for_Role__c = null, job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j8); 
                       
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c from SFDC_Job__c where id in :jobs order by id];

        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'GP - 1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'GP - 8');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'GP - 3');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'GP - 4');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'GP - 5');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'GP - 2');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'GP - 7');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'GP - 6');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'GP - 99');
    }            
}