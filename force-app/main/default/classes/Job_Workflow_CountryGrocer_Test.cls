@isTest
public class Job_Workflow_CountryGrocer_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Country Grocer').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
            
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Grocery Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j0);
            
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Bakery Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j1);
            
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Deli Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j2);
            
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Floral Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j3);
            
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Bulk Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j4);
            
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Produce Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j5);
            
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Front-End Service Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j6);
            
            //SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
            //                                Job_Title_for_Banner__c = 'Dairy Service Clerk',
            //                                Banner_of_Store__c = 'Country Grocer');
            //jobs.add(j7);
            
            //SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
            //                                Job_Title_for_Banner__c = 'Post-Office Service Clerk',
            //                                Banner_of_Store__c = 'Country Grocer');
            //jobs.add(j8);
            
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Baker',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j7);
            
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Meat Cutter',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j8);
            
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Shift Supervisor',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j9);
            
            //SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
            //                                Job_Title_for_Banner__c = 'Scanning Supervisor',
            //                                Banner_of_Store__c = 'Country Grocer');
            //jobs.add(j12);
            
                        
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Meat Wrapper',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j10);
            
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Seafood Specialist',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j11);
            
            
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Nutrition Advisor',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j12);
            
            
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Shipper/Receiver',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j13);
            
            
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Fresh Cut Produce Clerk',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j14);
            
            
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Cake Decorator',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j15);
            
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                                            Job_Title_for_Banner__c = 'Grocery Supervisor',
                                            Banner_of_Store__c = 'Country Grocer');
            jobs.add(j16);
                                                  
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'CG-1');
        
        system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'CG-2');
        
        system.assertequals(jobs[2].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'CG-3');
        
        system.assertequals(jobs[3].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'CG-4');
        
        system.assertequals(jobs[4].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'CG-5');
        
        system.assertequals(jobs[5].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'CG-6');
        
        system.assertequals(jobs[6].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'CG-7');
        
        //system.assertequals(jobs[7].mindfield_service__c, 'Full-Cycle Recruitment');
        //system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'CG-8');
        
        //system.assertequals(jobs[8].mindfield_service__c, 'Full-Cycle Recruitment');
        //system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'CG-9');
        
        system.assertequals(jobs[7].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'CG-10');
        
        system.assertequals(jobs[8].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'CG-11');
        
        system.assertequals(jobs[9].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'CG-12');
        
        //system.assertequals(jobs[12].mindfield_service__c, 'Full-Cycle Recruitment');
        //system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'CG-13');
        
        
        system.assertequals(jobs[10].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'CG-14');
        
        //system.assertequals(jobs[11].mindfield_service__c, 'Full-Cycle Recruitment');
        //system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'CG-15');
        
        system.assertequals(jobs[12].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'CG-16');
        
        system.assertequals(jobs[13].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'CG-17');
        
        system.assertequals(jobs[14].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'CG-18');
        
        system.assertequals(jobs[15].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'CG-19');
        
        system.assertequals(jobs[16].mindfield_service__c, 'Full-Cycle Recruitment');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'CG-21');
    }
}