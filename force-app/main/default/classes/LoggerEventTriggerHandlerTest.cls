@isTest
public class LoggerEventTriggerHandlerTest {
     static testmethod void test1(){
        List<Logger__e> loggerEvents = new List<Logger__e>();
        //for each log record, 
        //Talemetry_Logger__c log = new Talemetry_Logger__c(Request__c=***,Response__c=***,Status__c=***);
    
        loggerEvents.add(new Logger__e(Body__c='testing'));
        List<Database.SaveResult> results = EventBus.publish(loggerEvents);
        
    }
}