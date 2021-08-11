/*************
Trigger: User After Update

Description: If a user's approver settings change then we want to update any Open Job with the new approver fields

Created: Feb 10/11, Niki Vankerk

Modification Log:
    June 8/11: Niki Vankerk: when a portal user is deactivated and owns open jobs, send an email to Jeff with job numbers/titles to reassign
    
*************/
trigger User_AfterUpdate on User (after update) {
    // create list of users that had Approver fields change
    Set<Id> chgApprover = new Set<Id>();
    // create list of portal users that have been deactivated
    Set<Id> portal = new Set<Id>();
    
    // cycle through users to see if any of the approver lookup fields changed or portal user has deactivated
    for (User u : trigger.new) {
        // approver 1
        if (u.job_approver_1__c <> trigger.oldmap.get(u.id).job_approver_1__c) chgApprover.add(u.id);
        // approver 2
        if (u.job_approver_2__c <> trigger.oldmap.get(u.id).job_approver_2__c) chgApprover.add(u.id);
        // approver 3
        if (u.job_approver_3__c <> trigger.oldmap.get(u.id).job_approver_3__c) chgApprover.add(u.id);
        // HR User approver
        if (u.hr_user_approver__c <> trigger.oldmap.get(u.id).hr_user_approver__c) chgApprover.add(u.id);
        // portal user deactivated?
        if (!u.isactive && trigger.oldmap.get(u.id).isactive && u.contactid != null) portal.add(u.id);
    } // end loop through users
    // if there are approver users to maintain, call Job Utils class future method
    if (!chgApprover.isempty()) {
        Job_Util.SetApprovers(chgApprover);
    }
    // if there are deactivated portal users to check for open Jobs, call Job Utils class method
    if (!portal.isempty()) {
        Job_Util.JobOwnerCheck(portal);
    }    
}