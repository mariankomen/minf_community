public with sharing class TalemetryRetrieveResultAsync implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {

    public void execute(SchedulableContext sc){
        Id jobId = Database.executeBatch(new TalemetryRetrieveResultAsync());
        system.debug(jobId);
    }

    public List<SFDC_Job__c> start(Database.BatchableContext bc) {
        return [select id, Last_Talemetry_Response__c, Last_Talemetry_TxnId__c, LastTalemetrySyncStatus__c from SFDC_Job__c where Last_Talemetry_TxnId__c != null and LastTalemetrySyncStatus__c = 'Pending' order by lastmodifieddate asc Limit 1];
    }

    public void execute(Database.BatchableContext BC, List<SFDC_Job__c> scope){
        //for(SFDC_Job__c job : scope) {
            Id queueId = system.enqueueJob(new TalemetryGateway(scope[0]));
            system.debug('queueId: '+queueId);
        //}     
    }

    public void finish(Database.BatchableContext BC){
        List<AsyncApexJob> jobs = [SELECT ApexClass.Name,ExtendedStatus,Id,JobType,Status FROM AsyncApexJob Where status = 'Processing' and ApexClass.Name = 'TalemetryCandidateAsync'];
        system.debug('jobs: '+jobs.size());
        if(jobs.isEmpty()) {
            Id queueId1 = system.enqueueJob(new TalemetryCandidateAsync()); 
            system.debug('queueId1: '+queueId1);              
        }
    }

}