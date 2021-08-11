/*************
Trigger: User Before Insert/Update
Description: Set the Store ID text field on User for any Portal user; used in formula fields to indicate if record's Account link
    matches the portal user's account (ie Job field, My Store's Job)

Created: Jan 28/13, Niki Vankerk
Modification Log:
    
*************/
trigger User_BeforeInsertUpdate on User (before insert, before update) {
    // map of Contacts that need lookup for Account ID value
    Map<Id, Contact> contacts = new Map<Id, Contact>();
    // cycle through users to see if they have a contact filled in but no Store ID
    for (User u : trigger.new) {
        if (u.contactid != null) //&& u.store_Id__c == null) 
            contacts.put(u.contactid, new Contact());
    } // end loop through users
    // if there are contacts to lookup, query now
    if (contacts.size() > 0) {
        //contacts = new Map<Id, Contact>([select id, accountid from Contact where id in :contacts.keyset()]);
        contacts = new Map<Id, Contact>([SELECT id, accountid, account.Client_Profile__r.Using_New_Service_Model__c, account.Parent.Client_Profile__r.Using_New_Service_Model__c 
                                         FROM Contact WHERE id in :contacts.keyset()]);
        // cycle through users again to find the contact from our map and assign account id to Store ID field
        for (User u : trigger.new) {
            if (u.contactid != null && u.store_Id__c == null && contacts.containskey(u.contactid)) {
                u.store_id__c = string.valueof(contacts.get(u.contactid).accountid).left(15);
            }
            
            
            if (u.contactid != null && contacts.containskey(u.contactid)) {
                //NSM, find client profile off contact account or parent account and see if using NSM
                u.Client_Profile_Using_New_Service_Model__c=NewServiceModel_Util.IsUserOnNSMByContact(contacts.get(u.contactid));
            }
            
        }
    }
}