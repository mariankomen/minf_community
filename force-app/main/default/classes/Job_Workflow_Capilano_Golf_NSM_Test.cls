@isTest
public class Job_Workflow_Capilano_Golf_NSM_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Capilano Golf and Country Club - NSM').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = '1st Cook',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = '2nd Cook',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = '3rd Cook',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Banquet Saucier',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Banquet Bartender',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Banquet Server',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Bartender',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Busser/Expo',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Server',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Kitchen Helper',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Night Cleaner/Janitorial',  Banner_of_Store__c = 'Administration', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Grounds Person',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Assistant Horticulturist',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Equipment Technician',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Chef De Partie',  Banner_of_Store__c = 'Food & Beverage', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Locker Attendant',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Day Cleaner',  Banner_of_Store__c = 'Administration', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Backshop Colleague',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Arborist',  Banner_of_Store__c = 'Course & Grounds', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Seasonal Shop Assistant',  Banner_of_Store__c = 'Administration', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            insert jobs;
        }
        
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Role_Type__c, Program_Type__c,mindfield_service__c  from SFDC_Job__c where id in :jobs order by id];
        
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'CAP-12');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'CAP-1');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'CAP-2');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'CAP-3');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'CAP-4');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'CAP-5');
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'CAP-6');
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'CAP-7');
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'CAP-8');
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'CAP-9');
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'CAP-10');
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'CAP-11');
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'CAP-13');
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'CAP-14');
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'CAP-15');
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'CAP-16');
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'CAP-17');
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'CAP-18');
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'CAP-19');
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'CAP-20');
        
    }
}