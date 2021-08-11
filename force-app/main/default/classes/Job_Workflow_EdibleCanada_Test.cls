@isTest
public class Job_Workflow_EdibleCanada_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
		// grab map of Job record types to find the client we are testing
		Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
		Id RecType = JobRecTypes.get('Edible Canada').getrecordtypeid();

		// build list of Jobs to create so they go through the various field setting if statements
		List<SFDC_Job__c> jobs = new List<SFDC_Job__c>(); 

		// run tests as portal user to avoid clean up workflow
		system.runas(Job_Workflow_Test_Utility.u) {                          
			// all are the same
			SFDC_Job__c j0 = new SFDC_Job__c(Job_Title_for_Role__c = 'Retail Sales Associate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j0);     
			SFDC_Job__c j1 = new SFDC_Job__c(Job_Title_for_Role__c = 'Bartender',job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j1); 
			SFDC_Job__c j2 = new SFDC_Job__c( Job_Title_for_Role__c = 'Hostess', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j2); 
			SFDC_Job__c j3 = new SFDC_Job__c(Job_Title_for_Role__c = 'Server',job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j3); 
			SFDC_Job__c j4 = new SFDC_Job__c(Job_Title_for_Role__c = 'Server Assistant', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j4); 
			SFDC_Job__c j5 = new SFDC_Job__c(Job_Title_for_Role__c = 'Junior Sous Chef', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j5); 
			SFDC_Job__c j6 = new SFDC_Job__c(Job_Title_for_Role__c = 'Station Cook', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j6); 
			SFDC_Job__c j7 = new SFDC_Job__c(Job_Title_for_Role__c = 'Server Supervisor', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j7); 
			SFDC_Job__c j8 = new SFDC_Job__c(Job_Title_for_Role__c = 'Assistant Restaurant Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j8); 
			SFDC_Job__c j9 = new SFDC_Job__c(Job_Role_Title__c = 'ABC', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
				Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
			jobs.add(j9); 
						
			insert jobs;
		}

		jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobs order by id];

		system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'EC - 1');
		system.assertequals(jobs[0].MindField_Job_Type__c, 'TalentConnect - Promote Post');
		system.assertequals(jobs[1].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'EC - 2');
		system.assertequals(jobs[1].MindField_Job_Type__c, 'TalentConnect - Promote Post');
		system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'EC - 3');
		system.assertequals(jobs[2].MindField_Job_Type__c, 'TalentConnect - Promote Post');
		system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'EC - 4');
		system.assertequals(jobs[3].MindField_Job_Type__c, 'TalentConnect - Promote Post');
		system.assertequals(jobs[4].Credits_Used_for_Job__c, 1);
		system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'EC - 5');
		system.assertequals(jobs[4].MindField_Job_Type__c, 'TalentConnect - Promote Post');
		system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'EC - 6');
		system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'EC - 7');
		system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'EC - 8');
		system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'EC - 9');
		system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'EC - 99');
    }
}