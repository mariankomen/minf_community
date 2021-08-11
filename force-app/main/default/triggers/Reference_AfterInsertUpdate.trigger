/*****************************
  Trigger: References After Insert Update
  Purpose: This trigger fires when Reference record had Reference Reviewed checkbox set - updates related Candidate with relevant checkbox.

  Created: Apr 14/12 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
        Apr 15/13, Niki: updated code to use the new Candidate lookup field on Reference rather than finding most recently updated open Candidate.
        July 9/13, Niki: code clean up
                         
*****************************/
trigger Reference_AfterInsertUpdate on References__c (after insert, after update) {

    // map of candidates to update
    Map<Id, SFDC_Job_Candidate__c> canUpd = new Map<Id, SFDC_Job_Candidate__c>();
    // set of Candidate Records that need Reference count checking
    Set<Id> canRecIds = new Set<Id>();
     
    // cycle through References to check for reference checked value, pull Candidate Record link into map
    for (References__c r : trigger.new) {
        // if insert and Ref Reviewed is checked OR ref reviewed was updated to true and was false before, add to our map
        if ( ( trigger.isinsert && r.Set_Candidate_Reviewed_Field__c == 'Yes') ||
             ( trigger.isupdate && r.Set_Candidate_Reviewed_Field__c == 'Yes' && trigger.oldmap.get(r.id).Set_Candidate_Reviewed_Field__c == 'No') ) {
                // add candidate rec to our set
                canRecIds.add(r.candidate_record__c);
        }
    }  // end loop through references
    
    
    // if we have potential candidates to update, continue
    if (canRecIds.size() > 0) {
        
        // now that we know which Candidates have had a reference reviewed, we want to limit our updates to only those that having 2 or more already checked
        //  can't use roll up on Candidate Record since it hasn't been updated in dB yet
        AggregateResult[] groupedResults = [SELECT candidate_record__c, count(name) cnt
                                            FROM References__c where candidate_record__c in :canRecIds and Set_Candidate_Reviewed_Field__c = 'Yes'
                                            GROUP BY candidate_record__c having count(name) >= 2];
        // clear our CanIds set and readd entries that made it through our count filter
        canRecIds.clear();
        for (AggregateResult ar : groupedResults)  {
            // System.debug('candidate record ' + ar.get('candidate_record__c'));
            // System.debug('total records' + ar.get('cnt'));
            canRecIds.add((Id) ar.get('candidate_record__c'));
        }
        
        // cycle through References again, for any with a Candidate link populate and Candidate Rec in the set of Ids with count >= 2, Candidate needs updating with References Reviewed = true
        for (References__c r : trigger.new) {
            if (r.candidate__c != null && canRecIds.contains(r.candidate_record__c))
                canUpd.put(r.candidate__c, new SFDC_Job_Candidate__c(id = r.candidate__c, references_all_reviewed__c = true));
        }
        // now if we have Canidates to update, do so now
        if (canUpd.size() > 0) update canUpd.values();
    } // if possible cands to update   
}