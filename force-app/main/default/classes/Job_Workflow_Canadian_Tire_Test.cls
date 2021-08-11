@isTest
public class Job_Workflow_Canadian_Tire_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Canadian Tire').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j0);
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j1);
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j2);
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j3);
            SFDC_Job__c j50 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j50);
           
            
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j4);
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j5);
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j6);
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j7);
            SFDC_Job__c j51 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j51);
            
            
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j8);
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j9);
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j10);
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j11);
            SFDC_Job__c j52 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j52);
           
                               
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j12);
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j13);
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j14);
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j15); 
            SFDC_Job__c j53 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j53); 
            
            
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j16);
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j17);
            SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j18);
            SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j19);      
            SFDC_Job__c j54 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j54);
            
                               
            SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j20);
            SFDC_Job__c j21= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j21);
            SFDC_Job__c j22 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j22);
            SFDC_Job__c j23 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j23); 
            SFDC_Job__c j55 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j55);
            
            SFDC_Job__c j24 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j24);
            SFDC_Job__c j25= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j25);
            SFDC_Job__c j26 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j26);
            SFDC_Job__c j27 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j27); 
            SFDC_Job__c j56 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j56);  
            
               
            SFDC_Job__c j28 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j28);
            SFDC_Job__c j29= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j29);
            SFDC_Job__c j30 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j30);
            SFDC_Job__c j31 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j31);  
            SFDC_Job__c j57 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j57);
           
                 
            SFDC_Job__c j32 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j32);
            SFDC_Job__c j33= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j33);
            SFDC_Job__c j34 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j34);
            SFDC_Job__c j35 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j35);  
            SFDC_Job__c j58 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j58);
            
            SFDC_Job__c j36 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j36);
            SFDC_Job__c j37= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j37);
            SFDC_Job__c j38 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j38);
            SFDC_Job__c j39 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j39);  
            SFDC_Job__c j59 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j59);
           
            SFDC_Job__c j40 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j40);
            SFDC_Job__c j41= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j41);
            SFDC_Job__c j42 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j42);
            SFDC_Job__c j43 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j43);   
            SFDC_Job__c j60 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j60);
            
                        
            SFDC_Job__c j44 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Cambie');
            jobs.add(j44);
            SFDC_Job__c j45= new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'Greater Vancouver Associated Stores - Grandview');
            jobs.add(j45);
            SFDC_Job__c j46 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'GS McMillan Holdings Ltd');
            jobs.add(j46);
            SFDC_Job__c j47 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'Endress Sales & Distribution Ltd');
            jobs.add(j47);   
            SFDC_Job__c j61 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'Peter Charles Holdings Ltd');
            jobs.add(j61);
            
              
              
              
            SFDC_Job__c j62 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j62);  
            SFDC_Job__c j63 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j63); 
            SFDC_Job__c j64 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j64);
            SFDC_Job__c j65 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j65);   
            SFDC_Job__c j66 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j66);
            SFDC_Job__c j67 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j67);
            SFDC_Job__c j68 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j68);  
            SFDC_Job__c j69 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Licensed Automotive Technician',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j69);  
            SFDC_Job__c j70 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j70);
            SFDC_Job__c j71 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Department Manager',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j71);
            SFDC_Job__c j72 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Manager',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j72);    
            SFDC_Job__c j73 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Supervisor',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j73);                  
                   
            //SFDC_Job__c j74 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Warehouse Associate',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            //jobs.add(j74);  
            SFDC_Job__c j74 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Warehouse Associate',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j74);  
            
            SFDC_Job__c j75 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j75);  
            
            SFDC_Job__c j76 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'General Manager',  Banner_of_Store__c = 'Giacomo D\'Amico Holding Inc');
            jobs.add(j76);   
            
            
            
            //T. Macrae Family Sales ---------------------------------------------------------------------
            SFDC_Job__c j77 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Cashier',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j77); 
            SFDC_Job__c j78 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Associate',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j78); 
            SFDC_Job__c j79 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Customer Service Representative',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j79); 
            SFDC_Job__c j80 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Service Advisor',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j80); 
            SFDC_Job__c j81 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Parts Associate',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j81); 
            SFDC_Job__c j82 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Automotive Service Installer',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j82); 
            SFDC_Job__c j83 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Garden Centre Associate',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j83); 
            SFDC_Job__c j84 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Stock Handler',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j84); 
            SFDC_Job__c j85 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Warehouse Associate',  Banner_of_Store__c = 'T. Macrae Family Sales');
            jobs.add(j85); 
            //--------------------------------------------------------------------------------------------
            
            SFDC_Job__c j86 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Sales Advisor',  Banner_of_Store__c = 'Peter Charles Holdings Lts');
            jobs.add(j86); 
            SFDC_Job__c j87 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Pro Shop Associate',  Banner_of_Store__c = 'Peter Charles Holdings Lt');
            jobs.add(j87); 
              
                   
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        system.assertequals(jobs[0].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'CT-4');
        
        system.assertequals(jobs[5].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'CT-9');
        
        system.assertequals(jobs[10].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'CT-5');
        
        system.assertequals(jobs[15].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'CT-10');
        
        system.assertequals(jobs[20].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'CT-2');
        
        system.assertequals(jobs[25].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'CT-3');
        
        system.assertequals(jobs[30].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[30].OTHER_Job_Template_ID__c, 'CT-7');
        
        system.assertequals(jobs[35].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[35].OTHER_Job_Template_ID__c, 'CT-8');
        
        system.assertequals(jobs[40].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[40].OTHER_Job_Template_ID__c, 'CT-12');
        
        system.assertequals(jobs[45].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[45].OTHER_Job_Template_ID__c, 'CT-6');
        
        system.assertequals(jobs[50].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[50].OTHER_Job_Template_ID__c, 'CT-13');
        
        system.assertequals(jobs[55].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[55].OTHER_Job_Template_ID__c, 'CT-14');
      
        //system.assertequals(jobs[73].mindfield_service__c, 'Full-Cycle Recruitment');
        //system.assertequals(jobs[73].OTHER_Job_Template_ID__c, 'CT-15');
        
        system.assertequals(jobs[75].OTHER_Job_Template_ID__c, 'CT-4');
        system.assertequals(jobs[76].OTHER_Job_Template_ID__c, 'CT-9');
        system.assertequals(jobs[77].OTHER_Job_Template_ID__c, 'CT-5');
        system.assertequals(jobs[78].OTHER_Job_Template_ID__c, 'CT-10');
        system.assertequals(jobs[79].OTHER_Job_Template_ID__c, 'CT-2');
        system.assertequals(jobs[80].OTHER_Job_Template_ID__c, 'CT-3');
        system.assertequals(jobs[81].OTHER_Job_Template_ID__c, 'CT-7');
        system.assertequals(jobs[82].OTHER_Job_Template_ID__c, 'CT-12');
        system.assertequals(jobs[83].OTHER_Job_Template_ID__c, 'CT-15');
        
        system.assertequals(jobs[84].OTHER_Job_Template_ID__c, 'CT-18');
        system.assertequals(jobs[85].OTHER_Job_Template_ID__c, 'CT-19');
    }
}