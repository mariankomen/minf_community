//Project: New Service Model
//Date: July 03, 2017
//Author: Jeff Perron
//Description: This is a scheduled job that will run every night.
//             It will call any batch NSM job that need to be run
//             So far we have nsmBulkJobRecognitionUpdateBatch, nsmReferredCandidateMatchUpdateBatch, nsm30DayJobClosureUpdateBatch

global class scheduledNewServiceModel implements Schedulable {

    global void execute(SchedulableContext SC) {

        //if(!Test.isRunningTest()) {
            //call batch job: bulk job update
            Id batchinstanceid = database.executeBatch(new nsmBulkJobRecognitionUpdateBatch(),50);
        //}
           
        //if(!Test.isRunningTest()) {    
            //Q4 ROCK, call batch job: surveyContactUpdateBatch
            Id batchinstanceid2 = database.executeBatch(new surveyContactUpdateBatch(),50);
            //Id batchinstanceid3 = database.executeBatch(new surveyNPSAccountRollup(),200);        
        //}
       
        //if(!Test.isRunningTest()) {
            //ER 00184048, call batch job: candidateRevenueUpdateBatch
            Id batchinstanceid3 = database.executeBatch(new candidateRevenueUpdateBatch(),50);
        //}
       
        //Jan 2018, we dont need this anymore
        //call batch job: referrence candidates
        //Id batchinstanceid2 = database.executeBatch(new nsmReferredCandidateMatchUpdateBatch(),200);
        
        //Jan 2018, not going to be doing this
        //call batch job: 30 day job closure
        //Left out for release 3
        //Id batchinstanceid3 = database.executeBatch(new nsm30DayJobClosureUpdateBatch(),200);
   }
}