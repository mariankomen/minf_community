trigger ApplicantJobAppTrigger on Applicant_Job_Apps__c (before insert, before update, after insert, after update) 
{
   
    /*ApplicantJobAppTriggerHandler handler = new ApplicantJobAppTriggerHandler();    
    handler.run(Trigger.new, Trigger.oldmap, Trigger.operationType);
    */
    if(!TriggerFactory.isTriggerExecuted)
    {
        TriggerFactory.createandexecuteHandler(ApplicantJobAppsHandler.class);
    }
}