/************
Trigger: Job Point Before Insert/Update
Description: maintains the client name based on record type id and sets record name field.

Created: Apr 29/14, Vankerk Solutions
Modification Log:

************/
trigger JobPoint_BeforeInsertUpdate on Job_Point__c (before insert, before update) {
    // build map of record types for active job record types so we can set the ID value here
    map<Id, RecordType> RecTypeMapbyID = new Map<Id, RecordType>();
    // map of active job record types by name
    map<string, RecordType> RecTypeMapbyName = new map<string, RecordType> ();
    // cycle through rec types to build our maps
    for (RecordType r : [select id, name from recordtype where SobjectType='SFDC_Job__c' and isactive = true]) {
        RecTypeMapbyID.put(r.id, r);
        RecTypeMapbyName.put(r.name, r);
    }
    
    // set record name with client - banner - job title
    for (Job_Point__c j : trigger.new) {
        // need either recordtypeid or client populated or error
        if (j.record_type_id__c != null || j.client__c != null) {
            // if we have record Id, lookup and set client
            if (j.record_type_id__c != null && RecTypeMapbyID.containskey(j.record_type_id__c )) {
                j.client__c = RecTypeMapbyID.get(j.record_type_id__c).name; 
            }
            // if we have client, set record ID
            else if (j.client__c  != null && RecTypeMapbyName.containskey(j.client__c  )) {
                j.record_type_id__c = RecTypeMapbyName.get(j.client__c).id; 
            }            
            // set match key and name (up to 80 char) of record
            j.match_key__c = j.client__c  + ' - ' + (j.banner_of_store__c == null ? '' : j.banner_of_store__c + ' - ') + j.job_title__c;
            if(j.Custom_Job_Title__c != null && j.Job_owner_alias__c != null){
            j.match_key__c = j.client__C + ' - ' + j.Job_owner_alias__c + ' - ' +  j.custom_job_title__c;
            j.name = j.match_key__c;

            // truncate at 80 char
            if (j.name.length() > 80)
                j.name = j.name.left(80);
        }
        
            j.name = j.match_key__c;
            if (j.name.length() > 80)
                j.name = j.name.left(80);

        }
        // now check if both are not filled in, we couldn't find a match above so throw an error
        if (j.record_type_id__c == null || j.client__c == null)
            j.adderror('We are not able to resolve this client.  Please contact your system administrator for assistance.');
  
    }
}