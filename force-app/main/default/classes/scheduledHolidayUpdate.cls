//Project: Holiday Update
//Date: August 03, 2016
//Author: Jeff Perron
//Description: This is a scheduled job that will run every night.
//             It will determine if holiday is today by calling Utilities.IsReoccurringHoliday
//             If today is holiday then call jobHolidayUpdateBatch.
//             NOTE: this will only where recurrence Frequency=Yearly 

global class scheduledHolidayUpdate implements Schedulable {

    global void execute(SchedulableContext SC) {

        DateTime now = system.now(); 
        Date today = date.newinstance(now.year(), now.month(), now.day());
        
        //if today if holiday
        if(Utilities.IsReoccurringHoliday(now)) {
            //call batch job update
            Id batchinstanceid = database.executeBatch(new jobHolidayUpdateBatch(today),200);
        }
   }
}