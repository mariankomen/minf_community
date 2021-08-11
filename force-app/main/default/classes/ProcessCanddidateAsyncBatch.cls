public class ProcessCanddidateAsyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    
    public void execute(SchedulableContext sc){
        Id jobId = Database.executeBatch(new ProcessCanddidateAsyncBatch(),1);
        system.debug(jobId);
    }
    
    public ProcessCanddidateAsyncBatch(){}
    
    Id recordId;
    public ProcessCanddidateAsyncBatch(Id recordId){
        this.recordId = recordId;
    } 
    
    public List<Talemetry_Logger__c> start(Database.BatchableContext bc) {
        String type = 'CanddidateAsync';
        String status = 'Processing';
        Boolean exceedSafeSize= false;
        String query = 'SELECT Id, Transaction_Id__c, Type__c, Processed__c,Applicant_Id__c, StatusNumber__c,Exceed_Safe_Size_Limit__c, Status__c,Transaction_DateTime__c FROM Talemetry_Logger__c';
        if(!String.isBlank(recordId)) query += ' where Id =: recordId';
        else query += ' where Processed__c = false and Status__c =: status and  Type__c =: type and Exceed_Safe_Size_Limit__c =: exceedSafeSize';
        return Database.query(query); //[SELECT Id, Transaction_Id__c, Type__c, Processed__c, StatusNumber__c, Status__c FROM Talemetry_Logger__c where Processed__c = false and Status__c =: status and  Type__c =: type];
    }
    
    public void execute(Database.BatchableContext BC, List<Talemetry_Logger__c> scope){
        for(Talemetry_Logger__c job : scope) {
            String appId ='';
            if(!Test.isRunningTest()){
               	TalemetryCandidateAsync.processCanddidateAsync(job);  
            }
            if(String.isNotBlank(job.Applicant_Id__c) && (job.Applicant_Id__c.length() == 15 || job.Applicant_Id__c.length() == 18)) {
               job.Status__c = 'Completed';
               job.Processed__c = true;
            }
            else {
                job.Status__c = 'Failed';
            }
        } 
        Database.update(scope ,false);
    }
    
    public void finish(Database.BatchableContext BC){
    }
    public static string scheduleJob(){
        String CRON_EXPR;
        ProcessCanddidateAsyncBatch job  = new ProcessCanddidateAsyncBatch();
        for(Integer i=1; i < 20 ; i++){
            CRON_EXPR =  '0 '+3*i+' * * * ?' ; //every 3 min
            System.Schedule('ProcessCanddidateAsyncBatchRun'+i,CRON_EXPR,job);
        }
        
        return null;
    }    
    
}