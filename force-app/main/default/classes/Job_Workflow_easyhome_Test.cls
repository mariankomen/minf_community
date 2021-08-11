@isTest
public class Job_Workflow_easyhome_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
    // grab map of Job record types to find the client we are testing
    Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
    Id RecType = JobRecTypes.get('easyhome').getrecordtypeid();

    // build list of Jobs to create so they go through the various field setting if statements
    List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
    // run tests as portal user to avoid clean up workflow
    system.runas(Job_Workflow_Test_Utility.u) {             
      // EH Assistant Store Manager
      SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Store Manager',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j0);        
      // EH Customer Retention Specialist
      SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Retention Specialist',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j1);
      // EH Delivery Specialist
      SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Delivery Specialist',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j2);
      // EH EasyFinancial Assistant Branch Manager
      SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Branch Manager',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j3);
      // EH EasyFinancial Branch Manager in Training
      SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Branch Manager in Training',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j4);
      // EH EasyFinancial Branch Manager Non-RPO
      SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Branch Manager',  Banner_of_Store__c = 'easyfinancial', MindField_Service_Offering__c = 'Posting',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j5);
      // EH EasyFinancial Financial Services Representative
      SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Financial Service Representative',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j6);
      // EH Leasing Specialist
      SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Leasing Specialist',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j7);
      // EH Other (blank)
      SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j8);
      // EH Collector
      SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Collector',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j9);
      // EH Store Manager
      SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j10);
      // EH Store Manager in Training
      SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager in Training',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j11);
      // EH CSR
      SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Sales Representative',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j12);
      // EH FSR CSR
      SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Assistant Branch Manager - CSR',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j13);
    // EH Regional Manager
      SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Regional Manager',  Banner_of_Store__c = 'easyhome',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j14);
    // EH Verification Agent
      SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Verification Agent',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j15);
      // EH Verification Agent
      SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'New Store Opening',  Banner_of_Store__c = 'easyfinancial',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j16);
      
      insert jobs;
    }
    jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c, Career_Site_Alternate_Job_Title__c, Job_Role_Title__c from SFDC_Job__c where id in :jobs order by id];

    // EH Assistant Store Manager
    system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'EH - 9');
    // EH Customer Retention Specialist
    system.assertequals(jobs[1].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'EH - 7');
    // EH Delivery Specialist
    system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'EH - 8');        
    // EH EasyFinancial Assistant Branch Manager
    system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'EH - 2');
    // EH EasyFinancial Branch Manager in Training
    system.assertequals(jobs[4].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'EH - 11');
    // EH EasyFinancial Branch Manager Non-RPO
    system.assertequals(jobs[5].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'EH - 3');
    // EH EasyFinancial Financial Services Representative
    system.assertequals(jobs[6].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'EH - 1');
    // EH Leasing Specialist
    system.assertequals(jobs[7].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'EH - 6');
    // EH Other
    system.assertequals(jobs[8].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'EH - 99');        
    // EH Collector
    system.assertequals(jobs[9].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'EH - 4'); 
    // EH Store Manager
    system.assertequals(jobs[10].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'EH - 5'); 
    // EH Store Manager in Training
    system.assertequals(jobs[11].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'EH - 10'); 
    // EH CSR
    system.assertequals(jobs[12].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'EH - 13'); 
    // EH Assistant Branch Manager
    system.assertequals(jobs[13].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'EH - 14'); 
    // EH Regional Manager
    system.assertequals(jobs[14].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'EH - 22'); 
    // EH Verification Agent
    system.assertequals(jobs[15].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'EH - 15'); 
    // EH Verification Agent
    system.assertequals(jobs[16].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'EH - 27'); 
    }
}