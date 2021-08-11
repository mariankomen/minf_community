public class TalemetryLoggerDeleteRecordsBatch implements  Database.Batchable<sObject>, Schedulable {

    public void execute(SchedulableContext sc){
        Id jobId = Database.executeBatch(new TalemetryLoggerDeleteRecordsBatch());
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('enetered');
        //system.debug([select id, createddate from Talemetry_Logger__c]);
        //system.debug([select id, createddate from Talemetry_Logger__c where createddate < last_n_days:7 order by createddate desc]);
        return Database.getQueryLocator('select id, createddate from Talemetry_Logger__c where createddate < last_n_days:7 order by createddate desc');
    }

    public void execute(Database.BatchableContext BC, List<Talemetry_Logger__c> scope){
        Map<Id, Talemetry_Logger__c> scopeMap = New Map<Id, Talemetry_Logger__c>(scope);
		Database.delete(new List<Id>(scopeMap.keySet()), false)  ;
    }

    public void finish(Database.BatchableContext BC){

    }    
    
}