@isTest
public class Job_Workflow_Longo_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
		// grab map of Job record types to find the client we are testing
		Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
		Id RecType = JobRecTypes.get('Longo\'s').getrecordtypeid();

		// build list of Jobs to create so they go through the various field setting if statements
		List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

		// run tests as portal user to avoid clean up workflow
		system.runas(Job_Workflow_Test_Utility.u) {  
			// LO OnDemand
			SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Job_Type__c = 'TalentReach', 
				SLA_Level__c = 'Job Posting Only', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j0);        
			// LO Bakery Assistant Department Manager
			SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Bakery Assistant Department Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j1);        
			// LO Bakery Clerk
			SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Bakery Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j2);        
			// LO Barista
			SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Barista',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j3);        
			// LO Cake Decorator
			SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Cake Decorator',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j4);        
			// LO Cashier
			SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Cashier',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j5);        
			// LO Customer Service Clerk
			SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Customer Service Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j6);        
			// LO Dairy/Frozen Food Clerk
			SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Dairy/Frozen Food Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j7);        
			// LO Deli Assistant Department Manager
			SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Deli Assistant Department Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j8);        
			// LO Deli Clerk
			SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Deli Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j9);        
			// LO Floral Clerk
			SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Floral Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j10);        
			// LO Grocery Clerk
			SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Grocery Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j11);        
			// LO Grocery Gateway Driver
			SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Grocery Gateway Driver',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j12);        
			// LO Grocery Gateway Shopper
			SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Grocery Gateway Shopper',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j13);        
			// LO Meat Clerk
			SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Meat Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j14);        
			// LO Meat Cutter
			SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Meat Cutter',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j15);        
			// LO Pizza Artists
			SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Pizza Artist',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j16);        
			// LO Prepared Foods Assistant Department Manager
			SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Prepared Foods Assistant Department Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j17);        
			// LO Prepared Foods Clerk
			SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Prepared Foods Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j18);        
			// LO Produce Clerk
			SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Produce Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j19);        
			// LO Seafood Clerk
			SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Seafood Clerk',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j20);        
			// LO Store Manager
			SFDC_Job__c j21 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j21);        
			// LO Store Receiver
			SFDC_Job__c j22 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Receiver',
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j22);        
			
			insert jobs;
		}
		jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c from SFDC_Job__c where id in :jobs order by id];

		// LO OnDemand
		system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'LO - 99');
		system.assertequals(jobs[0].SLA_Level__c, 'Job Posting Only');
		// LO Bakery Assistant Department Manager
		system.assertequals(jobs[1].Credits_Used_for_Job__c, 4);
		system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'LO - 21');
		system.assertequals(jobs[1].SLA_Level__c, 'Management');
		// LO Bakery Clerk
		system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'LO - 2');
		system.assertequals(jobs[2].SLA_Level__c, 'Front Line');
		// LO Barista
		system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'LO - 14');
		system.assertequals(jobs[3].SLA_Level__c, 'Front Line');
		// LO Cake Decorator
		system.assertequals(jobs[4].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'LO - 18');
		system.assertequals(jobs[4].SLA_Level__c, 'Front Line');
		// LO Cashier
		system.assertequals(jobs[5].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'LO - 3');
		system.assertequals(jobs[5].SLA_Level__c, 'Front Line');
		// LO Customer Service Clerk
		system.assertequals(jobs[6].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'LO - 4');
		system.assertequals(jobs[6].SLA_Level__c, 'Front Line');
		// LO Dairy/Frozen Food Clerk
		system.assertequals(jobs[7].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'LO - 8');
		system.assertequals(jobs[7].SLA_Level__c, 'Front Line');
		// LO Deli Assistant Department Manager
		system.assertequals(jobs[8].Credits_Used_for_Job__c, 4);
		system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'LO - 22');
		system.assertequals(jobs[8].SLA_Level__c, 'Management');
		// LO Deli Clerk
		system.assertequals(jobs[9].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'LO - 5');
		system.assertequals(jobs[9].SLA_Level__c, 'Front Line');
		// LO Floral Clerk
		system.assertequals(jobs[10].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'LO - 7');
		system.assertequals(jobs[10].SLA_Level__c, 'Front Line');
		// LO Grocery Clerk
		system.assertequals(jobs[11].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'LO - 6');
		system.assertequals(jobs[11].SLA_Level__c, 'Front Line');
		// LO Grocery Gateway Driver
		system.assertequals(jobs[12].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'LO - 16');
		system.assertequals(jobs[12].SLA_Level__c, 'Front Line');
		// LO Grocery Gateway Shopper
		system.assertequals(jobs[13].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'LO - 15');
		system.assertequals(jobs[13].SLA_Level__c, 'Front Line');
		// LO Meat Clerk
		system.assertequals(jobs[14].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'LO - 10');
		system.assertequals(jobs[14].SLA_Level__c, 'Front Line');
		// LO Meat Cutter
		system.assertequals(jobs[15].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'LO - 17');
		system.assertequals(jobs[15].SLA_Level__c, 'Front Line');
		// LO Pizza Artists
		system.assertequals(jobs[16].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'LO - 19');
		system.assertequals(jobs[16].SLA_Level__c, 'Front Line');
		// LO Prepared Foods Assistant Department Manager
		system.assertequals(jobs[17].Credits_Used_for_Job__c, 4);
		system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'LO - 23');
		system.assertequals(jobs[17].SLA_Level__c, 'Management');
		// LO Prepared Foods Clerk
		system.assertequals(jobs[18].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'LO - 12');
		system.assertequals(jobs[18].SLA_Level__c, 'Front Line');
		// LO Produce Clerk
		system.assertequals(jobs[19].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'LO - 9');
		system.assertequals(jobs[19].SLA_Level__c, 'Front Line');
		// LO Seafood Clerk
		system.assertequals(jobs[20].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'LO - 11');
		system.assertequals(jobs[20].SLA_Level__c, 'Front Line');
		// LO Store Manager
		system.assertequals(jobs[21].Credits_Used_for_Job__c, 4);
		system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'LO - 20');
		system.assertequals(jobs[21].SLA_Level__c, 'Management');
		// LO Store Receiver
		system.assertequals(jobs[22].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[22].OTHER_Job_Template_ID__c, 'LO - 13');
		system.assertequals(jobs[22].SLA_Level__c, 'Front Line');
    }
}