/*******************
  Trigger: Account_AfterUpdate
  Purpose: This trigger updates any Open related Job's Manager user fields based on 
           changes made to the Account Manager user fields.

  Created: Feb 12/11 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
    Nov 16/11: added test for mgr 4,5 By Niki
    June 15/13: added test for Mgr type By Niki 
    Aug 10/08/2015 - Added access level managers By Nick
    
*********************/
trigger Account_AfterUpdate on Account (after update) {
    Set<Id> MgrChangedAccIds = new Set<Id>();  // holds Accounts that have had manager changes   
    // cycle through accounts to see if any have had Manager values change
    for (Account a : trigger.new) {
        if (a.X1st_Level_Manager__c <> trigger.oldmap.get(a.id).X1st_Level_Manager__c ||
            a.X1st_Level_Manager_type__c <> trigger.oldmap.get(a.id).X1st_Level_Manager_type__c ||
            a.X2nd_Level_Manager__c <> trigger.oldmap.get(a.id).X2nd_Level_Manager__c ||
            a.X2nd_Level_Manager_type__c <> trigger.oldmap.get(a.id).X2nd_Level_Manager_type__c ||
            a.X3rd_Level_Manager__c <> trigger.oldmap.get(a.id).X3rd_Level_Manager__c ||
            a.X3rd_Level_Manager_type__c <> trigger.oldmap.get(a.id).X3rd_Level_Manager_type__c ||
            a.X4th_Level_Manager__c <> trigger.oldmap.get(a.id).X4th_Level_Manager__c ||
            a.X4th_Level_Manager_type__c <> trigger.oldmap.get(a.id).X4th_Level_Manager_type__c ||
            a.X5th_Level_Manager__c <> trigger.oldmap.get(a.id).X5th_Level_Manager__c ||
            a.X5th_Level_Manager_type__c <> trigger.oldmap.get(a.id).X5th_Level_Manager_type__c ||
            a.X1st_Level_Access__c <> trigger.oldmap.get(a.id).X1st_Level_Access__c ||
            a.X2nd_Level_Access__c <> trigger.oldmap.get(a.id).X2nd_Level_Access__c ||
            a.HR_User_Usual__c <> trigger.oldmap.get(a.id).HR_User_Usual__c )
                MgrChangedAccIds.add(a.id);
    } // end loop through accounts
    // if manager values have changed, call Job Utils to update related Open jobs
    if (!MgrChangedAccIds.isempty()) Job_Util.SetManagers(MgrChangedAccIds);
}