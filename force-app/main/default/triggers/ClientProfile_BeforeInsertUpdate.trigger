/******
Client Profile Before update, Before Insert
Description:  Users will enter the record type name for the client job types and this trigger either errors if the job record type is not found or finds the job record type and populates the
    related job record type ID field in the Client Profile.
    
Created: Feb 15, 2015 Vankerk Solutions
Modification Log:

******/
trigger ClientProfile_BeforeInsertUpdate on Client_Profile__c (before update, before insert) {

    Map<string, RecordType > recTypebyName = new Map<string, RecordType >();
    // if CSS/FCR record type names are populated/changed, update related record type id fields
    for (Client_profile__c c : trigger.new) {
        if (c.css_record_type_name__c != null)
            recTypebyName.put(c.css_record_type_name__c, null);
        else
            c.css_record_type_id__c = null;
        if (c.fcr_record_type_name__c != null)
            recTypebyName.put(c.fcr_record_type_name__c , null);
        else
            c.fcr_record_type_id__c = null;      
        if (c.po_record_type_name__c != null)
            recTypebyName.put(c.po_record_type_name__c , null);
        else
            c.po_record_type_id__c = null;  
    }
    // if we have record types to process, continue
    if (recTypebyName.size() > 0) {
        // grab relevant record types
        for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType='SFDC_Job__c' and name in :recTypebyName.keyset()])  
            recTypebyName.put(rt.name, rt);    
        // cycle through profiles and set RT Id field or add error if no match found
        for (Client_Profile__c c : trigger.new) {
            if (c.css_record_type_name__c != null) {
                if (recTypebyName.containskey(c.css_record_type_name__c) && recTypebyName.get(c.css_record_type_name__c) != null)
                    c.css_record_type_id__c = recTypebyName.get(c.css_record_type_name__c).id;
                else {
                    c.css_record_type_name__c.adderror('There is no match in Job Record Types for this name.  Please check the spelling and try again.');
                }
            }  
            if (c.fcr_record_type_name__c != null) {
                if (recTypebyName.containskey(c.fcr_record_type_name__c ) && recTypebyName.get(c.fcr_record_type_name__c) != null)
                    c.fcr_record_type_id__c = recTypebyName.get(c.fcr_record_type_name__c ).id;
                else {
                    c.fcr_record_type_name__c.adderror('There is no match in Job Record Types for this name.  Please check the spelling and try again.');
                }
            }   
            if (c.po_record_type_name__c != null) {
                if (recTypebyName.containskey(c.po_record_type_name__c ) && recTypebyName.get(c.po_record_type_name__c) != null)
                    c.po_record_type_id__c = recTypebyName.get(c.po_record_type_name__c ).id;
                else {
                    c.po_record_type_name__c.adderror('There is no match in Job Record Types for this name.  Please check the spelling and try again.');
                }
            } 
        }
    }
}