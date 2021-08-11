/******************
Class: JobView, extension to VF page
Description: we want to show the Approval details to portal users but they can't see the Approval objects.  Instead we build a custom class with the pertinent details
    and that is displayed on the VF page instead
    
Created: Sept 8/11, Vankerk Solutions
Modification Log:
        Sept 1/12: Niki Vankerk: query for Candidates so we can sort by candidate sent date rather than default order
        Jan 15/13: updated test method for new profile names
        Dec 2/13: updated sort order and comments
        Sept 27/14: added eligibility and predictor for candidate list view
        Mar 1, 2015: added Drivers license for candidate list view
       July 27/15: added support for showing/hiding 'back to list' breadcrumb based on a retURL being in the URL
       
******************/
public class JobView {
    // list of Approval details to display on VF page
    public List<Approval> approvalSteps {get; set;}
    // list of Candidates in proper order
    public List<SFDC_Job_Candidate__c> cands {get; set;}
    // indicates if the job should hide the Eligibility/Predictor/Drivers license or not, based on Mindfield Service/Product
    public boolean showEligibility {get; set;}
    // used by VF page to know whether the breakcrumb 'back to list' should be visible
    public boolean showBreadcrumb {get; set;}
    
    public JobView(ApexPages.StandardController controller) {
        Id JobId = controller.getId();
        // if we have an id, find approval steps
        if (JobId != null) {
            // query for approval steps through Job since we can't query it directly and Candidate Records sorted by rating hyperlink or date sent if user can't see rating field
            string queryString = 'Select Id,Name, MindField_Job_Type__c, mindfield_service__c, '+ 
                                '(Select TargetObjectId, SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, Actor.name, ActorId, '+
                                ' OriginalActorId, OriginalActor.name, IsPending, IsDeleted, Id, CreatedDate, CreatedById, Comments From ProcessSteps order by SystemModstamp desc), '+
                                '(select id, Candidate_Name__c, Candidate__c, Phone_Number__c, Email__c, Status__c, Location_Column__c, Rating__c, Date_Candidate_Sent__c, eligibility__c, '+
                                ' Drivers_License__c, predictor__c '+
                                ' from SFDC_Job_Candidates__r ';
            // if job is NOT FCR user can see rating field, sort candidates by this value
            if (SFDC_Job_Candidate__c.Rating__c.getDescribe().isAccessible())
                queryString += ' order by rating__c desc ) ';
            else
                queryString += ' order by Date_Candidate_Sent__c desc ) ';
            queryString += ' from SFDC_Job__c where Id = :JobId ';               
            //    note that the rating field has hidden initial hyperlink that contains the rating number and then the date candidate sent in yyyy-mm-dd so we will sort by
            //    this combination.  The Rating hyperlink is unique for each candidate regardless of rating number because it later uses the candidate ID value in the link
            //    so you can sort by rating and then something else in the SOQL below as the rating will never be the same for all.  Instead update the Candidate Rating field
            //    with a different initial hidden hyperlink value to change the sort order
            SFDC_Job__c j = (SFDC_Job__c) database.query(querystring);
            // populate the list of Approvals if we have any
            approvalSteps = new List<Approval>();
            // cycle through SF table and build our Approval class object
            for (ProcessInstanceHistory p : j.processsteps) {
                approvalSteps.add(new Approval(p));
            } // end loop through Jobs
            //system.debug('approval steps are: '+approvalsteps);
            // populate our list of candidates
            cands = j.SFDC_Job_Candidates__r;
            
            // set boolean to show/hide Eligibility/Predictor/Drivers license
            set<string> CSSProducts = new set<string>{'TalentReach', 'TalentConnect - Promote Post', 'TalentConnect - Priority Post', 'TalentConnect - Post Only'};
            if (j.mindfield_service__c == 'Candidate Sourcing' || j.mindfield_service__c == 'Posting Only' || CSSProducts.contains(j.MindField_Job_Type__c))
                showEligibility = true;
            else
                showEligibility = false;
            
            // if the page URL has a retURL parameter that contains the JobListViews page, we show the back to list breadcrumb     
            if (apexpages.currentpage().getparameters().get('retURL') != null && apexpages.currentpage().getparameters().get('retURL').tolowercase().contains('joblistviews'))
                showBreadcrumb = true;
            else
                showBreadcrumb = false;
                
        } // end if job id found
    }

    // class to hold approval details for the Portal user that is not able to see ProcessInstanceHistory object
    public class Approval{
        public SFDC_Job__c j {get; set;}
        public string status {get; set;}
        public string AssignedTo {get; set;}
        public string ActualApprover {get; set;}
        public string Comments {get; set;}
        
        public Approval(ProcessInstanceHistory p){
            // use a Job object so we can borrow the formatting for a datetime field
            j = new SFDC_Job__c(Date_Job_Submitted_for_Approval__c = p.systemmodStamp);
            status = p.stepStatus;
            AssignedTo = p.OriginalActor.name;
            Actualapprover = p.Actor.name;
            Comments = p.comments;
        
    }
  
    }
}