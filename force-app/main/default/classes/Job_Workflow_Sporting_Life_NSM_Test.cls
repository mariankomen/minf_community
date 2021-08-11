@isTest
public class Job_Workflow_Sporting_Life_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Sporting Life').getrecordtypeid();
        

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        //system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Sales Associate - Cash', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Sales Associate - Footwear', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Sales Associate - Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Sales Associate - Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Personal Shopper', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Restocker', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'E-Commerce Shipping Associate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Warehouse Associate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Warehouse Lead Hand', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));              
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Key Holder', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Boot Fitter', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Service Shop Technician', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Service Shop Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Merchandiser', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Visual Display Artist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Training Coordinator', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Warehouse Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Department Manager - Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Department Manager - Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Assistant Cash Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Cash Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Assistant Merchandising Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Merchandising Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Visual Display Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
      //      jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Divisional Manager - Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
      //      jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Divisional Manager - Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Store Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Sales Associate - Cash', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Sales Associate - Footwear', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Sales Associate - Soft Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Sales Associate - Hard Goods', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Restocker', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Seasonal', Job_Title_For_Role_Classification__c = 'Warehouse Associate', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Accounts Payable Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Accounts Payable Clerk', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Customer Care Representative', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));           
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Social Media Specialist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Junior Graphic Designer', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Customer Care Assistant Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Planning Analyst', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Email CRM Specialist', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Office Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Retail Graphic Designer', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Digital Media Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Corporate', Job_Title_For_Role_Classification__c = 'Junior Systems Support Administrator', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));
            jobs.add(new SFDC_Job__c(Manager_Emails__c = 'temp@test.com', Role_Classification__c = 'Permanent', Job_Title_For_Role_Classification__c = 'Assistant Store Manager', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Banner_of_Store__c = 'Sporting Life'));

               
                  
            insert jobs;
        //}
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'SPL-1');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'SPL-2');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'SPL-3');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'SPL-4');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'SPL-5');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'SPL-6');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'SPL-7');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'SPL-8');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'SPL-9');    
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'SPL-10');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'SPL-11');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'SPL-12');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'SPL-13');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'SPL-14');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'SPL-15');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'SPL-16');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'SPL-17');
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'SPL-18');
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'SPL-19');
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'SPL-20');
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'SPL-21');
        system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'SPL-22');
        system.assertequals(jobs[22].OTHER_Job_Template_ID__c, 'SPL-23');
        system.assertequals(jobs[23].OTHER_Job_Template_ID__c, 'SPL-24');
     //   system.assertequals(jobs[24].OTHER_Job_Template_ID__c, 'SPL-25');
     //   system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'SPL-26');
        system.assertequals(jobs[24].OTHER_Job_Template_ID__c, 'SPL-27');
        system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'SPL-28');
        system.assertequals(jobs[26].OTHER_Job_Template_ID__c, 'SPL-29');
        system.assertequals(jobs[27].OTHER_Job_Template_ID__c, 'SPL-30');
        system.assertequals(jobs[28].OTHER_Job_Template_ID__c, 'SPL-31');
        system.assertequals(jobs[29].OTHER_Job_Template_ID__c, 'SPL-32');
        system.assertequals(jobs[30].OTHER_Job_Template_ID__c, 'SPL-33');
        system.assertequals(jobs[31].OTHER_Job_Template_ID__c, 'SPL-34');
        system.assertequals(jobs[32].OTHER_Job_Template_ID__c, 'SPL-35');
        system.assertequals(jobs[33].OTHER_Job_Template_ID__c, 'SPL-36');
        system.assertequals(jobs[34].OTHER_Job_Template_ID__c, 'SPL-37');
        system.assertequals(jobs[35].OTHER_Job_Template_ID__c, 'SPL-38');
        system.assertequals(jobs[36].OTHER_Job_Template_ID__c, 'SPL-39');
        system.assertequals(jobs[37].OTHER_Job_Template_ID__c, 'SPL-40');
        system.assertequals(jobs[38].OTHER_Job_Template_ID__c, 'SPL-41');
        system.assertequals(jobs[39].OTHER_Job_Template_ID__c, 'SPL-42');
        system.assertequals(jobs[40].OTHER_Job_Template_ID__c, 'SPL-43');
        system.assertequals(jobs[41].OTHER_Job_Template_ID__c, 'SPL-44');
        system.assertequals(jobs[42].OTHER_Job_Template_ID__c, 'SPL-45');
        system.assertequals(jobs[43].OTHER_Job_Template_ID__c, 'SPL-46');    


    
    }
}