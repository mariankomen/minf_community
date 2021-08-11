@isTest
public class Job_Workflow_Lowes_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Lowe\'s').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {                          
            // LOW OnDemand
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD', 
                SLA_Level__c = 'Store Project - Included in RPO Billing', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);        
            // LOW Commercial Customer Service Associate
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Commercial Customer Service Associate',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);  
            // LOW Commercial Sales Associate
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Commercial Sales Associate',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);  
            // LOW Department Manager - Delivery/Freight Flow
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Delivery/Freight Flow',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);  
            // LOW Department Manager – Appliances
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Appliances',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);  
            // LOW Department Manager – Electrical
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Electrical',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);  
            // LOW Department Manager – Flooring
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Flooring',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);  
            // LOW Department Manager – Hardware/Tools
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Hardware/Tools',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);  
            // LOW Department Manager – Inside Lawn and Garden
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Inside Lawn and Garden',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j8);  
            // LOW Department Manager - Outside Lawn and Garden
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Outside Lawn and Garden',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j9);  
            // LOW Department Manager – Night Crew
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Night Crew',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j10);  
            // LOW Department Manager – Overnight Receiving/Stocking
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Overnight Receiving/Stocking',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j11);  
            // LOW Department Manager – Paint
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Paint',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12);  
            // LOW Department Manager – Plumbing
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Plumbing',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13);  
            // LOW Department Manager – PSA
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'PSA',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j14);  
            // LOW Department Manager – Tools
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Tools',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j15);  
            // LOW Department Manager – Various Departments
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Various Departments',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j16);  
            // LOW Department Manager – Receiving
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Receiving',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j17);  
            // LOW Department Manager – Windows and Walls
            SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Department Manager', other_department__c = 'Windows and Walls',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j18);  
            // LOW Electrical Professional
            SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Electrical Professional',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j19);  
            // LOW Loss Prevention Manager
            SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Loss Prevention Manager',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j20);  
            // LOW Plumbing Professional
            SFDC_Job__c j21 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Plumbing Professional',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j21);  
            // LOW Product Services Specialist
            SFDC_Job__c j22 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Product Services Specialist',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j22);  
            // LOW Sales Specialist – Cabinets and Home Organizations
            SFDC_Job__c j23 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Cabinets and Home Organizations',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j23);  
            // LOW Sales Specialist – Commercial Sales
            SFDC_Job__c j24 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Commercial Sales',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j24);  
            // LOW Sales Specialist – Flooring
            SFDC_Job__c j25 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Flooring',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j25);  
            // LOW Sales Specialist – Kitchen Cabinets
            SFDC_Job__c j26 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Kitchen Cabinets',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j26);  
            // LOW Sales Specialist – Millwork
            SFDC_Job__c j27 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Millwork',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j27);  
            // LOW Sales Specialist – Plumbing
            SFDC_Job__c j28 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Plumbing',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j28);  
            // LOW Sales Specialist – Windows and Walls
            SFDC_Job__c j29 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Specialist', other_department__c = 'Windows and Walls',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j29);  

            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c from SFDC_Job__c where id in :jobs order by id];

        // LOW OnDemand
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'LOW - 99');
        //system.assertequals(jobs[0].SLA_Level__c, 'OnDemand Opening/Client');        
        // LOW Commercial Customer Service Associate
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'LOW - 1');
        system.assertequals(jobs[1].SLA_Level__c, 'Job Posting Only');      
        // LOW Commercial Sales Associate
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'LOW - 2');
        system.assertequals(jobs[2].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager - Delivery/Freight Flow
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'LOW - 3');
        system.assertequals(jobs[3].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Appliances
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'LOW - 4');
        system.assertequals(jobs[4].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Electrical
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'LOW - 5');
        system.assertequals(jobs[5].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Flooring
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'LOW - 6');
        system.assertequals(jobs[6].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Hardware/Tools
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'LOW - 7');
        system.assertequals(jobs[7].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Inside Lawn and Garden
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'LOW - 8');
        system.assertequals(jobs[8].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager - Outside Lawn and Garden
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'LOW - 9');
        system.assertequals(jobs[9].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Night Crew
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'LOW - 10');
        system.assertequals(jobs[10].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Overnight Receiving/Stocking
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'LOW - 11');
        system.assertequals(jobs[11].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Paint
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'LOW - 12');
        system.assertequals(jobs[12].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Plumbing
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'LOW - 13');
        system.assertequals(jobs[13].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – PSA
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'LOW - 14');
        system.assertequals(jobs[14].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Tools
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'LOW - 15');
        system.assertequals(jobs[15].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Various Departments
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'LOW - 16');
        system.assertequals(jobs[16].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Receiving
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'LOW - 17');
        system.assertequals(jobs[17].SLA_Level__c, 'Job Posting Only'); 
        // LOW Department Manager – Windows and Walls
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'LOW - 18');
        system.assertequals(jobs[18].SLA_Level__c, 'Job Posting Only'); 
        // LOW Electrical Professional
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'LOW - 19');
        system.assertequals(jobs[19].SLA_Level__c, 'Job Posting Only'); 
        // LOW Loss Prevention Manager
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'LOW - 20');
        system.assertequals(jobs[20].SLA_Level__c, 'Job Posting Only'); 
        // LOW Plumbing Professional
        system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'LOW - 21');
        system.assertequals(jobs[21].SLA_Level__c, 'Job Posting Only'); 
        // LOW Product Services Specialist
        system.assertequals(jobs[22].OTHER_Job_Template_ID__c, 'LOW - 22');
        system.assertequals(jobs[22].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Cabinets and Home Organizations
        system.assertequals(jobs[23].OTHER_Job_Template_ID__c, 'LOW - 23');
        system.assertequals(jobs[23].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Commercial Sales
        system.assertequals(jobs[24].OTHER_Job_Template_ID__c, 'LOW - 24');
        system.assertequals(jobs[24].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Flooring
        system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'LOW - 25');
        system.assertequals(jobs[25].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Kitchen Cabinets
        system.assertequals(jobs[26].OTHER_Job_Template_ID__c, 'LOW - 26');
        system.assertequals(jobs[26].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Millwork
        system.assertequals(jobs[27].OTHER_Job_Template_ID__c, 'LOW - 27');
        system.assertequals(jobs[27].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Plumbing
        system.assertequals(jobs[28].OTHER_Job_Template_ID__c, 'LOW - 28');
        system.assertequals(jobs[28].SLA_Level__c, 'Job Posting Only'); 
        // LOW Sales Specialist – Windows and Walls
        system.assertequals(jobs[29].OTHER_Job_Template_ID__c, 'LOW - 29');
        system.assertequals(jobs[29].SLA_Level__c, 'Job Posting Only'); 
    }
}