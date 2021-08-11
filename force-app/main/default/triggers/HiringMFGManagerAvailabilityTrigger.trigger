trigger HiringMFGManagerAvailabilityTrigger on MFG_Hiring_Manager_Availability__c (after insert) {
   fflib_SObjectDomain.triggerHandler(HiringManagerAvailabilityTriggerHandler.class);
}