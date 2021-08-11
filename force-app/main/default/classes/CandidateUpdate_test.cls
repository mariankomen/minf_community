/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CandidateUpdate_test {

/*
    static testMethod void BasicFieldTest() {
        // Create test records now
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c( first_name__c='Test3', Last_name__c='Test3');
        cans.add(can3);
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        can2 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can2.id];
        can3 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can3.id];   
        
        // get MFG Demo rec type
        id MFGDemo = [select id, name from recordtype where developername = 'MFG_Demo' and sobjecttype = 'SFDC_Job__C' limit 1].id;
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',
                                            recordtypeid = MFGDemo);
        insert j1;
        
        // start with loading page variables testing
        j1 = refreshJobFields(j1.id);
        // Add parameters to page URL
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 
        
        // check variables with 0 candidates linked 
        //system.assertequals(pg.NumCandidates, 0);
        //system.assertequals(pg.Candidates.size(), 0);

        // add 3 Candidates to set each picklist, one set to Interviewing, others as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Interviewing/Background Check', interview_date__c = date.today().adddays(7),
                                                                Date_Candidate_Sent__c = date.today());
        jcs.add(jc1);    
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can2.id, status__c='Qualified Candidates', Date_Candidate_Sent__c = date.today());
        jcs.add(jc2);    
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can3.id, status__c='Qualified Candidates', Date_Candidate_Sent__c = date.today());
        jcs.add(jc3);    
        insert jcs;
        
        jc1 = [select id, sfdc_job__c, candidate__c, status__c, Date_Candidate_Sent__c from SFDC_Job_Candidate__c where id = :jc1.id];
        jc2 = [select id, sfdc_job__c, candidate__c, status__c, Date_Candidate_Sent__c from SFDC_Job_Candidate__c where id = :jc2.id];
        jc3 = [select id, sfdc_job__c, candidate__c, status__c, Date_Candidate_Sent__c from SFDC_Job_Candidate__c where id = :jc3.id];      
        
        j1.job_status__c = 'Candidates Sent/Awaiting Hire';
        update j1;
        j1 = refreshJobFields(j1.id);
        system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');
        
        // refresh page
        pg = new CandidateUpdate(con); 
        // check variables with 3 candidates linked 
        //system.assertequals(pg.NumTotalCandidates, 3);
        //system.assertequals(pg.Candidates.size(), 3);
        
        // move status back to Qualified open page then try to save
        jc1.status__c = 'Qualified Candidates';
        update jc1;
        
        j1 = refreshJobFields(j1.id);
        string origPage = ApexPages.currentPage().getURL();
        pg= new CandidateUpdate(con);
        // try save function - should come back null with errors
        string result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        // should return null
        system.assertequals(result, 'pass');
        //page will have errors for each candidate
        //system.assertequals(ApexPages.getMessages().size(), 3);
        
        // set one to rejected and reload page (will no longer be in editable list of candidates)
        jc1.status__c = 'Rejected';
        jc1.Was_Candidate_Contacted_for_Interview__c = 'Test';
        jc1.Rejection_Reason_for__c = 'Test';
        jc1.Rejection_Is_Candidate_Suitable__c = 'Test';
        update jc1;
        j1 = refreshJobFields(j1.id);
        pg= new CandidateUpdate(con);
        // update can 1 to Left Message with Qualified Candidates
        //pg.candidates[0].selectedStatus = 'Left Message with Qualified Candidates';
       // pg.candidates[1].selectedStatus = 'Hired';

        // save with error of missing date
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.assertequals(result, 'pass');
        system.debug('messages after second save, missing message dates : ' + ApexPages.getMessages());
        // add date but in the past
        pg.candidates[0].can.candidate_message_date__c = date.today().adddays(-16);
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.assertequals(result, 'pass');
        system.debug('messages after third save, message date within 2 weeks: '+ApexPages.getMessages());
        // now skip interview date
        pg.candidates[0].selectedStatus = 'Interviewing';
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.assertequals(result, 'pass');
        system.debug('messages after fourth save, missing interview date: '+ApexPages.getMessages());
        // add date but in the past
        pg.candidates[0].can.interview_date__c = date.today().adddays(-36);
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.assertequals(result, 'pass');
        system.debug('messages after fifth save, interview date within 30 days: '+ApexPages.getMessages());

        // set to Rejected with NO CONTACT reason but contact fields are null
        pg.candidates[0].selectedStatus = 'Rejected';
        pg.candidates[0].can.Rejection_Reason_for__c = 'Could not Contact Candidate';
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.assertequals(result, 'pass');
        system.debug('messages after sixth save, missing Contact Name field value: '+ApexPages.getMessages());
        
        // add contact fields but make candidate sent today and don't answer Request More Candidates
        pg.candidates[0].can.contact_name__c = 'test';
        pg.candidates[0].can.contact_phone__c = '604';
        pg.candidates[0].can.Best_Time_for_Candidate_to_Contact_You__c = 'test';
        // clear interview date as a past date would not error out on request more candidates field
        pg.candidates[0].can.interview_date__c = null;
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.debug('messages after seventh save, missing request more candidates value: '+ApexPages.getMessages());
        system.assertequals(result, 'pass');

        // add request another candidate
        pg.candidates[0].can.Request_Another_Candidate__c = 'Yes';         
        // after save the candidate should have status of Awaiting MindField Group Contact
        pg.onsave();
        system.debug('messages after eighth save, should have allowed can[0] to be saved but switched to Awaiting Contact: '+ApexPages.getMessages());        
        j1 = refreshJobFields(j1.id);
        pg = new CandidateUpdate(con);
        system.debug('candidate status switched from rejected to awaiting contact: '+pg.candidates[0].can.status__c);
        system.assertequals(pg.candidates[0].can.status__c, 'Awaiting MindField Group Contact');
        
        // test No SHOW
        // set to Rejected with No Show for Interview
        pg.candidates[0].selectedStatus = 'Rejected';
        pg.candidates[0].can.Rejection_Reason_for__c = 'No Show for Interview';
        // call setRejectionReason as page would
        pg.updateRejectionReason();
        system.debug('SkipNoShowNoContactCandidates is currently: '+pg.SkipNoShowNoContactCandidates+' and NumNoShow is: '+pg.NumNoShow);
        
        // blank out request more candidates
        pg.candidates[0].can.Request_Another_Candidate__c = null;
        result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        system.debug('messages after ninth save, missing request another candidate option: '+ApexPages.getMessages());  
        system.assertequals(result, 'pass');
        
        // now say yes
        pg.candidates[0].can.Request_Another_Candidate__c = 'Yes';       
        // save will update job status to Additional Candidate(s) Required
        pg.onsave();
        SFDC_Job__c jtest = [select job_status__c, id from SFDC_Job__C where id = :j1.id];
        system.debug('10th save should move job status to Additional Candiates Reqd: '+jtest.job_status__c);
        system.assertequals(jtest.job_status__c, 'Additional Candidate(s) Required');

        j1 = refreshJobFields(j1.id);
        // test with forced exception - add err=1 into url
        ApexPages.currentpage().getParameters().put('err','1');
        pg= new CandidateUpdate(con);
        
        pg.getRejOptions();
    }
   */
    static SFDC_Job__c refreshJobFields(Id jId) {
        return [select id, Job_Status__c, job_owner_link__r.managerid , recordtype.name, job_billing_type__c, Number_of_Replacement_Candidates_Require__c, 
                Job_Comments__c, name, MindField_Job_Type__c, sla_level__c, Specific_Candidate_Preference__c,Using_New_Service_Model__c
               from SFDC_Job__c where id = :jId];
    }
    
    static testMethod void testNSM_TwoHires() {
    
        Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true, Time_to_Disposition_Job_Close_hrs__c=24, Time_to_Disposition_hrs__c=24, Time_to_Disposition_Reminder__c=23);
       insert cp;
       Account pa = new Account(name='Parent Test Account', Client_Profile__c=cp.id);
       insert pa;
       
       Account a = new Account(name='Test Account', ParentId=pa.id, Client_Profile__c=cp.id);
       insert a;
    
       Contact c = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
       insert c;
       User u = new User(firstname='Jeff', lastname='Perron', Username='jp@perron.com123', Email='jp@perron.com123', Alias='jp', CommunityNickname='jp123', TimeZoneSidKey='Pacific/Chatham', 
                         LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId='00eU0000000JM7h',LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=false, contactid=c.id);
       insert u;
        
        id MFGDemo = [select id, name from recordtype where developername = 'MFG_Demo' and sobjecttype = 'SFDC_Job__C' limit 1].id;
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', ownerid=u.id, Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',recordtypeid = MFGDemo);
        insert j1;
    
        // Create test records now - Job with one Hired can but still open
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        can2 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can2.id];
        
        
        // add 3 Candidates to set each picklist as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Qualified Candidates');
        jcs.add(jc1);    
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can2.id, status__c='Qualified Candidates');
        jcs.add(jc2);    
        insert jcs;     
        // flip job to candidates sent
        j1.job_status__c = 'Candidates Sent/Awaiting Hire';
        update j1;
        j1 = refreshJobFields(j1.id);
        system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');
        
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 

        // set all to Rejected but missing rejected fields
        //pg.candidates[0].selectedStatus = 'Hired';
        //pg.candidates[1].selectedStatus = 'Hired';
        
        pg.onsave();
        
        
    }
    
    static testMethod void testNSM_OneHires() {
    
        Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true, Time_to_Disposition_Job_Close_hrs__c=24, Time_to_Disposition_hrs__c=24, Time_to_Disposition_Reminder__c=23);
       insert cp;
       Account pa = new Account(name='Parent Test Account', Client_Profile__c=cp.id);
       insert pa;
       
       Account a = new Account(name='Test Account', ParentId=pa.id, Client_Profile__c=cp.id);
       insert a;
    
       Contact c = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
       insert c;
       User u = new User(firstname='Jeff', lastname='Perron', Username='jp@perron.com123', Email='jp@perron.com123', Alias='jp', CommunityNickname='jp123', TimeZoneSidKey='Pacific/Chatham', 
                         LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId='00eU0000000JM7h',LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=false, contactid=c.id);
       insert u;
        
        id MFGDemo = [select id, name from recordtype where developername = 'MFG_Demo' and sobjecttype = 'SFDC_Job__C' limit 1].id;
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', ownerid=u.id, Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',recordtypeid = MFGDemo);
        insert j1;
    
        // Create test records now - Job with one Hired can but still open
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
       
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
       
        
        
        // add 3 Candidates to set each picklist as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Qualified Candidates');
        jcs.add(jc1);    
          
        insert jcs;     
        // flip job to candidates sent
        j1.job_status__c = 'Candidates Sent/Awaiting Hire';
        update j1;
        j1 = refreshJobFields(j1.id);
        //system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');
        
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 

        // set all to Rejected but missing rejected fields
       // pg.candidates[0].selectedStatus = 'Hired';
       
        
        pg.onsave();
        
        
    }
    
    static testMethod void testCancelJob() {
        // Create test records now - Job with one Hired can but still open
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c( first_name__c='Test3', Last_name__c='Test3');
        cans.add(can3);
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        can2 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can2.id];
        can3 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can3.id];   
        
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test');
        insert j1;
        // add a hired candidate
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Hired');
        insert jc1;     
    //    j1.job_status__c = 'Open/Active Job';
    //    update j1;
        j1 = refreshJobFields(j1.id);
        system.debug('added 1 hired candidate to job: '+j1);
    //    system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire'); 
          
        // start with loading page variables testing
        
        // Add parameters to page URL
        PageReference pageRef = Page.CandidateUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('cancel','1');
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 
        // call check cancel function which will save the Job
        system.debug('checkcancel returns: '+ pg.checkcancel().getURL());
    
    }
    
    static testMethod void testSave_reject() {
        // Create test records now
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c( first_name__c='Test3', Last_name__c='Test3');
        cans.add(can3);
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        can2 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can2.id];
        can3 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can3.id];   
        
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', Name_of_Person_Submitting_Request__c= 'Test record', Job_Role_Title__c = 'test');
        insert j1;
        
        // add 3 Candidates to set each picklist as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Qualified Candidates');
        jcs.add(jc1);    
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can2.id, status__c='Qualified Candidates');
        jcs.add(jc2);    
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can3.id, status__c='Qualified Candidates');
        jcs.add(jc3);    
        insert jcs;     
        // flip job to candidates sent
        j1.job_status__c = 'Candidates Sent/Awaiting Hire';
        update j1;
        j1 = refreshJobFields(j1.id);
        system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');
        
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 

        // set all to Rejected but missing rejected fields
        pg.candidates[0].selectedStatus = 'Rejected';
        pg.candidates[1].selectedStatus = 'Rejected';
        pg.candidates[2].selectedStatus= 'Rejected';
        
        // this will create required field errors
        string result = 'start';
        try {result = pg.onsave().getURL();}
        catch (Exception e) {result = 'pass';}
        // should be back to same page because of errors
        system.assertequals(result, 'pass');        
        
        // set them all to Rejected with reasons
        for (integer i=0; i<3; i++) {
            pg.candidates[i].selectedStatus = 'Rejected';
            pg.candidates[i].can.Was_Candidate_Contacted_for_Interview__c = 'Test';
            pg.candidates[i].can.Rejection_Reason_for__c = 'Test';
            pg.candidates[i].can.Rejection_Is_Candidate_Suitable__c = 'Test';  
        }        
        // set the rejectAction to No
        pg.selectedRejAction = 'No';
        pg.updateRejectionReason();        
        result = pg.onsave().getURL();
        // should be back to original Job page
        system.assertequals(result, '/'+j1.id);
        // test original job status = 'Not Filled/Closed by Mgr'
        j1 = [select job_status__c from SFDC_Job__c where id = :j1.id];
        system.assertequals(j1.job_status__c, 'Not Filled/Closed by Mgr');
   
    }
 
   /*
    static testMethod void testSave_hire() {
        // Create test records now
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c( first_name__c='Test3', Last_name__c='Test3');
        cans.add(can3);
        insert cans;
        can1 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can1.id];
        can2 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can2.id];
        can3 = [select id, first_name__c, last_name__c from SFDC_Candidate__c where id = :can3.id];   
        
        // create OWF job
        id OWF_RecordType;
        for (RecordType JobTypes : [select id from RecordType where SobjectType = 'SFDC_Job__c' and Developername='OFG' limit 1]) {
                OWF_RecordType = JobTypes.id;
        }
        SFDC_Job__c j1 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', Name_of_Person_Submitting_Request__c='Test3 record', 
            recordtypeid= OWF_RecordType,Job_Role_Title__c = 'test');
        insert j1;
        
        // add 3 Candidates to set each picklist as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Qualified Candidates');
        jcs.add(jc1);    
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can2.id, status__c='Qualified Candidates');
        jcs.add(jc2);    
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can3.id, status__c='Qualified Candidates');
        jcs.add(jc3);    
        insert jcs;     

        // make sure job status is cands sent
        j1 = refreshJobFields(j1.id);
        if ( j1.job_status__c != 'Candidates Sent/Awaiting Hire') {
            j1.job_status__c = 'Candidates Sent/Awaiting Hire';
            update j1;
            j1 = refreshJobFields(j1.id);
        }
        system.assertequals(j1.recordtype.name, 'Overwaitea Food Group');
        system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');
        
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 

        // set all to hired 
       // pg.candidates[0].selectedStatus = 'Hired';
        //pg.candidates[1].selectedStatus = 'Hired';
        //pg.candidates[2].selectedStatus = 'Hired';
                                
        // since we have an OWF job, should be returning null so page will open PSFT page and nothing yet saved
        boolean retNull = false;
        string result;
        try { result = pg.onsave().getURL(); }
        catch (Exception e) {retNull = true;}
        system.assert(retNull, 'should be returning null from save for OFG job');
        // ConfirmOWFHire should be true now and we need a final save to complete the Hire
        system.assert(pg.ConfirmOWFHire);
        result = pg.onsave().getURL();
        // test original job status = 'Filled Closed Job'
        j1 = [select job_status__c, (select id, status__c from SFDC_Job_Candidates__r) from SFDC_Job__c where id = :j1.id];
        system.assertequals(j1.job_status__c, 'Filled Closed Job');
       
        // test the email function for CSM email
        pg.AlertCSMOnDemand();
    }*/

    // test method for Glentel having auto Yes selected for rejected and going through auto clone
    /*static testMethod void testSave_glentelReject() {
        SFDC_Candidate__c can = new SFDC_Candidate__c( first_name__c='Test', Last_name__c='Test');
        insert can;
        // glentel job rec type: 012U00000009QqlIAE
        SFDC_Job__c j1 = new SFDC_Job__c(recordtypeid = '012U00000009QqlIAE', Job_Role_Title__c = 'test',Job_Description__c = '12456789012345678901234578901234567980123456789_50',
            num_of_days_for_delivery_agreement__c = 1, num_of_candidates_for_delivery_agreement__c = 1, mindfield_job_type__c = 'test', job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No');
        insert j1;
        // add an Open candidate
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can.id, status__c='Qualified Candidates');
        insert jc1; 
        // update job status now
        j1.job_status__c = 'Candidates Sent/Awaiting Hire';
        update j1;
        j1 = refreshJobFields(j1.id);
        system.assertequals(j1.job_status__c, 'Candidates Sent/Awaiting Hire');

        // initiate controller
        ApexPages.StandardController con= new ApexPages.StandardController(j1);
        CandidateUpdate pg = new CandidateUpdate(con); 
        // check that  AutoCloneRequestMoreCandidates and AutoRequestMoreCandidates are true
        system.assert(pg.AutoCloneRequestMoreCandidates);
        // removed this Oct 6/11
        //system.assert(pg.AutoRequestMoreCandidates); 
        // set candidate to Rejected and save
        pg.candidates[0].selectedStatus = 'Rejected';
        pg.candidates[0].can.Was_Candidate_Contacted_for_Interview__c = 'Test';
        pg.candidates[0].can.Rejection_Reason_for__c = 'Test';
        pg.candidates[0].can.Rejection_Is_Candidate_Suitable__c = 'Test'; 
        pg.candidates[0].can.Rejection_Comments__c = 'test';
        // now that we are not defaulting Glentel to default Yes to all rejected, set it manually here
        pg.selectedRejAction = 'Yes';
        pg.updateRejectionReason();
        string result = pg.onsave().getURL();
        // should be back to original Job page
        system.assert(result.contains('/'+j1.id));
        
        // test original job status = 'Not Filled/Job Re-Opened'
        j1 = refreshJobFields(j1.id);
        system.assertequals(j1.job_status__c, 'Not Filled/Job Re-Opened');
        
        
    }*/
              
}