/******************
Class: Job Point Edit Controller, extension for VF Job Point Edit
Description:  Dynamically show/hide the relevant job Title field based on the selected record type.  To leverage job field dependencies and record types we are using a 
    shell Job record and then moving selected details into the Job Point record upon save.
    
Created: Apr 15/14, Vankerk Solutions
Modification Log:

******************/
public class JobPointNewEditController {

    // job record to use record type/job picklists
    public SFDC_Job__c job {get; set;}
    public Job_Point__c jobPt {get; set;}
    // OFG is the only client that uses the OWF Banner of Store field
    private set<string> JobTitleOFGRecTypeIds = new set<string>{'012U00000009QriIAE'};
    public boolean displayJobTitleOFG {get; set;}
    
    // constructor pulls in existing job desc details into relevant shell job fields for display and manages cloning if user has clicked Clone
    public JobPointNewEditController(ApexPages.StandardController controller) {
        try{
            jobPt = (Job_point__c) controller.getrecord();
            job = new SFDC_Job__c(recordtypeid = jobPt.record_type_id__c );
            // check if we are cloning, in which case do that now
            if (ApexPages.currentpage().getparameters().get('clone') == '1') {
                jobPt = jobPt.clone();
                jobPt.id = null;
            }
            updateClient();
            // now if we are editing existing, load the jobPt title/banner value into the appropriate job fields
            if (jobPt.job_title__c != null) {
                if (displayJobTitleOFG) {
                    job.OWF_Job_Title__c = jobPt.job_title__c;
                    job.OWF_Banner_of_Store__c = jobPt.banner_of_store__c;
                }
                else if (jobPt.banner_of_store__c != null) {
                    job.Job_Title_for_Banner__c = jobPt.job_title__c;
                    job.Banner_of_Store__c = jobPt.banner_of_store__c;
                    // also default this field so we don't have to fill it in each time
                    job.Job_Title_for_Role__c = 'Other';
                }
                else
                    job.Job_Title_for_Role__c = jobPt.job_title__c; 
            } // end if we are loading existing job       
        } catch(Exception e) {
            Apexpages.addmessage(new apexpages.message(apexpages.severity.fatal, 'Problem loading page: '+e.getstacktracestring()+': '+e));
        }
    }
    
    // update Client will set booleans based on record id - called from constructor and save/new and onchange from picklist in VF page
    public pagereference updateClient(){
        displayJobTitleOFG = false;
        if (job.recordtypeid != null && JobTitleOFGRecTypeIds.contains(job.recordtypeid)) 
            displayJobTitleOFG = true;
        //system.debug('selected record type is: '+job.recordtypeid);   
       
        return null;
    }
    
    // save will pull in relevant job banner/title fields into job Desc fields and set name
    public PageReference save(){
        try{    
            // need to find the record type name from the selected id
            if (job.recordtypeid != null) {
                Recordtype RT = [select id, name from recordtype where id = :job.recordtypeid];
                jobPt.client__c = rt.name;
                jobPt.record_type_id__c = job.recordtypeid;
            }
            // take the relevant job title value for this client
            if (displayJobTitleOFG) {
                jobPt.job_title__c = job.OWF_Job_Title__c;
                jobPt.banner_of_store__c = job.OWF_Banner_of_Store__c;
            }
            // if job title for banner is blank we aren't dealing with a job banner so push job title to job title for role
            //    and null out banner
            else if (job.Job_Title_for_Banner__c == null) {
                jobPt.job_title__c = job.Job_Title_for_Role__c;
                jobPt.banner_of_store__c = null;
            }        
            // if we aren't OFG and we have a job title for banner, push job title and banner into record        
            else {
                jobPt.job_title__c = job.Job_Title_for_Banner__c;
                jobPt.banner_of_store__c = job.Banner_of_Store__c;
            }
            upsert jobPt;   
            system.debug('upserted point: '+jobpt);
            return new pagereference('/'+jobPt.id);
        } catch(Exception e) {
            Apexpages.addmessage(new apexpages.message(apexpages.severity.fatal, 'Problem loading page: '+e.getstacktracestring()+': '+e));
            return null;
        }         
    }
    
    // save and new will clear out fields from current record, but keep selected client
    public PageReference saveNew() {
        save();
        jobPt = new job_point__c(name = null);
        Id recId = job.recordtypeid;
        job = new SFDC_Job__c(recordtypeid = recId);
        return null;
    }

}