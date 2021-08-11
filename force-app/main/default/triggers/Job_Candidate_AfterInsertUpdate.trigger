/**************************************
  Trigger: Job_Candidate_AfterInsertUpdate
  Purpose: This trigger creates a Reminder for the store to update each Candidate submitted to job and also changes the Candidate__c
      owner to match the most recently linked Job's owner
          After Insert: if status = Qualified Candidate, create reminder for 5 days out.  Change linked Candidate__c owner/mgr/hr user to match linked Job__c owner if active.
          After Update: 
              1. if status changes from Qualified to something else, close any open "Initial Update" reminders
              2. if status changes to Interviewing with a non-null date, create reminder for interview date + 1
              3. if the non-null interview date changes to another non-null date, first close any open "Interview" reminders
                  and then create a new "Interview" reminder for new date + 1
              4. if status changes from Interview to something else, close any open "Interview" reminders

  Dependency: This trigger uses a utility method to create the Reminder, passing a list of Job Candidate records and
              whether it is an insert or update.

  Created: Aug 23/09 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
      May 7/10: Niki Vankerk.  Added auto close of Reminders for Interview/Initial Update type reminders
      July 13/10: Niki Vankerk.  Added new "Interviewing" type status so made the comparison below a Contains instead of Equals
      Aug 30/10: Niki Vankerk.  Added Candidate owner change functionality into After Insert
      Feb 28/11: Niki Vankerk.  Added logic to grab the Job Owner's Store's Mgr 1/2/3 and HR User to set for Candidate on Insert
      Nov 15/11: Niki Vankerk.  Added logic for Mgr 4/5 as well
      Jan 25/12: Niki Vankerk.  Added logic to keep Can Record's Background Check URL updated after update
      Apr 9/12: Niki Vankerk. Added logic to copy SLA Level from Job to Can Rec
      Apr 14/12: Niki Vankerk. Added logic to copy Job Specific Can Req and scheduled interview date to Candidate Rec.
      Jan 27/13: NV. Added logic to copy job's store, parent account and other related account
      Apr 30/13: NV. Removed logic for other related account field.
      June 6/13: NV.  Added logic to copy job's record type and job owners parent account to Candidate Record
      June 24/13: NV.  Added Job link to Can. Rec on insert
      July 2/13: NV. for insert, always update Candidate record with new job details, not just if owner is now different
      July 18/13: NV. change to Display Name to replace Husaro with Mr Lube.
      Oct 16/13: updated parent account setting to use the job parent account rather than going through the store field to get the parent there.
      
**************************************/
trigger Job_Candidate_AfterInsertUpdate on SFDC_Job_Candidate__c (after insert, after update) {
  /*  // list of JCs that will be sent to CreateReminder function for Interview/Update Reminder
    //List<SFDC_Job_Candidate__c> jcs_new = new List<SFDC_Job_Candidate__c>();
    // list of JCs that will be sent to CloseReminder function for Initial
    List<SFDC_Job_Candidate__c> jcs_cls_initial = new List<SFDC_Job_Candidate__c>();
    // list of JCs that will be sent to CloseReminder function for Interview
    List<SFDC_Job_Candidate__c> jcs_cls_interview = new List<SFDC_Job_Candidate__c>();
    // list of JCs that will be sent to CloseReminder function for Message
    List<SFDC_Job_Candidate__c> jcs_cls_msg  = new List<SFDC_Job_Candidate__c>();
    // list of JCs that will be sent to CreateReminder function for Message
    List<SFDC_Job_Candidate__c> jcs_add_msg = new List<SFDC_Job_Candidate__c>();
    // list of Candidate records that need updating
    Map<Id, SFDC_Candidate__c> cans = new Map<Id, SFDC_Candidate__c>();
   

    // build map for use in job owner comparison so that we don't have to make sure our for loop query includes any and all fields
    //    needed in the rest of the trigger ie. CreateReminder utility
    Map<Id, SFDC_Job_Candidate__c> jcmap = new Map<id, SFDC_Job_Candidate__c>([select id, status__c, phone_number__c, sfdc_job__c, sfdc_job__r.ownerid, sfdc_job__r.owner.isactive, 
        sfdc_job__r.job_owner_link__r.contact.account.parent.name, sfdc_job__r.recordtype.name, sfdc_job__r.Banner_of_Store__c, sfdc_job__r.owf_Banner_of_Store__c,
        sfdc_job__r.job_owner_link__r.contact.account.name, candidate__c, candidate__r.ownerid, candidate__r.name, sfdc_job__r.x1st_level_manager__c, sfdc_job__r.x2nd_level_manager__c,
        sfdc_job__r.x3rd_level_manager__c, sfdc_job__r.x4th_level_manager__c, sfdc_job__r.x5th_level_manager__c, sfdc_job__r.hr_user_usual__c, 
        candidate__r.x1st_level_manager__c, candidate__r.x2nd_level_manager__c, candidate__r.x3rd_level_manager__c, candidate__r.x4th_level_manager__c, 
        candidate__r.x5th_level_manager__c, candidate__r.hr_user_usual__c, Background_Check_Results_URL__c, candidate__r.Background_Check_Results_URL__c,
        sfdc_job__r.sla_level__c, sfdc_job__r.Specific_Candidate_Preference__c, sfdc_job__r.store__c, sfdc_job__r.parent_account__c, sfdc_job__r.X1st_Level_Access__c, sfdc_job__r.X2nd_Level_Access__c,sfdc_job__r.Specific_Candidate_Phone_Number__c,sfdc_job__r.Specific_Candidate_Name__c from SFDC_Job_Candidate__c where id in :trigger.new]);
                
    // after insert processing:
    if (trigger.isInsert) {
        // cycle through records to check the status - we want to add a reminder for any new JC that is Qualified Candidate status
        // also update related Candidate record with new 'most recent job' and other settings based on the new job it is now linked to
        for (SFDC_Job_Candidate__c jc : trigger.new) {
            // grab data base values for this Job Candidate
            SFDC_Job_Candidate__c tempJC = jcmap.get(jc.id);
            //if (jc.Status__c == 'Qualified Candidates') jcs_new.add(jc);
            // pull up related Candidate and populate fields from linked Job
            SFDC_Candidate__c c;
            // check if we already have an update for this candidate and overwrite if we do
            if (cans.containskey(tempJC.candidate__c))
                c = cans.get(tempJC.candidate__c);
            else
                c = new SFDC_Candidate__c(id = tempJC.candidate__c);
            // change the candidate owner only if we have a new active owner for the JC, otherwise this will fail
            if (tempJC.sfdc_job__r.owner.isactive) c.ownerid = tempJC.sfdc_job__r.ownerid;
            // set the manager fields as well
            c.x1st_level_manager__c = tempJC.sfdc_job__r.x1st_level_manager__c;
            c.x2nd_level_manager__c = tempJC.sfdc_job__r.x2nd_level_manager__c;
            c.x3rd_level_manager__c = tempJC.sfdc_job__r.x3rd_level_manager__c;
            c.x4th_level_manager__c = tempJC.sfdc_job__r.x4th_level_manager__c;
            c.x5th_level_manager__c = tempJC.sfdc_job__r.x5th_level_manager__c;     
            c.X1st_Level_Access__c = tempJC.sfdc_job__r.X1st_Level_Access__c;
            c.X2nd_Level_Access__c = tempJC.sfdc_job__r.X2nd_Level_Access__c;           
            c.hr_user_usual__c = tempJC.sfdc_job__r.hr_user_usual__c;
            // set store and related account fields
            c.store__c = tempJC.sfdc_job__r.store__c;
            c.parent_account__c = tempJC.sfdc_job__r.parent_account__c;
            // move various fields from Job/Candidate to Can Rec
            c.sla_level__c = tempJC.sfdc_job__r.sla_level__c; 
            
            string reqNum = string.valueOf(tempJC.sfdc_job__r.Specific_Candidate_Phone_Number__c );
            string canNum = string.valueOf(tempJC.Phone_Number__c);
            if(reqnum != null)
                reqnum = trimPhone(reqnum);
                
            if(canNum != null)
                canNum = trimPhone(canNum);
            
            string reqName = string.valueof(tempJC.sfdc_job__r.Specific_Candidate_Name__c);
            string canName = string.valueOf(tempJC.Candidate__r.name);
                
            if(reqNum == canNum || reqName == canName){
                c.Specific_Candidate_requested__c = tempJC.sfdc_job__r.Specific_Candidate_Preference__c;
            }
            ELSE{
                c.Specific_Candidate_requested__c = 'No';
            }
            
            
            
            c.scheduled_interview_date_time__c =  jc.scheduled_interview_date_time__c; 
            // use banner of store if populated, else store parent account
            string displayName = tempJC.sfdc_job__r.banner_of_store__c;
            if (displayName == null || displayName == '') displayName = tempJC.sfdc_job__r.owf_banner_of_store__c;
            if (displayName == null || displayName == '') displayName = tempJC.sfdc_job__r.job_owner_link__r.contact.account.parent.name;
            // if we ended up with Husaro in the display name or in the contacts account name, replace with Mr. Lube Husaro
            if ((displayName != null && displayName.contains('Husaro')) || 
               (tempJC.sfdc_job__r.job_owner_link__r.contact.account.name != null &&
                tempJC.sfdc_job__r.job_owner_link__r.contact.account.name.contains('Husaro'))) displayName = 'Mr. Lube Husaro';
            c.client_display_name__c = displayName ;
            c.client_short_name__c = tempJC.sfdc_job__r.recordtype.name;   
            c.most_recent_job__c = tempJC.sfdc_job__c;       
            
            
            
            //Interview Scheduler --------------------------------------------------------------------------------------------------------
            //sets candidate interview with job candidate id
            Interview_Scheduler_Util.SetCandidateInterviewToJobCandidate(jc.Email__c, jc.SFDC_Job__c, jc.id);
            //END Interview Scheduler ----------------------------------------------------------------------------------------------------
            
            
                     
            cans.put(c.id, c);        
        } // end loop through JC
        
        // pass the list of JCs into the function to create Reminders
        //if (!jcs_new.isEmpty()) boolean result =  Reminder_Util.CreateReminder(jcs_new, 'insert');
    } // end if insert

    // after update processing:
    else if (trigger.isUpdate) {
    
            
        //scheduler--------------------------------------------------------------------------------------------
        DateTime dtNow = datetime.now();
        List<Candidate_Interview__c> ciListToDelete = new List<Candidate_Interview__c>();
        List<Candidate_Interview__c> ciListToUpdate = new List<Candidate_Interview__c>();
            
        for (SFDC_Job_Candidate__c jc : trigger.new) 
        {
            if (jc.status__c != trigger.oldMap.get(jc.id).status__c && //if status changed
                jc.status__c=='Rejected' &&                            //if status changed to rejected
                jc.Scheduled_Interview_Date_Time__c>dtNow)             //if interview is in the future
            {           
                //delete associated candidate interview so space if no taken up
                List<Candidate_Interview__c> ciL = [SELECT id FROM Candidate_Interview__c WHERE Job_Candidate__c =: jc.id]; //find cad interview
                if(ciL.size() > 0) {
                    ciL[0].Job_Candidate__c = null; 
                }
                ciListToDelete.addall(ciL);
            }
             
            if (jc.SFDC_Job__c != trigger.oldMap.get(jc.id).SFDC_Job__c) //if swapped candidate to a differnt job
            {           
                List<Candidate_Interview__c> ciL = [SELECT id, Job__c FROM Candidate_Interview__c WHERE Job_Candidate__c =: jc.id]; //find cad interview
                if(ciL.size() > 0) {
                    ciL[0].Job__c=jc.SFDC_Job__c;
                }
                ciListToUpdate.addall(ciL);
            }
        }  
             
             
        //delete candidates interviews if any found above
        if(ciListToDelete.size() > 0) {
            update ciListToDelete;
            delete ciListToDelete;
        }
        
        //delete candidates interviews if any found above
        if(ciListToUpdate.size() > 0) {
            update ciListToUpdate;
        }
        //END scheduler--------------------------------------------------------------------------------------------  
    
    } // end if update
    // update candidate records if needed
    if (!cans.isempty()) update cans.values();    
    
    public string trimPhone(string s)
    {
        s = s.removeStart('+1');
        s = s.remove('(');
        s = s.remove(')');
        s = s.remove(' ');
        s = s.remove('-');
        return s; 
    }
*/
}