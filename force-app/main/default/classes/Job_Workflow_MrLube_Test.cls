@isTest
public class Job_Workflow_MrLube_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Mr. Lube Franchise').getrecordtypeid();
        
        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

        // need a portal user with store that has Account_Billing_type__c = Credit Card On Demand for some tests
        Account a1 = new Account(name = 'test', Account_Billing_type__c = 'Credit Card On Demand', Credit_Card_Expiry_MM__c = '12', Credit_Card_Expiry_YYYY__c = '2012', Credit_Card_Number__c = '4530',
                Credit_Card_Type__c = 'test', Credit_Card_Verification_Number__c = '123', Confidential_Job_Posting_Required__c = true);
        insert a1;
        Contact c1 = new Contact(lastname = 'test', accountid = a1.id);
        insert c1;
        Profile p = [select id from Profile where name = 'MFG TalentDrive HirePortal Regional User EN'];
        User u2 = new User(contactid = c1.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u2;
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) {   
        
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Lower Technician',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Customer Service and Sales Representative',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Sales Advisor',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Greeter',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Assistant Manager',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
            jobs.add(new SFDC_Job__c(Job_Title_for_Banner__c = 'Store Manager',  Banner_of_Store__c = 'Mr. Lube', job_status__c = 'test', recordtypeid = RecType, Specific_Candidate_Preference__c = 'No'));
        
        
            /* March 2018, Comment all of this old code out to align with the NSM ------------------------------------------------------------------------------              
            // MLF OnDemand
            SFDC_Job__c j0 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD', 
                ownerid = Job_Workflow_Test_Utility.u.id, SLA_Level__c = 'OnDemand Opening/Client', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = Job_Workflow_Test_Utility.o.id,
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j0);        
            // MLF Assistant Store Manager
            SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Assistant Store Manager', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j1);        
            // MLF Assistant Store Manager Talent Connect
            SFDC_Job__c j2 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Assistant Store Manager', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j2);        
            // MLF Lower Service Technician
            SFDC_Job__c j3 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Lower Technician', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j3);        
            // MLF Lower Service Technician Talent Connect
            SFDC_Job__c j4 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Lower Technician', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j4);        
            // MLF MIT
            SFDC_Job__c j5 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Manager In Training', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j5);        
            // MLF MIT Talent Connect
            SFDC_Job__c j6 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Manager In Training', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j6); 
            // MLF OnDemand Assistant Manager
            SFDC_Job__c j7 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Assistant Manager', MindField_Service_Offering__c = 'Complete', 
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j7);        
            // MLF OnDemand Lower Service Technician
            SFDC_Job__c j8 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Lower Technician', MindField_Service_Offering__c = 'Complete',
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j8);        
            // MLF OnDemand Sales Advisor
            SFDC_Job__c j9 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Advisor', MindField_Service_Offering__c = 'Complete',
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j9);        
            // MLF OnDemand Store Manager
            SFDC_Job__c j10 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Service_Offering__c = 'Complete',
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j10);        
            // MLF OnDemand Supervisor
            SFDC_Job__c j11 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Supervisor', MindField_Service_Offering__c = 'Complete',
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j11);        
            // MLF OnDemand Upper Service Technician
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Upper Service Technician', MindField_Service_Offering__c = 'Complete',
                ownerid = u2.id, Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12);        
            // MLF Other
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13);
            // MLF Sales Advisor (Winnipeg or not)
            SFDC_Job__c j14 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Advisor', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j14); 
            // MLF Sales Advisor TalentConnect
            SFDC_Job__c j15 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Advisor', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j15);                     
            // MLF Service Advisor
            SFDC_Job__c j16 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Advisor', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j16);
            // MLF Service Advisor Talent Connect
            SFDC_Job__c j17 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Advisor', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j17);                     
            // MLF Service Technician
            SFDC_Job__c j18 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Technician', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j18); 
            // MLF Service Technician Talent Connect
            SFDC_Job__c j19 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Technician', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j19);                     
            // MLF Store Manager
            SFDC_Job__c j20 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j20); 
            // MLF Store Manager Talent Connect
            SFDC_Job__c j21 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j21);                     
            // MLF Supervisor
            SFDC_Job__c j22 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Supervisor', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j22); 
            // MLF Supervisor Talent Connect
            SFDC_Job__c j23 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Supervisor', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j23);                     
            // MLF Upper Service Technician
            SFDC_Job__c j24 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Upper Service Technician', MindField_Service_Offering__c = 'Complete',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j24); 
            // MLF Upper Service Technician
            SFDC_Job__c j25 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Upper Service Technician', MindField_Service_Offering__c = 'Post Online',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j25);         
            // MLF Assistant Store Manager Talent Connect
            SFDC_Job__c j26 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Assistant Store Manager', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j26); 
             // MLF Lower Service Technician Talent Connect
            SFDC_Job__c j27 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Lower Technician', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j27);
            // MLF MIT Talent Connect
            SFDC_Job__c j28 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Manager In Training', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j28);   
            // MLF Sales Advisor TalentConnect
            SFDC_Job__c j29 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Sales Advisor', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j29);   
            // MLF Service Advisor Talent Connect
            SFDC_Job__c j30 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Advisor', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j30);  
            // MLF Service Technician Talent Connect
            SFDC_Job__c j31 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Service Technician', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j31);   
            // MLF Store Manager Talent Connect
            SFDC_Job__c j32 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Store Manager', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j32);          
            // MLF Supervisor Talent Connect
            SFDC_Job__c j33 = new SFDC_Job__c(job_status__c = 'test', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Title_for_Role__c = 'Supervisor', MindField_Service_Offering__c = 'Promote',
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j33);     
            */
            
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, job_city__c, wage_details__c from SFDC_Job__c where id in :jobs order by id];

        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'MLF - 6');
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'MLF - 7');
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'MLF - 10');
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'MLF - 20');
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'MLF - 3');
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'MLF - 4');

        /* March 2018, Comment all of this old code out to align with the NSM ------------------------------------------------------------------------------
        // MLF OnDemand
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 5);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'MLF - 4');
       
        // MLF Assistant Store Manager
        system.assertequals(jobs[1].Credits_Used_for_Job__c, 3);
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'MLF - 3');
        system.assertequals(jobs[1].SLA_Level__c, 'Management');        
        // MLF Assistant Store Manager Talent Connect
        system.assertequals(jobs[2].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[2].OTHER_Job_Template_ID__c, 'MLF - 3TC');
        system.assertequals(jobs[2].SLA_Level__c, 'Job Posting Only');        
        // MLF Lower Service Technician
        system.assertequals(jobs[3].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[3].OTHER_Job_Template_ID__c, 'MLF - 6');
        system.assertequals(jobs[3].SLA_Level__c, 'Front Line');        
        // MLF Lower Service Technician Talent Connect
        system.assertequals(jobs[4].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[4].OTHER_Job_Template_ID__c, 'MLF - 6TC');
        system.assertequals(jobs[4].SLA_Level__c, 'Job Posting Only');        
        // MLF MIT
        system.assertequals(jobs[5].Credits_Used_for_Job__c, 3);
        system.assertequals(jobs[5].OTHER_Job_Template_ID__c, 'MLF - 9');
        system.assertequals(jobs[5].SLA_Level__c, 'Management');        
        // MLF MIT Talent Connect
        system.assertequals(jobs[6].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[6].OTHER_Job_Template_ID__c, 'MLF - 9TC');
        system.assertequals(jobs[6].SLA_Level__c, 'Job Posting Only');        
        // MLF OnDemand Assistant Manager
        system.assertequals(jobs[7].Credits_Used_for_Job__c, 3);
        system.assertequals(jobs[7].OTHER_Job_Template_ID__c, 'MLF - 3');
        system.assertequals(jobs[7].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF OnDemand Lower Service Technician
        system.assertequals(jobs[8].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[8].OTHER_Job_Template_ID__c, 'MLF - 6');
        system.assertequals(jobs[8].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF OnDemand Sales Advisor
        system.assertequals(jobs[9].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[9].OTHER_Job_Template_ID__c, 'MLF - 10');
        system.assertequals(jobs[9].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF OnDemand Store Manager
        system.assertequals(jobs[10].Credits_Used_for_Job__c, 5);
        system.assertequals(jobs[10].OTHER_Job_Template_ID__c, 'MLF - 4');
        system.assertequals(jobs[10].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF OnDemand Supervisor
        system.assertequals(jobs[11].Credits_Used_for_Job__c, 3);
        system.assertequals(jobs[11].OTHER_Job_Template_ID__c, 'MLF - 8');
        system.assertequals(jobs[11].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF OnDemand Upper Service Technician
        system.assertequals(jobs[12].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[12].OTHER_Job_Template_ID__c, 'MLF - 7');
        system.assertequals(jobs[12].SLA_Level__c, 'OnDemand Opening/Client'); 
        // MLF Other
        system.assertequals(jobs[13].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[13].OTHER_Job_Template_ID__c, 'MLF - 99TC');
        system.assertequals(jobs[13].SLA_Level__c, 'Job Posting Only'); 
        // MLF Sales Advisor (Winnipeg or not)
        system.assertequals(jobs[14].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[14].OTHER_Job_Template_ID__c, 'MLF - 10');
        system.assertequals(jobs[14].SLA_Level__c, 'Front Line'); 
        system.assertequals(jobs[14].wage_details__c, null);
        // MLF Sales Advisor TalentConnect
        system.assertequals(jobs[15].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[15].OTHER_Job_Template_ID__c, 'MLF - 10TC');
        system.assertequals(jobs[15].SLA_Level__c, 'Job Posting Only'); 
        // MLF Service Advisor
        system.assertequals(jobs[16].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[16].OTHER_Job_Template_ID__c, 'MLF - 12');
        system.assertequals(jobs[16].SLA_Level__c, 'Front Line'); 
        // MLF Service Advisor Talent Connect
        system.assertequals(jobs[17].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[17].OTHER_Job_Template_ID__c, 'MLF - 12TC');
        system.assertequals(jobs[17].SLA_Level__c, 'Job Posting Only'); 
        // MLF Service Technician
        system.assertequals(jobs[18].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[18].OTHER_Job_Template_ID__c, 'MLF - 11');
        system.assertequals(jobs[18].SLA_Level__c, 'Front Line'); 
        // MLF Service Technician Talent Connect
        system.assertequals(jobs[19].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[19].OTHER_Job_Template_ID__c, 'MLF - 11TC');
        system.assertequals(jobs[19].SLA_Level__c, 'Job Posting Only'); 
        // MLF Store Manager
        system.assertequals(jobs[20].Credits_Used_for_Job__c, 5);
        system.assertequals(jobs[20].OTHER_Job_Template_ID__c, 'MLF - 4');
        system.assertequals(jobs[20].SLA_Level__c, 'Management'); 
        // MLF Store Manager Talent Connect
        system.assertequals(jobs[21].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[21].OTHER_Job_Template_ID__c, 'MLF - 4TC');
        system.assertequals(jobs[21].SLA_Level__c, 'Job Posting Only'); 
        // MLF Supervisor
        system.assertequals(jobs[22].Credits_Used_for_Job__c, 3);
        system.assertequals(jobs[22].OTHER_Job_Template_ID__c, 'MLF - 8');
        system.assertequals(jobs[22].SLA_Level__c, 'Management'); 
        // MLF Supervisor Talent Connect
        system.assertequals(jobs[23].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[23].OTHER_Job_Template_ID__c, 'MLF - 8TC');
        system.assertequals(jobs[23].SLA_Level__c, 'Job Posting Only'); 
        // MLF Upper Service Technician
        system.assertequals(jobs[24].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[24].OTHER_Job_Template_ID__c, 'MLF - 7');
        system.assertequals(jobs[24].SLA_Level__c, 'Front Line'); 
        // MLF Upper Service Technician
        system.assertequals(jobs[25].Credits_Used_for_Job__c, 0);
        system.assertequals(jobs[25].OTHER_Job_Template_ID__c, 'MLF - 7TC');
        system.assertequals(jobs[25].SLA_Level__c, 'Job Posting Only');
        // MLF Assistant Store Manager Talent Connect
        system.assertequals(jobs[26].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[26].OTHER_Job_Template_ID__c, 'MLF - 3TC');
        system.assertequals(jobs[26].SLA_Level__c, 'Job Posting Only');   
        // MLF Lower Service Technician Talent Connect
        system.assertequals(jobs[27].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[27].OTHER_Job_Template_ID__c, 'MLF - 6TC');
        system.assertequals(jobs[27].SLA_Level__c, 'Job Posting Only'); 
        // MLF MIT Talent Connect
        system.assertequals(jobs[28].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[28].OTHER_Job_Template_ID__c, 'MLF - 9TC');
        system.assertequals(jobs[28].SLA_Level__c, 'Job Posting Only'); 
        // MLF Sales Advisor TalentConnect
        system.assertequals(jobs[29].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[29].OTHER_Job_Template_ID__c, 'MLF - 10TC');
        system.assertequals(jobs[29].SLA_Level__c, 'Job Posting Only'); 
        // MLF Service Advisor Talent Connect
        system.assertequals(jobs[30].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[30].OTHER_Job_Template_ID__c, 'MLF - 12TC');
        system.assertequals(jobs[30].SLA_Level__c, 'Job Posting Only'); 
        // MLF Service Technician Talent Connect
        system.assertequals(jobs[31].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[31].OTHER_Job_Template_ID__c, 'MLF - 11TC');
        system.assertequals(jobs[31].SLA_Level__c, 'Job Posting Only'); 
        // MLF Store Manager Talent Connect
        system.assertequals(jobs[32].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[32].OTHER_Job_Template_ID__c, 'MLF - 4TC');
        system.assertequals(jobs[32].SLA_Level__c, 'Job Posting Only'); 
        // MLF Supervisor Talent Connect
        system.assertequals(jobs[33].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[33].OTHER_Job_Template_ID__c, 'MLF - 8TC');
        system.assertequals(jobs[33].SLA_Level__c, 'Job Posting Only');
        */
    }
}