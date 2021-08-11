@istest
private class CandidateListViewTest{
@istest
private static void testpg(){
        // login as admin to create/update users
        User ua = [select id, username from user where id = :Userinfo.getuserid()];      
        // create portal user to run through the if/else statement
        Account a = new Account(name = 'test portal');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'High Volume User', email='test@mfg.com');
        insert c;
        Map<string, Profile> profileMap = new Map<string, Profile>();
        for (profile p : [select id, name from Profile where usertype != 'Standard'])
            profileMap.put(p.name, p);   
        
        ApexPages.StandardSetController con = new ApexPages.StandardSetController([select id from SFDC_Job_Candidate__c limit 1]);
        CandidateListViews ext = new CandidateListViews(con);
        
        // start with 'OFG HirePortal Store User EN'
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='test@mfg.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = profilemap.get('OFG HirePortal Store User EN').id, user_classification__c = 'Demo Related');
        system.runas(ua) { insert u; }
        system.runas(u) {
            ext = new CandidateListViews(con);
            PageReference pg = ext.pageredirect();
            system.assertequals(pg, null, 'returned null for portal user');
        }
        // test custom setting was populated
        CandidateListView__c mc = CandidateListView__c.getInstance(u.id);
        system.assertNOTequals(mc, null, 'found custom setting: '+ mc);
        system.assertNOTequals(mc.candidate_listid__c, null, 'found a list id: '+mc);

        // test with LPO profile
        u.profileid = profileMap.get('OFG HirePortal Store User EN - LPO Specific').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new CandidateListViews(con);
        }

        // 1800GotJunk HirePortal REG User
         u.profileid = profileMap.get('1800GotJunk HirePortal REG User').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new CandidateListViews(con);
        }

        // Proline Trucking Hireportal Store User User EN
        u.profileid = profileMap.get('Proline Trucking Hireportal Store User User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new CandidateListViews(con);
        }        
                           
        // MFG TalentDrive HirePortal Regional User EN
        u.profileid = profileMap.get('MFG TalentDrive HirePortal Regional User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new CandidateListViews(con);
        }
        
        // test with HR Users - Customer Portal Manager Custom license types
        Contact c2 = new Contact(accountid = a.id, lastname = 'Customer Portal Manager Custom', email='test@mfg.com');
        insert c2;
        // OFG HirePortal HR User EN
        User u_hr = new User(contactid = c2.id, firstname='test', lastname = 'portal user', email='test@mfg.com',
            username = 'sample2@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = profileMap.get('OFG HirePortal HR User EN').id, user_classification__c = 'HR User - Never Log In');        
        system.runas(ua) { insert u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        } 
        
        // test with Akzo User
        u_hr.profileid = profileMap.get('AkzoNobel HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        } 
        
        //  easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN  
        u_hr.profileid = profileMap.get('easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        } 
        
        //  easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN
        u_hr.profileid = profileMap.get('easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        } 
        
        // easyhome HirePortal HR User EN
        u_hr.profileid = profileMap.get('easyhome HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        } 
        // 1800GotJunk HirePortal HR User EN
        u_hr.profileid = profileMap.get('1800GotJunk HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }         
        // easyfinancial HirePortal HR User EN
        u_hr.profileid = profileMap.get('easyfinancial HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }  

        // Proline Trucking Hireportal HR User EN
        u_hr.profileid = profileMap.get('Proline Trucking Hireportal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }  
        
        // MFG TalentReach HirePortal HR User EN
        u_hr.profileid = profileMap.get('MFG TalentReach HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }          

        // FGL Sports HirePortal HR User EN
        u_hr.profileid = profileMap.get('FGL Sports HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }  
            
        // p.name.startswith('COBS')
        Profile testCOBSProfile;
        for (string profileName : profileMap.keyset())
            if (profilename.startswith('COBS')) {
                testCOBSProfile = profileMap.get(profilename);
                break;
            }
        u_hr.profileid = testCOBSProfile.id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
        }       
        
        // TEST Selecting lists
        system.runas(u_hr) {
            ext = new CandidateListViews(con);
            ext.pageredirect();
            CandidateListView__c testSetting = CandidateListView__c.getInstance(u_hr.id);
            system.assertNOTequals(testSetting.candidate_listid__c, '00BU0000002Ijvl', 'list id not the one we are using to test: '+mc);
            ext.selectedList = '00BU0000002Ijvl';
            ext.selectList();
            testSetting = CandidateListView__c.getInstance(u_hr.id);
            system.assertequals(testSetting.candidate_listid__c, '00BU0000002Ijvl', 'Now list id matches'+mc);
        }  
    }
    }