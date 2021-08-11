trigger LoggerTrigger on Logger__e (after insert) {

    LoggerEventTriggerHandler.insertLogRecords(Trigger.New);
    
}