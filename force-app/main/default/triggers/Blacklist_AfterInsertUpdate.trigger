/*********
Trigger: Blacklist After Insert Update
Description: If a Blacklist is added with Apply to all checked or modified so that the field is now checked,
    go through all existing Job Record Type records and add any that are missing from teh Blacklist to the Blacklist
    Job Types join table.
    
Created: June 18/11 Vankerk Solutions
Modification Log:

*********/
trigger Blacklist_AfterInsertUpdate on Blacklist__c (after insert, after update) {
    // list of new Blacklist Job Types
    List<Blacklist_Job_Type__c> newBJT = new List<Blacklist_Job_Type__c>();
    // list of Blacklists that need processing
    List<Blacklist__c> bls = new List<Blacklist__c>();
    // cycle through new or updated Blacklists to see which have Apply to all clients checked
    for (Blacklist__c b : trigger.new)
        if ((trigger.isinsert && b.apply_to_all_clients__c) || (b.apply_to_all_clients__c &&
            !trigger.oldmap.get(b.id).apply_to_all_clients__c))
            bls.add(b);
    // if there are Blacklists that need processing, continue
    if (!bls.isempty()) {
        // create a map of all JRTs to consider adding to a Blacklist
        Map<Id, Job_Record_Type__c> jrts = new Map<Id, Job_Record_Type__c>([select id from job_Record_Type__c]);
        // cycle through each Blacklist with assoc jrts to see what needs adding
        for (Blacklist__c b : [select id, (select job_record_type__c from Blacklist_Job_types__r) from Blacklist__c where id in :bls]) {
            // create a set of JRT IDs already linked to this Blacklist through subquery
            Set<Id> jrtids = new Set<Id>();
            for (Blacklist_Job_type__c bjt : b.Blacklist_Job_types__r) jrtids.add(bjt.job_record_type__c);
            // for each JRT in the system, see if it is already in the set of Blacklist Job Types for this blacklist
            for (id JRTId : jrts.keyset()) {
                // if not already in the set of BJT for this blacklist, add one now
                if (!jrtids.contains(JRTId)) newBJT.add(new Blacklist_Job_Type__c(blacklist__c = b.id, job_record_type__c = JRTid));
            } // end loop through Job Record Types
        } // end loop through blacklists
        // if new BJTs required, add now
        if (!newBJT.isempty()) insert newBJT;
    } // end if Blacklists that need processing

}