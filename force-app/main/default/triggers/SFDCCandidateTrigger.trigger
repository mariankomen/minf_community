trigger SFDCCandidateTrigger on SFDC_Candidate__c (before insert, before update, after insert, after update, after delete, after undelete) {
	TriggerFactory.createandexecuteHandler(SFDCCandidateHandler.class);
}