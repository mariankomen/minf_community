/******************
Class: Job Description Edit Controller, extension for VF Job Description Edit
Description:  Dynamically show/hide the relevant job Title field based on the selected record type.  To leverage job field dependencies and record types we are using a 
    shell Job record and then moving selected details into the Job Description record upon save.
    
Created: Oct 15/13, Vankerk Solutions
Modification Log:

******************/
public class JobDescriptionEditController {

    // job record to use record type/job picklists
    public SFDC_Job__c job {get; set;}
    public Job_Description__c jobDesc {get; set;}
    // list of record type ids that use each job title field with boolean to indicate if the related job title field should be displayed
    //   If the client uses the Banner of Store and dependent Job Title field, add their job record type into this list.
    private set<string> JobBannerRecTypeIds = new set<string>{'012U00000009QqVIAU', '012U00000009QqaIAE', '012U00000009QqfIAE', '012U00000009QrYIAU', '012U00000009QrnIAE', '012U00000009Qs7IAE'};
    public boolean displayJobBanner {get; set;}
    // OFG is the only one in this list that uses the OWB Banner of Store field
    private set<string> JobTitleOFGRecTypeIds = new set<string>{'012U00000009QriIAE'};
    public boolean displayJobTitleOFG {get; set;}
    // any other client not mentioned above will default to use the Job Title (Please Select) picklist field - no updates to the code needed.
    public boolean displayJobTitle {get; set;}
    
    // constructor pulls in existing job desc details into relevant shell job fields for display and manages cloning if user has clicked Clone
    public JobDescriptionEditController(ApexPages.StandardController controller) {
        jobDesc = (Job_description__c) controller.getrecord();
        job = new SFDC_Job__c(recordtypeid = jobDesc.record_type_id__c );
        // check if we are cloning, in which case do that now
        if (ApexPages.currentpage().getparameters().get('clone') == '1') {
            jobDesc = jobDesc.clone();
            jobDesc.id = null;
        }
        // if we don't have a selected record type yet, set it to the Akzo Nobel so the update client will show relevant fields
        if (job.recordtypeid == null)
            job.recordtypeid = '012U00000009QqVIAU';
        updateClient();
        // now if we are editing existing, load the jobDesc title/banner value into the appropriate job fields
        if (displayJobBanner) {
            job.Job_Title_for_Banner__c = jobDesc.job_title__c;
            job.Banner_of_Store__c = jobDesc.banner_of_store__c;
        }
        else if (displayJobTitleOFG) {
            job.OWF_Job_Title__c = jobDesc.job_title__c;
            job.OWF_Banner_of_Store__c = jobDesc.banner_of_store__c;
        }
        else
            job.Job_Title_for_Role__c = jobDesc.job_title__c;        
    }
    
    // update Client will set booleans based on record id - called from constructor and save/new and onchange from picklist in VF page
    public pagereference updateClient(){
        if (job.recordtypeid != null) {
            if (JobBannerRecTypeIds.contains(job.recordtypeid))
                displayJobBanner = true;
            else displayJobBanner = false;
            if (JobTitleOFGRecTypeIds.contains(job.recordtypeid))
                displayJobTitleOFG = true;
            else displayJobTitleOFG = false; 
            // if nothing is being displayed then display regular job title
            if (!displayJobBanner && !displayJobTitleOFG)
                displayJobTitle = true;   
            else displayJobTitle = false;       
        }
        return null;
    }
    
    // save will pull in relevant job banner/title fields into job Desc fields and set name
    public PageReference save(){
        // need to find the record type name from the selected id
        if (job.recordtypeid != null) {
            Recordtype RT = [select id, name from recordtype where id = :job.recordtypeid];
            jobDesc.client__c = rt.name;
            jobDesc.record_type_id__c = job.recordtypeid;
        }
        // take the relevant job title value for this client
        if (displayJobBanner) {
            jobDesc.job_title__c = job.Job_Title_for_Banner__c;
            jobDesc.banner_of_store__c = job.Banner_of_Store__c;
        }
        else if (displayJobTitleOFG) {
            jobDesc.job_title__c = job.OWF_Job_Title__c;
            jobDesc.banner_of_store__c = job.OWF_Banner_of_Store__c;
        }
        else {
            jobDesc.job_title__c = job.Job_Title_for_Role__c;
            jobDesc.banner_of_store__c = null;
        }
        // set record name with client - banner - job title
        jobDesc.name = jobDesc.client__c  + ' - ' + (jobDesc.banner_of_store__c == null ? '' : jobDesc.banner_of_store__c + ' - ') + jobDesc.job_title__c;
        upsert jobDesc;   
        return new pagereference('/'+jobDesc.id); 
    }
    
    // save and new will clear out fields from current record
    //  issue: page can't rerender with RTF field on it so the description continues to show the previous record's description.
    public PageReference saveNew() {
        save();
        jobDesc = new job_description__c(name = null);
        job = new SFDC_Job__c();
        updateclient();
        return null;
    }
}