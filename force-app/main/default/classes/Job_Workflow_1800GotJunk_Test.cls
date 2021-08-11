@isTest
public class Job_Workflow_1800GotJunk_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        Job_Workflow_Test_Utility.setupUser2();
        Job_Workflow_Test_Utility.setupUser3();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecTypeCSS = JobRecTypes.get('1800GotJunk-CSS').getrecordtypeid();
        Id RecTypeFCR = JobRecTypes.get('1800GotJunk-FCR').getrecordtypeid();
        Id RecTypePO = JobRecTypes.get('1800GotJunk-PO').getrecordtypeid();
        
        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        List<SFDC_Job__c> jobsUSA = new List<SFDC_Job__c>();    
        List<SFDC_Job__c> jobsAUS = new List<SFDC_Job__c>();  

        // run tests as portal user to avoid clean up workflow
        //CAN Jobs
        system.runas(Job_Workflow_Test_Utility.u) {                 
            // Truck Team Member Canada FCR
            SFDC_Job__c j0 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', Mindfield_Service__c = 'Full-cycle Recruitment', job_title_for_banner__c = 'Truck Team Member', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeFCR,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j0);
            
            // Truck Team Member Can CSS
            SFDC_Job__c j1 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Truck Team Member', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j1);
            
            // Operations Manager CAN CSS
            SFDC_Job__c j2 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Operations Manager', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j2);
            
            
            
            
            SFDC_Job__c j3 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Service Member', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job - Talent Connect', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j3);
            
            SFDC_Job__c j4 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Superheroes Wanted) $13-$18', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j4);
            
            SFDC_Job__c j5 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $15-$20', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j5);
            
            SFDC_Job__c j6 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $13-$18', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Canada', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j6);
                       
                        
            insert jobs;
        }
        
        //USA Jobs
        system.runas(Job_Workflow_Test_Utility.u2) {                 
            
           //Truck Team Member USA FCR
            SFDC_Job__c j0 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Truck Team Member', Mindfield_Service__c = 'Full-cycle Recruitment', Location_Country__c  = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeFCR,
                ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j0);
                       
            // Truck Team Member USA CSS
            SFDC_Job__c j1 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Truck Team Member', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j1);
            
            // Operations Manager USA CSS
            SFDC_Job__c j2 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Operations Manager', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j2);
                     
                     
                     
                     
            // Service Member USA CSS
            SFDC_Job__c j3 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Service Member', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j3);

            // SUper Heroes Wanted USA CSS
            SFDC_Job__c j4 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Superheroes Wanted) $15-$20', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j4);

            // Route Team Member USA CSS
            SFDC_Job__c j5 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $15-$20', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j5);

            // Best Job Ever USA CSS
            SFDC_Job__c j6 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $13-$18', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'United States', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
             ownerid = Job_Workflow_Test_Utility.u2.id, ft_or_pt__c = 'Part Time');
            jobsUSA.add(j6);            
                      
            insert jobsUSA;
        }
        //AUS Jobs
        system.runas(Job_Workflow_Test_Utility.u3) {                 
            
            // Truck Team Member AUS FCR
            SFDC_Job__c j0 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Truck Team Member', Mindfield_Service__c = 'Full-cycle Recruitment', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeFCR,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j0);
            
            // Truck Team Member AUS CSS
            SFDC_Job__c j1 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Truck Team Member', Mindfield_Service__c = 'Candidate Sourcing', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', Location_Country__c = 'Australia', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j1);
            
            // Operations Manager AUS CSS
            SFDC_Job__c j2 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Operations Manager', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j2);
            
            
            
            
            // Service Member AUS CSS
            SFDC_Job__c j3 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Service Member', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j3);
            
            // Super Heroes Wanted Manager AUS CSS
            SFDC_Job__c j4 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Superheroes Wanted) $15-$20', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j4);
            
            // Route Team Member Manager AUS CSS
            SFDC_Job__c j5 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $15-$20', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j5);
            
            // Best Job Ever Manager AUS CSS
            SFDC_Job__c j6 = new SFDC_Job__c(banner_of_store__c = '1-800-Got-Junk?', job_title_for_banner__c = 'Route Team Member (Want More Work Happy) $13-$18', Mindfield_Service__c = 'Candidate Sourcing', Location_Country__c = 'Australia', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecTypeCSS,
                ownerid = Job_Workflow_Test_Utility.u3.id, ft_or_pt__c = 'Part Time');
            jobsAUS.add(j6);
           
                        
            insert jobsAUS;
        }
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, Num_of_Candidates_for_Delivery_Agreement__c,
                Num_of_Days_for_Delivery_Agreement__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobs order by id];

        // Truck Team Member CAN FCR
        system.assertequals(jobs[0].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobs[0].Num_of_Days_for_Delivery_Agreement__c , 7);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, '18G-TTMFCRCA');
        //system.assertequals(jobs[0].Career_Site_Alternate_Job_Title__c, 'Part Time Customer Crew Truck Team Member - 1-800-Got-Junk? (Test Store)');
        // Truck Team Member CAN CSS
        //system.assertequals(jobs[1].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, '18G-TTMCSSCA');
        // Operations Manager CAN CSS
        //system.assertequals(jobs[2].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, '18G-OPMCSSCA');
        //Service member Canada CSS
        system.assertequals(jobs[3].other_job_template_ID__c, '18G-5');
        //Suepr Heroes Wanted
        system.assertequals(jobs[4].other_job_template_ID__c, '18G-60');
        //Route Team Member
        system.assertequals(jobs[5].other_job_template_ID__c, '18G-7');
        //Best job ever
        system.assertequals(jobs[6].other_job_template_ID__c, '18G-74');

        jobsUSA = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, Num_of_Candidates_for_Delivery_Agreement__c,
                Num_of_Days_for_Delivery_Agreement__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobsUSA order by id];
        
        // Truck Team Member USA FCR
        system.assertequals(jobsUSA[0].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobsUSA[0].Num_of_Days_for_Delivery_Agreement__c , 7);
        system.assertequals(jobsUSA[0].OTHER_Job_Template_ID__c, '18G-TTMFCRUS');
        // Truck Team Member USA CSS
        //system.assertequals(jobs[4].Num_of_Days_for_Delivery_Agreement__c, 7);
        system.assertequals(jobsUSA[1].OTHER_Job_Template_ID__c, '18G-TTMCSSUS');
        //system.assertequals(jobs[4].Career_Site_Alternate_Job_Title__c, 'Part Time Customer Crew Truck Team Member - 1-800-Got-Junk? (Test Store)');
        // Operations Manager USA CSS
        system.assertequals(jobsUSA[2].OTHER_Job_Template_ID__c, '18G-51');
        //Service Member USA
        system.assertequals(jobsUSA[3].other_job_template_ID__c, '18G-29');
        //super heroes wanted USA
        system.assertequals(jobsUSA[4].other_job_template_ID__c, '18G-30');
        //Route Team Member USA
        system.assertequals(jobsUSA[5].other_job_template_ID__c, '18G-31');
        //Best Job Ever USA
        system.assertequals(jobsUSA[6].other_job_template_ID__c, '18G-66');
        
        jobsAUS = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, Num_of_Candidates_for_Delivery_Agreement__c,
                Num_of_Days_for_Delivery_Agreement__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobsAUS order by id];
        
        // Truck Team Member AUS FCR
        system.assertequals(jobsAUS[0].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobsAUS[0].Num_of_Days_for_Delivery_Agreement__c , 7);
        system.assertequals(jobsAUS[0].OTHER_Job_Template_ID__c, '18G-TTMFCRAUS');
        //system.assertequals(jobs[2].Career_Site_Alternate_Job_Title__c, 'Part Time Customer Crew Truck Team Member - 1-800-Got-Junk? (Test Store)');                
        // Truck Team Member AUS CSS
        //system.assertequals(jobs[1].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobsAUS[1].OTHER_Job_Template_ID__c, '18G-TTMCSSAUS');       
        // Operations Manager AUS CSS
        system.assertequals(jobsAUS[2].OTHER_Job_Template_ID__c, '18G-OPMCSSAUS');
        
        //Service Member
        system.assertequals(JobsAUS[3].other_job_template_ID__c, '18G-41');
        
        //Super Heroes
        system.assertequals(jobsAUS[4].other_job_template_ID__c, '18G-42');
        
        //Route Team
        system.assertequals(jobsAUS[5].other_job_template_ID__c, '18G-43');
        
        //Best Job
        system.assertequals(JobsAUS[6].other_job_template_ID__c, '18G-70');
       
        
    }
}