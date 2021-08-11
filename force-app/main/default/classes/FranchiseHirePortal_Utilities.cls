/************
Class: Franchise HirePortal Utilities
Description:  This class holds basic logic for Hire portal features for paid/posting only jobs
    Used by Order Wizard and Posting Only Job as well as home page components to find Job Costs

Created: November 2015, Vankerk Solutions
Modification Log:

*************/
public without sharing class FranchiseHirePortal_Utilities {
    
        // current logged in user, access fields from contact, account, parent account, grand parent
    public User currUser { set; get{
        if(currUser == null) 
            currUser = [select id, firstname, lastname, username, contact.name, 
                        contact.accountid, contact.account.name, contact.account.client_profile__c, contact.account.cad_tax__c,
                        contact.account.parentid, contact.account.parent.name, contact.account.parent.client_profile__c, 
                        contact.account.parent.parentid, contact.account.parent.parent.name, contact.account.parent.parent.client_profile__c,
                        // address for payment component and billingcountry for currency/price
                        contact.account.billingstreet, contact.account.billingcity, contact.account.billingstate, contact.account.billingpostalcode, contact.account.billingcountry,
                        languagelocalekey, profile.name 
                        from user where id = :Userinfo.getuserid()];
            
        return currUser;
        }
    }

    // client profile map client Profiles for each account level from portal user account, to parent to parent's parent
    //   when accessing any field, 
    public Map<Id, Client_Profile__c> clientProfileMap {set; get {
        if (clientProfileMap == null) {
            // query the currUser's account, parent and grandparent to pull in relevant profiles for each level
            clientProfileMap = new Map<Id, Client_Profile__c>(
                [select id, name, FCR_Price_Per_Job_CAD__c, FCR_Price_Per_Job_USD__c, FCR_Price_Per_Job_AU__c, FCR_Record_Type_Name__c, FCR_Record_Type_Id__c,
                 CSS_Price_Per_Job_CAD__c, CSS_Price_Per_Job_USD__c, CSS_Price_Per_Job_AU__c, CSS_Record_Type_Name__c, CSS_Record_Type_ID__c,Terms_and_Conditions__c,
                 po_record_type_name__c, po_record_type_id__c
                 from Client_Profile__c where id = :currUser.contact.account.client_profile__c or id = :currUser.contact.account.parent.client_profile__c
                 or id = :curruser.contact.account.parent.parent.client_profile__c]);
        }
        return clientProfileMap;
    }}

    
    // ordered list of client profiles starting from lowest level to highest - should have at least 1 entry but may have up to 3
    // When we look for fields values, we always start at the lowest (user's account) and work up to grand parent until we find a value
    public List<sobject> clientProfileList {set; get {
        if (clientProfileList == null) {
            clientProfileList = new List<Client_Profile__c>();
            // try to add first level profile to list
            if (clientProfileMap.containskey(currUser.contact.account.client_profile__c))
                clientProfileList.add(clientProfileMap.get(currUser.contact.account.client_profile__c));
            if (clientProfileMap.containskey(currUser.contact.account.parent.client_profile__c))
                clientProfileList.add(clientProfileMap.get(currUser.contact.account.parent.client_profile__c));
            if (clientProfileMap.containskey(currUser.contact.account.parent.parent.client_profile__c))
                clientProfileList.add(clientProfileMap.get(currUser.contact.account.parent.parent.client_profile__c));
            //system.debug('client profile list: '+clientProfileList);
        }
        return clientProfileList;
    }}

    // input: string with API field name of a Client Profile field you wish to find a value of
    // Function will go through each Client Profile, starting with one linked to the contact's account if there is one and going up
    //    to grandparent account until we find the first non-null value of the specified field
    // Output: field value if found or null if none found in any related client profile.
    public object getClientProfileFieldValue(string fldName) {
        object fldValue;
        // cycle through the client Profile list in order until we have a non null field value
        for (integer i=0;clientProfileList.size()>i;i++) {
            fldValue = clientProfileList[i].get(fldName);
            if (fldValue != null) return fldValue;
        }
        return fldValue;
    }

    // pull order currency from logged in users client profile / account billing country
    //   values must match set Currency values from Chargent Order object
    //   need this before a job order has been opened to display pricing on the Intro pages 1
    public string clientOrderCurrency {set; get{
        if (clientOrderCurrency == null) {
            // currency is based on Billing Country of the portal users account
            if (currUser.contact.account.billingCountry == 'Canada')
                clientOrderCurrency = 'Canadian Dollar';
            else
                clientOrderCurrency = 'US Dollar';
        }
        return clientOrderCurrency;
    }}

    // want the abbreviation based on long form currency value - long form is required by Chargent so we pull
    // the formula field on Client Profile with display format
    public string clientOrderCurrencyDisplay {set; get{
        if (clientOrderCurrencyDisplay == null) {
            if (clientOrderCurrency == 'Canadian Dollar') 
                clientOrderCurrencyDisplay = 'CAD';
            else
                clientOrderCurrencyDisplay = 'USD';
        }
        return clientOrderCurrencyDisplay;
    }}



    // pull cost for CSS job based on the order currency from Client Profile
    public decimal clientJobCost_CSS {set; get{
        if (clientJobCost_CSS == null) {
            // job cost is based on the currency in the order and account billing country if US
            if (clientOrderCurrency == 'Canadian Dollar') {
                if ((decimal) getClientProfileFieldValue('CSS_Price_Per_Job_CAD__c') != null)
                    clientJobCost_CSS = (decimal) getClientProfileFieldValue('CSS_Price_Per_Job_CAD__c'); 
            } 
            // if not CAD then if Australia use AU price
            else if (currUser.contact.account.billingcountry == 'Australia') {
                if ((decimal) getClientProfileFieldValue('CSS_Price_Per_Job_AU__c') != null)
                    clientJobCost_CSS = (decimal) getClientProfileFieldValue('CSS_Price_Per_Job_AU__c'); 
            } 
            // otherwise default to US price
            else {
                if ((decimal) getClientProfileFieldValue('CSS_Price_Per_Job_USD__c') != null)
                    clientJobCost_CSS = (decimal) getClientProfileFieldValue('CSS_Price_Per_Job_USD__c');
            }
        }
        return clientJobCost_CSS;
    }}
    
    // pull cost for FCR job based on the order currency from Client Profile
    public decimal clientJobCost_FCR {set; get{
        if (clientJobCost_FCR == null) {
            // job cost is based on the currency in the order and account billing country if US
            if (clientOrderCurrency == 'Canadian Dollar') {
                if ((decimal) getClientProfileFieldValue('FCR_Price_Per_Job_CAD__c') != null)
                    clientJobCost_FCR = (decimal) getClientProfileFieldValue('FCR_Price_Per_Job_CAD__c'); 
            } 
            // if not CAD then if Australia use AU price
            else if (currUser.contact.account.billingcountry == 'Australia') {
                if ((decimal) getClientProfileFieldValue('FCR_Price_Per_Job_AU__c') != null)
                    clientJobCost_FCR = (decimal) getClientProfileFieldValue('FCR_Price_Per_Job_AU__c'); 
            } 
            // otherwise default to US price
            else {
                if ((decimal) getClientProfileFieldValue('FCR_Price_Per_Job_USD__c') != null)
                    clientJobCost_FCR = (decimal) getClientProfileFieldValue('FCR_Price_Per_Job_USD__c'); 
            }
        }
        return clientJobCost_FCR;
    }} 

    public PageReference goToErrorPg(string errorMsg, string subject) {
        // send email message to admins with error message
        sendErrorEmail(errorMsg, subject);
        // redirect user to generic error page
        PageReference ErrorPg = Page.FranchiseHirePortal_Error;
        ErrorPg.setRedirect(true);
        return ErrorPg;        
    }

    @testVisible
    private void sendErrorEmail(string errorMsg, string subject) { 
        // method to handle emailing error messages
        try  {
            // build single email to send to MFG Admin with error details
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'mfgsysadmin@mindfieldgroup.com', 'niki@vankerksolutions.com'}; 
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Mindfield Helpdesk');
            // Specify the subject line for your email address.  
            mail.setSubject(subject);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody(errorMsg+'\n\nUser: '+currUser.username+', '+currUser.contact.name+', '+curruser.contact.account.name+'\n\nPage URL: '+apexpages.currentPage().getURL());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {} // nothing to do if the error email won't go out        
    }   

    public PageReference cancel() {
        // take user to retURL or home
        string retURL = '/home/home.jsp';
        if (apexpages.currentPage().getparameters().get('retURL') != null)
            retURL = apexpages.currentPage().getparameters().get('retURL');
        return new PageReference(retURL);
    }
    

    public PageReference subscriptionRequest() {
        try {
            // pull in email template for Subscription Request
            EmailTemplate eTemplate = [select id from EmailTemplate where DeveloperName='HD_Subscription_Job_Request_from_Portal_HTML'];
            // call email method passing in template Id
            sendTalkToUsEmail(eTemplate.id);
            // redirect user to request thank you page
            PageReference ThankYouPg = Page.FranchiseHirePortal_ThankYou_SubRequest;
            ThankYouPg.getParameters().put('requestType', 'Subscription');
            ThankYouPg.setRedirect(true);
            return ThankYouPg;        
        } catch (Exception e) {
            return goToErrorPg('There was a problem sending the Subscription Request email to sales@mindfieldgroup.com so no notification was sent\nError details: '+e,
                    'HirePortal Franchise Subscription Request Error Report');
        }
    }
    
    public PageReference FCRRequest() {
        try {
            // pull in email template for Full Cycle Recruitment Request
            EmailTemplate eTemplate = [select id from EmailTemplate where DeveloperName='HD_FCR_Job_Request_from_Portal_HTML'];
            // call email method passing in template ID
            sendTalkToUsEmail(eTemplate.id);
            // redirect user to request thank you page
            PageReference ThankYouPg = Page.FranchiseHirePortal_ThankYou_SubRequest;
            ThankYouPg.getParameters().put('requestType', 'Full-Cycle Recruitment');
            ThankYouPg.setRedirect(true);
            return ThankYouPg;        
        } catch (Exception e) {
            return goToErrorPg('There was a problem sending the Full-Cycle Recruitment Request email to sales@mindfieldgroup.com so no notification was sent\nError details: '+e,
                    'HirePortal Franchise Full-Cycle Recruitment Request Error Report');
        }
    }
    

    // send templated email to sales@mindfieldgroup.com
    //   To keep access to contact details but not send to the Contact, use a trick from Appirio blog
    //   Set Target Object Id, send and then rollback email, then copy contents into new email without Contact
    //   http://appirio.com/category/tech-blog/2014/11/sending-emails-without-targetobject-id-apex/    
    private void sendTalkToUsEmail(Id templateId) {
        // method to handle emailing error messages
        // build single email to send to sales with details of client request
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'sales@mindfieldgroup.com'}; 
            mail.setToAddresses(toAddresses);
        // email template for this request
        mail.setTemplateId( templateId );
        mail.setWhatId(curruser.contact.accountid);
        mail.setTargetObjectId(curruser.contactid); 
        // can't store tasks owned by Portal Contact, this email is triggered by the portal user
        mail.setSaveAsActivity(false);           
        mail.setBccSender(false); 
        mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        msgList.add(mail);
        // Send the emails in a transaction, then roll it back
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(msgList); // Dummy email send
        Database.rollback(sp); // Email will not send as it is rolled Back
        // Send Actual email
        List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
        for (Messaging.SingleEmailMessage email : msgList) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setOrgWideEmailAddressId([select id from OrgWideEmailAddress where address = 'sales@mindfieldgroup.com'].id);
            emailToSend.setToAddresses(toAddresses);
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject());
            msgListToBeSend.add(emailToSend);
        }
        Messaging.sendEmail(msgListToBeSend);           
    }
}