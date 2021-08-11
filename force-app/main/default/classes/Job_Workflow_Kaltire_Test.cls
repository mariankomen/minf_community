@isTest
public class Job_Workflow_Kaltire_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
		// grab map of Job record types to find the client we are testing
		Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
		Id RecType = JobRecTypes.get('Kal-Tire').getrecordtypeid();

		// build list of Jobs to create so they go through the various field setting if statements
		List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   
		// run tests as portal user to avoid clean up workflow
		system.runas(Job_Workflow_Test_Utility.u) {  
			// KT OnDemand
			SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD', 
				SLA_Level__c = 'Store Project - Included in RPO Billing', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j0);        
			// KT Career Tracker
			SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Career Tracker',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j1); 
			// KT Warehouse ASM
			SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Warehouse Assistant Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j2); 
			// KT Warehouse Service
			SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Shipper/Receiver',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j3);
					 
			insert jobs;
		}
		jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c from SFDC_Job__c where id in :jobs order by id];

		// KT OnDemand
		system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'KT - 99');
		//system.assertequals(jobs[0].SLA_Level__c, 'OnDemand Opening/Client');
		// KT Career Tracker
		system.assertequals(jobs[1].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'KT - 5');
		system.assertequals(jobs[1].SLA_Level__c, 'Store Project - Included in RPO Billing');
		// KT Warehouse ASM
		system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'KT - 1');
		system.assertequals(jobs[2].SLA_Level__c, 'Management');
		// KT Warehouse Service
		system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'KT - 2');
		system.assertequals(jobs[3].SLA_Level__c, 'Front Line');
    }
}