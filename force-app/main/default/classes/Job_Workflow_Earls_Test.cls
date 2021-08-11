@isTest
public class Job_Workflow_Earls_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Earls').getrecordtypeid();
        
        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {                 
            // Hostess/Host USA
            SFDC_Job__c j0 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Hostess/Host', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j0);
            // Hostess/Host CAN
            SFDC_Job__c j1 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Hostess/Host', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j1);
            // Setter USA
            SFDC_Job__c j2 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Setter', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j2);
            // Setter CAN
            SFDC_Job__c j3 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Setter', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j3);
            // Server USA
            SFDC_Job__c j4 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Server', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j4);
            // Server CAN
            SFDC_Job__c j5 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Server', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j5);
            // Bartender USA
            SFDC_Job__c j6 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Bartender', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j6);
            // Bartender CAN
            SFDC_Job__c j7 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Bartender', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j7);
            // Recruit USA
            SFDC_Job__c j8 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Recruit', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j8);
            // Recruit CAN
            SFDC_Job__c j9 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Recruit', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j9);
            // Line Team USA
            SFDC_Job__c j10 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Line Team', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j10);
            // Line Team CAN
            SFDC_Job__c j11 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Line Team', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j11);
            // Prep Team USA
            SFDC_Job__c j12 = new SFDC_Job__c(banner_of_store__c = 'EARLS - USA', job_title_for_banner__c = 'Prep Team', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j12);
            // Prep Team CAN
            SFDC_Job__c j13 = new SFDC_Job__c(banner_of_store__c = 'EARLS - CANADA', job_title_for_banner__c = 'Prep Team', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                ownerid = Job_Workflow_Test_Utility.u.id, ft_or_pt__c = 'Part Time');
            jobs.add(j13);
                        
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c, Num_of_Candidates_for_Delivery_Agreement__c,
                Num_of_Days_for_Delivery_Agreement__c, MindField_Job_Type__c from SFDC_Job__c where id in :jobs order by id];

        // Hostess/Host USA
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'ERL-1');
        system.assertequals(jobs[0].Career_Site_Alternate_Job_Title__c, 'Part Time Hostess/Host - Earls (Test Store)');
        // Hostess/Host Can
        system.assertequals(jobs[1].Num_of_Candidates_for_Delivery_Agreement__c, 2);
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'ERL-8');
        // Setter USA
        system.assertequals(jobs[2].Num_of_Days_for_Delivery_Agreement__c, 5);
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'ERL-2');
        system.assertequals(jobs[2].Career_Site_Alternate_Job_Title__c, 'Part Time Restaurant Setter - Earls (Test Store)');
        // Setter  Can
        system.assertequals(jobs[3].MindField_Job_Type__c, 'TalentRecruit - Front Line');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'ERL-9');
        // Server USA
        system.assertequals(jobs[4].Num_of_Days_for_Delivery_Agreement__c, 5);
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'ERL-3');
        system.assertequals(jobs[4].Career_Site_Alternate_Job_Title__c, 'Part Time Restaurant Server - Earls (Test Store)');
        // Server Can
        system.assertequals(jobs[5].MindField_Job_Type__c, 'TalentRecruit - Front Line');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'ERL-10');
        // Bartender USA
        system.assertequals(jobs[6].sla_level__c , 'Front Line');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'ERL-4');
        system.assertequals(jobs[6].Career_Site_Alternate_Job_Title__c, 'Part Time Bartender - Earls (Test Store)');
        // Bartender Can
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'ERL-11');
        // Recruit USA
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'ERL-5');
        system.assertequals(jobs[8].Career_Site_Alternate_Job_Title__c, 'Part Time Restaurant Recruit-Dishwasher - Earls (Test Store)');
        // Recruit Can
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'ERL-12');
        //  Line Team USA
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'ERL-6');
        system.assertequals(jobs[10].Career_Site_Alternate_Job_Title__c, 'Part Time Restaurant Line Cook - Earls (Test Store)');
        //  Line Team Can
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'ERL-13');
        //  Prep Team USA
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'ERL-7');
        system.assertequals(jobs[12].Career_Site_Alternate_Job_Title__c, 'Part Time Restaurant Prep Cook - Earls (Test Store)');
        //  Prep Team Can
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'ERL-14');
        
    }
}