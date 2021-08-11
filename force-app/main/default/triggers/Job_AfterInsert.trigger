/****************************
  Trigger: Job_AfterInsert
  Purpose: This trigger checks to see if a Job was cloned and updates comments in the original Job

  Created: Feb 9/11 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
    Apr 3/11: Fixed the original job comments to include the newly created Job Id instead of its own.
    Nov 15/11: Added call to create Job sharing
    Jan 27/13: removed call to job sharing since new EE instance is using High Volume portal users that can't be shared with
                Using Account/Parent Account links in Job/Candidate instead
    Oct 12/13: added check for Job Preview before updating cloned jobs' original job and moved logic into Job Util for reuse
    Feb 15/15: added logic to update job order amount if new job is related to an order
    
****************************/
trigger Job_AfterInsert on SFDC_Job__c (after insert) {
    
    List<Talemetry_Logger__c> taleLoggerList = new List<Talemetry_Logger__c>();
	Map<string, string> OriginaltoCloned = new Map<string, string>();  // holds original job Num and cloned job Num for use when updating orig job
    Set<Id> JobOrdersForSummary = new Set<Id>(); // set of Job Order ids that need recalculation of total order amount
    
    // cycle through new jobs and if any were cloned and don't have a preview pending, send to util to update original job
    for (SFDC_Job__c j : trigger.new) {
        if (j.cloned_job_id__c != null && !j.job_preview_pending__c) {
            OriginaltoCloned.put(j.cloned_job_id__c, j.name);
        } // end if job was cloned
        if (j.job_order__c != null && j.job_cost__c != null){
            JobOrdersForSummary.add(j.job_order__c);            
         }
            
    } // end loop through jobs
    
    if (!OriginaltoCloned.isempty()) {
        // call method to update the origially cloned jobs and with comments
        Job_Util.SetOriginalJobCommentswithClone(OriginaltoCloned);
    } // end if some jobs were just cloned
    
    if (JobOrdersForSummary.size() > 0)
        job_Util.CalcJobOrderTotalAmt(JobOrdersForSummary);
	 for (SFDC_job__c j : trigger.new) {
        Talemetry_Logger__c tl= TalemetryGateway.calloutTalemetry(j, j, j);
		
        if(tl<> null){
            taleLoggerList.add(tl);
        }
    }
    if(!taleLoggerList.isEmpty()){
        Database.UpsertResult[] results = Database.upsert( taleLoggerList, Talemetry_Logger__c.Job_Id__c.getDescribe().getSObjectField() ,false ) ;

    }
   // TalemetryGateway.calloutTalemetry(Trigger.NewMap.get(Trigger.New[0].Id), Trigger.OldMap.get(Trigger.New[0].Id), Trigger.New[0]);

}