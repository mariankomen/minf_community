public class DeleteTalemetryLoggerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Schedulable{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date dt = System.today().addDays(-7);
        String query = 'SELECT Id, Status__c,Exceed_Safe_Size_Limit__c,Transaction_Id__c FROM Talemetry_Logger__c WHERE CreatedDate <: dt';
        return Database.getQueryLocator(query);
    }
    
    public void execute (Database.BatchableContext bc, List<sObject> scope){
        for(Talemetry_Logger__c log:(List<Talemetry_Logger__c>)scope){
            if(log.Exceed_Safe_Size_Limit__c && log.Transaction_Id__c <> null && (log.Status__c == 'Failed' || log.Status__c == 'Error') ){
                TalemetryCandidateAsync.removeResumeCallout(log.Transaction_Id__c);
            }
        }
        List<Database.DeleteResult> results = Database.delete(scope, false);
        for(Database.DeleteResult sr : results){
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                 err.getStatusCode() +
                                 ' - ' +
                                 err.getMessage());
                }
            }       
        }
        
    }
    
    public void finish (Database.BatchableContext bc){ }
    
    public void execute(SchedulableContext sc){
        Id jobId = Database.executeBatch(new DeleteTalemetryLoggerBatch(),50);
        system.debug(jobId);
    }
    
    public static void scheduleJob(){
        String CRON_EXPR;
        ProcessCanddidateAsyncBatch job  = new ProcessCanddidateAsyncBatch();
        CRON_EXPR  = '0 0 5 * * ?';//everyday  5 AM
        System.Schedule('DeleteTalemetryLoggerBatch '+System.now(),CRON_EXPR,job);
        
    }
    
}