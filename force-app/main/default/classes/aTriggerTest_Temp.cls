/**********
Class for testing specific methods that fail in prod but the log files for that whole test class are too long
    temporarily add test code into this class so it can be run in isolation
    
**********/
@isTest
private class aTriggerTest_Temp{
  /*
    // used by tests for OnDemand jobs that need an Oportunity created
    static Opportunity o {get; set;}
    static User u {get; set;}
    static {
        // create Account
        Account a = new Account(name = 'ABC');
        insert a;
        o = new Opportunity(name = 'test', accountid = a.id, stagename = 'Initial', closedate = date.today());
        insert o;
        
        // create a portal user and Job Ref record for testing
        Profile p = [select id from Profile where name = 'OFG HirePortal Store User EN'];        
        Account a2 = new Account(name = 'test portal2', store_number__c = '1502');
        insert a2;
        system.debug('new account id: '+a2.id);
        Contact c = new Contact(accountid = a2.id, lastname = 'test contact2', email='niki2@vankerksolutions.com');
        insert c;
        u = new User(contactid = c.id, firstname='test', lastname = 'portal user2', email='niki2@vankerksolutions.com',
            username = 'sample99@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'Demo Related');
        insert u;        
    }
    
    // tests job workflows for EH
    static testMethod void EH_Jobworkflow(){
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('easyhome').getrecordtypeid();
        
        // build list of Jobs to create so they go through the various field setting if statements
        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        system.runas(u) {             
            // EH OnDemand easyHome
            SFDC_Job__c j12 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Role_Title__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD',  Banner_of_Store__c = 'easyhome', 
                SLA_Level__c = 'OnDemand Opening/Client', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = o.id,
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j12);
            // EH OnDemand easyFinancial
            SFDC_Job__c j13 = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', recordtypeid = RecType, Job_Role_Title__c = 'Store Manager', MindField_Job_Type__c = 'TalentDrive - TBD',  Banner_of_Store__c = 'easyfinancial', 
                SLA_Level__c = 'OnDemand Opening/Client', Store_Address__c = 'test', job_linked_to_specific_opportunity__c = o.id,
                Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1);
            jobs.add(j13);
          
            insert jobs;
       }
        jobs = [select Credits_Used_for_Job__c, OTHER_Job_Template_ID__c, SLA_Level__c, Job_Title_FR__c, Career_Site_Alternate_Job_Title__c, MindField_Job_Type__c, Job_Role_Title__c, 
            Banner_of_Store__c from SFDC_Job__c where id in :jobs order by id];

      // EH OnDemand easyHome
        system.assertequals(jobs[0].Credits_Used_for_Job__c, 1);
        system.debug('job values: job type: '+jobs[0].MindField_Job_Type__c+' : banner of store: '+ jobs[0].Banner_of_Store__c+' : job role title: '+jobs[0].Job_Role_Title__c);
        system.assertequals(jobs[0].OTHER_Job_Template_ID__c, 'EH - 98'); 
        // workflow rule flips SLA to Project for TalentDrive type jobs: https://cs11.salesforce.com/01QU0000000D3gH
        //system.assertequals(jobs[12].SLA_Level__c, 'OnDemand Opening/Client');
        // EH OnDemand easyFinancial
        system.assertequals(jobs[1].Credits_Used_for_Job__c, 1);
        system.assertequals(jobs[1].OTHER_Job_Template_ID__c, 'EH - 98'); 
        //system.assertequals(jobs[13].SLA_Level__c, 'OnDemand Opening/Client');

    } // end test easyhome
    
    */
}