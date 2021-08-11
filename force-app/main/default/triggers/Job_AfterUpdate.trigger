/****************************
    Trigger: Job_AfterUpdate
    Purpose: This trigger checks to see if a Job is closed and closes out any related Reminders.  Also maintains
             Manager look up fields in related Job Candidate and Candidate records and sums related Job Order total $

    Created: Mar 10/10 by Niki Vankerk, Vankerk Solutions, Inc
    Modification Log:
        Feb 12/11: Niki Vankerk.  Added logic to look up related JC records and update manager look up fields if
            they were changed on the Job
        Feb 28/11: Niki Vankerk.  Added logic to also look up related Candidate records and update owner and manager
            if they were changed on the Job
        Nov 15/11: Niki Vankerk.  Added logic for Manager 4,5
        Jan 19/12: Niki Vankerk.  Added logic to maintain JC LTAS field if Job's LTAS changes, similar to manager logic
        Mar 16/12: Niki Vankerk. Added logic to manage job notifications on 'baby' jobs that are not posted due to a duplicate
        June 10/12: Niki Vankerk. Added logic to maintain Job Owner Manager field from Job for email alerts
        Jan 27/13: NV: removed job sharing call with new EE instance, added copy Store/parent account/other related to candidate Record when job owner
                    changes
        Apr 30/13: NV: removed other related account setting as no longer needed
        Oct 12/13: NV: added call to update original job if cloned job that was in preview mode was accepted
        Feb 15/15: NV: add call to sum Job Order total if job order link changes or job cost changes
        
****************************/
trigger Job_AfterUpdate on SFDC_Job__c (after update) {
   //List<Logger__e> loggerEvents = new List<Logger__e>();
    List<Talemetry_Logger__c> taleLoggerList = new List<Talemetry_Logger__c>();
    Set<Id> closedJobIds = new Set<Id>(); // holds Job ids for any that have closed
    List<MFG_Reminder__c> rem = new List<MFG_Reminder__c>();    //holds list of Reminders to close
    Map<Id, SFDC_Job__c> MgrChangedJobMap = new Map<Id, SFDC_Job__c>();  // holds jobs for any that have had manager changes
    List<SFDC_Job_Candidate__c> jcUpd = new List<SFDC_Job_Candidate__c>();  // holds candidates that need updating
    Map<Id, SFDC_Job__c> Mgr_OwnerChangedJobMap = new Map<Id, SFDC_Job__c>();  // holds jobs for any that have had owner or manager changes
    List<SFDC_Candidate__c> canUpd = new List<SFDC_Candidate__c>();  // holds candidate records that need updating
    List<Id> JobsOutOfOpen = new List<Id>(); // holds job Ids that have moved out of Open/Active - to check for Duplicate jobs linked in
    List<Id> JobsClosed = new List<Id>(); // holds job Ids that have moved into a filled status - to check for Duplicate jobs linked in
    Map<string, string> OriginaltoCloned = new Map<string, string>();  // holds original job Num and cloned job Num for use when updating orig job
    Set<Id> JobOrdersForSummary = new Set<Id>(); // set of Job Order ids that need recalculation of total order amount
    Set<Id> closedOrCancelledJobIds = new Set<Id>(); // holds Job ids for any that have closed or been cancelled
    List<SFDC_Job_Candidate__c> jcUpdAudit = new List<SFDC_Job_Candidate__c>();  // holds candidates that need updating
    
    //ER: 00173264 --------------------------------------------------------------------------------------------------------
    // When a job closes or is cancelled we want any candidates being audited to be cancelled
    //find jobs closed or cancelled
    for (SFDC_Job__c j : trigger.new) {
        if (j.Job_Status__c.contains('Closed') || !String.isEmpty(j.Reason_for_Job_Cancellation__c)) {
           closedOrCancelledJobIds.add(j.id);
        }    
    }
          
    
    //find candidates in above jobs that still sit in awaiting audit status, set back to rejected...cancel audit
    if (!closedOrCancelledJobIds.isempty()) {
        for (SFDC_Job_Candidate__c jc : [SELECT id, SFDC_Job__c FROM SFDC_Job_Candidate__c 
                                         WHERE SFDC_Job__c IN :closedOrCancelledJobIds AND
                                               Status__c='Awaiting Replacement Adjudication']) {
            
            jc.Candidate_Audit_Result__c='Adjudication Not Required - Job Closed';
            jc.Status__c='Rejected';
            jcUpdAudit.Add(jc);
        }
    }    
    
    //update
    if (!jcUpdAudit.isempty()) {  
        update jcUpdAudit;
    }  
    //END ER: 00173264 --------------------------------------------------------------------------------------------------------
    
    // cycle through jobs to see if any have been Filled.  Also check if any have had Manager values change (Can/Job Can) or owner change (Can)
    for (SFDC_Job__c j : trigger.new) {
        if (j.Job_Status__c!=null && trigger.oldmap.get(j.id).job_status__c!=null)
        if (j.Job_Status__c.contains('Filled') && !trigger.oldmap.get(j.id).job_status__c.contains('Filled') || !trigger.oldmap.get(j.id).job_status__c.contains('Sent') && j.job_status__c.contains('Sent') )
            closedJobIds.add(j.id);
        if (j.X1st_Level_Manager__c <> trigger.oldmap.get(j.id).X1st_Level_Manager__c ||
            j.X2nd_Level_Manager__c <> trigger.oldmap.get(j.id).X2nd_Level_Manager__c ||
            j.X3rd_Level_Manager__c <> trigger.oldmap.get(j.id).X3rd_Level_Manager__c ||
            j.X4th_Level_Manager__c <> trigger.oldmap.get(j.id).X4th_Level_Manager__c ||
            j.X5th_Level_Manager__c <> trigger.oldmap.get(j.id).X5th_Level_Manager__c ||      
            j.X1st_Level_Access__c <> trigger.oldmap.get(j.id).X1st_Level_Access__c ||
            j.X2nd_Level_Access__c <> trigger.oldmap.get(j.id).X2nd_Level_Access__c ||          
            j.HR_User_Usual__c <> trigger.oldmap.get(j.id).HR_User_Usual__c) {
                MgrChangedJobMap.put(j.id, j);
                Mgr_OwnerChangedJobMap.put(j.id, j);
         }
         // if LTAS changed on the job, add to MgrChangedJobMap so we update the Job Candidate records
         if (j.ltas__c <> trigger.oldmap.get(j.id).ltas__c)
             MgrChangedJobMap.put(j.id, j);
         // here we check if the job owner changed and add it to the Mgr-OwnerChanged (will overwrite if already in there)
         // this will also push the new owners Manager field down    
         if (j.ownerid <> trigger.oldmap.get(j.id).ownerid) Mgr_OwnerChangedJobMap.put(j.id, j);
         // check if the status was Open/Active and is no longer
         if(trigger.oldmap.get(j.id).job_status__c!=null && j.job_status__c!=null)
         if (trigger.oldmap.get(j.id).job_status__c.startswith('Open/Active Job') && !j.job_status__c.startswith('Open/Active Job') && !j.job_status__c.contains('Sent') )
             JobsOutOfOpen.add(j.id);
          if(trigger.oldmap.get(j.id).job_status__c!=null && j.job_status__c!=null)
         if (!trigger.oldmap.get(j.id).job_status__c.contains('Filled') && j.job_status__c.contains('Filled')|| !trigger.oldmap.get(j.id).job_status__c.contains('Sent') && j.job_status__c.contains('Sent') )
             JobsClosed.add(j.id);  
         // check if this is a cloned job and the preview just flipped to false - we want to update original job with job ID now
        if (j.cloned_job_id__c != null && !j.job_preview_pending__c && trigger.oldmap.get(j.id).job_preview_pending__c)
            OriginaltoCloned.put(j.cloned_job_id__c, j.name);
        
        // check if job order link has changed - send in old and new job order for recalc
        if (j.job_order__c != trigger.oldmap.get(j.id).job_order__c) {
            if (j.job_order__c != null) JobOrdersForSummary.add(j.job_order__c);
            if (trigger.oldmap.get(j.id).job_order__c != null) JobOrdersForSummary.add(trigger.oldmap.get(j.id).job_order__c);
        }
        // or check if job order linked and job cost has changed
        else if (j.job_order__c != null && j.job_cost__c != trigger.oldmap.get(j.id).job_cost__c)
            JobOrdersForSummary.add(j.job_order__c);
    } // end loop through jobs
    
    // find all reminders that are not complete for these jobs, close and save them
    if (!closedJobIds.isempty()) {
        for (MFG_Reminder__c r : [select id, status__c from MFG_Reminder__c where SFDC_job__c in :closedJobIds and status__c <> 'Complete']) {
            r.status__c = 'Complete';
            rem.add(r);
        }
        // update reminders
        try {
            update rem;
        } catch (Exception e) {
            system.debug('Error updating Reminders: '+e);
        } // end try-catch block
    } // end if reminders to close
    
    // cycle through any Job Candidates that need Manager Changes or LTAS change
    if (!MgrChangedJobMap.isempty()) {
        for (SFDC_Job_Candidate__c jc : [select id, SFDC_Job__c, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, X4th_Level_Manager__c, X5th_Level_Manager__c, 
                                         HR_User_Usual__c, LTAS__c, sfdc_job__r.job_owner_link__r.managerid from SFDC_Job_Candidate__c where SFDC_Job__c in :MgrChangedJobMap.keyset()]) {
            SFDC_Job__c j = MgrChangedJobMap.get(jc.SFDC_Job__c);
            jc.X1st_Level_Manager__c = j.X1st_Level_Manager__c;
            jc.X2nd_Level_Manager__c = j.X2nd_Level_Manager__c; 
            jc.X3rd_Level_Manager__c = j.X3rd_Level_Manager__c;
            jc.X4th_Level_Manager__c = j.X4th_Level_Manager__c; 
            jc.X5th_Level_Manager__c = j.X5th_Level_Manager__c;
            jc.X1st_Level_Access__c = j.X1st_Level_Access__c;
            jc.X2nd_Level_Access__c = j.X2nd_Level_Access__c;
            jc.HR_User_Usual__c      = j.HR_User_Usual__c;
            jc.ltas__c               = j.ltas__c;
            jc.job_owner_manager__c  = jc.sfdc_job__r.job_owner_link__r.managerid;
            jcUpd.add(jc);
        } // end loop through candidates
        // if any JC need updating, do so now
        if (!jcUpd.isempty()) {
            try {
                update jcUpd;
            } catch (Exception e) {
                system.debug('Error updating Candidates: '+e);
            } // end try-catch block
        } // end if JC to update            
    } // end if Job Mgr changed

    // cycle through any Candidates that need Manager or Owner Changes
    if (!Mgr_OwnerChangedJobMap.isempty()) {
        for (SFDC_Job_Candidate__c jc : [select id, SFDC_Job__c, Candidate__r.X1st_Level_Manager__c, Candidate__r.X2nd_Level_Manager__c, Candidate__r.X3rd_Level_Manager__c, 
                                         Candidate__r.X4th_Level_Manager__c, Candidate__r.X5th_Level_Manager__c, Candidate__r.HR_User_Usual__c, candidate__c from SFDC_Job_Candidate__c where SFDC_Job__c in :Mgr_OwnerChangedJobMap.keyset()]) {
            SFDC_Job__c j = Mgr_OwnerChangedJobMap.get(jc.SFDC_Job__c);
            SFDC_Candidate__c can = new SFDC_Candidate__c(id = jc.candidate__c);
            can.ownerid = j.ownerid;
            can.store__c = j.store__c;
            can.parent_account__c = j.parent_account__c;
            can.X1st_Level_Manager__c = j.X1st_Level_Manager__c;
            can.X2nd_Level_Manager__c = j.X2nd_Level_Manager__c; 
            can.X3rd_Level_Manager__c = j.X3rd_Level_Manager__c;
            can.X4th_Level_Manager__c = j.X4th_Level_Manager__c; 
            can.X5th_Level_Manager__c = j.X5th_Level_Manager__c;  
            can.X1st_Level_Access__c = j.X1st_Level_Access__c; 
            can.X2nd_Level_Access__c = j.X2nd_Level_Access__c;          
            can.HR_User_Usual__c      = j.HR_User_Usual__c;
            canUpd.add(can);
        } // end loop through candidates
        // if any Candidates need updating, do so now
        if (!canUpd.isempty()) {
            try {
                update canUpd;
            } catch (Exception e) {
                system.debug('Error updating Candidate Records: '+e);
            } // end try-catch block
        } // end if Candidate to update            
    } // end if Job Mgr/Owner changed

    // see if any Jobs need Job Approved Date set
    Set<Id> jobs = new Set<id>();
    for (SFDC_Job__c j : trigger.new) {
        if (j.set_date_job_approved__c && !trigger.oldmap.get(j.id).set_date_job_approved__c)
            jobs.add(j.id);
    } // end loop 
    if (!jobs.isempty()) 
        Job_Util.updateJobApprovedDate(jobs);
        
    // if job status changed away from Open/active, call util to look for linked duplicate jbos
    if (JobsOutOfOpen.size() > 0)
        Job_Util.DuplicateJobNotificationsCheck(JobsOutOfOpen, 'ACTIVE');
    // if job status changed to Filled, call util to look for linked duplicate jbos
    if (JobsClosed.size() > 0)
        Job_Util.DuplicateJobNotificationsCheck(JobsClosed, 'FILLED');
    // if we have cloned jobs that were just previewed, call util to update original job
    if (!OriginaltoCloned.isempty()) 
        // call method to update the origially cloned jobs and with comments
        Job_Util.SetOriginalJobCommentswithClone(OriginaltoCloned);
    // call method to recalculate total order amount for job orders related to these jobs
    if (JobOrdersForSummary.size() > 0)
        job_Util.CalcJobOrderTotalAmt(JobOrdersForSummary);
    for (SFDC_job__c j : trigger.new) {
        
           //TalemetryGateway.calloutTalemetry(Trigger.NewMap.get(Trigger.New[0].Id), Trigger.OldMap.get(Trigger.New[0].Id), Trigger.New[0]);
         Talemetry_Logger__c tl=  TalemetryGateway.calloutTalemetry(j, Trigger.OldMap.get(j.Id), Trigger.NewMap.get(j.id));
        if(tl<> null){
            taleLoggerList.add(tl);
        }
    }
    if(!taleLoggerList.isEmpty()){
        Database.UpsertResult[] results = Database.upsert( taleLoggerList, Talemetry_Logger__c.Job_Id__c.getDescribe().getSObjectField() ,false ) ;

    }
}