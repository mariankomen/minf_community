/******
Client Profile After update, After Insert
Description: Find users by their client profile and update Using New Service Model flag.
    
Created: August 23, 2017 Jeff Perron
Modification Log:

******/     
   

trigger ClientProfile_AfterInsertUpdate on Client_Profile__c (after update, after insert) {

    for (Client_profile__c c : trigger.new) {
        if(trigger.isupdate && c.Using_New_Service_Model__c <> trigger.oldmap.get(c.id).Using_New_Service_Model__c) {
            //NSM, we want to set Using New Service Model on users associated with related account
            NewServiceModel_Util.UpdateUsersToNSMByClientProfile(c);
        }
    }

}