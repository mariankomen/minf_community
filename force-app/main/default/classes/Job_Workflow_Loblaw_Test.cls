@isTest
public class Job_Workflow_Loblaw_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
		// grab map of Job record types to find the client we are testing
		Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
		Id RecType = JobRecTypes.get('Loblaw').getrecordtypeid();

		// all are the same
		SFDC_Job__c j0;
		// run tests as portal user to avoid clean up workflow
		system.runas(Job_Workflow_Test_Utility.u) { 
			j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager');
			insert j0;        
		}
		j0 = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c from SFDC_Job__c where id = :j0.id];

		system.assertequals(j0.Credits_Used_for_Job__c, 1);
		system.assertequals(j0.OTHER_Job_Template_ID__c, 'LOB - 99');
		system.assertequals(j0.SLA_Level__c, 'OnDemand Opening/Client');

    }
}