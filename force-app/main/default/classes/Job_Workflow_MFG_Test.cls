@isTest
public class Job_Workflow_MFG_Test {
    
      static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('MindField OnDemand').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        //system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Retail Associate', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Food Service Worker', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Warehouse Associate', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Production Worker', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Team Lead', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Assistant Manager', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Manager', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Call Centre Representative', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Delivery Driver', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));             
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Forklift Operator', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Experienced Retail Associate', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Experienced Warehouse Associate', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Experienced Production Worker', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Warehouse Associate (Overnight)', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Experienced Call Centre Representative', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(Job_Title_for_Role__c = 'Reach Truck Operator', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType));


            insert jobs;
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'OD-7');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'OD-14');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'OD-16');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'OD-17');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'OD-24');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'OD-25');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'OD-27');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'OD-28');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'OD-29');    
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'OD-32');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'OD-37');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'OD-43');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'OD-44');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'OD-45');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'OD-46');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'OD-48');


    }
}