/*************************
      Class: CandidatePageUpdate
      Purpose: This class contains methods to support the CandidatePageUpdate visualforce page, including test methods.
              It is launched from a button on the Candidate record to find the the most recent job he/she is linked to
              and open that job in teh CandidateUpdate page.

      1. CandidateUpdate(): controller extension method to initialize the page variables, including setting the valid Status arrays
           for query
      2. FindJobSubmission(): method to find the appropriate Job Candidate record and launch UpdateCandidate vf page.  
              - Find most recently modified job Candidate record for this Candidate with appropriate status values
              - If one is found, launch UpdateCandidate vf page for the related Job.
              - If none found, remain on page which will display statis message

      Created: Feb 15/2010 by Niki Vankerk, Vankerk Solutions, Inc
      Modification Log:
         March 15/11: added userLang setting to determine correct message body on VF page.
         Dec 5/11: added to the valid Job Status values array.
         Mar 10/12: made js public and added Job Department to query so we can use this extension with the Print Candidate page to find Department
         Mar 19/13: added SLA Level to query to use in VF page rendering logic
         Mar 30/13: added support to pass can rec Id as 'feature' parameter to Update page for ordering it first
         
*************************/
public with sharing class CandidatePageUpdate {

    private final SFDC_Candidate__c can; // Candidate we are launched from
    private List<string> JobStatus;      // valid Job status list
    private List<string> notJCStatus;    // invalid Job Candidate status list
    public string UserLang {get; set;}   // users language setting
    private SFDC_Job_Candidate__c js {get; set;}  // candidate to be updated in the Find Job Submission method
    public string jobDept {get; set;}  // most recent job's department to display on Print Candidate page
    public string JobSLA {get; set;}   // most recent job's sla level to use in Print Candidate page
    public string jobName {get; set;}
    
    // set up variables
    public CandidatePageUpdate(ApexPages.StandardController controller) {
        this.can = (SFDC_Candidate__c)controller.getRecord();
        // build list of valid statuses to use when searching for a Job Candidate record using the Open Job Status custom setting
        JobStatus = new List<String>();
        for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
            JobStatus.add(o.status_name__c);
        } // end loop through settings        

        this.notJCStatus = new string[]{'Hired', 'Rejected'};
        
        // query for current user's language key and set public variable - used to determine which message to display
        User currUser = [select id, languagelocalekey from User where id = :UserInfo.getUserId()];
        UserLang = currUser.languagelocalekey;
        
        // start with empty records
        js = new SFDC_Job_Candidate__c();
        try {
            // query Job Candidate table for most recently modified candidate
            js = [select id, sfdc_job__c, sfdc_job__r.name, sfdc_job__r.department__c, sfdc_job__r.OWF_Department__c, sfdc_job__r.sla_level__c from SFDC_Job_Candidate__c where candidate__c = :can.id and
                sfdc_job__r.job_status__c in :JobStatus and status__c not in :notJCStatus order by lastmodifieddate desc limit 1];
            jobDept = (js.sfdc_job__r.owf_department__c == null ? js.sfdc_job__r.department__c : js.sfdc_job__r.OWF_Department__c);
            jobSLA = js.sfdc_job__r.sla_level__c;
            jobName = js.sfdc_job__r.name;
        } catch (Exception e) {
            // if the query found no results, we leave each record as-is
        }
    }

    // Method invoked when page launches
    //    query for any JobCandidate records for this Candidate where the Job status and JobCandidate
    //    status match the valid lists.  Order by most recently modified and pick the first one.
    //    If there are no matches, stay at this page with a message.  If a match is found, launch
    //    the UpdateCandidate vf page for that Job.
    public PageReference FindJobSubmission() {
        try {
            if (js != null && js.id != null) {
                // if query found results, setup the CandidateUpdate page for that job and launch
                PageReference CanUpd = page.CandidateUpdate;
                CanUpd.getParameters().put('id', js.sfdc_job__c);
                // pass over can rec Id so it is listed first in the update page
                CanUpd.getParameters().put('feature', can.id);
                return CanUpd;  
            }
        } catch (Exception e) {}
        return null;
    }
    
       
}