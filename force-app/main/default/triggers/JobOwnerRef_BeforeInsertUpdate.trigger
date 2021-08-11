trigger JobOwnerRef_BeforeInsertUpdate on Job_Owner_Reference__c (before insert, before update) {
    // build set of id values from RecordTypeId field to ensure they are valid
    Map<Id, RecordType> RecTypes = new Map<Id, RecordType>([select id from RecordType where sobjecttype = 'SFDC_Job__c']);
    for (Job_Owner_Reference__c jr : trigger.new) {
        // test rec type value is valid id
        if (jr.job_record_type_id__c != null) {
            if (jr.job_record_type_id__c.length() >15)
                jr.job_record_type_id__c.adderror('Record Type Id '+jr.job_record_type_id__c+' is longer than 15 characters.  Please check the workflow field update formula.');
            else {
                try { 
                    Id recId = jr.Job_Record_Type_Id__c;
                    // if not a valid value, will fall into exception code, else test if it exists in table
                    if (!RecTypes.containskey(jr.Job_Record_Type_Id__c) )
                        jr.job_record_type_id__c.adderror('Record Type Id '+jr.job_record_type_id__c+' does not appear to exist for Jobs.  Please check the workflow field update formula.');
                }
                catch (Exception e) {
                    jr.job_record_type_id__c.adderror('Record Type Id '+jr.job_record_type_id__c+' is not a valid ID value.  Please check the workflow field update formula.');
                }
            } // end if not too long
        }
    } // end loop through ref recs
}