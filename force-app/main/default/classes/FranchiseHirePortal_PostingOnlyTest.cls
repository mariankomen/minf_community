@isTest
private class FranchiseHirePortal_PostingOnlyTest {

    @testSetup
    static void setupUsers() {
        User uCan = TestDataFactory.setupPortalUserWith3Levels('Canada', 10, 'fr');
        RecordType rt_PO = [select id, name from recordtype where name = '1800GotJunk-PO' and sobjecttype = 'SFDC_Job__c']; 
        // create profile for base level
        client_profile__c can_location = new client_profile__c(name = 'Canada location', 
            FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 13, CSS_Price_Per_Job_USD__c = 14, CSS_Price_Per_Job_AU__c = 15, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO');
        insert can_location;
        uCan.contact.account.client_profile__c = can_location.id;
        update uCan.contact.account;
    }

    private static User CanadianUser {set; get{
        if (CanadianUser == null)
            CanadianUser = [select id, username, contact.account.id, contact.account.parent.id, contact.account.parent.parent.id from User where alias = 'Canada' limit 1];
        return CanadianUser;
    }}  

    private static Id PORecType {set; get{
        if (PORecType == null)
            PORecType = [select id, name from recordtype where name = '1800GotJunk-PO' and sobjecttype = 'SFDC_Job__c'].id;
        return PORecType;
    }}

    private static testmethod void testcurrUser(){
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            system.assertequals(wiz.currUser.contact.account.billingcountry, 'Canada');
        }
    }

    // test open job with client profile that has PO Rec TYpe linked - sets defaults and returns null page
    @isTest static void openJob_success() {
        system.runas(CanadianUser) {
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            PageReference retPg = POJob.openJob();
            test.stoptest();
            system.assertEquals(POJob.job.recordtypeid, PORecType, 'job opened with PO Rec type: '+POJob.job);
            system.assertEquals(null, retPg, 'sent back null');
        }
    }
    
    // test open job with client profile that has NO PO Rec TYpe linked - returns error page FranchiseHirePortal_Error
    @isTest static void openJob_fail() {
        CanadianUser.contact.account.client_profile__c = null;
        update CanadianUser.contact.account;
        system.runas(CanadianUser) {
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            PageReference retPg = POJob.openJob();
            test.stoptest();
            system.assertEquals(POJob.job.recordtypeid, null, 'job opened without PO Rec type: '+POJob.job);
            system.assert(retPg.getURL().containsIgnoreCase('FranchiseHirePortal_Error'), 'sent to error page: '+retPg);
        }
    }
    

    // test save job with missing reqd fields - no upsert and returns null with page messages
    @isTest static void saveJob_fail() {
        system.runas(CanadianUser) {
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            POJob.openJob();
            POJob.job.Banner_of_Store__c = null;
            POJob.job.Name_of_Person_Submitting_Request__c = null;
            POJob.job.Number_Of_Hours_Per_Week__c = null;
            POJob.job.FT_or_PT__c = null;
            POJob.job.wage_details__c = null;
            PageReference retPg = POJob.saveJob();
            test.stoptest();
            system.assertEquals(POJob.job.id, null, 'job not saved: '+POJob.job);
            system.assertEquals(null, retPg, 'sent back null');
        }
    }   

    // test save job with filled in reqd fields - upsert and returns FranchiseHirePortal_ThankYou_JobCreation
    // user does not have access to job is for store so passes without it.
    @isTest static void saveJob_pass() {
        system.runas(CanadianUser) {
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            POJob.openJob();
            POJob.job.Banner_of_Store__c = '1-800';
            POJob.job.job_title_for_banner__c = 'Test Title';
            POJob.job.Name_of_Person_Submitting_Request__c = 'Test';
            POJob.job.Number_Of_Hours_Per_Week__c = 'Test';
            POJob.job.FT_or_PT__c = 'Test';
            POJob.job.wage_details__c = 'Test';
            PageReference retPg = POJob.saveJob();
            test.stoptest();
            //system.assertNOTEquals(POJob.job.id, null, 'job is saved: '+POJob.job);
            //system.assert(retPg.getURL().containsIgnoreCase('FranchiseHirePortal_ThankYou_JobCreation'), 'sent to thank you page: '+retPg);
        }
    }
    
    private static testmethod void saveJobFail_jobIsForStoreVisible() {
        // this user is REG User and doesnt' have access to Job is for store number field
        User u = CanadianUser;
        User currUser = [select id from User where id = :userinfo.getuserid()];
        system.runas(currUser) {
            Profile FPUser =  [select id from Profile where name = '1800GotJunk HirePortal FP User EN'];
            u.profileid = FPUser.id;
            update u;
        }
        system.runas(CanadianUser) {        
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            POJob.openJob();
            POJob.job.Banner_of_Store__c = '1-800';
            POJob.job.job_title_for_banner__c = 'Test Title';
            POJob.job.Name_of_Person_Submitting_Request__c = 'Test';
            POJob.job.Number_Of_Hours_Per_Week__c = 'Test';
            POJob.job.FT_or_PT__c = 'Test';
            POJob.job.wage_details__c = 'Test';
            PageReference retPg = POJob.saveJob();
            test.stoptest();
            system.assertEquals(POJob.job.id, null, 'job not saved: '+POJob.job);
            system.assertEquals(null, retPg, 'sent back null');        
        }
    }    
    
    private static testmethod void saveJobPASS_jobIsForStoreVisible() {
        // this user is REG User and doesnt' have access to Job is for store number field
        User u = CanadianUser;
        User currUser = [select id from User where id = :userinfo.getuserid()];
        system.runas(currUser) {
            Profile FPUser =  [select id from Profile where name = '1800GotJunk HirePortal FP User EN'];
            u.profileid = FPUser.id;
            update u;
        }
        system.runas(CanadianUser) {        
            test.startTest();
            FranchiseHirePortal_PostingOnlyJob POJob = new FranchiseHirePortal_PostingOnlyJob();
            POJob.openJob();
            POJob.job.Banner_of_Store__c = '1-800';
            POJob.job.job_title_for_banner__c = 'Test Title';
            POJob.job.Name_of_Person_Submitting_Request__c = 'Test';
            POJob.job.Number_Of_Hours_Per_Week__c = 'Test';
            POJob.job.FT_or_PT__c = 'Test';
            POJob.job.wage_details__c = 'Test';
            POJob.job.Job_is_for_Store_if_applicable__c = '123';
            PageReference retPg = POJob.saveJob();
            test.stoptest();
            system.assertNOTEquals(POJob.job.id, null, 'job is saved: '+POJob.job);
            system.assert(retPg.getURL().containsIgnoreCase('FranchiseHirePortal_ThankYou_JobCreation'), 'sent to thank you page: '+retPg);
        }
    }    
    
}