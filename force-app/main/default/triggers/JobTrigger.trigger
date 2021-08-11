trigger JobTrigger on SFDC_Job__c (after update) 
{
	JobTriggerHandler.run(Trigger.new, Trigger.oldmap, Trigger.operationType);
}