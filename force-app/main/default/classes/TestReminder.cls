@istest
    private class TestReminder{
        @istest
    static void TestReminder(){
        // create Job owned by new portal user
        // create 2 reminders, one Complete and one not, linked to Job
        // run class and test OpenReminders num
        Account ap = new Account(name = 'test');
        insert ap;
        Contact cp = new Contact(lastname = 'test', accountid = ap.id);
        insert cp;
        Profile p = [select id from profile where name = 'MFG Test HirePortal Profile' limit 1]; 
        User cPUser = new User(alias = 'standt', email='standarduser@testorg.com', 
             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
             localesidkey='en_US', profileid = p.Id, contactid = cp.id, User_Classification__c = 'HR User - Standard',
             timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com', managerid= userinfo.getuserid());
                
        insert cPUser;         
        
        System.runAs(cPUser){
            SFDC_Job__c j = new SFDC_Job__c(job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No', Name_of_Person_Submitting_Request__c = 'test');
            insert j;
            MFG_Reminder__c r1 = new MFG_Reminder__c(Status__c = 'New', SFDC_Job__c = j.id , Name= 'open test');
            insert r1;
            MFG_Reminder__c r2 = new MFG_Reminder__c(Status__c = 'Complete', SFDC_Job__c = j.id , Name= 'closed test');
            insert r2;
            r2 = [select id, status__c from mfg_reminder__c where id = :r2.id];
            system.debug('closed reminder after insert: '+r2);
            ReminderComponent pg = new ReminderComponent();
            /* check variables with 2 reminders linked */
            system.assertequals(pg.OpenReminders, 1);
            // add Reminder to list of selected reminders and try to close them
            pg.OpenList.get(0).selected = true;
            string result = pg.CloseReminders().getUrl();
            // that should have marked r1 as Complete
            r1 = [select id, status__c from MFG_Reminder__c where id = :r1.id];
            system.assertequals(r1.status__c, 'Complete');
        }
        } 
        }