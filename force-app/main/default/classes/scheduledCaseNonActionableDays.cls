// Enhancement: Add Actionable Days
//Date: August 15th, 2017
//Author: Justin Medwid and Jami Silzer
//Description: Scheduled Job to update Case Field "Actionable Days" when a job is NOT in status "on hold"

global class scheduledCaseNonActionableDays implements Schedulable {
    
    global void execute(SchedulableContext SC) {
            
         Id batchinstanceid = database.executeBatch(new caseNonActionableDayUpdateBatch(),200);
    }
}