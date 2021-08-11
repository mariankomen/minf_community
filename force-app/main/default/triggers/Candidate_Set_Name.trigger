/*****************
    Trigger: Candidate_Set_Name
    Purpose: This trigger updates the record name to a more user friendly name
            while allowing the first and last name to be stored in separate fields.

    Created: Aug 23/09 by Niki Vankerk, Vankerk Solutions, Inc
    Modification Log:
        Nov 15/11: Niki Vankerk.  Set Candidate Owner Link with owner
*******************/
trigger Candidate_Set_Name on SFDC_Candidate__c (before insert, before update) {
 /*   for (SFDC_Candidate__c can : trigger.new) {
        can.Name = (can.first_Name__c == null ? '' : can.first_Name__c) + ' ' + (can.last_Name__c == null ? '' : can.last_Name__c);
        can.candidate_owner_link__c = can.ownerid;
    }
*/    
}