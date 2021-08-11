@isTest
public class Job_Workflow_Olsen_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
 		// grab map of Job record types to find the client we are testing
		Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
		Id RecType = JobRecTypes.get('Olsen Europe').getrecordtypeid();

		// build list of Jobs to create so they go through the various field setting if statements
		List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   
		// run tests as portal user to avoid clean up workflow
		system.runas(Job_Workflow_Test_Utility.u) {                 
			// OE OnDemand
			SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD', 
				SLA_Level__c = 'OnDemand Opening/Client', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j0);        
			// OE Asst. Shoppe Manager
			SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Associate – FRENCH',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j1);  
			// OE Other
			SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j2);  
			// OE Store Manager
			 SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j3);  
			// OE Senior Sales Associate
			SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Senior Sales Associate',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j4);  
			// OE Sales Associate
			SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Associate',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j5);  
			
			insert jobs;
		}
		jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c from SFDC_Job__c where id in :jobs order by id];

		// OE OnDemand
		system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'OE - 99');
		// OE Sales Associate – FRENCH
		system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'OE - 5');
		// OE Other
		system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'OE - 99');
		// OE Store Manager
		system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'OE - 2');
		// OE Senior Sales Associate
		system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'OE - 3');
		// OE Sales Associate
		system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'OE - 1');
    }
}