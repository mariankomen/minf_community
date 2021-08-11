trigger ApplicantTrigger on Applicant__c (before insert, after insert, before update, after update, after delete, after undelete) {
    System.debug('TriggerFactory.isTriggerExecuted @>'+TriggerFactory.isTriggerExecuted);
    if(!TriggerFactory.isTriggerExecuted){
    	TriggerFactory.createandexecuteHandler(ApplicantHandler.class);
    }
}