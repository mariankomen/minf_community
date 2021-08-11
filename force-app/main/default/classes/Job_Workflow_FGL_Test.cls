@isTest
public class Job_Workflow_FGL_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('FGL Sports').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>(); 
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 


            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Order Fulfillment Lead', Banner_of_Store__c = 'Sport Chek',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j0);           
            // FGL Sport Chek Cashier
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);
            // FGL Sport Chek Sales Associate Bike
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hard Goods - Bike', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);
            // FGL Sport Chek Sales Associate Footwear
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Footwear', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);
            // FGL Sport Chek Sales Associate Golf
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hard Goods - Golf', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);
            // FGL Sport Chek Sales Associate Hockey
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hard Goods - Hockey', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);
            // FGL Sport Chek Sales Associate Other
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hard Goods - General', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6);
            // FGL Sport Chek Shipper/Receiver
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shipper/Receiver', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);
            // FGL Sport Chek Visual Merchandiser
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Visual Merchandiser', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j8);         
            // FGL Atmosphere Cashier
            SFDC_Job__c j9 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Cashier', Banner_of_Store__c = 'Atmosphere', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j9); 
            // FGL Atmosphere Visual Merchandiser
            SFDC_Job__c j10 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Visual Merchandiser', Banner_of_Store__c = 'Atmosphere', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j10);             
            // FGL Atmosphere Shipper/Receiver
            SFDC_Job__c j11 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Shipper/Receiver', Banner_of_Store__c = 'Atmosphere', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j11); 
            // FGL Sport Chek Service Shop Technician - Basic 
            SFDC_Job__c j12 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Service Shop Technician - Basic', Banner_of_Store__c = 'Sport Chek', department__c = 'Hard Goods - Bike', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12); 
            // FGL Sport Chek Service Shop Technician - Advanced 
            SFDC_Job__c j13 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Service Shop Technician - Advanced', Banner_of_Store__c = 'Sport Chek', department__c = 'Hard Goods - Bike', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13);  
            // FGL Sport Chek Sales Associate Ski
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hard Goods - Ski', Banner_of_Store__c = 'Sport Chek',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j14);
            // FGL Atmospher sales advisor Camping
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Camping', Banner_of_Store__c = 'Atmosphere',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j15);
            // FGL Atmospher sales advisor Hiking
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Hiking', Banner_of_Store__c = 'Atmosphere',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j16);
            // FGL Atmospher sales advisor Kayaking
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Kayaking/Canoeing', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j17); 
            // FGL Atmosphere sales advisor climbing
            SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Climbing', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j18);    
            // FGL Atmosphere sales advisor Trail Running
            SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'Trail Running', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j19);    
            // FGL Atmosphere sales advisor General
            SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor', department__c = 'General', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j20);            
             
            SFDC_Job__c j21 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Order Fulfillment Associate', Banner_of_Store__c = 'Sport Chek',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j21);   
            
            SFDC_Job__c j22 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Order Fulfillment Associate', Banner_of_Store__c = 'Sport Chek',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j22); 
            
            SFDC_Job__c j23 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Associate', Banner_of_Store__c = 'Sport Chek',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j23);
            
            SFDC_Job__c j24 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Order Fulfillment Associate', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j24); 
            
            SFDC_Job__c j25 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Associate', Banner_of_Store__c = 'Atmosphere',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j25);
            
            SFDC_Job__c j26 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Shop Technician - Advanced', department__c = 'Hard Goods - Ski', Banner_of_Store__c = 'Sport Chek',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j26);
                        
            SFDC_Job__c j27 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j27);
            
            SFDC_Job__c j28 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate', Banner_of_Store__c = 'Pro Hockey Life', department__c = 'Goalie',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j28);
            
            SFDC_Job__c j29 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Pro Shop Service Technician', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j29);
            
            SFDC_Job__c j30 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shipper/Receiver', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j30);
            
            SFDC_Job__c j31 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Visual Merchandiser', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j31);
            
            SFDC_Job__c j32 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Order Fulfillment Associate', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j32);
            
            SFDC_Job__c j33 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Associate', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j33);
            
            SFDC_Job__c j34 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Seasonal Order Fulfillment Associate', Banner_of_Store__c = 'Pro Hockey Life',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j34);
            
            SFDC_Job__c j35 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate', Banner_of_Store__c = 'Pro Hockey Life', department__c = 'General',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j35);
            
            SFDC_Job__c j36 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier', Banner_of_Store__c = 'National Sports',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j36);
            
            SFDC_Job__c j37 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Shipper/Receiver', Banner_of_Store__c = 'National Sports',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j37);
            
            SFDC_Job__c j38 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Order Fulfillment Associate', Banner_of_Store__c = 'National Sports',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j38);
            
            SFDC_Job__c j39 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Shop Technician', Banner_of_Store__c = 'National Sports',
            Num_of_Days_for_Delivery_Agreement__c = 5, Num_of_Candidates_for_Delivery_Agreement__c = 2);
            jobs.add(j39);
                 
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c from SFDC_Job__c where id in :jobs order by id];



        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'FGLSC-24');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'FGLSC-6');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'FGLSC-8');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'FGLSC-7');
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'FGLAT-17');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'FGLAT-19');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'FGLAT-18');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'FGLSC-17C');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'FGLSC-17C');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'FGLSC-20');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'FGLAT-22');
        system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'FGLSC-22');
        system.assertequals(jobs[22].OTHER_Job_Template_ID__c, 'FGLSC-21');
        system.assertequals(jobs[23].OTHER_Job_Template_ID__c, 'FGLSC-19');
        system.assertequals(jobs[24].OTHER_Job_Template_ID__c, 'FGLAT-21');
        system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'FGLAT-20');
        system.assertequals(jobs[26].OTHER_Job_Template_ID__c, 'FGLSC-18C'); 
        system.assertequals(jobs[27].OTHER_Job_Template_ID__c, 'PHL-1');
        system.assertequals(jobs[28].OTHER_Job_Template_ID__c, 'PHL-2');
        system.assertequals(jobs[29].OTHER_Job_Template_ID__c, 'PHL-3');
        system.assertequals(jobs[30].OTHER_Job_Template_ID__c, 'PHL-4');
        system.assertequals(jobs[31].OTHER_Job_Template_ID__c, 'PHL-7');
        system.assertequals(jobs[32].OTHER_Job_Template_ID__c, 'PHL-8');
        system.assertequals(jobs[33].OTHER_Job_Template_ID__c, 'PHL-9');
        system.assertequals(jobs[34].OTHER_Job_Template_ID__c, 'PHL-10');
        system.assertequals(jobs[35].OTHER_Job_Template_ID__c, 'PHL-2');
        system.assertequals(jobs[36].OTHER_Job_Template_ID__c, 'NS-1');
        system.assertequals(jobs[37].OTHER_Job_Template_ID__c, 'NS-2');
        system.assertequals(jobs[38].OTHER_Job_Template_ID__c, 'NS-8');
        system.assertequals(jobs[39].OTHER_Job_Template_ID__c, 'NS-9');
        
    }
}