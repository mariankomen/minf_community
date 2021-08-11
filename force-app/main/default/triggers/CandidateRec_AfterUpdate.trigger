/***************
  Trigger: CandidateRec_After Update
  Purpose: After any update of the Candidate Rec, if the Recruiter Summary or email address changed then 
      move the new value into all linked Candidates

  Created: June 6/11 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
     Nov 7/11: added email update down to Candidates
     Jan 27/13: removed job sharing logic for new EE org
     Feb 5/14: added logic to update certain candidates that are open if the candidate rec escalated reference check is changed.
     
***************/
trigger CandidateRec_AfterUpdate on SFDC_Candidate__c (after update) {
/*    // map of Candidates that need updating
    Map<Id, SFDC_Job_Candidate__c> updCan = new Map<Id, SFDC_Job_Candidate__c>();
    // set of Candidate Ids that have new Recruiter Summary to copy
    Set<Id> CanRecRecruiterIds = new Set<Id>();
    // set of Candidate Ids that have Escalated Reference checked
    Set<Id> CanRecEscalatedIds = new Set<Id>();    
    // set of Candidate Ids that have updated owners
    //Set<Id> CanShareIds = new Set<Id>();

    // cycle through updated records to see if the Recruiter Summary changed
    // also check if owner or Mgr 1-5 changed to build list for sharing
    for (SFDC_Candidate__c can : trigger.new) {
        if (can.Recruiter_Summary_on_Candidate__c != trigger.oldmap.get(can.id).Recruiter_Summary_on_Candidate__c ||
            can.SFDC_Candidate_Email__c != trigger.oldmap.get(can.id).SFDC_Candidate_Email__c )
            CanRecRecruiterIds.add(can.id);
        // if escalated ref check changed, add to set for updates
        if (can.Escalated_Reference_Check__c  != trigger.oldmap.get(can.id).Escalated_Reference_Check__c) 
            CanRecEscalatedIds.add(can.id);
   
    } // end loop through cans
    // if there are summary changes to process, do it now
    if (CanRecRecruiterIds.size() > 0) {
        // cycle through all candidates linked to the modified can record and copy the summary
        for (SFDC_Job_Candidate__c jc : [select id, Recruiter_Summary_on_Candidate__c, candidate_email_address__c, candidate__c, candidate__r.Recruiter_Summary_on_Candidate__c, candidate__r.SFDC_Candidate_Email__c  from SFDC_Job_Candidate__c where candidate__c in :CanRecRecruiterIds]) {
            jc.Recruiter_Summary_on_Candidate__c = jc.candidate__r.Recruiter_Summary_on_Candidate__c;
            jc.candidate_email_address__c = jc.candidate__R.SFDC_Candidate_Email__c;
            updCan.put(jc.id, jc);
        } // end loop through linked Cans
    }
    // if Escalated Ref to process, do it now
    if (CanRecEscalatedIds.size() > 0) {
        set<string> notJCStatus = new set<string>{'Hired', 'Rejected'};
        // cycle through all open candidates linked to the modified can record that don't have escalated ref checked
        for (SFDC_Job_Candidate__c jc : [select id, Escalated_Reference_Check__c, candidate__r.Escalated_Reference_Check__c from SFDC_Job_Candidate__c where candidate__c in :CanRecEscalatedIds and status__c not in :NotJCStatus]) {
            // if the checkboxes are not already the same, update the JC record
            if (jc.Escalated_Reference_Check__c != jc.candidate__r.Escalated_Reference_Check__c ) {
                // see if the JC is already in our update map from previous update loop
                SFDC_Job_Candidate__c thisJC = updCan.get(jc.id);
                if (thisJC == null) thisJC = jc;
                thisJC.Escalated_Reference_Check__c = jc.candidate__r.Escalated_Reference_Check__c;
                updCan.put(thisJC.id, thisJC );
            } // end if escalate needs updating
        } // end loop through linked Cans for escalated ref   
    }
    // if anything to update, do so now
    if (updCan.size() > 0) {
        update updCan.values();
    } // end update Cans

    // if there are candidates to share, call the method now
    //if (CanShareIds.size() > 0)
    //  Job_Util.CreateCandidateSharing(CanShareIds);
*/    
}