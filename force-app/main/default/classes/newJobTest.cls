// TEST METHOD //
    @istest
    private class newJobTest{
    @istest
    private static void testpg() {
        // create Test records: account, contact, portal user
        Account a = new Account(name = 'test portal', banner_of_store__c = 'test', owf_banner_of_store__c = 'test');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        // find a profile that is in the banned list above
        Map<String, BannedProfileList__c> bannedmap = BannedProfileList__c.getall();
        // make sure our profile is in the list
        boolean found = false;
        for (BannedProfileList__c p : bannedmap.values()) {
            if (p.profile_name__c == 'MFG Test HirePortal Profile') {
                found = true;
                break;
            }
        }
        if (!found) {
            BannedProfileList__c p = new BannedProfileList__c(name = 'test', profile_name__c = 'MFG Test HirePortal Profile', error_message__c = 'test');
            insert p;
            bannedmap = BannedProfileList__c.getall();
        }        
       
        Profile p1 = [select id from Profile where name = 'MFG Test HirePortal Profile'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p1.id, user_classification__c = 'HR User - Standard');
        insert u;

        // create admin user for the additional user update
        Profile pa = [select id from Profile where name = 'System Administrator'];
        User admin = new User(firstname='test', lastname = 'admin', email='niki@vankerksolutions.com',
            username = 'sampleadmin@mfg.com', alias='testadmi', communitynickname='testadmin', 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pa.id , user_classification__c = 'Demo Related');
                    
        // test hitting th newJob page as the portal user - should return null since banned profile in use
        system.runas(u) {
            PageReference testpg = new PageReference('/a0P/e?retURL=myTESTRetURL');
            Test.setCurrentPage(testpg);
            
            ApexPages.StandardController con = new ApexPages.StandardController(new SFDC_Job__c());
            newJob ext = new newJob(con);
            // did we get the retURL parameter:
            system.assertequals('myTESTRetURL', ext.retURL);
            // now call the action function to see where we are redirected
            // this user is in the banned list so should return null
            string results = 'start';
            try { 
                results = ext.newJobLink().getURL();
                results = 'fail';
            } catch (Exception e) { results = 'pass'; }
            system.assertequals('pass', results);
        }
        
        // now delete this profile from the banned list and try again
        for (BannedProfileList__c p : bannedmap.values()) {
            if (p.profile_name__c == 'MFG Test HirePortal Profile') {
                delete p;
                break;
            }
        }        

        // test hitting the newJob page as the portal user - both banner fields should be included in the URL returned
        system.runas(u) {
            PageReference testpg = new PageReference('/a0P/e?retURL=myTESTRetURL');
            Test.setCurrentPage(testpg);
            
            ApexPages.StandardController con = new ApexPages.StandardController(new SFDC_Job__c());
            newJob ext = new newJob(con);        
            
            string results = ext.newJobLink().getURL();
            // both banner fields should be in the page parameters
            system.assert(results.contains('00NU0000003AuUx=test'));
            system.assert(results.contains('00NU0000003AuV2=test'));
            system.assert(results.contains('retURL=myTESTRetURL'));
        }
    }
    }