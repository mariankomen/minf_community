@isTest
public class Job_Workflow_Overwaitea_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Overwaitea Food Group').getrecordtypeid();

        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();   

        // need a portal user with alias of 6607/21 for some tests on wage details
        Account a1 = new Account(name = 'test');
        insert a1;
        Contact c1 = new Contact(lastname = 'test', accountid = a1.id);
        insert c1;
        Profile p = [select id from Profile where name = 'MFG TalentDrive HirePortal Regional User EN'];
        User u6607 = new User(contactid = c1.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='OFG6607', communitynickname='test6607', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u6607;
        Contact c2 = new Contact(lastname = 'test2', accountid = a1.id);
        insert c2;
        User u21 = new User(contactid = c2.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample2@mfg.com', alias='OFG21', communitynickname='test21', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Standard');
        insert u21;  
                                    
        // run tests as portal user to avoid clean up workflow
        system.runas(Job_Workflow_Test_Utility.u) { 
            // skipping some wage details testing through code as many are alike
            // OFG - CF - Service Clerks - default credits/sla
            SFDC_Job__c j0 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Service Clerk (O0039)', OWF_Banner_of_Store__c = 'Cooper\'s Foods');
            jobs.add(j0);
            // OFG - CF - Special Roles - Cash Up Clerk - credits/sla set and wage details with alt title
            SFDC_Job__c j1 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Cash Up Clerk (O0070)', OWF_Banner_of_Store__c = 'Cooper\'s Foods');
            jobs.add(j1);
            // OFG #21 Special Wages All roles (test BC Allocation Crew)
           SFDC_Job__c j2 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'BC Allocation Crew (OF - Z0123)', OWF_Banner_of_Store__c = 'Overwaitea Foods', ownerid = u21.id);
            jobs.add(j2);
            // OFG - SOFBC/OWT for BC Allocation Crew not store #21
            SFDC_Job__c j3 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'BC Allocation Crew (OF - Z0123)', OWF_Banner_of_Store__c = 'Overwaitea Foods');
            jobs.add(j3);
            // OFG - SOFAB - Courtesty Specialist (OFG6607)
            SFDC_Job__c j4 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Courtesy Specialist (C0555)', OWF_Banner_of_Store__c = 'Save On Foods - AB', ownerid = u6607.id);
            jobs.add(j4);        
            // OFG - SOFAB - Department Specialist (no special alias)
            SFDC_Job__c j5 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Department Specialist (C0550)', OWF_Banner_of_Store__c = 'Save On Foods - AB');
            jobs.add(j5);
            // OFG SOFBC - Special Roles - Beauty Counter
            SFDC_Job__c j6 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Beauty Advisor (SOFBC - A0048)', OWF_Banner_of_Store__c = 'Save On Foods - BC', OWF_Department__c = '39 [Cosmetics]');
            jobs.add(j6);
            // OFG - UF - Cook 1
            SFDC_Job__c j7 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Cook (G0256)', OWF_Banner_of_Store__c = 'Urban Fare');
            jobs.add(j7);
            // OFG - UF - Head Chef
            SFDC_Job__c j8 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Head Chef - Non-Union (Z0258)', OWF_Banner_of_Store__c = 'Urban Fare');
            jobs.add(j8);
            // OFG Special Roles - LPA
            SFDC_Job__c j9 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Loss Prevention Assessor (Z0218)', OWF_Banner_of_Store__c = 'Head Office', OWF_Department__c = '90 [Loss Prevention]');
            jobs.add(j9);
            // OFG Special Roles - Health Role for General Clerk (OF - A0034) - should have alt job tittle set
            SFDC_Job__c j10 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'General Clerk (OF - A0034)', OWF_Banner_of_Store__c = 'Overwaitea Foods', OWF_Department__c = '18 [Health]');
            jobs.add(j10);      
            // OFG - SOFBC/OWT for BC Allocation Crew not store #21
            SFDC_Job__c j11 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Cook (C0576)', OWF_Banner_of_Store__c = 'Save On Foods - AB');         
            jobs.add(j11);
            //Save on foods MB Job 1
            SFDC_Job__c j12 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Service Clerk (M0009)', OWF_Department__c ='09 [Cashier]', OWF_Banner_of_Store__c = 'Save On Foods - MB');         
            jobs.add(j12);
            //Save on foods MB Job 2
            SFDC_Job__c j13 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Western Cook (M0008)', OWF_Department__c ='27 [Fast Foods/Restaurant]', OWF_Banner_of_Store__c = 'Save On Foods - MB');         
            jobs.add(j13);
            //Save on foods MB Job 3
            SFDC_Job__c j14 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (M0001)', OWF_Department__c ='42 [Allocation]', OWF_Banner_of_Store__c = 'Save On Foods - MB');         
            jobs.add(j14);
            //Save on foods MB Job 4
            SFDC_Job__c j15 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Meat Cutter (M0011)', OWF_Department__c ='02 [Meat Cutter]', OWF_Banner_of_Store__c = 'Save On Foods - MB');         
            jobs.add(j15);
            
            
            
            //YK banner tests
            SFDC_Job__c j16 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='42 [Allocation]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j16);
            
            SFDC_Job__c j17 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='01 [Grocery]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j17);
            
            SFDC_Job__c j18 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='03 [Produce]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j18);
            
            SFDC_Job__c j19 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='04 [Bakery]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j19);
            
            SFDC_Job__c j20 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='02 [Meat Clerk]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j20);
            
            SFDC_Job__c j21 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='06 [Bulk]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j21);
            
            SFDC_Job__c j22 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='09 [Front End Clerk]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j22);
            
            SFDC_Job__c j23 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='19 [Deli]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j23);
            
            SFDC_Job__c j24 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='26 [Fish/Seafood]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j24);
            
            SFDC_Job__c j25 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='28 [Dairy]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j25);
            
            SFDC_Job__c j26 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='29 [Frozen]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j26);
            
            SFDC_Job__c j27 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='91 [Shipper/Receiver]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j27);
            
            SFDC_Job__c j28 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='93 [Price Change]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j28);
            
            SFDC_Job__c j29 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='30 [Starbucks Barista]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j29);
            
            SFDC_Job__c j30 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, OWF_Job_Title__c = 'Store Clerk (X0123)', OWF_Department__c ='65 [E-Commerce]', OWF_Banner_of_Store__c = 'Save on Foods - YK');         
            jobs.add(j30);
            
            
            
            //New job title test, 00128108
            SFDC_Job__c j31 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'Store Clerk (X0123)',OWF_Banner_of_Store__c = 'Save on Foods - YK');
            jobs.add(j31);
            
            SFDC_Job__c j32 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'Food Clerk (J0002)',OWF_Banner_of_Store__c = 'PriceSmart Foods');
            jobs.add(j32);
            
            SFDC_Job__c j33 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'General Clerk (OF - A0034)',OWF_Banner_of_Store__c = 'Overwaitea Foods');
            jobs.add(j33);
            
            SFDC_Job__c j34 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'General Clerk (SOFBC - A0034)',OWF_Banner_of_Store__c = 'Save On Foods - BC');
            jobs.add(j34);
            
            SFDC_Job__c j35 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'Department Specialist (C0550)',OWF_Banner_of_Store__c = 'Save On Foods - AB');
            jobs.add(j35);
            
            SFDC_Job__c j36 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'Store Clerk (R0001)',OWF_Banner_of_Store__c = 'Save On Foods - SK');
            jobs.add(j36);
            
            SFDC_Job__c j37 = new SFDC_Job__c(Job_Title_for_Role__c = 'abc', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType,
                                              OWF_Department__c = '01 [Overnight Grocery Clerk]', OWF_Job_Title__c = 'Store Clerk (M0001)',OWF_Banner_of_Store__c = 'Save On Foods - MB');
            jobs.add(j37);
            
            insert jobs;
        }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c ,SLA_Level__c, Job_Title_FR__c , Career_Site_Alternate_Job_Title__c, Job_Role_Title__c, Num_of_Days_for_Delivery_Agreement__c, job_city__c, wage_details__c, Career_Site_Alternate_Job_Title_OFG__c, OFG_Job_Template_Description__c, Mindfield_service__c, Job_Template_ID_for_HireDesk_Integration__c from SFDC_Job__c where id in :jobs order by id];

        // OFG - CF - Service Clerks - default credits/sla with wages set
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[0].sla_level__c, 'Front Line');
        system.assertnotequals(jobs[0].wage_details__c, null);        
        // OFG - CF - Special Roles - Cash Up Clerk - credits/sla set with no wage details
        system.assertequals(jobs[1].Career_Site_Alternate_Job_Title_OFG__c, 'Cash & Payroll Office Clerk');
        system.assertnotequals(jobs[1].wage_details__c, null); 
        // OFG #21 Special Wages All roles (test BC Allocation Crew)
        system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
        // OFG - SOFBC/OWT for BC Allocation Crew not store #21
       system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
       // OFG - SOFAB - Courtesy Specialist (OFG6607)
        system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
        // OFG - SOFAB - Department Specialist (no special alias)
        system.assertequals(jobs[1].mindfield_service__c, 'Full-Cycle Recruitment');
        // OFG SOFBC - Special Roles - Beauty Counter - blank wage details with alt title
        system.assertequals(jobs[6].Career_Site_Alternate_Job_Title_OFG__c, 'Grocery Clerk');
        system.assertequals(jobs[6].wage_details__c, null); 
        // OFG - UF - Cook 1
        system.assertequals(jobs[7].Career_Site_Alternate_Job_Title_OFG__c, 'Cook');
        system.assertequals(jobs[7].OFG_Job_Template_Description__c, 'Cook');
        system.assertequals(jobs[7].Num_of_Days_for_Delivery_Agreement__c, 3);
        
        // OFG - UF - Head Chef
        system.assertequals(jobs[8].OFG_Job_Template_Description__c, 'Manual');
        // OFG Special Roles - LPA
        system.assertequals(jobs[9].SLA_Level__c, 'Front Line');
        system.assertequals(jobs[9].Career_Site_Alternate_Job_Title_OFG__c, 'Loss Prevention Assessor');
        system.assertequals(jobs[9].OFG_Job_Template_Description__c, 'LPA');        
        // OFG Special Roles - Health
        system.assertequals(jobs[10].Career_Site_Alternate_Job_Title_OFG__c, 'Grocery Clerk');
        // OFG Save on Foods AB Cook
        system.assertequals(jobs[11].Career_Site_Alternate_Job_Title_OFG__c, 'Cook');
        //mb 1
        system.assertequals(jobs[12].Job_Template_ID_for_HireDesk_Integration__c, 'SOFMB - Cashier');
        //mb 2
        system.assertequals(jobs[13].Job_Template_ID_for_HireDesk_Integration__c, 'SOFMB - Cook');
        //mb 3
        system.assertequals(jobs[14].Job_Template_ID_for_HireDesk_Integration__c, 'SOFMB - SCAllocation');
        //mb 4
        system.assertequals(jobs[15].Job_Template_ID_for_HireDesk_Integration__c, 'SOFMB - MeatCutter');
        
        system.assertequals(jobs[16].Job_Template_ID_for_HireDesk_Integration__c, 'SOFYK - SCAllocation');
        
    }
}