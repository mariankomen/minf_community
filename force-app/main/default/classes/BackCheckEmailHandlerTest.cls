@istest
private class BackCheckEmailHandlerTest{
      // ENGLISH start and end labels used to find details in the email body.  Change here if the body text is adjusted in the future
      static final string CANDIDATE_START_LABEL = 'The file you have submitted for *';
      static final string CANDIDATE_END_LABEL = '* is now';
      static final string CLIENT_START_LABEL = 'Location:* ';
      static final string CLIENT_END_LABEL = '\n';
      static final string URL_START_LABEL = 'View This Report:*\n';
      static final string URL_END_LABEL = '\n*View All Files';
      // FRENCH start and end labels used to find details in the email body.  Change here if the body text is adjusted in the future
      static final string CANDIDATE_START_LABEL_FR = 'Le dossier que vous avez soumis pour *';
      static final string CANDIDATE_END_LABEL_FR = '* est maintenant';
      static final string CLIENT_START_LABEL_FR = 'Adresse :* ';
      static final string CLIENT_END_LABEL_FR = '  *Contact';
      static final string URL_START_LABEL_FR = 'Voir ce rapport :*\n';
      static final string URL_END_LABEL_FR = '\n*Voir tous les dossiers';
    // TEST METHOD //
    @istest
    private static void testhandler(){
        // create Longo Job, Candidate Record and Candidate in Qualified Candidates status

        // create a portal user and Job Ref record
        Account a = new Account(name = 'test portal', store_number__c = '1500', backcheck_custom_store_name__c = 'testing portal');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        // need to test with Akzo Nobel user since BC is only available for them right now
        Profile p = [select id from Profile where name = 'AkzoNobel HirePortal Regional Mgr EN'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'Demo Related');
        insert u;

        // create job that should be assigned to user u
        SFDC_Job__c job;
        system.runas(u) {
            job = new SFDC_Job__c(job_name__c = 'Test', job_status__c = 'test', Job_Title_for_Role__c = 'job title', Specific_Candidate_Preference__c = 'No');
            insert job;
        }  
        job = [select id, job_status__c, ownerid, store__c, store__r.name, recordtypeid from SFDC_Job__c where id = :job.id];
        system.debug('job created: '+job);
        // create Candidate with unique name
        SFDC_Candidate__c can = new SFDC_Candidate__c(first_name__c = 'Unique', last_name__c = 'Candidate');
        insert can;
        // link to job with default status
        SFDc_Job_Candidate__c jc = new SFDC_Job_Candidate__c(candidate__c = can.id, sfdc_job__c = job.id);
        insert jc;
        
        string CanName = '';
        string LocName = '';
        string StoreName = '';
        string BCURL = '';
        // Create a new email, envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'test';
        // test with no BCURL
        CanName = 'Unique Candidate';
        StoreName = 'testing portal';
        
        string ebody = '\n' + CANDIDATE_START_LABEL + CanName+ CANDIDATE_END_LABEL +
            CLIENT_START_LABEL + StoreName+ CLIENT_END_LABEL + URL_START_LABEL + BCURL + URL_END_LABEL;
        email.plaintextbody = ebody;
        // call email service
        BackCheckEmailHandler hand = new BackCheckEmailHandler();
        hand.handleInboundEmail(email, env);

        jc = [select id, status__c, background_check_results_url__c from SFDC_Job_Candidate__c where id = :jc.id];
        system.assertequals(jc.background_check_results_url__c, null);       

        // test Process 
        BCURL = 'www.salesforce.com';
        ebody = '\n' + CANDIDATE_START_LABEL + CanName+ CANDIDATE_END_LABEL +
            CLIENT_START_LABEL + StoreName+ CLIENT_END_LABEL + URL_START_LABEL + BCURL + URL_END_LABEL;
        email.plaintextbody = ebody;
        hand.handleInboundEmail(email, env);        
        jc = [select id, status__c, background_check_results_url__c from SFDC_Job_Candidate__c where id = :jc.id];
        system.assertequals(jc.background_check_results_url__c, 'www.salesforce.com');  
        // check for the task record
        system.assertequals(1, [select count() from TAsk where whatid = :jc.id]); 
        
        // test with french
        jc.background_check_results_url__c = null;
        update jc;
        ebody = '\n' + CANDIDATE_START_LABEL_FR + CanName+ CANDIDATE_END_LABEL_FR +
            CLIENT_START_LABEL_FR + StoreName+ CLIENT_END_LABEL_FR + URL_START_LABEL_FR + BCURL + URL_END_LABEL_FR;
        email.plaintextbody = ebody;
        hand.handleInboundEmail(email, env);        
        jc = [select id, status__c, background_check_results_url__c from SFDC_Job_Candidate__c where id = :jc.id];
        system.assertequals(jc.background_check_results_url__c, 'www.salesforce.com');  
    }
    }