trigger HiringManagerAvailabilityTrigger on Hiring_Manager_Availability__c (before insert,before update) {
    fflib_SObjectDomain.triggerHandler(InterviewAvailabilityTriggerHandler.class);
}