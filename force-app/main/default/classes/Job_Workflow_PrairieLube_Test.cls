@isTest
public class Job_Workflow_PrairieLube_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
    // grab map of Job record types to find the client we are testing
    Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
    Id RecType = JobRecTypes.get('Prairie Lube').getrecordtypeid();

    // build list of Jobs to create so they go through the various field setting if statements
    List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

    // need a portal user with alias of PL18 for some tests on wage details
    Account a1 = new Account(name = 'test');
    insert a1;
    Contact c1 = new Contact(lastname = 'test', accountid = a1.id);
    insert c1;
    Profile p = [select id from Profile where name = 'MFG TalentDrive HirePortal Regional User EN'];
    User u2 = new User(contactid = c1.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
      username = 'sample@mfg.com', alias='PL18', communitynickname='testabc', managerid = Userinfo.getuserid(), 
      EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
      profileid = p.id, user_classification__c = 'HR User - Standard');
    insert u2;

    // run tests as portal user to avoid clean up workflow
    system.runas(Job_Workflow_Test_Utility.u) {                         
      // PL OnDemand
      SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD', 
        ownerid = Job_Workflow_Test_Utility.u.id, SLA_Level__c = 'Store Project - Included in RPO Billing', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j0);        
      // PL Assistant Store Manager
      SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube', Job_Title_for_Banner__c = 'Assistant Store Manager',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j1);        
      // PL Store Manager
      SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube',Job_Title_for_Banner__c = 'Store Manager',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j2);        
      // PL Supervisor
      SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube',Job_Title_for_Banner__c = 'Supervisor',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j3);        
      // PL Lower Technician - 12/hr wage
      SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube',Job_Title_for_Banner__c = 'Lower Service Technician', 
        ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j4);        
      // PL Upper Technician
      SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube',Job_Title_for_Banner__c = 'Upper Service Technician',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j5);        
      // Sales Advisor
      SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c='Mr. Lube',Job_Title_for_Banner__c = 'Sales Advisor',
        Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
      jobs.add(j6); 
      
      insert jobs;
    }
    jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, Job_Title_for_Banner__c, Banner_of_Store__c, wage_details__c from SFDC_Job__c where id in :jobs order by id];

    // PL OnDemand
    system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'PL - 99');
    //system.assertequals(jobs[0].SLA_Level__c, 'OnDemand Opening/Client');        
    // PL Assistant Store Manager
    system.assertequals(jobs[1].Credits_Used_for_Job__c, 2);
    system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'PL - 3');
    system.assertequals(jobs[1].SLA_Level__c, 'Management');        
    // PL Store Manager
    system.assertequals(jobs[2].Credits_Used_for_Job__c, 2);
    system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'PL - 4');
    system.assertequals(jobs[2].SLA_Level__c, 'Management');        
    // PL Supervisor
    system.assertequals(jobs[3].Credits_Used_for_Job__c, 2);
    system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'PL - 8');
    system.assertequals(jobs[3].SLA_Level__c, 'Management');        
    // PL Lower Technician - 12/hr wage?
    system.assertequals(jobs[4].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'PL - 6');
    system.assertequals(jobs[4].SLA_Level__c, 'Front Line');        
    system.assertequals(jobs[4].wage_details__c, 'Hourly Wage is $12.00/hour to start');
    // PL Upper Technician
    system.assertequals(jobs[5].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'PL - 7');
    system.assertequals(jobs[5].SLA_Level__c, 'Front Line'); 
    // PL Upper Technician
    system.assertequals(jobs[6].Credits_Used_for_Job__c, 1);
    system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'MLF - 10');
    system.assertequals(jobs[6].SLA_Level__c, 'Front Line');            
    }
}