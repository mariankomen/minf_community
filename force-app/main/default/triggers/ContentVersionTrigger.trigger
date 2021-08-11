trigger ContentVersionTrigger on ContentVersion (after insert, after update) {
	if(!TriggerFactory.isTriggerExecuted){
    	TriggerFactory.createandexecuteHandler(ContentVersionHandler.class);
    }
    
    if (trigger.isInsert && trigger.isAfter)
       ContentDocumentLinkTriggerHandler.createContentDistribution(trigger.new);
}