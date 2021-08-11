/**************
Class: newJob, extension for newJob VF page
Description: contains an action method called by the page to redirect the user.
    1. first check a list of Banned Profile Names and if current user is in the same profile we stay at the page to view the error message
    2. We check the currentuser - if they are portal and the related Account has either Banner of Store or Banner of Store (OFG) values set, 
        add those to the redirected page URL as parameters for the appropriate fields.  Add the original URL's retURL paramter and return
        the new page reference for redirection
        
        NOTE: to add new customer profiles into the logic to stop them from adding new Jobs directly, 
          Add their profile ID, Name and specific Error message into the custom setting for Banned jobs.
          
        
Created: July 14/11, Vankerk Solutions
Modification Log:
    Sept 14/11: added custom setting for the list of bannedProfileNames so Jeff can add new profiles in Production without code changes required.
    Nov 11/11: added saveURL parameter for new jobs created by portal users
    June 9/13: added support for error message on banned Profile setting
    Oct 4/13: added support to set saveURL to Job Preview page for some clients
    
**************/
public class newJob {

    public SFDC_Job__C j {get; set;}    // holds the Job coming into the page - to grab the record type if selected
    public string retURL {get; set;}    // holds the incoming page's retURL parameter to add to our redirection
    public string errorMsg {get; set;}    // holds the error message based on teh banned profile list
    
    // constructor to grab the job and retURL paramters
    public newJob(ApexPages.StandardController controller) {
        j = (SFDC_Job__c) controller.getRecord();
        // grab the retURL
        retURL = ApexPages.currentpage().getparameters().get('retURL');
    }

    // action method called by page - return null if not allowed to create new jobs or the standard Job layout with assorted parameters
    public PageReference newJobLink() {
        try {
            // if determine if the user should not be allowed to continue, return null
            // use a custom setting with the exact Profile name so it can be easily added to in the future without having to redeploy
            Map<string, BannedProfileList__c> bannedProfileNames = new Map<string, BannedProfileList__c>();
            for (BannedProfileList__c p : BannedProfileList__c.getall().values()) {
                bannedProfileNames.put(p.Profile_Name__c.touppercase(), p);
            }
            
            // find Profile for this user
            Profile p = [select id, name from Profile where id = :UserInfo.getProfileid()];
            // if this users profile is part of the banned list, stay at the newJob page for an error msg
            if (bannedProfileNames.containskey(p.Name.touppercase())) {
                errorMsg = bannedProfileNames.get(p.name.touppercase()).error_message__c;
                return null;
            }
            
            // set record type if not selected and user only has access to one
            if (j.RecordTypeId == null) {
                // cycle through available record types and grab default
                Schema.DescribeSObjectResult d = SFDC_Job__c.SObjectType.getDescribe();
                for (Schema.RecordTypeInfo rt : d.getRecordTypeInfos()) {
                    if (rt.isavailable() && rt.isDefaultRecordTypeMapping()) {
                        j.RecordTypeId = rt.getRecordTypeId();
                        break;
                    }
                } // end loop through RT
            } // end if rec type is null
            
            // not banned so send user to the standard new Job page(s)
            pageReference jobPg = new PageReference('/a0P/e?nooverride=true&RecordType='+(j.RecordTypeId == null ? '' : j.RecordTypeId));
            // get current user's portal Account banner defaults, if populated
            User currU = [select id, contactid, contact.account.banner_of_store__c, contact.account.owf_banner_of_store__c from User where id = :UserInfo.getUserid()];
            // if this is a portal user, set defaults for Banner of Store fields
            if (currU.contactid != null) {
                // Banner of Store field ID: 00NU0000003AuUx
                // Banner of Store OFG field ID: 00NU0000003AuV2
                jobPg.getparameters().put('00NU0000003AuUx', currU.contact.account.banner_of_store__c);
                jobPg.getparameters().put('00NU0000003AuV2', currU.contact.account.owf_banner_of_store__c);
            }
            // add the original retURL in
            jobPg.getparameters().put('retURL', retURL);
            // If this is a portal user, send them to the Preview or Confirmation page when the Job is saved
            if (UserInfo.getUserType() != 'Standard') {
                // send all portal jobs to preview as page will redirect them to confirmation if no need to preview  
                jobPg.getparameters().put('saveURL', '/apex/JobPreview');
            } // end if portal user
            return jobPg;
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.Message(apexpages.severity.fatal, 'Unfortunately there was a system error in processing your new Job request. If you continue to encounter errors, ' +
                'please call the MindField Group Help Desk at 866-511-9554 and press extension 4 and report the following to your Administrator: '+e.getstacktracestring()+': '+e));
            return null;
        }    
    }
    
  
}