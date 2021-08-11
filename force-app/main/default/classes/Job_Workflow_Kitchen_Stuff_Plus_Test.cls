@isTest
public class Job_Workflow_Kitchen_Stuff_Plus_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Kitchen Stuff Plus').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
            // Warehouse Associate
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shift Leader',
            Banner_of_Store__c = 'Kitchen Stuff Plus');
            jobs.add(j0);
                   
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Warehouse Shift Leader',
            Banner_of_Store__c = 'Kitchen Stuff Plus');
            jobs.add(j1);  
            
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Store Manager',
            Banner_of_Store__c = 'Kitchen Stuff Plus');
            jobs.add(j2);       
                                                  
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'KSPI-1');
        
        system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'KSPI-2');
        
        system.assertequals(jobs[2].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'KSPI-3');
        
    }
}