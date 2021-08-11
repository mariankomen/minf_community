/*******************
  Trigger: Job_Candidate_BeforeInsertUpdate
  Purpose: This trigger updates the record name to a more user friendly name
          using the Job's Name and Candidate's Last name.  Also sets the Sent By Lookup based on a matching
          user with Sent By name and Manager user fields based on parent Job record.

  Created: Aug 23/09 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
        Feb 8/11: added Sent By User lookup logic
        Feb 12/11: added Manager user setting for new JC records
        June 6/11: added Recruiter Summary field setting from Candidate Record on insert only
        June 23/11: added call to Blacklist Matching util method
        Nov 7/11: added setting new Candidate Email field from related Candidate
        Nov 15/11: added Manager 4/5 setting
        Jan 19/12: added copying LTAS from Job to Candidate for workflow purposes
        Jun 10/12: added copying Job owner link.manager to Candidate for workflow
        Aug 11/12: for insert, default candidate status to Initial Applicant if job SLA = Job Posting Only
        Apr 27/13: add logic to copy Job External alert email
        Apr 25/14: add logic to set points allocation field upon creation
        
*********************/
trigger Job_Candidate_BeforeInsertUpdate on SFDC_Job_Candidate__c (before insert, before update) {
/*    List<SFDC_Job_Candidate__c> SentByJC = new List<SFDC_Job_Candidate__c>();  // track candidates that need the Sent by User lookup set
    Set<string> sentby = new Set<string>();  // tracks unique list of Sent By names for lookup
    List<SFDC_Job_Candidate__c> NewJC = new List<SFDC_Job_Candidate__c>();  // track new candidates that need the Manager User lookups set and other processing
    Set<Id> NewJC_JobIds = new Set<Id>();  // holds job ids for any newly inserted JC
    Set<Id> CanRecIds = new Set<Id>(); // holds candidate record ids for all newly inserted JC

    
    // cycle through Candidate records to set the name field, also if insert or Sent By has changed, add to a list for a lookup
    for (SFDC_Job_Candidate__c jobcan : trigger.new) {
    
        //Interview Scheduler ----------------------------------------------------------------------------------------------------
        //finds candidate interview match and gets interview date
        if(trigger.isinsert) { 
            DateTime interviewStartDate = Interview_Scheduler_Util.FindCandidateInterviewByEmailAndJobIdAndReturnStartDate(jobcan.Email__c, jobcan.SFDC_Job__c);
            if(interviewStartDate != null) {
                jobcan.Scheduled_Interview_Date_Time__c = interviewStartDate;
            }
        }
        //END Interview Scheduler ----------------------------------------------------------------------------------------------------
    
        //New Service Model ----------------------------------------------------------------------------------------------------
        //set date candidate rejected field, part of new service model
        if (jobcan.Status__c=='Rejected' && (trigger.isinsert || (trigger.isupdate && jobcan.Status__c <> trigger.oldmap.get(jobcan.id).Status__c))) {
            //only fill in first time it gets rejected, we could have case where gets rejected but then triggers audit
            //then after audit sets rejection agian....we don't want to overrite date at this time
            if(jobcan.Datetime_Candidate_Rejected__c == null) {  
                jobcan.Datetime_Candidate_Rejected__c=datetime.now();
            }    
        }
        //////////////////////////////////////////////////////////////
        
        //set date candidate hired field, part of new service model
        if (jobcan.Status__c=='Hired' && (trigger.isinsert || (trigger.isupdate && jobcan.Status__c <> trigger.oldmap.get(jobcan.id).Status__c))) {
            if(jobcan.Datetime_Candidate_Hired__c== null) { //only fill in first time it gets hired
                jobcan.Datetime_Candidate_Hired__c=datetime.now();
            }  
            //Enhancement Request (00160600)
            if(jobcan.Revenue_Earned__c == null || jobcan.Revenue_Earned__c == 0) {
                //try to get this as long as candidate hired and revenue is empty
                jobcan.Revenue_Earned__c = NewServiceModel_Util.FindTargetVolumePrice(jobcan.SFDC_Job__c, jobcan.Datetime_Candidate_Hired__c, (jobcan.SFDC_Job__r.Record_Type_Developer_Name__c=='FGL_Sports'));  
            }    
        }
        //////////////////////////////////////////////////////////////
        
        //NSM-------------------------------------------------------------------------------------------------------------
        //   Cls_Dt_Wthn_Time_to_Disposition_Period__c and Rjt_Dt_Wthn_Time_to_Disposition_Period__c are formula fields.
        //   We need to do a rollups on these values at the job level....however SF does not allow this.
        //   So instead we push the values into TtoDP_Rejection_Hires__c and TtoDP_Valid_Rejection __c and do rollup on them.
        //Jan 29, 2018 - update so pushes value in all the time
        //July, 2018 - remove this from trigger. (changes in formula field not being caught)
        //Instead move to workflows/field updates
        // - Candidate within Disposition - True
        // - Candidate within Disposition - False
        // - Candidate within Disposition Rjct - True
        // - Candidate within Disposition Rjct - False
        
        
        //sets picklist value to either Yes or No.
        //This is a related list that will drive what rejection reason options are selectable on CE page
        //jobcan.Using_New_Service_Model_Rejection_Reason__c = jobcan.Using_New_Service_Model__c ? 'Yes' : 'No';
        
        
        //END New Service Model ----------------------------------------------------------------------------------------------------
    
        jobcan.Name = (jobcan.job_id__c == null ? '' : 'Job#' + jobcan.job_id__c+' - ') + (jobcan.candidate_last_name__c == null ? '' : jobcan.candidate_last_name__c);
        // if this is an insert or the Sent by field changed, track it so we can update the Sent By lookup
        if (trigger.isinsert || jobcan.Sent_By__c <> trigger.oldmap.get(jobcan.id).Sent_By__c ) {
            SentByJC.add(jobcan);
            sentby.add(jobcan.sent_by__c);
        } // end if sent by needed
        // if this is an insert, add related JobId to set so we can set manager and LTAS flds, also
        if (trigger.isinsert) {
            NewJC.add(jobcan);
            NewJC_JobIds.add(jobcan.sfdc_job__c);
            CanRecIds.add(jobcan.candidate__c);
        } // end if insert
    } // end loop
    
    // Manage Sent By Lookup field 
    if (!SentByJC.isempty()) {
        // look in User table for matching user fullnames and build map
        Map<string, Id> sentbyMap = new Map<string, Id>();
        for (User u : [select id, name from user where name in :sentby]) {
            sentbyMap.put(u.name, u.id);
        } // end loop through users to build map
        // now cycle through candidates that need the value set
        for (SFDC_Job_Candidate__c jobcan : SentByJC) {
            // if there is a match, set it
            if (sentbyMap.containskey(jobcan.sent_by__c)) jobcan.sent_by_lookup__c = sentbyMap.get(jobcan.sent_by__c);
            // if no match,  null out value
            else jobcan.sent_by_lookup__c = null;
        } // end loop through cans that need lookup set
    } // end if need to manage sent by lookup
    
    /// Set Manager(s), LTAS, job owner manager fields if needed, also default status based on job sla 
    // goes in here for insert only
    if (!NewJC_JobIds.isempty()) {
        // build map of Job Id to Job to get mgr fields
        Map<Id, SFDC_Job__c> JobMap = new Map<Id, SFDC_Job__c>([select id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, recordtypeID,
                                         X4th_Level_Manager__c, X5th_Level_Manager__c, HR_User_Usual__c, ltas__c, X1st_Level_Access__c,X2nd_Level_Access__c, job_owner_link__r.managerid, sla_level__c,
                                          external_alert_email_address__c from SFDC_Job__c where id in :NewJC_JobIds]);
        // cycle through new JC that need mgr fields and populate from map
        for (SFDC_Job_Candidate__c jc :  NewJC ) {
            if (JobMap.containskey(jc.sfdc_job__c)) {
                SFDC_Job__c j = JobMap.get(jc.sfdc_job__c);
                jc.X1st_Level_Manager__c = j.X1st_Level_Manager__c;
                jc.X2nd_Level_Manager__c = j.X2nd_Level_Manager__c; 
                jc.X3rd_Level_Manager__c = j.X3rd_Level_Manager__c;
                jc.X4th_Level_Manager__c = j.X4th_Level_Manager__c; 
                jc.X5th_Level_Manager__c = j.X5th_Level_Manager__c;
                jc.X1st_Level_Access__c = j.X1st_Level_Access__c; 
                jc.X2nd_Level_Access__c = j.X2nd_Level_Access__c;
                jc.HR_User_Usual__c      = j.HR_User_Usual__c;
                jc.ltas__c               = j.ltas__c;
                jc.job_owner_manager__c  = j.job_owner_link__r.managerid;
                jc.external_alert_email_address__c = j.external_alert_email_address__c;
                // also check job sla, if Job Posting Only, change candidat status to initial candidate
                if (j.sla_level__c == 'Job Posting Only' && j.recordtypeID != '012U0000000A2vi')
                    jc.status__c = 'Initial Applicant';
            } // end if job is in map
        } // loop through JC
    } // end if need to set mgr flds

    // Set Candidate Recruiter Summary and Email field on insert 
    // also push candidates through method to find/set points allocation 
    if (!CanRecIds.isempty()) {
        // build map of candidate Id to Candidate to get summary and email field
        Map<Id, SFDC_Candidate__c> CanMap = new Map<Id, SFDC_Candidate__c>([select id, recruiter_summary_on_candidate__c, SFDC_Candidate_Email__c from SFDC_Candidate__c where id in :CanRecIds]);
        // cycle through JC in trigger and populate summary, email field from map
        for (SFDC_Job_Candidate__c jc :  trigger.new) {
            if (CanMap.containskey(jc.candidate__c)) {
                jc.recruiter_summary_on_candidate__c = CanMap.get(jc.candidate__c).recruiter_summary_on_candidate__c;
                jc.candidate_email_address__c = CanMap.get(jc.candidate__c).SFDC_Candidate_Email__c;
            } // end if can rec is in map
        } // loop through JC
        Job_Util.SetCandidatePointsAllocation(NewJC);
    } // end if need to set summary field
    
    // Handle Blacklist Logic on insert 
    if (trigger.isinsert)
        Job_Util.BlacklistCandidateCheck(trigger.new);
*/        
}