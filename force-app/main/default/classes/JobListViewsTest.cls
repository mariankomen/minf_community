@istest
private class JobListViewsTest{
@isTest
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
            
        ApexPages.StandardSetController con = new ApexPages.StandardSetController([select id from SFDC_Job__c limit 1]);
        JobListViews ext = new JobListViews(con);
        
        // start with 'AkzoNobel HirePortal Regional Mgr EN'
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='test@mfg.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = profilemap.get('AkzoNobel HirePortal Regional Mgr EN').id, user_classification__c = 'Demo Related');
        system.runas(ua) { insert u; }
        system.runas(u) {
            ext = new JobListViews(con);
            PageReference pg = ext.pageredirect();
            system.assertequals(pg, null, 'returned null for portal user');
        }
        // test custom setting was populated
        //JobListView__c mc = JobListView__c.getInstance(u.id);
        //system.assertNOTequals(mc, null, 'found custom setting: '+ mc);
        //system.assertNOTequals(mc.listid__c, null, 'found a list id: '+mc);
        
        // test with LPO profile
        //u.profileid = profileMap.get('OFG HirePortal Store User EN - LPO Specific').id;
        //system.runas(ua) { update u; }
        //system.runas(u) {
        //    ext = new JobListViews(con);
        //}

        //AkzoNobel HirePortal Regional Mgr EN
        //u.profileid = profileMap.get('AkzoNobel HirePortal Regional Mgr EN').id;
        //system.runas(ua) { update u; }
        //system.runas(u) {
        //    ext = new JobListViews(con);
        //}
        
        // AkzoNobel HirePortal Store User EN
        u.profileid = profileMap.get('AkzoNobel HirePortal Store User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }     
        
        
        // PPG HirePortal Store User EN
        u.profileid = profileMap.get('PPG USA Hireportal Store User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }     
        
        // Mr. Lube Franchise HirePortal Store User EN
        u.profileid = profileMap.get('Mr. Lube Franchise HirePortal Store User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }    
        
        // Country Grocer Hireportal Store User EN
        //u.profileid = profileMap.get('Country Grocer Hireportal Store User EN').id;
        //system.runas(ua) { update u; }
        //system.runas(u) {
        //    ext = new JobListViews(con);
        //}     
        
        // Tim Hortons hireportal Store User (NSM) EN
        u.profileid = profileMap.get('Tim Hortons hireportal Store User (NSM) EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }   
        
        // Wendys hireportal Store User (NSM) EN
        u.profileid = profileMap.get('Wendys hireportal Store User (NSM) EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }   
        
        // Ecoservice Group hireportal Store User (NSM) EN
        u.profileid = profileMap.get('Eco Group hireportal Store User (NSM) EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }   
        
        // Canadian Tire hireportal Store User EN - NSM
        u.profileid = profileMap.get('Canadian Tire hireportal Store User EN - NSM').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
        }  
        
                
           
        // MindField Internal HirePortal Store User EN
        u.profileid = profileMap.get('MindField Internal HirePortal Store User EN').id;
        system.runas(ua) { update u; }
        system.runas(u) {
            ext = new JobListViews(con);
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
            ext = new JobListViews(con);
        } 
        
        /* 1800GotJunk HirePortal HR User EN
        u_hr.profileid = profileMap.get('1800GotJunk HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        } 
        
        // easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN
        u_hr.profileid = profileMap.get('easyfinancial and easyhome Head HirePortal HR (EH Focus) User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        }  
        
        // easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN
        u_hr.profileid = profileMap.get('easyfinancial and easyhome Head HirePortal HR (EF Focus) User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        }*/
        
        // FGL Sports HirePortal HR User EN
        u_hr.profileid = profileMap.get('FGL Sports HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        }         
        
        // test with Akzo User
        u_hr.profileid = profileMap.get('AkzoNobel HirePortal HR User EN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        }  
          
        // PPG USA Hireportal HR UserEN
        u_hr.profileid = profileMap.get('PPG USA Hireportal HR UserEN').id;
        system.runas(ua) { update u_hr; }
        system.runas(u_hr) {
            ext = new JobListViews(con);
        }       
          
        /* TEST Selecting lists
        system.runas(u_hr) {
            ext = new JobListViews(con);
            //ext.pageredirect();
            //JobListView__c testSetting = JobListView__c.getInstance(u_hr.id);
            //system.assertNOTequals(testSetting.listid__c, '00BU0000002HkgE', 'list id not the one we are using to test: '+mc);
            //ext.selectedList = '00BU0000002HkgE';
            //ext.selectList();
            //testSetting = JobListView__c.getInstance(u_hr.id);
            //system.assertequals(testSetting.listid__c, '00BU0000002HkgE', 'Now list id matches'+mc);
        } */                 
    }
    }