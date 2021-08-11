@isTest
public class Job_Workflow_Marks_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Marks').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 
            // Marks Sales Associate
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Associate', 
            FT_or_PT__c = 'Full Time', department__c = 'test', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);
            // Marks Visual Merchandiser
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Visual Merchandiser', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);
            // Mark Sales Support Coordinator
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Key Holder', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);
            // Marks Shipper/Receiver
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Shipper/Receiver', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);
            // Marks Seasonal Associate
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Seasonal Associate', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);
            // Marks Seasonal Order Fulfillment Associate
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Seasonal Order Fulfillment Associate', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);           
            // Marks Order Fulfillment Associate
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Order Fulfillment Associate', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Seasonal Order Fulfillment/Stock Associate', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);
                    
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c from SFDC_Job__c where id in :jobs order by id];

        // Mark's Sales Associate
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'MK-1');
        // Marks Visual Merchandiser
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'MK-5');
        // Mark Sales Support Coordinator
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'MK-3');
        // Marks Shipper/Receiver
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'MK-4');
        // Mark's Seasonal Associate
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'MK-7');
        // Mark Sales Support Coordinator
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'MK-8');
        // Marks Shipper/Receiver
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'MK-6');
        // Seasonal Order Fulfillment Associate/Stock Associate
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'MK-8');
    }
}