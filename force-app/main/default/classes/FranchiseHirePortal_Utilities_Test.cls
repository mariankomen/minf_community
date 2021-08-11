@isTest
private class FranchiseHirePortal_Utilities_Test {
    @testSetup
    static void setupUsers() {
        User uCan = TestDataFactory.setupPortalUserWith3Levels('Canada', 10, 'fr');
        User uAuz = TestDataFactory.setupPortalUserWith3Levels('Australia', 10, 'en_US');
        RecordType rt_FCR = [select id, name from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_CSS = [select id, name from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_PO = [select id, name from recordtype where name = '1800GotJunk-PO' and sobjecttype = 'SFDC_Job__c']; 
        // create client profiles to use with each account
        list<client_profile__c> cps = new list<client_profile__c>();
        // create profiles for each level with all values, can be adjusted in certain tests as needed
        client_profile__c can_location = new client_profile__c(name = 'Canada location', 
        	FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 13, CSS_Price_Per_Job_USD__c = 14, CSS_Price_Per_Job_AU__c = 15, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO');
		cps.add(can_location);
        client_profile__c can_parent = new client_profile__c(name = 'Canada parent/store', 
            FCR_Price_Per_Job_CAD__c = 100, FCR_Price_Per_Job_USD__c = 110, FCR_Price_Per_Job_AU__c = 120, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 130, CSS_Price_Per_Job_USD__c = 140, CSS_Price_Per_Job_AU__c = 150, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO',
            terms_and_conditions__c = 'Here are the terms for parent');
		cps.add(can_parent);
        client_profile__c can_grand = new client_profile__c(name = 'corporate', 
            FCR_Price_Per_Job_CAD__c = 1000, FCR_Price_Per_Job_USD__c = 1100, FCR_Price_Per_Job_AU__c = 1200, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 1300, CSS_Price_Per_Job_USD__c = 1400, CSS_Price_Per_Job_AU__c = 1500, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO',
            terms_and_conditions__c = 'Here are the terms for grand parent');
        cps.add(can_grand);
        client_profile__c aus_location = new client_profile__c(name = 'Australia location', 
            FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 13, CSS_Price_Per_Job_USD__c = 14, CSS_Price_Per_Job_AU__c = 15, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO');
        cps.add(aus_location);
        client_profile__c aus_parent = new client_profile__c(name = 'Australia parent/store', 
            FCR_Price_Per_Job_CAD__c = 100, FCR_Price_Per_Job_USD__c = 110, FCR_Price_Per_Job_AU__c = 120, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 130, CSS_Price_Per_Job_USD__c = 140, CSS_Price_Per_Job_AU__c = 150, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO',
            terms_and_conditions__c = 'Here are the terms for parent');
        cps.add(aus_parent);
        client_profile__c aus_grand = new client_profile__c(name = 'Australia corporate', 
            FCR_Price_Per_Job_CAD__c = 1000, FCR_Price_Per_Job_USD__c = 1100, FCR_Price_Per_Job_AU__c = 1200, FCR_Record_Type_Name__c = '1800GotJunk-CSS', 
            CSS_Price_Per_Job_CAD__c = 1300, CSS_Price_Per_Job_USD__c = 1400, CSS_Price_Per_Job_AU__c = 1500, CSS_Record_Type_Name__c ='1800GotJunk-CSS',
            PO_Record_Type_Name__c = '1800GotJunk-PO',
            terms_and_conditions__c = 'Here are the terms for grand parent');
        cps.add(aus_grand);
        insert cps; 
        // link user accounts to each client profile
        list<account> accUpdates = new list<Account>();
        uCan.contact.account.client_profile__c = can_location.id;
        accUpdates.add(uCan.contact.account);
        uCan.contact.account.parent.client_profile__c = can_parent.id;
        accUpdates.add(uCan.contact.account.parent);
        uCan.contact.account.parent.parent.client_profile__c = can_grand.id;
        accUpdates.add(uCan.contact.account.parent.parent);
        // auz accounts
        uAuz.contact.account.client_profile__c = aus_location.id;
        accUpdates.add(uAuz.contact.account);
        uAuz.contact.account.parent.client_profile__c = aus_parent.id;
        accUpdates.add(uAuz.contact.account.parent);
        uAuz.contact.account.parent.parent.client_profile__c = aus_grand.id;
        accUpdates.add(uAuz.contact.account.parent.parent);
        update accUpdates;
    }

    private static User CanadianUser {set; get{
        if (CanadianUser == null)
            CanadianUser = [select id, username, contact.account.id, contact.account.parent.id, contact.account.parent.parent.id from User where alias = 'Canada' limit 1];
        return CanadianUser;
    }}
    private static User AustralianUser {set; get{
        if (AustralianUser == null)
            AustralianUser = [select id, username, contact.account.id, contact.account.parent.id, contact.account.parent.parent.id from User where alias = 'Australi' limit 1];
        return AustralianUser;
    }}

    // test currUser, client currency/display getters which are based on account's billing country
    private static testmethod void testcurrUser(){
        system.runAs(CanadianUser) { 
        	FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
        	system.assertequals(util.currUser.contact.account.billingcountry, 'Canada');
            system.assertequals(util.clientOrderCurrency, 'Canadian Dollar');
            system.assertequals(util.clientOrderCurrencyDisplay , 'CAD');
        }

        system.runAs(AustralianUser) {
        	FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
        	system.assertequals(util.currUser.contact.account.billingcountry, 'Australia');
            system.assertequals(util.clientOrderCurrency, 'US Dollar');
            system.assertequals(util.clientOrderCurrencyDisplay , 'USD');
        }        
    }

    // test clientProfile Map and list getters, pulling all client profiles from account, parent and grandparent
    // test with all 3 levels populated
    private static testmethod void testCProfileMap_all(){
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            set<id> CPIds = new set<Id>{util.currUser.contact.account.client_profile__c, 
                                        util.currUser.contact.account.parent.client_profile__c,
                                        util.currUser.contact.account.parent.parent.client_profile__c};
            system.assertEquals(CPIds.size(), 3, '3 profiles linked to account, parent and grandparent');
            system.assertEquals(util.clientProfileMap.size(), 3, 'map has all levels: '+util.clientProfileMap);
            system.assert(util.clientProfileMap.keyset().containsall(cpids), 'all CPids in map');
            system.assertEquals(util.clientProfileList.size(), 3, 'list has all levels: '+util.clientProfileList);
        }
    }

    // test clientProfile Map and list getters, pulling all client profiles from account, parent and grandparent
    // test with only grandparent levels populated
    private static testmethod void testCProfileMap_grandparentonly(){
        list<Account> clearAccProfiles = new list<Account>();
        AustralianUser.contact.account.client_profile__c = null;
        clearAccProfiles.add(AustralianUser.contact.account);
        AustralianUser.contact.account.parent.client_profile__c = null;
        clearAccProfiles.add(AustralianUser.contact.account.parent);
        update clearAccProfiles;
        system.runAs(AustralianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            system.assertEquals(util.clientProfileMap.size(), 1, 'map has grandparent levels: '+util.clientProfileMap);
            system.assertEquals(util.clientProfileMap.values()[0].name,'Australia corporate', 'Aus corporate in map');
            system.assertEquals(util.clientProfileList.size(), 1, 'list has grandparent levels: '+util.clientProfileList);
            system.assertEquals(util.clientProfileList[0].get('name'),'Australia corporate', 'Aus corporate in map');
        }
    }

    // test get client profile field value - if field only has value at middle parent level
    private static testmethod void testgetCPFIeld_parent(){
        list<client_profile__c> CdnProfiles = new List<client_profile__c>();
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            CdnProfiles = util.clientProfileList;
        }
        // update account and grand parent profiles for no value in FCR_Price_Per_Job_CAD__c
        CdnProfiles[0].FCR_Price_Per_Job_CAD__c = null;
        CdnProfiles[1].FCR_Price_Per_Job_CAD__c = 55;
        CdnProfiles[2].FCR_Price_Per_Job_CAD__c = null;
        update CdnProfiles;
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            object FCRPrice = util.getClientProfileFieldValue('FCR_Price_Per_Job_CAD__c');
            system.assertEquals((decimal) FCRPrice, 55, 'FCR price from parent profeil: '+CdnProfiles[1]);
        }
    }    

    // test get client profile field value - if field has value at first and parent level
    private static testmethod void testgetCPFIeld_account(){
        list<client_profile__c> CdnProfiles = new List<client_profile__c>();
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            CdnProfiles = util.clientProfileList;
        }
        // update grand parent profiles for no value in CSS_Price_Per_Job_CAD__c
        CdnProfiles[0].CSS_Price_Per_Job_CAD__c = 44;
        CdnProfiles[1].CSS_Price_Per_Job_CAD__c = 55;
        CdnProfiles[2].CSS_Price_Per_Job_CAD__c = null;
        update CdnProfiles;
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            object CSSPrice = util.getClientProfileFieldValue('CSS_Price_Per_Job_CAD__c');
            system.assertEquals((decimal) CSSPrice, 44, 'FCR price from account profeil: '+CdnProfiles[0]);
        }
    } 

    // test get client profile field value - if field has value at all levels
    private static testmethod void testgetCPFIeld_alllevels(){
        list<client_profile__c> CdnProfiles = new List<client_profile__c>();
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            CdnProfiles = util.clientProfileList;
        }
        // update value in CSS_Price_Per_Job_USD__c
        CdnProfiles[0].CSS_Price_Per_Job_USD__c = 44;
        CdnProfiles[1].CSS_Price_Per_Job_USD__c = 55;
        CdnProfiles[2].CSS_Price_Per_Job_USD__c = 66;
        update CdnProfiles;
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities ();
            object CSSPrice = util.getClientProfileFieldValue('CSS_Price_Per_Job_USD__c');
            system.assertEquals((decimal) CSSPrice, 44, 'FCR price from account profeil: '+CdnProfiles[0]);
        }
    }

    // testJobCostCSS/FCR - Canadian pulls CAD price 
   private static testmethod void testJobCosts_CAD(){
        client_profile__c CdnProfile = [select name, FCR_Price_Per_Job_CAD__c, FCR_Price_Per_Job_USD__c, FCR_Price_Per_Job_AU__c, CSS_Price_Per_Job_CAD__c, 
            CSS_Price_Per_Job_USD__c, CSS_Price_Per_Job_AU__c from client_profile__c where name = 'Canada location' limit 1];
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities (); 
            system.assertEquals(util.clientJobCost_CSS, CdnProfile.CSS_Price_Per_Job_CAD__c, 'CSS price match: '+CdnProfile);
            system.assertEquals(util.clientJobCost_FCR, CdnProfile.FCR_Price_Per_Job_CAD__c, 'FCR price match: '+CdnProfile);
        }
    }

    // testJobCostCSS/FCR - Austrailan pulls AUS price 
   private static testmethod void testJobCosts_AUS(){
        client_profile__c AusProfile = [select name, FCR_Price_Per_Job_CAD__c, FCR_Price_Per_Job_USD__c, FCR_Price_Per_Job_AU__c, CSS_Price_Per_Job_CAD__c, 
            CSS_Price_Per_Job_USD__c, CSS_Price_Per_Job_AU__c from client_profile__c where name = 'Australia location' limit 1];
        system.runAs(AustralianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities (); 
            system.assertEquals(util.clientJobCost_CSS, AusProfile.CSS_Price_Per_Job_AU__c, 'CSS price match: '+AusProfile);
            system.assertEquals(util.clientJobCost_FCR, AusProfile.FCR_Price_Per_Job_AU__c, 'FCR price match: '+AusProfile);
        }
    }           

    // testJobCostCSS/FCR - United States pulls USD price 
    private static testmethod void testJobCosts_USD(){
        User uUSA = TestDataFactory.setupPortalUserWith3Levels('United States', 0, 'en_US');
        // link account to can_account profile for values
        client_profile__c USDProfile = [select name, FCR_Price_Per_Job_CAD__c, FCR_Price_Per_Job_USD__c, FCR_Price_Per_Job_AU__c, CSS_Price_Per_Job_CAD__c, 
            CSS_Price_Per_Job_USD__c, CSS_Price_Per_Job_AU__c from client_profile__c where name = 'Canada location' limit 1];
        uUsa.contact.account.client_profile__c = USDProfile.id;
        update uUsa.contact.account;
        system.runAs(uUSA) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities (); 
            system.assertEquals(util.clientJobCost_CSS, USDProfile.CSS_Price_Per_Job_USD__c, 'CSS price match: '+USDProfile);
            system.assertEquals(util.clientJobCost_FCR, USDProfile.FCR_Price_Per_Job_USD__c, 'FCR price match: '+USDProfile);
        }
    }

    // test error page running as Cdn User, should send email and return to  Page.FranchiseHirePortal_Error
    private static testmethod void testgoToErrorPg(){
        system.runAs(CanadianUser) { 
            integer emailSends = limits.getEmailInvocations();
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
            string redirectPg = util.goToErrorPg('my message', 'my subject').getURL();
            system.assert(redirectPg.containsIgnoreCase('FranchiseHirePortal_Error'), 'redirected to error: '+redirectPg);
            system.assertequals(emailSends+1, limits.getEmailInvocations(), 'sent email: '+limits.getEmailInvocations());
        }
    }

    // test cancel with retURL parameter set
    private static testmethod void testcancel_retURL(){
        system.runAs(CanadianUser) { 
            apexpages.currentpage().getparameters().put('retURL', '/www.salesforce.com');
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
            string redirectPg = util.cancel().getURL();
            system.assert(redirectPg.containsIgnoreCase('www.salesforce.com'), 'redirected to retURL: '+redirectPg);
        }
    } 

    // test cancel with retURL parameter set
    private static testmethod void testcancel_home(){
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
            string redirectPg = util.cancel().getURL();
            system.assert(redirectPg.containsIgnoreCase('home/home.jsp'), 'redirected to home: '+redirectPg);
        }
    }

    // test subscription request page running as Cdn User, should send email and return to  Page.FranchiseHirePortal_ThankYou_SubRequest
    private static testmethod void testsubscription(){
        system.runAs(CanadianUser) { 
            integer emailSends = limits.getEmailInvocations();
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
            string redirectPg = util.subscriptionRequest().getURL();
            system.assert(redirectPg.containsIgnoreCase('FranchiseHirePortal_ThankYou_SubRequest'), 'redirected to thank you: '+redirectPg);
            system.assert(redirectPg.containsIgnoreCase('requestType=Subscription'), 'page has parameter set: '+redirectPg);
            system.assertequals(emailSends+2, limits.getEmailInvocations(), 'sent email: '+limits.getEmailInvocations());
        }
    }    
    
    private static testmethod void testFCREmail(){
        system.runAs(CanadianUser) { 
            integer emailSends = limits.getEmailInvocations();
            FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
            string redirectPg = util.FCRRequest().getURL();
            system.assert(redirectPg.containsIgnoreCase('FranchiseHirePortal_ThankYou_SubRequest'), 'redirected to thank you: '+redirectPg);
            system.assert(redirectPg.containsIgnoreCase('requestType=Full-Cycle+Recruitment'), 'page has parameter set: '+redirectPg);
            system.assertequals(emailSends+2, limits.getEmailInvocations(), 'sent email: '+limits.getEmailInvocations());
        }
    }     
}