@istest
public class FranchiseHirePortal_OrderWizard_Test {

    @testSetup
    static void setupUsers() {
        User uCan = TestDataFactory.setupPortalUserWith3Levels('Canada', 10, 'en_US');
        User uAuz = TestDataFactory.setupPortalUserWith3Levels('Australia', 10, 'en_US');
    }

    private static User CanadianUser {set; get{
        if (CanadianUser == null)
            CanadianUser = [select id, username from User where alias = 'Canada' limit 1];
        return CanadianUser;
    }}
    private static User AustralianUser {set; get{
        if (AustralianUser == null)
            AustralianUser = [select id, username from User where alias = 'Australi' limit 1];
        return AustralianUser;
    }}

    private static testmethod void testcurrUser(){
        system.runAs(CanadianUser) { 
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            system.assertequals(wiz.currUser.contact.account.billingcountry, 'Canada');
        }

        system.runAs(AustralianUser) {
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            system.assertequals(wiz.currUser.contact.account.billingcountry, 'Australia');
        }        
    }
    
    private static testmethod void testOrder() {
        FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
        User u = CanadianUser;
        // location has FCR details for rec type, cad/USD prices, no CSS
        client_profile__c cp = new client_profile__c(name = 'location', FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, 
                 CSS_Price_Per_Job_CAD__c = 20, CSS_Price_Per_Job_USD__c = 21, CSS_Price_Per_Job_AU__c = 22, terms_and_conditions__c = 'Here are the terms');
        insert cp;
        // attach to grand parent account
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser;            
        }
        u.contact.account.parent.parent.Client_Profile__c = cp.id;
        update u.contact.account.parent.parent;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            // call createorder with no URL param
            PageReference currPg = Apexpages.currentPage();
            wiz.createOrder();
            // should have created an order with tax, T&C, currency adn linked to store
            system.assertequals(wiz.order.tax_percent__c, u.contact.account.cad_tax__c, 'order tax set');
            system.assertequals(wiz.order.Terms_Conditions_Text__c , cp.terms_and_conditions__c, 'order T&C set');
            system.assertequals(wiz.order.currency__c , 'Canadian Dollar', 'order currency set');
            system.assertequals(wiz.order.store__c, u.contact.accountid, 'order store set');
            // should have order id in parm for currPg now
            system.assertequals(ApexPages.currentpage().getparameters().get('id'), wiz.order.id, 'order id in URL now');
            // call again and should not create a second order
            system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 1, 'only 1 job order before calling create order again');
            wiz.createOrder();
            system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 1, 'still 1 job order after calling create order again');

        }
    }

    private static testmethod void testgoToJobEntry() {
        FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
        User u = CanadianUser;
        RecordType rt_FCR = [select id from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_CSS = [select id from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
        // FCR and CSS, all details in single profile
        client_profile__c cp = new client_profile__c(name = 'location', FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c ='1800GotJunk-FCR',
                 CSS_Record_Type_Name__c ='1800GotJunk-CSS', CSS_Price_Per_Job_CAD__c = 20, CSS_Price_Per_Job_USD__c = 21, CSS_Price_Per_Job_AU__c = 22, terms_and_conditions__c = 'Here are the terms');
        insert cp;
        // attach to grand parent account
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser;            
        }
        u.contact.account.parent.parent.Client_Profile__c = cp.id;
        update u.contact.account.parent.parent;
        // start with no CSS Rec Type Id/Name for exception
        cp.CSS_Record_Type_Id__c = null;
        cp.CSS_Record_Type_Name__c = null;
        update cp;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_CanSourcing(); 
            // call page action method to try and create job
            result = wiz.validateCSSJob();
            // should have redirected to error page and emailed error to team
            system.debug(result.getURL());
            system.assertequals(result.getURL(), Page.FranchiseHirePortal_Error.getURL());
            // job rec type is blank
            system.assertequals(wiz.job.recordtypeid, null, 'record type is blank');
        }
        
        // put CSS Rec Type Id/Name back in
        cp.CSS_Record_Type_Name__c = '1800GotJunk-CSS';
        update cp;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_CanSourcing(); 
            // call page action method to try and create job
            wiz.validateCSSJob();
            // should have redirected to page 2
            system.debug(result.getURL());
            system.assert(result.getURL().contains(Page.FranchiseHirePortal_OrderPg2_CanSource.getURL()), 'pg 2 in URL');
            // job rec type is set
            system.assertnotequals(wiz.job.recordtypeid, null, 'record type is set');
            // order is populated
            system.assert(wiz.order != null);
            
            // test cancel delete where we don't save job and actually delete order
            system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 1);
            wiz.cancelDelete();
            system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 0);
            // clear any id params pointing to deleted order
            if (ApexPages.currentpage().getparameters().containskey('id'))
                ApexPages.currentpage().getparameters().remove('id');
            
            // start again with FCR
            wiz = new FranchiseHirePortal_OrderWizard ();
            result = wiz.gotoOrderPg2_fullRecruit(); 
            // call page action method to try and create job
            wiz.validateFCRJob();
            system.debug(result.getURL());
            system.assert(result.getURL().contains(Page.FranchiseHirePortal_OrderPg2_FullRecruit.getURL()), 'pg 2 in URL');
            system.assert(wiz.order != null);
            
            // test validate Summary page if job is not saved yet
            // clear order variable but add id into page URL
            ApexPages.currentpage().getparameters().put('id', wiz.order.id);
            wiz.order = null;
            PageReference results = wiz.validateSummaryPage();
            system.assertnotequals(results, null, 'sent user to Error page');
        }
    }
   
    private static testmethod void testOrderSummary() {
        FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
        // this user is REG User and doesnt' have access to Job is for store number field
        User u = CanadianUser;
        RecordType rt_FCR = [select id from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_CSS = [select id from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
        // FCR and CSS, all details in single profile
        client_profile__c cp = new client_profile__c(name = 'location', FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c ='1800GotJunk-FCR',
                 CSS_Record_Type_Name__c ='1800GotJunk-CSS', CSS_Price_Per_Job_CAD__c = 20, CSS_Price_Per_Job_USD__c = 21, CSS_Price_Per_Job_AU__c = 22, terms_and_conditions__c = 'Here are the terms');
        insert cp;
        // attach to grand parent account
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser;            
        }
        u.contact.account.parent.parent.Client_Profile__c = cp.id;
        update u.contact.account.parent.parent;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_CanSourcing(); 
            // call page action method to try and create job
            wiz.validateCSSJob();
            // try save with all fields empty
            //system.assert(wiz.saveJob());
            // fill in fields
            wiz.job.job_title_for_banner__c = 'Operations Manager';
            wiz.job.Name_of_Person_Submitting_Request__c = 'Ms Big';
            wiz.job.Number_Of_Hours_Per_Week__c = 'test';
            wiz.job.FT_or_PT__c = 'Full Time';
            wiz.job.wage_details__c = 'test wage details';
            result = wiz.gotoOrderPg3_Summary();
            //system.debug(result.getURL());
            //system.assert(result.getURL().contains(Page.FranchiseHirePortal_OrderPg3_Summary.getURL()), 'pg 3 in URL');
            // order set to Pending Payment
            //system.assertequals(wiz.order.status__c, 'Pending Payment');
            
            // test Delete OrderJobs - deletes job and order
            //system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 1);
            //system.assertequals([select count() from sfdc_job__c where ownerid = :u.id], 1);
            wiz.deleteOrderJobs();
            //system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 0);            
            //system.assertequals([select count() from sfdc_job__c where ownerid = :u.id], 0);
            // clear any id params pointing to deleted order
            if (ApexPages.currentpage().getparameters().containskey('id'))
                ApexPages.currentpage().getparameters().remove('id');
        }
        // do the same but for FCR
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_FullRecruit();
            // call page action method to try and create job
            wiz.validateFCRJob();
            // try save with all fields empty
            system.assert(!wiz.saveJob(), 'save job failed');
            // fill in fields
            wiz.job.job_title_for_banner__c = 'Operations Manager';
            wiz.job.Name_of_Person_Submitting_Request__c = 'Ms Big';
            wiz.job.Number_Of_Hours_Per_Week__c = 'test';
            wiz.job.FT_or_PT__c = 'Full Time';
            wiz.job.wage_details__c = 'test wage details';
            wiz.job.Number_Of_Hours_Per_Week__c = 'test';
            wiz.job.Profit_Sharing__c  = 'test';
            wiz.job.Benefits__c  = 'test';
            wiz.job.Interview_Scheduling__c = 'test';
            result = wiz.gotoOrderPg3_Summary();
            //system.debug(result.getURL());
            //system.assert(result.getURL().contains(Page.FranchiseHirePortal_OrderPg3_Summary.getURL()), 'pg 3 in URL');
            // order set to Pending Payment
            //system.assertequals(wiz.order.status__c, 'Pending Payment');
        }        
    }

    private static testmethod void testCSS_jobIsForStoreVisible() {
        FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
        // this user is REG User and doesnt' have access to Job is for store number field
        User u = CanadianUser;
        User currUser = [select id from User where id = :userinfo.getuserid()];
        system.runas(currUser) {
            Profile FPUser =  [select id from Profile where name = '1800GotJunk HirePortal FP User EN'];
            u.profileid = FPUser.id;
            update u;
        }
        
        RecordType rt_FCR = [select id from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_CSS = [select id from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
        // FCR and CSS, all details in single profile
        client_profile__c cp = new client_profile__c(name = 'location', FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c ='1800GotJunk-FCR',
                 CSS_Record_Type_Name__c ='1800GotJunk-CSS', CSS_Price_Per_Job_CAD__c = 20, CSS_Price_Per_Job_USD__c = 21, CSS_Price_Per_Job_AU__c = 22, terms_and_conditions__c = 'Here are the terms');
        insert cp;
        // attach to grand parent account
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser;            
        }
        u.contact.account.parent.parent.Client_Profile__c = cp.id;
        update u.contact.account.parent.parent;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_CanSourcing(); 
            // call page action method to try and create job
            wiz.validateCSSJob();
            // try save with all fields empty
            system.assert(!wiz.saveJob(), 'save job failed');
            // fill in fields
            wiz.job.job_title_for_banner__c = 'Operations Manager';
            wiz.job.Name_of_Person_Submitting_Request__c = 'Ms Big';
            wiz.job.Number_Of_Hours_Per_Week__c = 'test';
            wiz.job.FT_or_PT__c = 'Full Time';
            wiz.job.wage_details__c = 'test wage details';
            wiz.job.Job_is_for_Store_if_applicable__c = '123';
            system.assert(wiz.saveJob(), 'save job passed');
        }
    }

            
    private static testmethod void testOrderPayment() {
        FranchiseHirePortal_Utilities util = new FranchiseHirePortal_Utilities();
        User u = CanadianUser;
        RecordType rt_FCR = [select id from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
        RecordType rt_CSS = [select id from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
        // FCR and CSS, all details in single profile
        client_profile__c cp = new client_profile__c(name = 'location', FCR_Price_Per_Job_CAD__c = 10, FCR_Price_Per_Job_USD__c = 11, FCR_Price_Per_Job_AU__c = 12, FCR_Record_Type_Name__c ='1800GotJunk-FCR',
                 CSS_Record_Type_Name__c ='1800GotJunk-CSS', CSS_Price_Per_Job_CAD__c = 20, CSS_Price_Per_Job_USD__c = 21, CSS_Price_Per_Job_AU__c = 22, terms_and_conditions__c = 'Here are the terms');
        insert cp;
        // attach to grand parent account
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard ();
            u = wiz.currUser;            
        }
        u.contact.account.parent.parent.Client_Profile__c = cp.id;
        update u.contact.account.parent.parent;
        system.runas(u) {
            util = new FranchiseHirePortal_Utilities();
            FranchiseHirePortal_OrderWizard wiz = new FranchiseHirePortal_OrderWizard();
            u = wiz.currUser; 
            PageReference result = wiz.gotoOrderPg2_CanSourcing(); 
            // call page action method to try and create job
            wiz.validateCSSJob();
            // fill in fields
            wiz.job.job_title_for_banner__c = 'Operations Manager';
            wiz.job.Name_of_Person_Submitting_Request__c = 'Ms Big';
            wiz.job.Number_Of_Hours_Per_Week__c = 'test';
            wiz.job.FT_or_PT__c = 'Full Time';
            wiz.job.wage_details__c = 'test wage details';
            result = wiz.gotoOrderPg3_Summary();
            // $20 plus 10% tax
            //system.assertequals(wiz.order.order_amount__c, 20);
            //system.assertequals(wiz.order.order_total__c, 22);
            // go to confirm without T&C
            result = wiz.ConfirmPurchase();
            //system.assertequals(result, null, 'came back null with missing field');
            wiz.order.terms_conditions_accepted__c = true;
            result = wiz.ConfirmPurchase();
            // redirected to payment pages
            system.debug(result.getURL());
            //system.assert(result.getURL().contains(Page.FranchiseHirePortal_OrderPg4_Payment.getURL()), 'pg 4 payment in URL');
            // chargent order record
            ChargentOrders__ChargentOrder__c co = [select id, ChargentOrders__total__c from ChargentOrders__ChargentOrder__c where job_order__c = :wiz.order.id];
            //system.assertequals(co.ChargentOrders__total__c, 22);
            // chargent payment record
            //system.assertequals([select count() from ChargentOrders__Payment_Request__c  where ChargentOrders__ChargentOrder__c = :co.id], 1);
            
            // start over at summary to test delete job now that there are chargent records
            ApexPages.currentpage().getparameters().put('id', wiz.order.id);
            wiz = new FranchiseHirePortal_OrderWizard();
            wiz.validateSummaryPage();
            //system.assertequals(wiz.order.jobs__r.size(), 1, '1 job attached'); 
            //system.assertequals(wiz.order.Chargent_Orders__r.size(), 1, '1 chargent order attached');
            
            // now test that deleteOrderJobs doesn't delete order, just changes status since there are chargent orders
            //system.assertequals([select count() from job_order__c where store__c = :u.contact.accountid], 1);
            wiz.deleteOrderJobs();
            job_order__c jo = [select id, status__c from job_order__c where store__c = :u.contact.accountid];
            //system.assertequals(jo.status__c, 'Customer Cancelled');            
            //system.assertequals([select count() from sfdc_job__c where ownerid = :u.id], 1);
            //system.assertequals([select count() from ChargentOrders__ChargentOrder__c where ChargentOrders__Account__c  = :u.contact.accountid], 1);            
        }
    }
    
}