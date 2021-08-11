@isTest
public class Job_Workflow_Golf_Town_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Golf Town').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        //system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Sales Associate - Golf Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Sales Associate - Golf Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Sales Associate - Seasonal', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Receiving Associate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Bilingual Customer Service Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Department Manager - Golf Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Department Manager - Golf Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Assistant Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'General Store Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
               
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Associate Buyer', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Buyer', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Merchandising Analyst', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Vendor Relationship Specialist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'HR Business Partner - Corporate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'HR Business Partner - Retail (Bilingual)', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Data Compliance Specialist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Account Executive', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Email CRM Specialist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Allocation Analyst', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Golf Town'));
               
               
               
                  
            insert jobs;
        //}
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'GT-1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'GT-2');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'GT-3');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'GT-4');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'GT-5');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'GT-6');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'GT-7');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'GT-8');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'GT-9');
       
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'GT-10');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'GT-11');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'GT-12');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'GT-13');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'GT-14');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'GT-15');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'GT-16');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'GT-17');
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'GT-18');
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'GT-20');
    }
}