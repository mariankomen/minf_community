public class LoggerEventTriggerHandler {
    
    public static void insertLogRecords(List<Logger__e> loggerRecords){
        List<Talemetry_Logger__c> logs = new List<Talemetry_Logger__c>();
        for (Logger__e logE : loggerRecords) {
            Talemetry_Logger__c log = (Talemetry_Logger__c) JSON.deserialize(logE.Body__c, Talemetry_Logger__c.Class);
            logs.add(log);
        }
        insert logs;
    }

}

/*
	To create the events... 
	List<Logger__e> loggerEvents = new List<Logger__e>();
	//for each log record, 
	//Talemetry_Logger__c log = new Talemetry_Logger__c(Request__c=***,Response__c=***,Status__c=***);

	loggerEvents.add(new Logger__e(Body__c=JSON.serialize(log)));

	system.enqueueJob(new TalemetryLoggerAsync(loggerEvents));
    
	

*/