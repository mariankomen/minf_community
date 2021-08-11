/************
Trigger: Job Record Type After Insert
Description: after insert or undelete of a Job Record Type record, find any Blacklist that has Apply to all Clients
    checked and add a new link between the new Job Rec Type and that Blacklist record.
    
Created: June 18/11, Vankerk Solutions
Modification Log:

************/
trigger JobRecordType_AfterInsert on Job_Record_Type__c (after insert, after undelete) {
    List<Blacklist_Job_Type__c> newBJT = new List<Blacklist_Job_Type__c>();  // list of new records to insert
    // cycle through any Blacklist with All Clients checked to add all new record types
    for (Blacklist__c b : [select id from blacklist__c where apply_to_all_clients__c = true])
        // go through each new record type record added in this trigger
        for (Job_Record_Type__c j : trigger.new)
            newBJT.add(new Blacklist_Job_Type__c(blacklist__c = b.id, job_record_type__c = j.id));
    // if there are new records to insert, do so now
    if (!newBJT.isempty())
        insert newBJT;
}