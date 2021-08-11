@istest
private class CaseListViewsTest{
@istest
 private static void testpg(){
        ApexPages.StandardSetController con = new ApexPages.StandardSetController([select id from Case limit 1]);
        CaseListViews ext = new CaseListViews(con);
     
        // create Store User to run through the else statement
        Account a = new Account(name = 'test portal');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MFG TalentReach HirePortal Store User EN' limit 1];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'Demo Related');
        system.runas(u) {
            ext = new CaseListViews(con);
        }
        // test with HR User
        p = [select id from Profile where name = 'MFG TalentReach HirePortal HR User EN' limit 1];
        Contact c2 = new Contact(accountid = a.id, lastname = 'test contact2', email='niki@vankerksolutions.com');
        insert c2;
        User u_hr = new User(contactid = c2.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample2@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, user_classification__c = 'HR User - Never Log In');        
        system.runas(u_hr) {
            ext = new CaseListViews(con);
        }                

    }
    }