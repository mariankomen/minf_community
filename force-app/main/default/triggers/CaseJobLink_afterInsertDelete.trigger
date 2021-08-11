/**********
Trigger: Case Job Link After insert delete
Description: this trigger will fire an update on the related Case to list all linked Jobs in the Case is Related to Job (Recruiter) field
    The platform users can't see the link object so if jobs are linked to an existing case they aren't able to see this.  They fill out this
    field when they submit a case, which triggers the insert of job case links (in this case the update of teh field is not necessary) but
    jobs linked to the case afterwards will trigger the update and add new jobs ids to the field
    
Created: Sept 9/13
Modification Log:

**********/
trigger CaseJobLink_afterInsertDelete on Case_Job_Link__c (after insert, after delete) {
    // set of Case Ids that need to the recruiter job id field recalculated
    Set<Id> CaseRecruiterUpdate = new Set<Id>();
    // cycle through records to build list of cases
    for (Case_Job_Link__c cj : (trigger.isinsert ? trigger.new : trigger.old) )
        CaseRecruiterUpdate.add(cj.case__c);
        
    // call util method to recalc Case field
    if (CaseRecruiterUpdate.size() > 0)
        Case_Util.RecalcCaseIsForJobRecruiter(CaseRecruiterUpdate);
}