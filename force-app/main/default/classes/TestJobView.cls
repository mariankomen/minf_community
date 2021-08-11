// TEST Methods //
@istest
Private class TestJobView{
    @istest
    private static void testPg(){
        // create test Job and find active Approval Process
        // create a portal user 
        Account a = new Account(name = 'test portal', store_number__c = '1500');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        Id CurrUserId = userinfo.getuserid();
        
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, User_Classification__c = 'HR User - Standard', job_approver_1__c = CurrUserId , job_approver_2__c = CurrUserId , job_approver_3__c = CurrUserId ,
            hr_user_approver__c =CurrUserId );
        insert u;
        RecordType rt = [select id from recordtype where name = 'AkzoNobel' and sobjecttype = 'SFDC_Job__c'];
        
        // use start/stop test since the approval processing for Akzo is async
        test.starttest();       
        // now create a job that needs approval submission
        SFDC_Job__c j1 = new SFDC_Job__c(job_name__c = 'Test1', ownerid = u.id, job_status__c = 'test', Job_Title_for_Role__c = 'job title', Specific_Candidate_Preference__c = 'No',
                recordtypeid = rt.id, job_comments__c = 'First set of comments', auto_submit_job_for_approvals__c = true);
        insert j1;
        test.stoptest();
        // check for approval steps:
        SFDC_Job__c j = [Select Id,Name, (Select TargetObjectId, SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, Actor.name, ActorId,
                    OriginalActorId, OriginalActor.name, IsPending, IsDeleted, Id, CreatedDate, CreatedById, Comments From ProcessSteps order by SystemModstamp desc) 
                    from SFDC_Job__c where Id = :j1.id];
        system.debug('approval details for job: '+j.processsteps);  
        // now set up JobView page
        PageReference pageRef = Page.JobView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', string.valueof(j1.id)); 
        ApexPages.currentPage().getParameters().put('retURL', '\\apex\\JobListViews'); 
        ApexPages.StandardController con = new ApexPages.StandardController(j1);
        JobView ext = new JobView(con);
        system.assertequals(j.processsteps.size(), ext.approvalSteps.size());
        // breadcrumb on
        system.assertequals(ext.showBreadcrumb, true, 'breadcrumb on: '+ApexPages.currentPage().getParameters().get('retURL'));
        // increase test coverage if we weren't able to force a job into an approval process
        //approval app = new approval(new ProcessInstanceHistory());
    
        }     
    }