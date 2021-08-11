//Description: This is a scheduled job that will run every night.


global class scheduledDaysInLieu implements Schedulable {
    
    global void execute(SchedulableContext SC) {
            
         Id batchinstanceid = database.executeBatch(new Job_DaysInLieuUpdateBatch(),200);
    }
}