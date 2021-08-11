trigger TaskTrigger on Task (before insert, before update, after insert, after update, after delete, after undelete) {
	if(!TriggerFactory.isTriggerExecuted){
    	TriggerFactory.createandexecuteHandler(TaskHandler.class);
    }
}