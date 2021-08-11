/************
Class: Franchise HirePortal Job Order Wizard controller
Description:  This class holds logic to navigate between pages, create and default Job Order fields and Job fields from the portal users
    Client Profile, summarizes order and handles payment with Chargent objects.

Created: February 2015, Vankerk Solutions
Modification Log:
    Jan 2016 - remove shard utility methods into Util class to accommodate new Job Posting ONly type job page
    
*************/
public without sharing class FranchiseHirePortal_OrderWizard {

    // used to throw exceptions if required fields can't be defaulted or data issues occur
    public class MFGException extends Exception {}

    public FranchiseHirePortal_Utilities utility {set; get{
        if (utility == null)
            utility = new FranchiseHirePortal_Utilities();
        return utility;
        }}    
    
    // current logged in user, access fields from contact, account, parent account, grand parent
    public User currUser { set; get{
        return utility.currUser;
        }
    }
   
    // order record, create new order the first time user accesses the wizard (page action call) and use throughout navigation
    public Job_Order__c order {set; get;}
    
    // job record is created on page 2 of wizard through page action call
    public SFDC_Job__c job {set; get;}

    // method called by gotoPage2 methods for each job type to create order, then it creates open job
    public void createOrder() {
        // let exception be handled by main page so we can redirect to error page
        if (order == null) { 
            // check for a URL parameter for id in case we are hitting an existing Order
            string orderId = ApexPages.currentpage().getparameters().get('id');
            if (orderId == null) {
                order = new Job_Order__c(store__c = currUser.contact.accountid);
                // get job order currency from variable pulling from Client Profile
                order.Currency__c = utility.clientOrderCurrency;
                // get order T&C
                if ( (string) utility.getClientProfileFieldValue('Terms_and_Conditions__c') != null) {
                    order.Terms_Conditions_Text__c = (string) utility.getClientProfileFieldValue('Terms_and_Conditions__c') ;
                }
                // add tax % from store account field
                order.tax_percent__c = curruser.contact.account.CAD_Tax__c;
                insert order;
                orderId = order.id;
                ApexPages.currentpage().getparameters().put('id', orderId);
            }
            order = refreshOrder(orderId);
        }
    }

    // call from Pg 2 as action method - if no job is open, create CSS job type
    public PageReference validateCSSJob() {
        try {
            createorder();
            if (job == null) {
                openJob('CSS');
                // if we didn't find a record type or job cost there was an issue with Client Profile we can't proceed            
                if (job.recordtypeid == null || utility.clientJobCost_CSS == null)
                    throw new MFGException('Could not find Candidate Sourcing job defaults in Client Profile for '+currUser.contact.name+
                                       ' at store '+currUser.contact.account.name);
            }
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem in Validate CSS Job Entry Page: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
        return null;
    }    

    // call from Pg 2 as action method - if no job is open, create FCR job type
    public PageReference validateFCRJob() {
        try {
            createorder();
            if (job == null) {
                openJob('FCR');
                // if we didn't find a record type or job cost there was an issue with Client Profile we can't proceed            
                if (job.recordtypeid == null || utility.clientJobCost_FCR == null)
                    throw new MFGException('Could not find Full-Cycle Recruitment job defaults in Client Profile for '+currUser.contact.name+
                                       ' at store '+currUser.contact.account.name);
            }
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem in Validate FCR Job Entry Page: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');            
        }
        return null;
    }      
    // send in 'css' or 'fcr'
    private void openJob(string jobType) {
        job = new SFDC_Job__c();
        // sfdc_job__c job_defaults = (SFDC_Job__c) SFDC_Job__c.sObjectType.newSObject(recType, true);
        //   This newSObject call throws error in VF when we try to add errors, known issue: https://success.salesforce.com/issues_view?id=a1p30000000Sz5RAAS
        //   Without this method we can't easily default the Banner of Store if there is only 1 option
        // manually default Banner of Store until we release to other clients and figure out styling to prepopulate
        job.banner_of_store__c = '1-800-GOT-JUNK?';
        job.job_status__c = 'Pending Order';
        job.job_order__c = order.id;
        // set job record type, currency and cost for Candidate Sourcing and continue to new job page
        id recType;
        if (jobType.toUpperCase() == 'CSS') {    
            if ( (Id) utility.getClientProfileFieldValue('css_record_type_id__c') != null) {
                recType = (Id) utility.getClientProfileFieldValue('css_record_type_id__c') ;
            }  
            job.RecordTypeId = recType;
            job.mindfield_service__c = 'Candidate Sourcing';
            // job cost is based on the currency in the order pulled from Client Profile
            job.Job_Cost__c = utility.clientJobCost_CSS; 
            // css jobs should default Hours per Week to 40 hours or more as it is a hidden field and controls FT/PT options that are required
            job.Number_Of_Hours_Per_Week__c = '33 to 39 hours';       
        }
        else {
            if ( (Id) utility.getClientProfileFieldValue('fcr_record_type_id__c') != null) {
                recType = (Id) utility.getClientProfileFieldValue('fcr_record_type_id__c') ;
            } 
            job.RecordTypeId = recType;       
            job.mindfield_service__c = 'Full-Cycle Recruitment';
            // job cost is based on the currency in the order pulled from Client Profile
            job.Job_Cost__c = utility.clientJobCost_FCR;             
        }
    }
    
    // check order summary and payment - page action method to make sure we should be here, that we have an order and job created
    public PageReference validateSummaryPage() {
        try {    
            if (order == null) {
                // check for a URL parameter for id in case we are hitting an existing Order
                string orderId = ApexPages.currentpage().getparameters().get('id');
                if (orderId == null) {        
                    // send user to error page and then button to start over
                    return utility.goToErrorPg('Problem navigating to Order/Payment summary page without an order created.','HirePortal Franchise Job Wizard Error Report');
                }
                order = refreshOrder(orderId);
            }
            // if no jobs saved, go to error page
            if (order.jobs__r.size() == 0 || order.jobs__r[0].id == null)
                // send user to error page and then button to start over
                return utility.goToErrorPg('Problem navigating to Order/Payment summary page with an order but no job created.','HirePortal Franchise Job Wizard Error Report');
            // else set job to the first one
            job = order.jobs__r[0];
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem in Validate Summary Page: '+e.getStackTraceString()+': '+e, 'HirePortal Franchise Job Wizard Error Report');
        }        
        return null;
    }

    // navigation actions for page buttons
   
    // from Page 1 Candidate Sourcing details, this button action creates an order and 
    //   takes user to Page 2 for data entry
    public PageReference gotoOrderPg2_CanSourcing(){
        try {
            if (order == null)
                createOrder();
            
            PageReference nextPg = page.FranchiseHirePortal_OrderPg2_CanSource;
            nextPg.getparameters().put('id', order.id);
            return nextPg ;  
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem on Candidate Source Pg 1 with Buy Now button: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
    }

    // from Page 1 Full-Cycle Recruitment details, this button action creates an order and 
    //   takes user to Page 2 for data entry    
    public PageReference gotoOrderPg2_fullRecruit(){
        try {
            if (order == null)
                createOrder();
            
            PageReference nextPg = page.FranchiseHirePortal_OrderPg2_FullRecruit;
            nextPg.getparameters().put('id', order.id);
            return nextPg ;        
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem on Full-Cycle Recruitment Pg 1 with Buy Now button: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
    }

    private ChargentOrders__ChargentOrder__c chargent_order {get; set;}
    
    // method to pull back any related order and job fields needed in new job flow
    // also pull back details on the Chargent Order and related gateway/amount to make sure we only pull matching and active gateways
    // // TODO consider putting job fields in custom setting so we can add new fields over tiem without deploys, or not since we
    // would need to update VF pages as well to display these new fields?
    @testvisible
    private Job_Order__c refreshOrder(Id orderId) {
        Job_Order__c refreshedOrder = [select id, name, status__c, store__c, ownerid, owner.name, order_amount__c, tax_amount__c, order_total__c, job_title__c, 
                Terms_Conditions_Text__c, Terms_Conditions_Accepted__c, order_completed_Date__c, currency__c, currency_display__c, tax_percent__c,
                (select id, name, recordtype.name, Mindfield_Service__c, job_cost__c, Job_Title_for_Banner__c, banner_of_store__c, Job_Status__c, Job_is_for_Store_if_applicable__c,
                 Number_Of_Hours_Per_Week__c, FT_or_PT__c, Wage_Details__c, Hours_of_Availability__c, Hours_of_Availability_Comments__c, Job_Comments__c,
                 Reason_for_Opening__c, Reason_for_Position__c, benefits__c, interview_location__c, Interview_Availability__c, Interview_Scheduling__c, Profit_Sharing__c, 
                 Additional_Information__c, role_type__c, Name_of_Person_Submitting_Request__c from jobs__r),
                (select id, name, ChargentOrders__Gateway__c, ChargentOrders__Gateway__r.ChargentBase__Active__c, ChargentOrders__Balance_Due__c from Chargent_Orders__r order by id desc)
            from Job_Order__c where id = :orderId]; 
        if (refreshedOrder.Chargent_Orders__r.size() == 0)
            chargent_order = null;
        // if we have a chargent order but the gateway is inactive or totals don't match, clear variable so we create a new record
        else if ((refreshedOrder.Chargent_Orders__r[0].ChargentOrders__Gateway__c != null && refreshedOrder.Chargent_Orders__r[0].ChargentOrders__Gateway__r.ChargentBase__Active__c == false)  || 
                 refreshedOrder.Chargent_Orders__r[0].ChargentOrders__Balance_Due__c != refreshedOrder.order_total__c)
            chargent_order = null;
        else
            chargent_order = [select id, name, ChargentOrders__Gateway__c, ChargentOrders__Gateway__r.ChargentBase__Active__c, ChargentOrders__Balance_Due__c, 
                              (select id, ChargentOrders__Pay_Link__c from ChargentOrders__Payment_Requests__r) 
                              from ChargentOrders__ChargentOrder__c where id = :refreshedOrder.Chargent_Orders__r[0].id];
        return refreshedOrder;
    }
    
    // called from page 2 to proceed to summary - set final variables in job and save it, then pull in new order
    //   details for total amount and proceed to page 3
    public PageReference gotoOrderPg3_Summary(){
        try {
            // call save Job method to check for required fields
            if (!saveJob())
                return null;
            // job trigger runs for assignment
            // job trigger calls update to order with amount
            
            // Updating Order's Job Title field here since it makes sense only in the context of a single Job per Order
            //   Future Phase: Multiple jobs in an order will need to be accomodated some other way, maybe join all
            //   titles together which could be moved into the Job trigger where we are summing Order Cost.
            order.job_title__c = job.Job_Title_for_banner__c;
            order.status__c = 'Pending Payment';
            update order;
            
            order = refreshOrder(order.Id);
            
            PageReference nextPg = page.FranchiseHirePortal_OrderPg3_Summary;
            nextPg.getparameters().put('id', order.id);
            return nextPg ;
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem on a job order pg 2 with Order button saving job and updating order: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
    }
    
    // using apex input required = true is causing the UI to change in combination with bootstrap styling so we are looking for
    //   required fields for each job type here
    @testVisible
    private boolean saveJob() {
        try {
            boolean saveSuccess = true;
            // check for universally required fields
            if (job.Banner_of_Store__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Brand is a required field.'));
            }

            if (job.job_title_for_banner__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Job Title is a required field.'));
            }  
            if (job.Name_of_Person_Submitting_Request__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Supervisors Name is a required field.'));
            } 
            // if the user has access to Job is for Store, they need to fill it out
            Schema.DescribeFieldResult F = SFDC_Job__c.Job_is_for_Store_if_applicable__c.getDescribe();
            
            if (f.isAccessible() && job.Job_is_for_Store_if_applicable__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Job is for Location is a required field.'));
            }            
            if (job.Number_Of_Hours_Per_Week__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Hours Per Week is a required field.'));
            }  
            if (job.FT_or_PT__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Full Time / Part Time is a required field.'));
            }          
            if (job.wage_details__c == null) {
                saveSuccess = false;
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Wage Details is a required field.'));
            }
            // check for FCR only required fields
            if (job.Mindfield_Service__c == 'Full-Cycle Recruitment') {  
    
                if (job.Number_Of_Hours_Per_Week__c == null) {
                    saveSuccess = false;
                    apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Hours / Days needed from Candidates is a required field.'));
                }
                if (job.Profit_Sharing__c == null) {
                    saveSuccess = false;
                    apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Profit Sharing is a required field.'));
                }
                if (job.Benefits__c == null) {
                    saveSuccess = false;
                    apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Benefits is a required field.'));
                }
                if (job.Interview_Scheduling__c == null) {
                    saveSuccess = false;
                    apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 
                                                           'Interview Scheduling is a required field.'));
                }
            }
            if (saveSuccess) upsert job;
            return saveSuccess;
        } catch (Exception e) {
            // throw an exception back to the calling function since we can't redirect user to a new page from this method
            throw new MFGException('Problem checking required fields on job and saving: '+e.getStackTraceString()+': '+e);
        }
        return null;
    }

    // Purchase Now button on Order Summary page runs logic to update order, set up chargent objects and redirect to Purchase page
    public PageReference ConfirmPurchase() {
        try {
            // user must have checked the T&C box
            if (!order.Terms_Conditions_Accepted__c) {
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.FATAL, 'Please accept the Terms and Conditions for this order prior to Purchase'));
                return null;            
            }
            order.Terms_Conditions_Accepted_By__c = Userinfo.getUserId();
            order.Terms_Conditions_Accepted_On__c = datetime.now();
            update order;
            
            // if we have an order and payment request, use these records
            if (chargent_order == null) {
                // create chargent order record for processing
                chargent_order = new ChargentOrders__ChargentOrder__c();
                chargent_order.job_order__c = order.id;
                chargent_order.ChargentOrders__Account__c = currUser.contact.accountid;
                chargent_order.ChargentOrders__Date__c = datetime.now();
                chargent_order.ChargentOrders__Currency__c = order.Currency__c;
                chargent_order.ChargentOrders__Subtotal__c = order.Order_Amount__c;
                chargent_order.ChargentOrders__Tax__c = order.tax_amount__c;
                chargent_order.ChargentOrders__Status__c = 'Initiated';
                // don't pull in store billing address - we are hiding address since many contacts may use their personal credit cards -setting Stripe to ignore address validation
                insert chargent_order;
            }
            ChargentOrders__Payment_Request__c payment;
            if (chargent_order.ChargentOrders__Payment_Requests__r.size() == 0) {
                // create Purchase Request record to get secure code to pass into Chargent via req URL parameter
                payment = new ChargentOrders__Payment_Request__c();
                payment.ChargentOrders__ChargentOrder__c = chargent_order.id;
                insert payment;
                payment = [select id, ChargentOrders__Pay_Link__c from ChargentOrders__Payment_Request__c where id = :payment.id];
            }
            else
                payment = chargent_order.ChargentOrders__Payment_Requests__r[0];
            string req_param;
            // the req parameter is in the pay_link after the initial domain?req= to the end of the string
            if (payment.ChargentOrders__Pay_Link__c.contains('?req=')) {
                req_param = payment.ChargentOrders__Pay_Link__c.right(payment.ChargentOrders__Pay_Link__c.length() - payment.ChargentOrders__Pay_Link__c.indexof('?req=')-5);
                //system.debug('req param: '+req_param);
                // go to purchase page
                Pagereference pr = Page.FranchiseHirePortal_OrderPg4_Payment;
                pr.getParameters().put('req',req_param); 
                pr.getparameters().put('id', order.id);
                return pr; 
            }
            // if we didn't find the req parameter, send user to error page and then button to start over
            return utility.goToErrorPg('Problem on order summary page Pay Now button to find Payment Request req parameter: '+payment,'HirePortal Franchise Job Wizard Error Report');
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem on order summary page Pay Now button to save order, create chargent records and grab req parameter'+
                               ' for Payment Request component: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }       
    }
    
    // use from Order pg 2 before we created Job and want to cancel - delete Order and go home.
    public PageReference cancelDelete(){
        try {        
            
            // if we have an order and no related jobs, delete the order
            if (order != null && order.Chargent_Orders__r.size() == 0 && order.jobs__r.size() == 0 ) 
                delete order;
        } catch (Exception e) {
            // just send error message here and continue on to Home since there is no value in reporting an error to the end user, don't return page reference
            utility.goToErrorPg('Problem with deleting an order from pg 2 job entry screens from the Cancel button: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
        return utility.cancel();
    }

    // button on order summary page - if they want to delete the order and job
    public PageReference deleteOrderJobs() {
        try { 
            // if we have an order 
            if (order != null) {
                // if we don't have any Chargent orders then delete jobs and order
                if (order.Chargent_Orders__r.size() == 0) {
                    // if we have jobs, delete those first
                    if (order.jobs__r.size() > 0)
                        delete order.jobs__r;
                    delete order;
                }
                // else just update the Order to 'Customer Cancelled' and go home
                else {
                    order.Status__c = 'Customer Cancelled';
                    update order;
                }
            }
        } catch (Exception e) {
            // just send error message here and continue on to Home since there is no value in reporting an error to the end user
            utility.goToErrorPg('Problem with deleting an order from pg 3 order summary button Delete Order: '+e.getStackTraceString()+': '+e,'HirePortal Franchise Job Wizard Error Report');
        }
        return utility.cancel();
    }
    

}