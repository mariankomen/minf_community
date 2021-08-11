@isTest
public class Job_Workflow_Wallace_Carey_Inc_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Wallace & Carey Inc - NSM').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Order Assembler/General Warehouse Worker',  Banner_of_Store__c = 'Wallace & Carey Inc.', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Forklift Operator',  Banner_of_Store__c = 'Wallace & Carey Inc.', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'AZ Truck Driver',  Banner_of_Store__c = 'Wallace & Carey Inc.', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            insert jobs;
        }
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'WAC-1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'WAC-2');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'WAC-3');
                
    }
}