/****************************
    Trigger: Job_BeforeInsertUpdate
    Purpose: This trigger calls a utility that sets the Job Opened Date to be 6am Pacific the next business day for
        all new Jobs.  For new or updated jobs, set the job owner link to the job's owner id.  Also reassign Jobs to
        new owners if it matches a Job Owner Reference record.  After all processing for updates, run logic to 
        determine whether a Job can be posted online through duplicate/confidential job checking.  After this run auto
        approvals submission based on the checkbox

    Created: Mar 30/10 by Niki Vankerk, Vankerk Solutions, Inc
    Modification Log:
        May 28/10: Niki Vankerk. Set job owner link to be the new jobs owner for formula purposes
        July 17/10: Niki Vankerk.  Added lookup in Reference table to find new job owner
        Sept 14/10: Niki Vankerk.  Added OFG Rec Type/Dept Code reference in new job owner lookup logic
        Jan 29/11: Niki Vankerk.  Add logic to handle Duplicate/Confidential jobs during the first Update call on a Job.
        Feb 9/11: Niki Vankerk. Add logic to submit jobs for approvals during initial update and set approver user links when Job owner is set
        Feb 12/11: Niki Vankerk. Add logic to set manager links when Job owner is set/changed
        Feb 13/11: Niki Vankerk. Added logic to set the store challenges field when job owner is set/changed for a portal user
        Mar 13/11: Niki Vankerk. Added logic to set the Store requires unique job postings for Duplicate/Confidential jobs
        Apr 25/11: Niki Vankerk. Added logic to set the Store requires confidential job postings for Duplicate/Confidential jobs
        Aug 25/12: Niki Vankerk. Added logic to push first time jobs into Job Workflow for default setting, and manage clearing checkbox in this code
        Sept 1/12: Niki Vankerk. Move Account Store Hours to job along with managers/approvers
        Jan 27/13: NV. Added logic to move Account's Parent Account/Other Related Account fields into job with new owner
        Mar 21/13: NV. Changed order of Dup Check and Job Workflow methods so Dup Check runs afterwards
        Apr 27/13: NV.  Added logic to copy store external email address down and removed logic for Other Related Account from Store record
        June 15/13: NV.  Added Mgr 1/2/3/4/5 Type from store to Job
        Sept 19/13: NV. changed parent account to use account if no parent is set; strip HTML from job desc and candidate reqt fields
        Oct 24/13: NV. set new chart job title field at end of other job updates; used for grouping aggregate queries as charting groups on formula fields not supported
        Nov 1/13: NV. added logic to populate job desc and job preview pending if we have a match with job title
        Jul 30/14: GB. Added 4th level approver for PPG
        Mar 11/15: NV. Add logic to reset Job Added Date and rerun dup check if the Job Added Date is cleared, triggered by Job ORder completed
        
****************************/ 
trigger Job_BeforeInsertUpdate on SFDC_Job__c (before insert, before update) {

    if(trigger.isUpdate && !Job_BeforeInsertUpdate_Helper.isFirstTime(trigger.New)){
        return;
    }
    // initiate Job Util class for helper functions
    Job_Util myUtil = new Job_Util();

    //check for OFG sourcing duplicates //////////////////////////////////////////////////////
    User[] uList = [SELECT Contact.Account.Id FROM User WHERE Id =:UserInfo.getUserId()];
    if (uList.size() > 0) {
        for (SFDC_Job__c j : Trigger.new) {
            if(trigger.isinsert && j.Record_Type_Developer_Name__c=='OFG_Sourcing' && uList[0].Contact.Account.Id != null) {
                if(myUtil.CheckForDuplicateOFGSourcing(j, uList[0].Contact.Account.Id)) {
                    j.addError('A job title for this store already exists. Either change the job title or cancel this job.');
                }
        }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////


    // all new jobs get the Job Added date set and reassignment logic is run
    if (trigger.isinsert) {
       
        // pass all new Jobs into utility method to set the Job Added/Created Date
        myUtil.SetJobAddedDate(trigger.new, datetime.now());
        //system.debug('end of Job insert trigger with : '+trigger.new);
        // now pass new jobs to utility method to see if jobs need reassignment
        myUtil.JobReassignment(trigger.new);
    }

    // now set the associated Contact/Store links for a job
        // on insert: now that we have the proper owner, set the associated Contact and Account (Store) link for each
        //    set of ownerids to query; 
        // on update: if the owner changed, update the Contact/Account links and Approvers/Managers
    Set<id> ownerIds = new Set<Id>();
    for (SFDC_Job__c j : Trigger.new) {
        if (trigger.isInsert || (trigger.isUpdate && j.ownerid <> trigger.oldmap.get(j.id).ownerid) )
            ownerIds.add(j.ownerid);
    }
    // query for related contact and account ids
    Map<id, User> Users = new Map<id, User>();
    // if we have anything to update, query now for relevant fields, including Approvers (from user) and Managers (from store)
    //   and store challenge fields
    if (!ownerids.isempty())
        Users = new Map<id, User>([select id, contactid, contact.accountid, contact.account.no_posting_allowed__c, contact.account.unique_job_posting_required__c,
            contact.account.Confidential_Job_Posting_Required__c, job_approver_1__c,job_approver_2__c, job_approver_3__c, job_approver_4__c, HR_User_Approver__c, contact.account.X1st_Level_Manager__c, 
            contact.account.X2nd_Level_Manager__c, contact.account.X3rd_Level_Manager__c, contact.account.X4th_Level_Manager__c, contact.account.X5th_Level_Manager__c, contact.account.HR_User_Usual__c, contact.account.X1st_Level_Access__c,contact.account.X2nd_Level_Access__c,
            contact.account.X1st_Level_Manager_type__c, contact.account.X2nd_Level_Manager_type__c, contact.account.X3rd_Level_Manager_type__c, contact.account.X4th_Level_Manager_type__c, contact.account.X5th_Level_Manager_type__c, 
            contact.account.Special_Challenges_for_Store1__c, contact.account.Special_Challenges_Comments__c, contact.account.Special_Wage_Comments__c, contact.account.Transit_Accessibility_Issues__c,
            contact.account.Store_HM_Area_Comments__c, contact.account.Store_hours__c, contact.account.parentid, contact.account.external_alert_email_address__c,
            contact.account.Client_Profile__r.Current_Contract__r.id, contact.account.parent.Client_Profile__r.Current_Contract__r.id,
            contact.account.Max_HM_Availability__c
            from User where id in :ownerids]);

    // create list of Jobs that need first-time updates for dup/confidential checking run
    List<SFDC_Job__c> processFirstTimeUpdates = new List<SFDC_Job__c>();
    // create list of Jobs that need to be submitted for approvals processing
    List<SFDC_Job__c> submitJobs = new List<SFDC_Job__c>();    
    Set<Id> submitJobIds = new Set<Id>();
    // list of Jobs inserted and assigned to a portal contact so we can count other open Candidates for the same store
    List<SFDC_Job__c> NewPortalOwnedJobs = new List<SFDC_Job__c>();
    // list of jobs updated with blank Date Job Added/Opened so we can reset
    List<SFDC_Job__c> resetDateJobAdded = new List<SFDC_Job__c>();
    
    // cycle through jobs to set contact/store links, set Job Owner link and determine if jobs need first-time updates run
    for ( SFDC_Job__c j : Trigger.new) {
       // if we have a record in Users for this owner, replace contact and account, mgr/approvers and store comments
       if (Users.containskey(j.ownerid)) {
           User u = Users.get(j.ownerid);
           j.contact__c = u.contactid;
           j.store__c = u.contact.accountid;
           // set parent account from users store's parent account unless there isn't one, then use store here
           j.parent_account__c = (u.contact.account.parentid != null ? u.contact.account.parentid : u.contact.accountid);
           if(j.Job_Description__c == ''){
           j.job_Description__c = j.Job_Description_ID__r.Job_Description__c;
           }
           //----------------------------------------------------------------------------------------------------------------
           //Enhancement Request - 00160600
           //Hook in the contract assocaited with the client profile if exists.
           if(j.Contract__c == null) { //only grab if not already put in
               if(u.contact.account.parent.Client_Profile__r.Current_Contract__r.id != null) { //try to get from parent account first
                   j.Contract__c = u.contact.account.parent.Client_Profile__r.Current_Contract__r.id;
               } else if(u.contact.account.Client_Profile__r.Current_Contract__r.id != null) { //else try to get from store
                   j.Contract__c = u.contact.account.Client_Profile__r.Current_Contract__r.id; 
               }
           }
           //----------------------------------------------------------------------------------------------------------------
            
           if(j.Record_Type_Developer_Name__c != 'Sporting_Life' && u.contact.account.external_alert_email_address__c != null || j.Record_Type_Developer_Name__c == 'Sporting_Life' && j.Manager_Emails__c == null && u.contact.account.external_alert_email_address__c != null) 
             {
               j.Store_Email_Address__c = u.contact.account.external_alert_email_address__c;
             }
           // on insert only, set the online posting settings from the current Store
           if (trigger.isinsert) {
               j.store_doesnt_allow_posting__c = u.contact.account.no_posting_allowed__c;
               j.store_requires_unique_job_posting__c = u.contact.account.unique_job_posting_required__c;
               j.store_requires_confidential_job_posting__c = u.contact.account.confidential_job_posting_required__c;
               
               //check if we have at least 30 days of interviews scheduled in the system
               //Couldn't do formula because ran into relation constraint.
               if(u.contact.account.Max_HM_Availability__c!=null) {
                   Datetime dtMax = u.contact.account.Max_HM_Availability__c.addDays(-30);
                   Date dMax = date.newinstance(dtMax.year(), dtMax.month(), dtMax.day());
                   j.Interview_Availability_for_Next_30_Days__c = dMax >= system.today();
               }   
               
          }
           // set the approver fields with the new portal user approvers
           j.approver_1__c = u.job_approver_1__c;
           j.approver_2__c = u.job_approver_2__c;
           j.approver_3__c = u.job_approver_3__c;
           j.approver_4__c = u.job_approver_4__c;
           j.HR_User_Approver__c = u.HR_User_Approver__c;
           // set the manager fields with new portal user store settings
           j.X1st_Level_Manager__c = u.contact.account.X1st_Level_Manager__c;
           j.X1st_Level_Manager_type__c = u.contact.account.X1st_Level_Manager_type__c;
           j.X2nd_Level_Manager__c = u.contact.account.X2nd_Level_Manager__c; 
           j.X2nd_Level_Manager_type__c = u.contact.account.X2nd_Level_Manager_type__c; 
           j.X3rd_Level_Manager__c = u.contact.account.X3rd_Level_Manager__c;
           j.X3rd_Level_Manager_type__c = u.contact.account.X3rd_Level_Manager_type__c;
           j.X4th_Level_Manager__c = u.contact.account.X4th_Level_Manager__c; 
           j.X4th_Level_Manager_type__c = u.contact.account.X4th_Level_Manager_type__c; 
           j.X5th_Level_Manager__c = u.contact.account.X5th_Level_Manager__c;
           j.X5th_Level_Manager_type__c = u.contact.account.X5th_Level_Manager_type__c;
           j.X1st_Level_Access__c = u.contact.account.X1st_Level_Access__c;
           j.X2nd_Level_Access__c = u.contact.account.X2nd_Level_Access__c;
           j.HR_User_Usual__c = u.contact.account.HR_User_Usual__c;
           // set the store comments/challenges/hours field
           string storecomments;
           storecomments = (u.contact.account.Store_HM_Area_Comments__c != null ? 'Store HM/Area Comments:\n' + u.contact.account.Store_HM_Area_Comments__c + '\n\n' : '') +
                (u.contact.account.Special_Challenges_for_Store1__c != null ? 'Special Challenges for Store:\n' + u.contact.account.Special_Challenges_for_Store1__c + '\n\n'  : '') + 
                (u.contact.account.Special_Challenges_Comments__c != null ? 'Including these other challenges - '+u.contact.account.Special_Challenges_Comments__c + '\n\n'  : '' ) +
                (u.contact.account.Transit_Accessibility_Issues__c != null ? 'Transit/Accessibility Issues:\n' + u.contact.account.Transit_Accessibility_Issues__c + '\n\n'  : '') +
                (u.contact.account.Special_Wage_Comments__c != null ? 'Special Wage Comments:\n' + u.contact.account.Special_Wage_Comments__c : '');
           j.Store_CommentsChallenges__c = (storecomments.length() >= 32000 ? storecomments.substring(0,31999) : storecomments);
           j.store_hours__c = u.contact.account.store_hours__c;
       } // end if replacing contact/account
       // set the Job Owner Link to always reflect the job's ownerid
       j.job_owner_link__c =  j.OwnerId;
       // if insert or cand reqts changed to not null, clean HTML out
        if (j.candidate_requirements__c != null && (trigger.isinsert || (trigger.isupdate && j.candidate_requirements__c != trigger.oldmap.get(j.id).candidate_requirements__c )) ) {
           j.candidate_requirements_original__c = j.candidate_requirements__c;
           j.candidate_requirements__c = job_util.CleanHTMLField(j.candidate_requirements__c);
        }
       // if insert or job desc changed to not null, clean HTML out
       if (j.job_description__c != null && (trigger.isinsert || (trigger.isupdate && j.job_description__c != trigger.oldmap.get(j.id).job_description__c )) ) {
           j.job_description_original__c = j.job_description__c;
            j.job_description__c = job_util.CleanHTMLField(j.job_description__c);
        }          
       // check if this job should be sent into the first-time update processing for dup/confidential checking and field defaulting
       if (trigger.isupdate && j.Force_First_Time_Update__c)  {
           processFirstTimeUpdates.add(j);
           // reset first run boolean on job so we don't go through it again
           j.Force_First_Time_Update__c = false;
       }
       // check if this job should be sent to approvals processing
       if (trigger.isupdate && j.auto_submit_job_for_approvals__c) {
           submitJobIds.add(j.id);
           // reset the flag to false so we don't resubmit in the future
           j.auto_submit_job_for_approvals__c = false;
       }

       // check if this job needs Date Job Added reset after it was cleared (if related Job Order is completed we want to reset this date)
       //  and also then runs dup check again
       if (trigger.isupdate && j.Date_Job_Added_or_Opened__c == null)  {
           resetDateJobAdded.add(j);
       }
        
       // if inserting, check for job clone fields and set comments to indicate it came from another job
       //    NOTE: here we are always using text that indicates a Rejected job caused this clone.  If we have other occasions to clone in this 
       //    manner we will need to indicate a clone reason field as well.
       //    This is currently being set by the UpdateCandidate page when all candidates are rejected - done by portal user so language translations will work
       if (trigger.isinsert && j.cloned_Job_id__c != null) {
           // the clone fields will be nulled out during the after Insert trigger so leave them here
           j.Job_Comments__c = (j.Job_Comments__c != null ? j.Job_Comments__c+'\n' : '') + Label.Job_Comment1+': '+j.cloned_Job_id__c+' '+Label.Job_Comment2;
       }
       
       // if inserting and job's store contact is set (portal owned) add this job to the list for calculating number of open candidates for same store
       if (trigger.isinsert && j.contact__c != null)
           NewPortalOwnedJobs.add(j);
    } // end loop through jobs
    
    // if there are any jobs to be processed for their fist time updates, send them now
    if (!processFirstTimeUpdates.isempty()) {
        Job_Workflow.SetJobDefaults( processFirstTimeUpdates );
        // run dup check after the job defaults since we have some matching based on fields that are set in the job defaults method
        myUtil.DupConfCheck( processFirstTimeUpdates );
        myUtil.SetDefaultsSpecificCandidateRequested( processFirstTimeUpdates );
    }

    // if there are any jobs to be submitted, send them now in async call since approvals
    //    may cause further updates to the Job record
    if (!submitJobIds.isempty()) Job_Util.SubmitForApproval( submitJobIds );
    
    // if there are New portal owned jobs, count open candidates now
    if (NewPortalOwnedJobs.size() > 0) {
        Job_Util.SetNumOpenCandidates(NewPortalOwnedJobs);
        // send jobs to set Job Description and preview checkbox
        Job_Util.SetJobDescription(NewPortalOwnedJobs);
    }

    // if there are any jobs that had the job added date reset after Job Order was completed, call date reset and rerun dup check
    if (!resetDateJobAdded.isempty()) {
        myUtil.SetJobAddedDate( resetDateJobAdded, datetime.now() );
        myUtil.DupConfCheck(resetDateJobAdded);
    }
    
    // one more cycle through jobs to populate chart job title field - in case the job title was changed in any of the updates above
    for (SFDC_Job__c j : trigger.new) {
        j.chart_job_title__c = (j.Job_Role_Title__c != null ? j.Job_Role_Title__c :
            (j.Job_Title_for_Banner__c != null ? j.Job_Title_for_Banner__c :
                ( j.Job_Title_for_Role__c != null ? j.Job_Title_for_Role__c :
                    ( j.OWF_Job_Title__c != null ? j.OWF_Job_Title__c : '') ) ) );

    }
    
         for (SFDC_Job__c j : trigger.new) {
      if (j.minimum_hours__c != null){
           j.FT_or_PT__c = j.Full_Time_Part_Time__c;          
           j.Number_Of_Hours_Per_Week__c = 'Not needed for Community'; 
           j.Hours_of_Availability__c = 'Not needed for Community';
        
        }  
       } 
       
}