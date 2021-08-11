trigger SFDCJobCandidateTrigger on SFDC_Job_Candidate__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    //SFDCJobCandidateTriggerHandler.run(Trigger.new, Trigger.oldmap, Trigger.operationType);
    System.debug('operationType '+Trigger.operationType);
    TriggerFactory.createandexecuteHandler(SFDCJobCandidateHandler.class);
}