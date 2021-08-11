/*************
Class: Recall Approvals, VF page extension
Description:  This controller holds a function to recall any pending Approval Processes for a Job.
    It was written for the Akzo approval process needs but will work on any Job type.  
    
Created: May 23, 2011, Niki Vankerk
Change Log: 

*************/
public class RecallApprovals {
 
    // Constructor - this only really matters if the autoRun function doesn't work right
    private final SFDC_Job__c j;
    public RecallApprovals(ApexPages.StandardController stdController) {
        this.j = (SFDC_Job__c)stdController.getRecord();
    }
 
    // Code we will invoke on page load.
    public PageReference autoRun() {
 
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        
        try {
            // cycle through any pending approvals for this job
            for (ProcessInstanceWorkitem pw : [Select p.Id, p.ProcessInstanceId, p.ProcessInstance.TargetObjectId from 
                    ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :theId]) {
                // Instantiate the new ProcessWorkitemRequest object and populate it
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                // check job owner language when setting Recall Comments                   
                req2.setComments( (j.job_owner_link__r.languagelocalekey == 'fr' ? 'Retrait de la demande d\'approbation-Processus d\'embauche accéléré' : 'Removing request as per Early Hire Process.'));
                req2.setAction('Removed');
                req2.setWorkItemId(pw.Id);
                Approval.ProcessResult result = Approval.process(req2);
                //system.debug(result);
            } // end loop through approvals steps

            // Redirect the user back to the original page
            PageReference pageRef = new PageReference('/' + theId);
            pageRef.setRedirect(true);
            return pageRef;
         } catch (Exception e) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error encounted when processing the Early Hire.  Please contact your System Administrator with this error message: '+e));
             return null;
         }
    }

}