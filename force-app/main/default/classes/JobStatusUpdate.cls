/*************
Class: Job Status update, extension for VF page that updates a Job status to a particular value with a single click.  Previously used a web link with save=1 to automatically open, edit and
        save the record but this is no longer allowed with orgs created after 2012.  Controller finds the specific Status value from the URL and action method updates the job.

Created: Feb 17, 2013, Vankerk Solutions
Modification Log:

*************/
public class JobStatusUpdate {

    private string newStatus {get; set;}
    public SFDC_Job__c job {get; set;}
    
    // find the paramter to use
    public JobStatusUpdate(ApexPages.StandardController controller) {
        job = (SFDC_Job__c) controller.getRecord();
        // look for parameter in page URL for new Status value
        if (ApexPages.currentpage().getparameters().containskey('status') != null)
            newStatus = ApexPages.currentpage().getparameters().get('status');
    }

    // action method called from page to update the job with the new status value if found.  Otherwise show an error message on page.
    public PageReference setJobStatus() {
        try {
            // if we have a status, update job and return to Job view
            if (newStatus != null) {
                job.job_status__c = newStatus;
                update job;
                PageReference jobPg = new PageReference('/'+job.id);
                return jobPg;
            }
            // if no status parameter was found, add error message and display
            else {
                ApexPages.AddMessage(new apexPages.Message(ApexPages.severity.fatal, 'There was a problem updating the Job.  Please contact the HirePortal administrator with the following information: \n'+
                    'No status parameter found'));
                return null;            
            }
        } 
        // if an update error was found, display on page
        catch (Exception e) {
            ApexPages.AddMessage(new apexPages.Message(ApexPages.severity.fatal, 'There was a problem updating the Job.  Please contact the HirePortal administrator with the following information: \n'+
                e.getstacktracestring()+': '+e));
            return null;
        }
    }
}