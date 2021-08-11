@isTest
public class Job_Workflow_NoLimits_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('No Limits Group').getrecordtypeid();

        // all are the same
        SFDC_Job__c j0;
        SFDC_Job__c j1;
        SFDC_Job__c j2;
        SFDC_Job__c j3;
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 
            j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Hourly Associate');
            insert j0;
            j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job',  Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Warehouse Supervisor');       
            insert j1;
            j2 = new SFDC_Job__c(job_status__c = 'Open/Active Job',  Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Warehouse Flow Coordinator');       
            insert j2;
            j3 = new SFDC_Job__c(job_status__c = 'Open/Active Job',  Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Maintenance Specialist');       
            insert j3;
        }
        j0 = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, MindField_Job_Type__c, job_city__c from SFDC_Job__c where id = :j0.id];
        j1 = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, MindField_Job_Type__c, job_city__c from SFDC_Job__c where id = :j1.id];
        j2 = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, MindField_Job_Type__c, job_city__c from SFDC_Job__c where id = :j2.id];
        j3 = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, MindField_Job_Type__c, job_city__c from SFDC_Job__c where id = :j3.id];

        system.assertequals(j0.Credits_Used_for_Job__c, 1);
        system.assertequals(j0.OTHER_Job_Template_ID__c, 'A52-1');
        system.assertequals(j0.SLA_Level__c, 'Front Line 2');
        
        system.assertequals(j1.Credits_Used_for_Job__c, 1);
        system.assertequals(j1.OTHER_Job_Template_ID__c, 'A52-2');
        system.assertequals(j1.SLA_Level__c, 'Management 1');
        
        system.assertequals(j2.Credits_Used_for_Job__c, 1);
        system.assertequals(j2.OTHER_Job_Template_ID__c,'A52-3');
        system.assertequals(j2.SLA_Level__c, 'Specialty 2');
        
        system.assertequals(j3.Credits_Used_for_Job__c, 1);
        system.assertequals(j3.OTHER_Job_Template_ID__c, 'A52-4');
        
        system.assertequals(j3.SLA_Level__c, 'Specialty 2');
       
    }
}