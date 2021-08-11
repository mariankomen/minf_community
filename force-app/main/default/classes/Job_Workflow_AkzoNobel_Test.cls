@isTest
public class Job_Workflow_AkzoNobel_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('AkzoNobel').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {          
            // AN Manager in Training Betonel
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Manager in Training - Internal Hire',  Banner_of_Store__c = 'Betonel', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Management');
            jobs.add(j0);
            // AN Manager in Training Dulux
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Manager in Training',  Banner_of_Store__c = 'ICI Paints', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Management');
            jobs.add(j1);
            // AN Sales Associate Betonel
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Service Rep',  Banner_of_Store__c = 'Betonel', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Front Line');
            jobs.add(j2);
            // AN Sales Associate Commercial Dulux
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Service Rep - Commercial Centre - Internal Hire',  Banner_of_Store__c = 'Dulux Paints', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Front Line');
            jobs.add(j3);                        
            // AN Sales Associate Dulux
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Service Rep',  Banner_of_Store__c = 'ICI Paints', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Front Line');
            jobs.add(j4);        
            // AN Store Manager Betonel
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager - Internal Hire',  Banner_of_Store__c = 'Betonel', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Management');
            jobs.add(j5);
            // AN Store Manager Dulux
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Store Manager',  Banner_of_Store__c = 'Dulux Paints', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Management');
            jobs.add(j6);
            // AN Trade Sales Rep Betonel
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Trade Sales Rep',  Banner_of_Store__c = 'Betonel', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Front Line');
            jobs.add(j7);
            // AN Trade Sales Rep Dulux
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Banner__c = 'Trade Sales Rep - Internal Hire',  Banner_of_Store__c = 'Dulux Paints', 
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, MindField_Job_Type__c = 'TalentRecruit - Front Line');
            jobs.add(j8);
            // AN Talent Reach
            SFDC_Job__c j9 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Trade Sales Rep - Internal Hire',  Banner_of_Store__c = 'Dulux Paints', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentReach', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j9);
            // AN Corporate Field Services Rep
            SFDC_Job__c j10 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Field Service Rep',  Banner_of_Store__c = 'PPG Architectural Coatings', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentRecruit - Front Line', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j10);
            // AN Corp Territory Mgr
            SFDC_Job__c j11 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Territory Manager - DIY',  Banner_of_Store__c = 'PPG Architectural Coatings', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentRecruit - Front Line', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j11);  
            // AN Sales Associate Commercial Betonel
            SFDC_Job__c j12 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Store Service Rep - Commercial Centre',  Banner_of_Store__c = 'Betonel', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentRecruit - Front Line', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12);
            
            
            
             // March 15, 2017 - added banner back in
            SFDC_Job__c j13 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Warehouse Associate',  Banner_of_Store__c = 'PPG Architectural Coatings', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentRecruit - Front Line', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13); 
            
             // June, 2017 - new job title for Dulux Paints
            SFDC_Job__c j14 = new SFDC_Job__c(Job_Title_for_Banner__c = 'Assistant Store Manager',  Banner_of_Store__c = 'Dulux Paints', job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, 
                MindField_Job_Type__c = 'TalentRecruit - Management', Num_of_Days_for_Delivery_Agreement__c = 30, Num_of_Candidates_for_Delivery_Agreement__c = 3);
            jobs.add(j14); 
            
            
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c ,Job_Title_FR__c , Career_Site_Alternate_Job_Title__c from SFDC_Job__c where id in :jobs order by id];
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'AN - 4');
        //system.assertequals(jobs[1].SLA_Level__c, 'Management');
        system.assertequals(jobs[2].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'AN - 1 FR');
        system.assertequals(jobs[3].SLA_Level__c, 'Front Line');
        system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'AN - 2');
        //system.assertequals(jobs[4].SLA_Level__c, 'Front Line');
        system.assertequals(jobs[5].Credits_Used_for_Job__c, 6);
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'AN - 5 FR');
        //system.assertequals(jobs[6].SLA_Level__c, 'Management');
        system.assertequals(jobs[6].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'AN - 8');
        //system.assertequals(jobs[7].SLA_Level__c, 'Other (3 in 30)');
        //system.assertequals(jobs[8].Credits_Used_for_Job__c, 6);
        //system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'AN - 6 FR');
        system.assertequals(jobs[9].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'AN - 99');
        system.assertequals(jobs[10].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'AN - 11');
        system.assertequals(jobs[11].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'AN - 12');
        system.assertequals(jobs[12].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'AN - 9 FR');
        
        system.assertequals(jobs[13].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'PPGAC-1');
        
        system.assertequals(jobs[14].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'AN - 11');
    }

}