/***************
Class: Candidate View, extension of VF page
Description:  queries the Reference table to build ordered list of records for this Candidate to display on page
    Was set up to filter on status of Completed but no longer needed Oct 2013.  Still want to use an extension so 
    we can control the sort order as it is random when we reference the child records using the {!SFDC_Candidate__c.References__r}
    syntax.

Created: Apr 29, 2012; Vankerk Solutions
Modification Log:
    June 14/13: Added first/last name to query for References
    Oct 4/13: Removed where clause
    July 27/15: added support for showing/hiding 'back to list' breadcrumb based on a retURL being in the URL
    
***************/
public class CandidateView {

    // list of References for viewing on page
    //Refs1 is for all non AkzoNobel clients whereas Refs2 is for AkzoNobel only so they can see all references regardless of status
    public List<References__c> Refs {get; set;}
    public List<References__c> Refs2 {get; set;}
    // used by VF page to know whether the breakcrumb 'back to list' should be visible
    public boolean showBreadcrumb {get; set;}
        
    // constructor to find any relevant References
    public CandidateView(ApexPages.StandardController controller) {
        SFDC_Candidate__c can = (SFDC_Candidate__c) controller.getrecord();
        Refs = new List<References__c>();
        Refs2 = new List<References__c>();
        // find any linked References with Completed Successfully = Completed & Positive, order by created date
        Refs = [select id, name, first_name__c, last_name__c, Reference_Check_SLA__c, Reference_Completed_Successfully__c, Type__c, createddate from References__c where Candidate_Record__c = :can.id
                 and Reference_Completed_Successfully__c = 'Completed' order by createddate desc];
        Refs2 = [select id, name, first_name__c, last_name__c, Reference_Check_SLA__c, Reference_Completed_Successfully__c, Type__c, createddate from References__c where Candidate_Record__c = :can.id
                 order by createddate desc];  

        // if the page URL has a retURL parameter that contains the CandidateListViews page, we show the back to list breadcrumb     
        if (apexpages.currentpage().getparameters().get('retURL') != null && apexpages.currentpage().getparameters().get('retURL').tolowercase().contains('candidatelistviews'))
            showBreadcrumb = true;
        else
            showBreadcrumb = false;               
    }
}