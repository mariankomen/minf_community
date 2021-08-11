trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert, before insert) 
{
	ContentDocumentLinkTriggerHandler.run(Trigger.new, Trigger.oldmap, Trigger.operationType);
}