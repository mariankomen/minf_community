/*********************
CLass: Job Preview, extension to VF page
Description: VF page is showing preview details regarding a new job that was just created.  Use action method to determine
	 if we should stay here on preview (there is a default Job Desc to review) or go on to Confirmation page
    
Created: Nov 10/13, Vankerk Solutions
Modification Log:

*********************/
public class JobPreview_Controller{

    public SFDC_Job__c job {get; set;}
    public boolean showDesc {get; set;}
    public boolean showCandReqt {get; set;}
    
    public JobPreview_Controller() {
        job = new SFDC_Job__c();
        // see if we have a newid parameter on the page
        if (ApexPages.currentPage().getParameters().get('newid') != null) 
            try { 
                // note to properly 'clone' if we want to modify the job we need to pull in all accessible job field
                //  values in this query.
                job = [select id, name, recordtypeid, Job_role_title__c, candidate_requirements__c,
                         Job_Description__c, Job_Preview_Pending__c, Job_Description_original__c
                         from SFDC_Job__c where id = :ApexPages.currentPage().getParameters().get('newid')]; 
            }
            catch (Exception e) { }
        // if there is no parameter we will refer to the new, empty job created above
		showDesc = false;
        showCandReqt = false;
    }
    
    // page action method to deteremine if we stay on Preview page or redirect to Confirmation
    public PageReference PreviewRedirect(){
    	// if job is still pending preview, check job desc and job/role title fields
        if (job.Job_Preview_Pending__c) {
            // if job desc was filled in set boolean to show
            if (job.Job_Description__c != null)
                showDesc = true;
            // if job/role title text field filled in, set boolean to show
            if (job.Job_Role_Title__c != null)
                showCandReqt = true;
            // if both are false for some reason, go on to Confirmation since there is nothing to preview
            if (!showDesc && !showCandReqt)
                return confirm();
            else
            	return null;
        }
        // other wise redirect to job Confirmation for this new job
        return jumptoConfirmation();
    }
    
    public PageReference confirm(){
        job.job_Preview_pending__c = false;
        update job;
        // now go to confirmation page
        return jumptoConfirmation();
    }
    
    public PageReference jumptoConfirmation(){
        pageReference JobConf = Page.JobConfirmation;
        jobConf.getparameters().put('newid', job.id);
        jobConf.setRedirect(true);
        return jobConf;        
    }
    
    public PageReference deleteJob(){
        delete job;
        // now go to jobs tab?
        pageReference JobConf = page.joblistviews;
        return jobConf;
    }
    
    public PageReference modifyJob(){
     	// here we want to build a clone link with nulled out fields, then give the user time to view the new job before
        //    we delete the original job that was not confirmed.

        // build clone URL for this job nulling out fields to clear
        PageReference modPage = new PageReference('/'+job.id+'/e?clone=1&00NU0000003Auge=Open/Active Job&saveURL=/apex/jobPreview&retURL=/apex/JobListViews');
        // now add other fields to be nulled out stored in Custom Setting
        for (CloneJobFields__c f : CloneJobFields__c.getall().values())
            modPage.getParameters().put(f.name, (f.field_value__c == null ? '' : f.field_value__c)); 
        modPage.setRedirect(true);
        // call async method to delete this job but skip if running a test as we can't run callouts from test code
        if (!test.isrunningtest())
        	deloriginalJob(job.id);
        return modPage;
    }
    @future(callout=true)
        public static void deloriginalJob(Id JobId){
         	// wait for a few seconds for the user's clone page to render
            sleep(1);
            SFDC_Job__c j = new SFDC_Job__c(id = JobId);
            delete j;
        }
    
    public static void sleep(Integer sleepSeconds) {
        Long startTS = System.currentTimeMillis();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://1.cuzillion.com/bin/resource.cgi?sleep=' + sleepSeconds);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Long duration = System.currentTimeMillis() - startTS;
        //System.debug('Duration: ' + duration + 'ms');
    }
}