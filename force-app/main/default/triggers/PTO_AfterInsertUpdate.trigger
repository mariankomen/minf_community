/*****************************
  Trigger: PTO After Insert Update
  Purpose: This trigger autosubmits jobs with submit to Manager checkbox checked on insert or update

  Created: Nov 23/11 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:

*****************************/
trigger PTO_AfterInsertUpdate on SFDC_PTO_Request__c (after insert, after update) {
    Set<Id> PTO_Approvals = new Set<ID>();
    // cycle through records to find new or updated with the Submit to Manager checked
    for (SFDC_PTO_Request__c p : trigger.new) {
        if (p.submit_to_manager__c && (trigger.isinsert || (trigger.isupdate && !trigger.oldmap.get(p.id).submit_to_manager__c)) )
            PTO_Approvals.add(p.id);
    } // end loop through PTO
    
    // if we have approvals to submit, call method now
    if (PTO_Approvals.size() > 0) 
        Employee_Util.SubmitForApproval(PTO_Approvals);
}