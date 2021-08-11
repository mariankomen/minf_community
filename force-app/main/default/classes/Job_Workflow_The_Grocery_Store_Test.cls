@isTest
public class Job_Workflow_The_Grocery_Store_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('The Grocery Shop').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>(); 

        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {                          
            // all are the same
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);          
            insert jobs;
        }

        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobs order by id];

        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'TGS-99');
        system.assertequals(jobs[0].MindField_Job_Type__c, 'TalentConnect - Post Only');
       
    }
}