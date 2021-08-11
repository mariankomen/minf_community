/************
Class: Franchise HirePortal Posting Only Job creation controller
Description:  This class holds logic to create Jobs through the Posting Only page from the portal users, referring to their
    Client Profile and saves job without interaction with Chargent/job orders.

Created: November 2015, Vankerk Solutions
Modification Log:

*************/
public without sharing class FranchiseHirePortal_PostingOnlyJob {

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
    
    public SFDC_Job__c job {set; get;}

    public PageReference openJob() {
        try  {        
            job = new SFDC_Job__c();
            // sfdc_job__c job_defaults = (SFDC_Job__c) SFDC_Job__c.sObjectType.newSObject(recType, true);
            //   This newSObject call throws error in VF when we try to add errors, known issue: https://success.salesforce.com/issues_view?id=a1p30000000Sz5RAAS
            //   Without this method we can't easily default the Banner of Store or MF Service if there is only 1 option
            // manually default Banner of Store until we release to other clients and figure out styling to prepopulate

            // set job record type and other defaults before displaying job
            if ( (Id) utility.getClientProfileFieldValue('po_record_type_id__c') != null) {
                job.RecordTypeId = (Id) utility.getClientProfileFieldValue('po_record_type_id__c');
            }  
            else 
                return utility.goToErrorPg('The Client Profile for this job does not have a PO Record Type Id set\n\nClient Profile: '+utility.clientProfileList, 
                'HirePortal Franchise Posting Only Job Creation Error Report');

            job.mindfield_service__c = 'Posting Only';
            job.banner_of_store__c = '1-800-GOT-JUNK?';        
            // css jobs should default Hours per Week to XXXX as it is a hidden field and controls FT/PT options that are required
            job.Number_Of_Hours_Per_Week__c = '33 to 39 hours';         
            return null;
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem open a new Posting Only job: '+e.getStackTraceString()+': '+e, 
                'HirePortal Franchise Posting Only Job Creation Error Report');

        }        
    }

    // using apex input required = true is causing the UI to change in combination with bootstrap styling so we are looking for
    //   required fields for each job type here
    public PageReference saveJob() {
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
            if (!saveSuccess) 
                return null;
            
            upsert job;
            // take user to thank you page
            PageReference nextPg = page.FranchiseHirePortal_ThankYou_JobCreation;
            nextPg.getParameters().put('id', job.id);
            nextPg.setredirect(true);
            return nextPg;
        } catch (Exception e) {
            // send user to error page and then button to start over
            return utility.goToErrorPg('Problem checking required fields on job and saving: '+e.getStackTraceString()+': '+e, 
                'HirePortal Franchise Posting Only Job Creation Error Report');
        }
        return null;
    }    
   
 
}