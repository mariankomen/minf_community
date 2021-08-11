/****************************
    Class: Job_Util
    Purpose: This class contains methods to manage Job data.
    
    1. SetJobAddedDate method:
        This method sets the Job Added/Opened Date to 1:30pm next business day (weekends or weekdays).  Called from Job Before Insert trigger
        We have it in a utility class so we can call it from a test method and set our own dates for test coverage purposes.
    
        Requirements:
        A.  This class depends upon a Custom Setting called Daylight_Saving_Time to be created with an instance called
            "Current Year" that will contain the start and end date of the current year's DST period.  This must be updated
            each year prior to the March start date.  It always starts the 2nd Sunday in March and ends the 1st Sunday in 
            November.  If this is missing or not updated, the code will assume it is not DST.
        B.  This class uses Holidays, the setting under Company Information, to determine when day is a MFG holiday.  If these
            are not set up then the logic will be based on weekends only. NOTE: to cut back on coding we only look for single
            day holidays in our logic.  All recurring holidays will be ignored. 

    2. JobReassignment method:
        This method looks in the Job Owner Reference table to see if this new Job has a default owner based on Store Number, Job/Dept Codes, Banner of Store and
        Job Record Type.  It is called from Job Before Insert trigger.
        
    3. DupConfCheck method:
        This method takes in a list of Jobs and determines if they can be posted online.  It runs a check on Confidential setting as well as looking for
        Jobs created for the same store with similar settings within a time period, deeming it a "duplicate" job and not to be posted.  Run only on the first
        update of a Job, called by Job_BeforeInsertUpdate.  (added Jan 2012 - some clients always want online posting so these will skip processing and immediately
        be set to allowed.)
            
    4. SubmitforApproval method:
        This method attempts to submit a list of Jobs for approval processing.  The call will create 
        failures if any job doesn't meet an approvals process entry criteria but we can ignore these failures.  Jobs are sent in based on
        a checkbox and that is unchecked after the approvals are submitted.
        
    5.  SetApprovers method:
        This method is called from the User trigger if a user's Approver lookups have changed.  The method will go through all open Jobs and reset
        the Job approver fields.  Uses Custom Setting Open_Job_Statuses__c to determine which job status is considered "open"
           
    6.  
     method:
        This method is called from the Account trigger if an Account's Manager lookups have changed.  The method will go through all open Jobs and reset
        the Job Manager fields (which then kicks off a process to update related Candidate Manager fields).  Uses Custom Setting Open_Job_Statuses__c to 
        determine which job status is considered "open"

    7.  UpdateJobApprovedDate:
        This method is called from the Job After Update trigger when the Set Job Approved Date is checked.  It is a future method that will update the Job
        Approved Date and run through any workflow that this change causes. We had to put this in a future method so that Job Approvals can get the date
        set and also run through workflow.  Updates made from Approval processing do not trigger workflow rules.
        
    8. BlacklistCandidateCheck:
        This method takes in a list of new Job Candidates and compares them to the Blacklist records with matching Job record types.  If there is a match we link
        the Job Candidate to the Blacklist and update the Blacklist Status picklist which will impact the email alerts that go out.
    
    9. Create Job/Candidate Sharing (with helper methods):
        These methods take a set of Job or Canadidate Ids and create Store and Manager sharing for portal user Account's Executive Roles
        and Subordinates.  It will clear out the Store/Mgr sharing first then recalculate who needs it and create.  Helper methods do the
        actual share record generation as well as the mapping of an Account to its Exec Role&Sub Group Id.
        ** As of JAN 2013, no longer needed in new EE instance
        
    10. Duplicate Job Notification:
        This method will take in jobs and either set the Duplicate Job Notification Date (based on SLA of parent duplicate job and its Date Last Posted) or
        check the Duplicate Job Closed box.  Runs workflow to notify individuals to broadcast or post baby jobs.
        
    11. SetNumOpenCandidates: 
        this method counts all open Candidates for Jobs at the same store and stamps the new Job with this number.  used by workflow to notify store contact
        of too many open candidates when a new job is created.
        
    12. FindOpenCandidate:
        This method takes in map of Candidate Records and sends back the map with most recently modified open Candidate against open job for each.  Called from
        Reference Befpre/After triggers, Can Page Update an Can Record Alerts classes.
        
    13. CleanHTMLField:
        This method takes in rich text and removes certain tags and replaces some.  Called from Job Before Insert/Update for some fields that sync with HireDesk
    
    Created: Mar 30/10 by Niki Vankerk, Vankerk Solutions, Inc
    Modification Log:
        Oct 12/10, Niki Vankerk: added JobReassignment method
        Jan 29/11, Niki Vankerk: added DupConfCheck method
        Feb 9/11, Niki Vankerk: added SubmitforApproval method
        Feb 10/11, Niki Vankerk: added SetApprovers/Set Managers methods
        Feb 10/11, Niki Vankerk: updated Reassignment method to ignore jobs if Make Job Visible is set to No
        Mar 15/11, Niki Vankerk: updated DupConfCheck to consider new Account setting Unique Job Desc.
        Apr 25/11, Niki Vankerk: updated DupConfCheck to consider new Account setting Confidentintial Job Desc.
        Apr 26/11, Niki Vankerk: added UpdateJobApprovedDate method
        June 22/11, Niki Vankerk: added BlacklistCandidateCheck method
        Aug 11/11, Niki Vankerk: updated Job Reassignment to use Banner of Store
        Nov 23/11, Niki Vankerk: added Job/Candidate sharing methods
        Jan 19/12, Niki Vankerk: added auto post functionality to DupConfCheck method
        Jan 23/12, Niki Vankerk: adjust auto post so it looks at auto post before specific candidate selected
        Feb 7/12, Niki Vankerk: DupConfCheck: added setting Internal Job Status value based on Allowed or not.
        Feb 13/12, Niki Vankerk: changed DupConfCheck to look for 'Yes' in specific Candidate Selected
        Mar 9/12, Niki Vankerk: changed DupConfCheck to skip Specific Candidate check for Glentel jobs
        Mar 18/12, Niki Vankerk: added Duplicate Job notification logic
        Mar 20/12, Niki Vankerk: added counting open candidates for newly inserted jobs
        June 20/12, Niki Vankerk: added job/can sharing for HR User Usual link
        July 24/12, Niki Vankerk: changed DupConf Check and Baby Job Notifications to handle null SLA and use Days for Delivery for time frame.
        Aug 24/12, Niki Vankerk: removed resetting first time update from DupConf Check since it will be done in Job before I/U trigger and removed commented code
        Jan 27/13, NV: comment out Apex Sharing code
        Mar 21/13, NV: add department into the dupConf check code, updated job reassignment code for multiple job inserts
        June 15/13: NV: updated Set Managers to move Mgr Type values
        July 9/13: added FindOpenCandidate method
        Aug 30/13: updated Job Added Date to be 1:30pm instead of 6am
        Sept 7/13: updated logic for Online posting to allow for department specific auto posting
        Sept 21/13: added CleanHTMLField method
        Nov 15/13: added SetJobDescription method to find default job desc based on client/job title
        Feb 2015: Franchise Hire Portal updates: skip SetJobDescription for status of Pending Order, added Calc JobOrder Amount
        Mar 11/15: Dup Check changes: don't run on Pending ORder jobs and don't include Pending ORder jobs in the set of possible dups
        
****************************/
public class Job_Util {

    public boolean CheckForDuplicateOFGSourcing(SFDC_Job__c job, Id storeId) {
        
        //look for any OFG sourcing jobs that have same account (location), same title, and are broadcasting (Open)
        List<SFDC_Job__c> jl = [SELECT id FROM SFDC_Job__c 
                                WHERE OWF_Job_Title__c =: job.OWF_Job_Title__c AND 
                                      Store__c =: storeId AND
                                      Record_Type_Developer_Name__c =: job.Record_Type_Developer_Name__c AND
                                      Job_Status__c='Open/Active Job'];
    
        return jl.Size()>0;
    }

   
    // start job at 1:30pm the next business day, taking Holidays into account
    //  if created date is 2pm Friday, use 1:30pm Saturday; if 1:00pm Monday, use 1:30pm Monday
    public void SetJobAddedDate(List<SFDC_Job__c> jobs, datetime currDate) {
        // Date we are basing calculations on is passed in from trigger.  This allows test methods to trick the code but 
        //  from the trigger we pass in "now" which is the GMT version of current user's system date/time
        Datetime compareDate = (isTest ? testDateTime : currDate);
        //system.debug('starting with compareDate in GMT: '+compareDate);
        //system.debug('same compare date in Pacific: '+compareDate.date()+' and time: '+compareDate.time());
        // determine if we are in daylight savings from the custom setting dates
        Daylight_Saving_Time__c dst = Daylight_Saving_Time__c.getInstance('Current Year');      
        boolean DaylightSavings = false;
        // if we can't find the setting or either start or end are null, stick with PST
        if (dst == null || dst.dst_start__c == null || dst.dst_end__c == null) DaylightSavings = false;
        else if (compareDate.date() >= dst.dst_start__c && compareDate.date() <= dst.dst_end__c ) DaylightSavings = true;
        //system.debug('we are in DST? '+DaylightSavings );

        // query for any active Holidays from compareDate and into future
        // NOTE:  we only look for nonrecurring holidays and we assume they are full day holidays
        Set<Date> holidays = new Set<date>();
        for (Holiday h : [select Name, IsRecurrence, Id, ActivityDate From Holiday where activitydate >= :compareDate.date() and isRecurrence = false]) {
            holidays.add(h.activitydate);
        } 

        // if weekends should be skipped, use this set
        //Set<String> weekends = new Set<String>{'Sat', 'Sun'};
        
        // Open time is either GMT 20:30 (1:30pm DST) or 21:30 (1:30pm PST)
        Time jobOpenTime = time.newinstance((DaylightSavings ? 20 : 21),30,0,0);
        // compare the date with midnight - 1:30pm Pacific, which is either 0700-2030 or 0800-2130 GMT
        datetime UpperBound = datetime.newinstanceGMT(compareDate.date(), time.newinstance((DaylightSavings ? 20 : 21),30,0,0));
        datetime LowerBound = datetime.newinstanceGMT(compareDate.date(), time.newinstance((DaylightSavings ? 7 : 8),0,0,0));
        //system.debug('Upper Bound: '+UpperBound+' and Lower Bound: '+LowerBound);

        // find out which date we use for the Job - today or next working day
        date jobOpenDate;
        // if current GMT time is between midnight - 1:30pm Pacific, use same day 
        //   taking DaylightSavings into account, compare now GMT with either 0700-2030 or 0800-2130 GMT
        if (compareDate > LowerBound && compareDate <= UpperBound) {
            // use same day, remove time portion for remaining weekend/holiday tests
            compareDate = datetime.newinstanceGMT(compareDate.date(), time.newinstance(9,0,0,0));
        } else { // add 1 working day, remove time portion for remaining tests
            //system.debug('compare date Pacific plus 1 day: '+compareDate.date().adddays(1));
            //system.debug('new GMT compare date: '+datetime.newinstanceGMT(compareDate.date().adddays(1), time.newinstance(0,0,0,0)));
            compareDate = datetime.newinstanceGMT(compareDate.date().adddays(1), time.newinstance(9,0,0,0));     
            //system.debug('new compare date in Pacific: '+comparedate.date());
        }

        // now check if we landed on a holiday and continue adding days until we are not on a holiday
        // NOTE: if weekends should be skipped add this to the While statement:  || weekends.contains(compareDate.formatgmt('E'))
        //system.debug('about to check holidays: '+holidays+' for comparison date of: '+compareDate.date());
        while (holidays.contains(compareDate.date())) {
            compareDate = compareDate.adddays(1);
        }
        //system.debug('Job Open Date after holiday check is: '+compareDate);
        
        // cycle through new Jobs to set the Date_Job_Added_or_Opened__c field
        // only set the field if it is blank
        for (SFDC_Job__c j : jobs) {
            if (j.Date_Job_Added_or_Opened__c == null)
                j.Date_Job_Added_or_Opened__c = datetime.newinstancegmt(compareDate.dateGmt(), jobOpenTime);
        } // end loop
    }

    // check if we need to change the owner to the designated store owner 
    //    If Job is not Visible to Store we don't reassign.  Otherwise:
    //    If Job for STore Num is populated or job is OWF, we go through reassignment logic:
    //        If OWF and Job&Dept code is filled in, check for match (User's store num used if the Job for Store Num not filled in on store)
    //        If OWF and Job code is filled in, check for match (User's store num used if ...)
    //        If Banner of Store filled in, check for matching Store Num, Banner and Client
    //        If non-OWF OR OWF without Job for Store Num filled in and user is not Store User, check for matching Store Num/Client
    //    First match to be found will use the default User from JOR to reassign owner, otherwise leave the owner as-is
    public void JobReassignment(List<SFDC_Job__c> jobs) {
        // Job/Dep Code level map of Job to match key (store number + Job Code + Dept Code + first 15 char of record type id)
        //Map<SFDC_Job__c, string> OWFDeptJobCode = new Map<SFDC_Job__c, string>();
        // Job Code level map of Job to match key (store number + Job Code + first 15 char of record type id)
        //Map<SFDC_Job__c, string> OWFJobCode = new Map<SFDC_Job__c, string>();
        // Banner of store level map of Job to match key (store number + Banner of Store + first 15 char of record type id)
        Map<SFDC_Job__c, string> Banner = new Map<SFDC_Job__c, string>();   
        
        //Map<SFDC_Job__c, string> OFGSourcingBanner = new Map<SFDC_Job__c, string>();                
        // Store default level map of Job to match key (store number + first 15 char of record type id)
        Map<SFDC_Job__c, string> storeNum = new Map<SFDC_Job__c, string>();
        // list of Jobs that need reassignment
        List<SFDC_Job__c> tobeReassigned = new List<SFDC_Job__c>();
        
        // get current User's store number for OWF match key use and banner of store for matching
        User curruser = [select id, store_number__c, profile.name, contact.account.banner_of_store__c, contactid from User where id = :UserInfo.getUserId()];
        // create map of Job record types to add in comments if make job visible is set to No
        Schema.DescribeSObjectResult d = Schema.SObjectType.SFDC_Job__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();

        //Using for Eco account, we want to pull the store number
        User u = [SELECT Contact.Account.Store_Number_NonOFG__c FROM user WHERE id=:userinfo.getuserid()];

        // cycle through jobs in the trigger to find which need job owner changed; add to relevant match maps and overall List of Jobs to be reassigned
        for ( SFDC_Job__c j : jobs) { 
        
            //hack setup for Eco account....
            //Eco now deprecated
            /*if(j.Record_Type_Developer_Name__c=='ECO_Group') {
                //get store number from user creating the job, default is 1
                //this way it will always put in a store number and the system will reasign to the default owner alias we want
                j.Job_is_for_Store_if_applicable__c = (u != null && u.Contact.Account.Store_Number_NonOFG__c != null) ? u.Contact.Account.Store_Number_NonOFG__c : '1';
            }*/
        
        
            // if job for store # is populated BUT make job visible is set to No, don't reassign and add a note into the Job
            // Apr 2013: changed logic to still assign job AND add creating user as mgr 5; search and list view filters will hide these jobs from store users
            if (j.Job_is_for_Store_if_applicable__c != null && j.make_job_visible_to_store__c == 'No') {
                //Schema.RecordTypeInfo rtById =  rtMapById.get(j.recordtypeid);
                // add comments Job created for <recordType name> Store Number xx
                //j.job_comments__c = (j.job_comments__c != null ? j.job_comments__c + '\n' : '') + 'Job created for ' + rtById.getName() + ' Store Number ' + j.job_is_for_Store_if_applicable__c;
                
                // if user is portal, add as Make_Job_Visible_Creating_User lookup
                if (curruser.contactid != null)
                    j.Make_Job_Visible_Creating_User__c = curruser.id;
            } // end if reassigning job that is not visible to store user
            // now if Job for Store Num is populated or it's an OWF Job, add to relevant maps and overall list
            //Jan 2018, add new sourcing record type '0120P000000Akiu'...should fall through to banner match
            if (j.Job_is_for_Store_if_applicable__c != null || j.recordtypeid == '012U00000009QriIAE' || j.recordtypeid == '0120P000000Akiu') {
                // add the job to list for reassignment
                tobeReassigned.add(j);
                // to prep for match codes, if OWF doesn't have Job for Store Num filled in, we use the OWF User's Store Num; if not OWF we use the Job for Store Num
                string StoreNumber = j.Job_is_for_Store_if_applicable__c;
                if ((j.recordtypeid == '012U00000009QriIAE' || j.recordtypeid == '0120P000000Akiu') && j.Job_is_for_Store_if_applicable__c == null)
                    StoreNumber = curruser.store_number__c;
                    
                // Match 1: if OWF and has Job and Dept code, add to first map
                //if (j.recordtypeid == '012U00000009QriIAE' && j.job_code_OWF__c != null && j.OWF_Department__c != null) {
                //    OWFDeptJobCode.put(j, StoreNumber + j.Job_Code_OWF__c + j.OWF_Department__c.substring(0,2) + '012U00000009Qri');
                //} // end match 1
                // Match 2: if OWF and has Job code, add to next map
                //if (j.recordtypeid == '012U00000009QriIAE' && j.job_code_OWF__c != null) {
                //    OWFJobCode.put(j, StoreNumber + j.Job_Code_OWF__c + '012U00000009Qri');
                //} // end match 2  
                
                // Match 2.5: match banner to new ofg sourcing record type
                //if (j.recordtypeid == '0120P000000Akiu' && j.OWF_Banner_of_Store__c != null) {
                //    OFGSourcingBanner.put(j, StoreNumber + j.OWF_Banner_of_Store__c + '0120P000000Akiu');
                //} // end match 2.5
                
                
                // Match 3: if job has Banner of Store set, add to next map
                if (j.banner_of_store__c != null) {
                    Banner.put(j, StoreNumber + j.Banner_of_Store__c + string.valueof(j.recordtypeid).substring(0,15));
                } // end match 3
                // Match 4: if non-OWF or if OWF and (job for store num filled in or user's profile not Store User), add to next map
                if (j.recordtypeid != '012U00000009QriIAE' || 
                    (j.Job_is_for_Store_if_applicable__c != null || curruser.profile.name != 'OWF Customer Portal Store User')
                   )
                {
                    storeNum.put(j, StoreNumber + string.valueof(j.recordtypeid).substring(0,15));
                } // end match 4 
            } // end if we are reassigning job
        } //end loop through jobs in trigger
        //system.debug('list of job/dept code:'+OWFDeptJobCode);
        //system.debug('list of job code:'+OWFJobCode);
        //system.debug('list of banner:'+Banner);
        //system.debug('list of store num:'+storeNum);                
    
    
        // if any jobs need the owner update, continue
        if (!tobeReassigned.isempty()) {
            // map of match key and default owner from the job reference table
            Map<string, id> ownerRef = new Map<string, id>();
            // cycle through any rows with a match key in our various match maps from above
            for (Job_Owner_Reference__c ref : [select default_job_owner__c, match_key__c from job_owner_reference__c where 
                //match_key__c in :OWFDeptJobCode.values() or
                //match_key__c in :OWFJobCode.values() or 
                //match_key__c in :OFGSourcingBanner.values() or 
                match_key__c in :Banner.values() or match_key__c in :storeNum.values()]) {
                ownerRef.put(ref.match_key__c, ref.default_job_owner__c);
            } // end cycle through reference table
           // system.debug('List of reference records to compare with: '+ownerRef);
            // cycle through jobs tobeReassigned and compare to each match  map.  When one is found, go to the next Job
            for (SFDC_Job__c j : tobeReassigned) {
                // match 1
                //if (ownerRef.containskey(OWFDeptJobCode.get(j)))
                //    j.ownerid = ownerRef.get(OWFDeptJobCode.get(j));
                //else if (ownerRef.containskey(OWFJobCode.get(j)))
                //    j.ownerid = ownerRef.get(OWFJobCode.get(j));
                //else if (ownerRef.containskey(OFGSourcingBanner.get(j)))
                //    j.ownerid = ownerRef.get(OFGSourcingBanner.get(j));
                if (ownerRef.containskey(Banner.get(j)))
                    j.ownerid = ownerRef.get(Banner.get(j));
                else if (ownerRef.containskey(storeNum.get(j)))
                    j.ownerid = ownerRef.get(storeNum.get(j));                    
            } // end loop through jobs to reassign     
        } // end if there are jobs that need updates
    }

     //for newly created jobs, sets defaults for referred candidates
     public void SetDefaultsSpecificCandidateRequested(List<SFDC_Job__c> jobs) {
          for ( SFDC_Job__c j : jobs) {
              if(j.NSM_Specific_Candidate_Requested__c=='Yes_Referred_Candidate') {
                 j.Num_of_Candidates_for_Delivery_Agreement__c=1;
                 j.Job_Internal_Status__c='Broadcasting Needed';
                 j.Online_Posting__c='Allowed';  //'No - Matching Job Posted in Range';
                 j.Additional_Candidate_s_Required__c='No';
              }    
              if(j.NSM_Specific_Candidate_Requested__c=='Yes_Requested_Candidate') {
                  j.Additional_Candidate_s_Required__c='Yes';
              }
          }
     }


    /* Check newly created jobs and whether they can be posted online.  Don't process jobs in pending Order until they are paid for, then trigger runs them through this again.
        1. If Job is marked Confidential, not to be posted and several field updates are made
        2. If Job's store has No Posting Allowed, Confidential Job Posting Reqd or Unique Job posting, not to be posted     
        3. If Job's specific candidate requested = yes, not to be posted
        4. Now check if this is a duplicate job: 
                - based on SLA we have a number of days back that we look
                - search for dups in that set based on store, Job Title, PT/FT status, department and SLA
                - if a job has a duplicate, not to be posted
                - if no duplicate, can be posted
    */
    
    
    
    public void DupConfCheck(List<SFDC_Job__c> jobs) {
        // list to hold jobs that need to have the dup check run
        List<SFDC_Job__c> DupCheck = new List<SFDC_Job__c>();
        // variables to hold update text while going through checks
        string postStatus = '';
        string additionalComment = '';
        // we need to query for the job owner's language in case we are going to add comments
        //    to the job regarding Confidentiality.  This is to be done in the owners language, not the
        //    running user's language so we can't use labels/translations
        Map<Id, SFDC_Job__c> jobMap = new Map<Id, SFDC_Job__c>([select id, job_owner_link__c, job_owner_link__r.languagelocalekey, job_internal_status__c, recordtype.name from SFDC_Job__c where id in :jobs]);
        // build set of Job record type names and optional departments that automatically post jobs online, using custom setting
        Set<string> AutoPost = new Set<string>(); 
        // cycle through all settings to combine Name and Department if filled out
        for (ClientsAutoPost__c c : ClientsAutoPost__c.getall().values()) {
            string matchKey = c.name;
            if (c.department__c != null) matchKey += '::' + c.department__c;
            AutoPost.add(matchKey);
        }

        // start by cycling through jobs list and exclude any job in Pending Order status from the rest of this logic
        List<SFDC_Job__c> jobsToProcess = new list<SFDC_Job__c>();
        for ( SFDC_Job__c j : jobs) {
            // if this job is in Pending Order Status, don't do the dup checks
            if (j.job_status__c == 'Pending Order')
                continue; 
            // otherwise add this job to our list for processing
            jobsToProcess.add(j);       
        }
        
        // cycle through jobs to run first set of checks
        for ( SFDC_Job__c j : jobsToProcess) { 
            SFDC_Job__c jobRef = jobMap.get(j.id);
            if (jobRef == null) jobRef = new SFDC_Job__c();
            

            // if confidential we don't post
            if (j.confidential__c == 'Yes') { 
                postStatus = 'No - Confidential Job';
                j.Job_Internal_Status__c = 'Broadcasting Needed';
                // apply translation based on the job owner link user's language setting
                if (jobRef.job_owner_link__r.languagelocalekey == 'fr')
                    // use french translation here
                    additionalComment = 'Ce travail est confidentiel - ne pas poster et faire attention à la façon dont il est décrit à la candidate.';
                else 
                    // default to English
                    additionalComment = 'This Job is Confidential - Do Not Post and Be Careful of how it is described to candidates.';
            } // end if job is confidential     
            // if store doesn't allow posting we don't post (value set through Job trigger)
            else if (j.store_doesnt_allow_posting__c)  postStatus = 'No - Account Record Prohibits';
            // if store requires confidential job postings we don't post (value set through Job trigger)
            else if (j.store_requires_confidential_job_posting__c)  postStatus = 'No - Confidential Job Descriptions Required';
            // if store requires unique job postings we don't post (value set through Job trigger)
            else if (j.store_requires_unique_job_posting__c)  postStatus = 'No - Unique Job Descriptions Required';
            // now check if this Job is auto posted based on client/record type and department or OFG department
            else if (AutoPost.contains(jobRef.recordtype.name + '::' + j.Department__c) ||
                     AutoPost.contains(jobRef.recordtype.name + '::' + j.OWF_Department__c) ||
                     AutoPost.contains(jobRef.recordtype.name) ) 
                 postStatus = 'Allowed';
            // if specific candidate is requested for 3 Yes answers for OFG/FGL jobs, don't post
            else if (j.Specific_Candidate_Preference__c != null && ( jobMap.get(j.id).recordtype.name == 'Overwaitea Food Group' || jobMap.get(j.id).recordtype.name == 'FGL Sports' ) &&
                     ( j.Specific_Candidate_Preference__c == 'Yes - Same Store Rehire' || j.Specific_Candidate_Preference__c == 'Yes - Work Experience Student' || j.Specific_Candidate_Preference__c == 'Yes - Interviewed & Ready to Hire'|| (j.Specific_Candidate_Preference__c == 'Yes - Phone Screen' && j.Specific_Candidate_Requested_Options__c == 'Only send requested candidate')) )
                postStatus = 'No - Candidate Already Hired';
            
            // check if we are not posting and finish updates.  If didn't hit one of these conditions, add to list for further processing
            if (postStatus != '') {
                // set the Online Post status
                postStatus = 'Allowed';
                j.online_posting__c = postStatus;
                // add comments if needed
                if (additionalComment != '') j.Job_Comments__c = (j.Job_Comments__c == null ? additionalComment : j.Job_Comments__c+'\n'+additionalComment);
            } // end if we are not posting
            
            // if the job is not marked for posting then we check for duplicates IF:
            //       - the job's num days for delivery agreement is filled in
            //       - or the SLA is filled in with either Front Line, Management or starts with Other

            else if (
                       /* May 2019, simplify process. SLA level not considered anymore, just use -2 days for all.*/
                       j.Num_of_Days_for_Delivery_Agreement__c != null || j.SLA_Level__c != null
                       
                       /* OLD VERSION
                       j.Num_of_Days_for_Delivery_Agreement__c != null || 
                       (
                         j.SLA_Level__c != null && (j.SLA_Level__c == 'Front Line' || j.SLA_Level__c == 'Management' || j.SLA_Level__c.startswith('Other'))
                       ) */
                    )
                DupCheck.add(j); 
            // if job is not going to be dup checked due to above filter, then set it to Allowed
            else
                j.online_posting__c = 'Allowed';
                
            // reset string variables for the next loop
            postStatus = '';
            additionalComment = '';  
        } // end cycle through jobs for first round checks

        // if we have any jobs that still need a DupCheck, run that processing now
        if (!DupCheck.isempty()) {
            Set<Id> DupCheckJobIds = new set<id>();
            
            // cycle through jobs to make a map of Jobs at the same stores meeting all SLA based criteria
            //  this will give us too many jobs back since we need to find jobs for stores for each SLA and
            //  then check based on each newly added store's SLA
            Set<Id> AccIds = new Set<Id>();
            // capture max value for # Days for Delivery field since we need a number of days boundary for blank SLA jobs
            decimal numDaysDelivery = 0;
            // cycle through jobs to grab store ID and max # Days for Delivery from new jobs
            for (SFDC_Job__c j : DupCheck) {
                DupCheckJobIds.add(j.id);
                if (j.store__c != null)
                    AccIds.add(j.store__c);
                if (j.Num_of_Days_for_Delivery_Agreement__c != null && j.Num_of_Days_for_Delivery_Agreement__c > numDaysDelivery)
                    numDaysDelivery = j.Num_of_Days_for_Delivery_Agreement__c;
            }
            // since we are looking for jobs created in half the # days delivered, divide by 2 and round number down if at .5
            if (numDaysDelivery != 0) numDaysDelivery = (numDaysDelivery/2).round(System.RoundingMode.DOWN);
            // set holding all unique match key combinations of store id - Job Title - FT/PT Status - SLA Level - Department
            MAp<string, SFDC_Job__c> Matchkey = new Map<string, SFDC_Job__c>();
            // now query for any jobs for those stores not in our set of jobs being checked and with date range:
            //        Job Opened based on max # Days Delivery found above (SLA can be anything)
            //        SLA = Front Line, Job Opened in last 2 days (changed from 6 to 2 Feb 18/12)
            //        SLA = Mgmt, Job Opened in last 7 days (changed from 15 days to 7 Feb 18/12)
            //        SLA contains Other, Job Opened in last 7 days (changed from 15 days to 7 Feb 18/12)
            //   not including jobs with status of Pending Order
            system.debug('starting dup check with max numDaysDelivery value halved: '+numDaysDelivery + 'and first job details: '+DupCheck[0]);
            
            for (SFDC_Job__c j : [select id, store__c, Job_Title__c, New_Job_Title__c, FT_or_PT__c, SLA_Level__c, Date_Job_Added_or_Opened__c, Department__c, OWF_Department__c 
                                  from SFDC_Job__c where store__c in :AccIds and
                (online_posting__c = null or online_posting__c = 'Allowed') and job_status__c != 'Pending Order' and 
                (
                    /* May 2019, simplify process. SLA level not considered anymore, just use -2 days for all.*/
                    Date_Job_Added_or_Opened__c > :date.today().adddays(-2) OR
                    (Date_Job_Added_or_Opened__c > :date.today().adddays(-numDaysDelivery.intvalue()))
                    
                    /* OLD VERSION
                    (SLA_Level__c = 'Front Line' and Date_Job_Added_or_Opened__c > :date.today().adddays(-2)) or
                    (SLA_Level__c = 'Management' and Date_Job_Added_or_Opened__c > :date.today().adddays(-7)) or
                    (SLA_Level__c like 'Other%' and Date_Job_Added_or_Opened__c > :date.today().adddays(-7))  or
                    (Date_Job_Added_or_Opened__c > :date.today().adddays(-numDaysDelivery.intvalue())) 
                    */
                )
                    order by Date_Job_Added_or_Opened__c desc ]) {
                 if (!DupCheckJobIds.contains(j.id)) {
                    Matchkey.put(j.store__c+j.New_Job_Title__c+j.FT_or_PT__c+j.SLA_Level__c+j.department__c+j.OWF_Department__c, j);
                    system.debug('found potential matching job: '+j);
                  }
            } // end loop to create matchkey set
            system.debug('matchkey set for comparing: '+matchkey.keyset());
            // now we cycle through the jobs that need to be checked for duplicates in our matchkey set
            //    if we find a matching key, no online posting, else allowed
            for (SFDC_Job__c j : DupCheck) {
                //system.debug('checking for dups with this job: '+j.store__c+j.New_Job_Title__c+j.FT_or_PT__c+j.SLA_Level__c+j.department__c+j.OWF_Department__c);
                if (Matchkey.containskey(j.store__c+j.New_Job_Title__c+j.FT_or_PT__c+j.SLA_Level__c+j.department__c+j.OWF_Department__c) ) {
                    SFDC_Job__c potentialMatch = Matchkey.get(j.store__c+j.New_Job_Title__c+j.FT_or_PT__c+j.SLA_Level__c+j.department__c+j.OWF_Department__c);
                    //system.debug('found a match: '+potentialmatch);
                    // if new job has num days delivery filled in, check that the match was created less than half that # Days of Delivery
                    if (j.Num_of_Days_for_Delivery_Agreement__c != null) {
                        //system.debug('num days populated, comparing match create date: '+potentialmatch.Date_Job_Added_or_Opened__c + ' with this date: '+date.today().adddays(-(j.Num_of_Days_for_Delivery_Agreement__c/2).round(System.RoundingMode.ceiling).intvalue()));
                        if (potentialMatch.Date_Job_Added_or_Opened__c > date.today().adddays(-(j.Num_of_Days_for_Delivery_Agreement__c/2).round(System.RoundingMode.down).intvalue()) ) {
                            j.online_posting__c = 'Allowed';//'No - Matching Job Posted in Range';
                            j.duplicate_job__c = potentialMatch.id; 
                        } // end if potential within date range
                        else
                           j.online_posting__c = 'Allowed';                    
                    } // end if days for delivery filled in
                    // else if new job's num days delivery is blank and we found a match, check that it is in the right time frame since it could have been scooped up in the 
                    //    max days delivery from set of new jobs
                    else {
                    
                         /* May 2019, simplify process. SLA level not considered anymore, just use -2 days for all.*/
                         if (potentialmatch.Date_Job_Added_or_Opened__c > date.today().adddays(-2)) {
                            j.online_posting__c = 'Allowed';//'No - Matching Job Posted in Range';
                            j.duplicate_job__c = potentialMatch.id;
                         }
                         else  j.online_posting__c = 'Allowed';
                         
                         /* OLD VERSION
                         // SLA of Front Line means match should have been created within 2 days
                         if (j.SLA_Level__c == 'Front Line' && potentialmatch.Date_Job_Added_or_Opened__c > date.today().adddays(-2)) {
                            j.online_posting__c = 'No - Matching Job Posted in Range';
                            j.duplicate_job__c = potentialMatch.id;
                        } // end if Front Line
                        // SLA of Mgmt or Other means match should have been created within 7 days
                        else if ( (j.SLA_Level__c == 'Management' || (j.SLA_Level__c != null && j.SLA_Level__c.startswith('Other')) ) && potentialmatch.Date_Job_Added_or_Opened__c > date.today().adddays(-7)) {
                            j.online_posting__c = 'No - Matching Job Posted in Range';
                            j.duplicate_job__c = potentialMatch.id;
                        } // end if Mgmt/Other
                        // if the match was added too long ago, no match
                        else  j.online_posting__c = 'Allowed';
                        */
                    } // end else
                } // end if match was found
                else j.online_posting__c = 'Allowed';
                //system.debug('online posting is now: '+j.online_posting__c);
            } // end loop through jobs to check for dups
        } // end if there are jobs to check for duplicates

        // finally, cycle through jobs once more to set internal job status if not already set
        for (SFDC_Job__c j : jobsToProcess) {
            if (j.job_internal_status__c == null) {
                //if (j.online_posting__c == 'Allowed') 
                    j.job_internal_status__c = 'Broadcasting Needed';
                //else j.job_internal_status__c = 'Broadcasting Not Needed';
            }
        }
    }    

    /* Submit newly created Jobs for approvals processing.
        Send list of jobs for approvals processing and reset the flag to false
    */
    @future
    public static void SubmitForApproval(Set<Id> jobs) {
        // if we have jobs to submit, do so now
        if (!jobs.isempty()) {  
           //system.debug('about to submit these jobs for approval: '+[select id, name, approver_1__c, recordtypeid from SFDC_Job__c where id in :jobs]);
           List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
           for (Id jid :  jobs) {
               Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
               req1.setComments('Submitting automated requests for approval.');
               req1.setObjectId(jid);
               reqs.add(req1);
           } // end build list of approvals to submit
           try {
               // submit all jobs with AllorNothing set to false so some can fail and others still submit
               Approval.ProcessResult[] results = Approval.process(reqs, false); 
               //System.debug('approval submission process results: '+results);
           } catch (Exception e) {system.debug('approval submit failed: '+e); } 
        } // end if jobs to submit
    }

    // Set Approvers will cycle through the User set and update open jobs with the new approver values
    //  uses Custom Setting Open_Job_Statuses__c to determine which are open, compare upper case with Status_Name__c field
    @future
    public static void SetApprovers(Set<Id> user) {
        List<SFDC_Job__c> upd = new List<SFDC_Job__c>(); // track jobs being updated
        // Make array of "open" status values
        List<string> status = new List<String>();
        for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
            status.add(o.status_name__c);
        } // end loop through settings
        //system.debug('open status values are: '+status);
        // now cycle through any open job owned by the users sent into the method
        for (SFDC_Job__c j : [select id, approver_1__c, approver_2__c, approver_3__c, hr_user_approver__c, job_status__c, job_owner_link__r.job_approver_1__c,
                              job_owner_link__r.job_approver_2__c, job_owner_link__r.job_approver_3__c, job_owner_link__r.hr_user_approver__c from SFDC_Job__c
                              where ownerid in :user and job_status__c in :status]) {
            j.approver_1__c =  j.job_owner_link__r.job_approver_1__c;
            j.approver_2__c =  j.job_owner_link__r.job_approver_2__c;
            j.approver_3__c =  j.job_owner_link__r.job_approver_3__c;
            j.hr_user_approver__c =  j.job_owner_link__r.hr_user_approver__c;
            upd.add(j);
        } // end loop through jobs to update
        if (!upd.isempty())
            try {
                update upd;
            } catch (Exception e) {system.debug('Error updating Job Approvers: '+e);}
    }

    // Set Managers will cycle through the Account set and update open jobs with the new Manager values
    //  uses Custom Setting Open_Job_Statuses__c to determine which are open, compare upper case with Status_Name__c field
    @future
    public static void SetManagers(Set<Id> accIds) {
        List<SFDC_Job__c> upd = new List<SFDC_Job__c>(); // track jobs being updated
        // Make array of "open" status values
        List<string> status = new List<String>();
        for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
            status.add(o.status_name__c);
        } // end loop through settings

        // now cycle through any open job linked to the stores sent into the method
        for (SFDC_Job__c j : [select id, job_status__c, store__r.HR_User_Usual__c,
                              store__r.X1st_Level_Manager__c, store__r.X2nd_Level_Manager__c, store__r.X3rd_Level_Manager__c, store__r.X4th_Level_Manager__c, store__r.X5th_Level_Manager__c, 
                              store__r.X1st_Level_Manager_type__c, store__r.X2nd_Level_Manager_type__c, store__r.X3rd_Level_Manager_type__c, store__r.X4th_Level_Manager_type__c, store__r.X5th_Level_Manager_type__c, store__r.X1st_Level_Access__c, store__r.X2nd_Level_Access__c
                              from SFDC_Job__c
                              where store__c in :accIds and job_status__c in :status]) {
            j.X1st_Level_Manager__c =  j.store__r.X1st_Level_Manager__c;
            j.X1st_Level_Manager_type__c =  j.store__r.X1st_Level_Manager_type__c;
            j.X2nd_Level_Manager__c =  j.store__r.X2nd_Level_Manager__c;
            j.X2nd_Level_Manager_type__c =  j.store__r.X2nd_Level_Manager_type__c;
            j.X3rd_Level_Manager__c =  j.store__r.X3rd_Level_Manager__c;
            j.X3rd_Level_Manager_type__c =  j.store__r.X3rd_Level_Manager_type__c;
            j.X4th_Level_Manager__c =  j.store__r.X4th_Level_Manager__c;
            j.X4th_Level_Manager_type__c =  j.store__r.X4th_Level_Manager_type__c;
            j.X5th_Level_Manager__c =  j.store__r.X5th_Level_Manager__c;
            j.X5th_Level_Manager_type__c =  j.store__r.X5th_Level_Manager_type__c;
            j.X1st_Level_Access__c =  j.store__r.X1st_Level_Access__c;
            j.X2nd_Level_Access__c =  j.store__r.X2nd_Level_Access__c;
            j.hr_user_Usual__c = j.store__r.hr_user_Usual__c; 
            upd.add(j);
        } // end loop through jobs to update
        if (!upd.isempty())
            try {
                update upd;
            } catch (Exception e) {system.debug('Error updating Job Managers: '+e);}
    }

    /* Submit newly created Jobs for approvals processing.
        Send list of jobs for approvals processing and reset the flag to false
    */
    @future
    public static void updateJobApprovedDate(Set<Id> jobs) {
        // if we have jobs to update, do so now
        if (!jobs.isempty()) {  
           //system.debug('about to submit these jobs for approval: '+[select id, name, approver_1__c, recordtypeid from SFDC_Job__c where id in :jobs]);
           List<SFDC_Job__C> jUpd = new List<SFDC_Job__C>();
           for (Id jid :  jobs) {
               SFDC_Job__c j = new SFDC_Job__c(id = jid);
               j.date_job_approved__c = date.today();
               j.Set_Date_Job_Approved__c = false;
               jUpd.add(j);
           } // end build list of approvals to submit
           try {
               // submit all jobs with AllorNothing set to false so some can fail and others still submit
               update jUpd; 
           } catch (Exception e) {system.debug('job update failed: '+e); } 
        } // end if jobs to update
    }

    /*  This method takes in a list of UserIds that have just been deactivated.  Check if there are open jobs owned by the users and if so,
        send an email to Jeff with a list of Jobs to fix */
        
    public static void JobOwnerCheck(Set<Id> userids) {
        try {
            // if we have users to check, do so now
            if (!userids.isempty()) {
                // Make array of "open" status values
                List<string> status = new List<String>();
                for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
                    status.add(o.status_name__c);
                } // end loop through settings
                //system.debug('open status values are: '+status);              
               // create list of open jobs owned by the users
               Map<Id, SFDC_Job__c> openJobs = new Map<Id, SFDC_Job__c>([select id, name, new_job_title__c, url__c, ownerid, owner.name from SFDC_Job__c 
                   where ownerid in :userids and job_status__c in :status order by owner.name, name]);
               // if there are open jobs, build and send single email to Jeff
               if (!openJobs.isempty()) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.settargetObjectId([select id from User where email = 'jeff.summers@mindfieldgroup.com' and isactive = true and contactid = null limit 1].id);
                    mail.setsaveAsActivity(false); // this is vital when sending an email to a User
                    mail.setSenderDisplayName('Jeff Summers');
                    mail.setUseSignature(false);
                    mail.setSubject('Alert: Portal users deactivated with Open Jobs');
                    // body of email will be a list of Job names and owners with link
                    string emailBody = 'The following open jobs are owned by recently deactivated portal users:\n\n';
                    for (SFDC_Job__c j : openJobs.values())
                        emailBody += 'Owner: '+j.owner.name+', JOB ID: '+j.name+' with link: '+j.url__c+'\n';
                    mail.setPlainTextBody(emailBody);
                    //system.debug('Mail details: '+mail);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
               }
            } // end if jobs to update
        } catch (Exception e) {system.debug('Job Owner Check failed: '+e); }        
    }

/*  This method takes in a set of Job Candidates that have just been inserted.  Check if the Candidate matches any Blacklsit record valid for that
    Job's recordtype.  If any found, set Blacklist Status field on Job Candidate and link to Blacklist record */
        
    public static void BlacklistCandidateCheck(List<SFDC_Job_Candidate__c> cans) {
        try {
            // if we have candidates to check, do so now
            if (!cans.isempty()) {    
                // prepare maps of Candidate and Job details
                Set<Id> Jids = new Set<Id>();  // job ids
                Set<Id> Cids = new Set<Id>();  // candidate ids
                Set<Id> RTids = new Set<Id>();  // job RecordTypeIds
                // cycle through incoming cans to create sets of ids
                for (SFDC_Job_Candidate__c jc : cans) {
                    Jids.add(jc.sfdc_job__c);
                    Cids.add(jc.candidate__c);
                } // end loop through incoming jcs
                // create map of jobs with rec type
                Map<Id, SFDC_Job__c> jobMap = new Map<Id, SFDC_Job__c>();
                // loop through so we can create map of Job and set of Job Recordtypeids for later
                for (SFDC_Job__c j : [select id, recordtypeid from SFDC_Job__c where id in :Jids]) {
                    jobMap.put(j.id, j);
                    RTids.add(j.recordtypeid);
                } // end loop through impacted jobs
                // create map of Candidates with first/last/email etc
                Map<Id, SFDC_Candidate__c> canMap = new Map<Id, SFDC_Candidate__c>( [select id, first_name__c, last_name__c, SFDC_candidate_email__c, Primary_phone__c, Postal_Zip_Code__c from SFDC_Candidate__c where id in :Cids]);
                // prepare Blacklist maps for matching - Job Record Type id to map of matching string/Blacklist
                //    this way each Candidate's job record type can find it's own assoc map of matching string/Blacklist
                Map<Id, Map<string, Blacklist__c>> emailList = new Map<Id, Map<string, Blacklist__c>>();
                Map<Id, Map<string, Blacklist__c>> PhoneList = new Map<Id, Map<string, Blacklist__c>>();
                Map<Id, Map<string, Blacklist__c>> PostalList = new Map<Id, Map<string, Blacklist__c>>();
                
                // cycle through Blacklists with assoc B Job Types and for each Job Type that matches a record type being used here, add to all 3 maps
                for (Blacklist__c b : [select id, name, first_name__c, email__c, phone__c, postal_code__c, (select id, job_record_Type__r.record_type_id__c from Blacklist_Job_Types__r where job_record_Type__r.record_type_id__c in :RTids)
                    from Blacklist__c]) {
                    // for each Blacklist Job Type that matches a job being referenced here, add entries into 3 maps
                    for (Blacklist_Job_type__c bjt : b.Blacklist_job_types__r) {
                        // add to EmailList if there is an email
                        if (b.email__c != null) {
                            // set match string
                            string emailString = b.email__c;  
                            // if Rec Type already in map, add to existing search map
                            if (EmailList.containskey(bjt.job_record_Type__r.record_type_id__c)) {
                                Map<string, Blacklist__c> temp = EmailList.get(bjt.job_record_Type__r.record_type_id__c);
                                temp.put(emailString, b);
                                EmailList.put(bjt.job_record_Type__r.record_type_id__c, temp);
                            } // end if emaillist contains entry for recordType already
                            // else add new entry with job RT and new map with match string and Blacklist
                            else EmailList.put(bjt.job_record_Type__r.record_type_id__c, new Map<string, Blacklist__c>{emailString => b});
                        } // end if email not null
                        // add to PhoneList if there is a phone number
                        if (b.phone__c != null) {
                            // set match string
                            string phoneString = b.name+b.phone__c;  
                            // if Rec Type already in map, add to existing search map
                            if (PhoneList.containskey(bjt.job_record_Type__r.record_type_id__c)) {
                                Map<string, Blacklist__c> temp = PhoneList.get(bjt.job_record_Type__r.record_type_id__c);
                                temp.put(phoneString, b);
                                PhoneList.put(bjt.job_record_Type__r.record_type_id__c, temp);
                            } // end if phonelist contains entry for recordType already
                            // else add new entry with job RT and new map with match string and Blacklist
                            else PhoneList.put(bjt.job_record_Type__r.record_type_id__c, new Map<string, Blacklist__c>{phoneString => b});
                        } // end  if phone not null
                        // add to PostalList if postal code not null
                        if (b.postal_code__c != null) {
                            // set match string
                            string postalString = b.name+(b.Postal_code__c == null ? '' : b.Postal_Code__c.replaceAll(' ',''));  
                            // if Rec Type already in map, add to existing search map
                            if (PostalList.containskey(bjt.job_record_Type__r.record_type_id__c)) {
                                Map<string, Blacklist__c> temp = PostalList.get(bjt.job_record_Type__r.record_type_id__c);
                                temp.put(postalString, b);
                                PostalList.put(bjt.job_record_Type__r.record_type_id__c, temp);
                            } // end if postallist contains entry for recordType already
                            // else add new entry with job RT and new map with match string and Blacklist
                            else PostalList.put(bjt.job_record_Type__r.record_type_id__c, new Map<string, Blacklist__c>{postalString => b});
                        } // end if postal code not null                        
                    } // end loop through blacklist's record types   
                } // end loop through blacklist records to build matching maps
                //system.debug('email list: '+emailList);
                //system.debug('phone list: '+phoneList);
                //system.debug('postal list: '+postalList);
                // cycle through Candidates added and see if they match any maps for their job record type
                for (SFDC_Job_Candidate__c jc :cans) {
                    // create match strings
                    SFDC_Candidate__c c = canMap.get(jc.candidate__c);
                    string emailmatch = c.SFDC_candidate_email__c;
                    string phoneMatch = c.last_name__c+c.primary_phone__c;
                    string postalMatch = c.last_name__c+(c.Postal_Zip_code__c == null ? '' : c.Postal_Zip_Code__c.replaceAll(' ',''));
                    // match is the record we found as our match, to be linked to the Candidate
                    Blacklist__c match;
                    // track what the match result is, either none or email/phone/postal match
                    string matchType = 'No Entries';
                    Id RecId = jobMap.get(jc.sfdc_job__c).recordtypeid;
                    // cycle through EmailList first for match
                    if (EmailList.size() > 0) {
                        for (string s : EmailList.get(RecId).keyset()) {
                            //system.debug(s+ ' compared to can email key: '+emailMatch);
                            // if the emailMatch string matches, set the associated Blacklist and break out of loop
                            if (s == emailmatch) {
                                match = EmailList.get(RecId).get(s);
                                matchType = 'Blacklisted - Email Match';
                                break;
                            } // end if match
                        } // end loop through emaillist
                    }
                    // if match not found, check phonematch
                    if (match  == null && PhoneList.size() > 0)
                        // cycle through PhoneList first for match
                        for (string s : PhoneList.get(RecId).keyset()) {
                            //system.debug(s+ ' compared to can phone key: '+phoneMatch);
                            // if the phoneMatch string matches, set the associated Blacklist and break out of loop
                            if (s == phonematch) {
                                match = PhoneList.get(RecId).get(s);
                                matchType = 'Blacklisted - Phone Match';                                
                                break;
                            } // end if match
                        } // end loop through Phonelist                    
                    // if match not found, check postalmatch
                    if (match  == null && PostalList.size() > 0)
                        // cycle through postalList first for match
                        for (string s : postalList.get(RecId).keyset()) {
                            //system.debug(s+ ' compared to can postal key: '+postalMatch);
                            // if the postalMatch string matches, set the associated Blacklist and break out of loop
                            if (s == postalmatch) {
                                match = postalList.get(RecId).get(s);
                                matchType = 'Blacklisted - Postal Code Match';                                
                                break;
                            } // end if match
                        } // end loop through postallist
                    // now set our match link and status
                    jc.Candidate_blacklist_status__c = matchType;
                    // if we found a match link, add it now
                    if (match != null)
                        jc.blacklist__c = match.id;
                } // end loop through jcs
                
            } // end if cans to update
        } catch (Exception e) {system.debug('Blacklist Candidate Check failed: '+e); }        
    }
    
    // called from Job After Update trigger
    // sets fields on 'baby' jobs that were not posted due to being a duplicate.  When the master duplicate job is started (not Open/Active) or filled
    //     then search for any related baby jobs still open to set fields that will kick off workflow alerts
    public static void DuplicateJobNotificationsCheck(List<Id> JobIds, string actionFlag) {
        // determine if we are moving into an ACTIVE status (set date field) or FILLED status (set checkbox)
        if (actionFlag == null || (actionFlag != 'ACTIVE' && actionFlag != 'FILLED')) actionFlag = 'FILLED';
        // find all duplicate linked jobs that are still Open/Active or Addtnl Cand Reqd and set appropriate fields for notification
        List<SFDC_Job__c> updDupJobs = new List<SFDC_Job__c>();
        // create set of valid statuses for baby jobs
        Set<string> babyStatus = new Set<string>{'Open/Active Job', 'Open/Active Job for New Store', 'Additional Candidate(s) Required', 'Open/Active Job – Talent Connect', 'Candidates Sent/Awaiting Hire' };
        for (SFDC_Job__c j : [select id, Date_Job_Last_Posted_Refreshed__c, SLA_Level__c, Num_of_Days_for_Delivery_Agreement__c, Num_of_Candidates_for_Delivery_Agreement__c,
                (select id, job_status__c, duplicate_job_closed__c from Jobs__r where job_status__c in :babyStatus) From SFDC_Job__c where id in :JobIds]) {
            // system.debug('parent job to review: '+j);
            // if action is Active, set the notification date based on Date job Last Posted and SLA
            if (actionFlag == 'ACTIVE' && j.Date_Job_Last_Posted_Refreshed__c != null) {
                // find notification date for this job:
                //   first if there is a num days for Delivery, use half rounded down
                //   then if that is blank, SLA: Front Line -> 3 days after Date Posted
                //                               Management/starts with Other -> 7 days after
                date DupNotificationDate;
                // if num days deliery filled in, add half of # Days for Delivery, rounding up to nearest day (ie. 1.3 days is 2)
                if (j.Num_of_Days_for_Delivery_Agreement__c != null && j.Num_of_Days_for_Delivery_Agreement__c != 0) {
                    decimal numDays = j.Num_of_Days_for_Delivery_Agreement__c/2;
                    DupNotificationDate = j.Date_Job_Last_Posted_Refreshed__c.adddays(numDays.round(System.RoundingMode.ceiling).intvalue());
                }
                
                /* May 2019, simplify code. SLA irrelevant now*/
                else if (j.sla_level__c != null)
                    DupNotificationDate = j.Date_Job_Last_Posted_Refreshed__c.adddays(3);
                /* OLD VERSION
                else if (j.sla_level__c == 'Front Line')
                    DupNotificationDate = j.Date_Job_Last_Posted_Refreshed__c.adddays(3);
                else if (j.sla_level__c != null && j.sla_level__c.startswith('Other') || j.sla_level__c == 'Management')
                    DupNotificationDate = j.Date_Job_Last_Posted_Refreshed__c.adddays(7);
                */    
                else continue;
                // now cycle through baby jobs and set the notification date to trigger time based workflow
                for (SFDC_Job__c dupJ : j.jobs__r)
                    updDupJobs.add(new SFDC_Job__c(id = dupJ.id, Duplicate_Job_Notification__c = DupNotificationDate));
            } // end if active action
            else if (actionFlag == 'FILLED') {
                // cycle through baby jobs and if not already true, set the duplicate job closed field to trigger workflow alert
                for (SFDC_Job__c dupJ : j.jobs__r)         
                    if (!dupJ.duplicate_job_closed__c)
                    updDupJobs.add(new SFDC_Job__c(id = dupJ.id, duplicate_job_closed__c = true));
            } // end if filled action
            
        } // end loop through parent job updates
        
        if (updDupJobs.size() > 0)
               
         update updDupJobs;
    }
    
    // takes in a list of new jobs (pre-insertion).  Count all open jobs with open candidates created x days ago for the stores involved
    // and stamp each new job with the current number.
    public static void SetNumOpenCandidates(List<SFDC_Job__c> newJobs) {
        // set of store ids involved with new jobs
        Map<Id, Account> storeMap = new Map<Id, Account>();
        // cycle through new jobs to build map keyset
        for (SFDC_Job__c j : newJobs)
            storeMap.put(j.store__c, new Account());
        // find all job status values considered 'Open'
        List<string> status = new List<String>();
        for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
            status.add(o.status_name__c);
        } // end loop through settings        

        // now query for all open jobs linked to each store
        storeMap = new Map<Id, Account>([select id, (select id, recordtypeid from Jobs__r where job_status__c in :status) from Account where id in :storeMap.keyset()]);
        // create set of Job ids from the storeMap - use to get at all Qualified candidates since we can't do nested queries 2 deep
        Set<Id> openJobIds = new Set<Id>();
        for (Account a : storeMap.values())
            // for each store, add all job Ids to master set
            for (SFDC_Job__c j : a.jobs__r)
                openJobIds.add(j.id);
        // map of Job to open Candidates, query Candidates where the record is valid based on formula field using status and num days past Sent:
        //    the Record Valid for Open Candidates Count is a formula that sets the number of days past that the Date Sent must be for each job record type
        Map<Id, SFDC_Job__c> jobMap = new Map<Id, SFDC_Job__c>([select id, recordtypeid, (select id from SFDC_Job_Candidates__r where
            Record_Valid_for_Open_Candidates_Count__c = 'Yes') from SFDC_Job__c where id in :openJobIds]);
        
        // now cycle through storeMap Accounts, and tally up each related Job's num Candidates from the jobMap.  Add total number to storeCountMap
        Map<Id, integer> storeCountMap = new Map<Id, integer>();
        for (Account a : storeMap.values()) {
            integer CandidateCnt = 0;
            for (SFDC_Job__c j : a.jobs__r)
                // for each job for this store, grab the number of Candidates that were found in the subquery to add to our overall count
                if (jobMap.containskey(j.id))
                    CandidateCnt += jobMap.get(j.id).SFDC_Job_Candidates__r.size();
            // now that we have counted all open Candidates on each Job linked to the account, add to the storeCountMap
            storeCountMap.put(a.id, CandidateCnt);
        } // end store cycle
        
        // and finally, cycle through the incoming Jobs list to find the appropriate Candidate count for the linked store
        for (SFDC_Job__c j : newJobs)
            if (storeCountMap.containskey(j.store__c))
                j.Num_Open_Candidates_upon_Creation__c = storeCountMap.get(j.store__c);
    }
      
      
    // for each candidate rec, find most recently updated open candidate against open job
    //   called from Reference triggers, can Page Update class, Can Record Alerts class
    public static Map<Id, SFDC_Candidate__c> FindOpenCandidate(Map<Id, SFDC_Candidate__c> canRecMap) {
        // build list of valid statuses to use when searching for a Job Candidate record using the Open Job Status custom setting
        List<String> JobStatus = new List<String>();
        for (Open_Job_Statuses__c o : Open_Job_Statuses__c.getall().values()) {
            JobStatus.add(o.status_name__c);
        } // end loop through settings        
        // build list of candidate status values we want to skip
        List<String> notJCStatus = new string[]{'Hired', 'Rejected', 'Complete'};

        // now build map of Candidate Rec with most recently modified open Candidate against Open Job
        //canRecMap = new Map<Id, SFDC_Candidate__c>([select id, (select id, sfdc_job__c, sfdc_job__r.name from Candidates_Submitted_to_Job1__r where sfdc_job__r.job_status__c 
        //    in :JobStatus and status__c not in :notJCStatus order by lastmodifieddate desc limit 1) from SFDC_Candidate__c where id in :canRecMap.keyset()]);
        
        //Update June 2018
        //Remove 'where sfdc_job__r.job_status__c in :JobStatus and status__c not in :notJCStatus'
        //We want to find the record and associate referrnce to job candidate even is job is already closed or candidate already hired/rejected
        canRecMap = new Map<Id, SFDC_Candidate__c>(
                [select id, 
                    (select id, sfdc_job__c, sfdc_job__r.name 
                     from Candidates_Submitted_to_Job1__r 
                     order by lastmodifieddate desc limit 1)
                 from SFDC_Candidate__c where id in :canRecMap.keyset()]);
        
        
        return canRecMap;
    }
    
    // method to clean up HTML/rich text fields.  HireDesk doesn't like div and span tags and needs p instead of br
    // called from Job Before InsertUpdate trigger for each field that needs cleaning
    public static string CleanHTMLField(string startText){
        string cleanText = startText;
        // remove all div and span tags
        //regular expression to match span/div tags
        string SPANTags = '(?i)<span([^>]+)>';
        // compile the pattern for open span  
        pattern myPattern = pattern.compile(SPANTags );
        // get your matcher instance
        matcher myMatcher = myPattern.matcher(cleanText);
        //remove the tags     
        cleanText = myMatcher.replaceAll('');

        // repeat for close span tag
        string clsSPANTags = '</span>';        
        myPattern = pattern.compile(clsSPANTags );
        myMatcher = myPattern.matcher(cleanText);
        //remove the tags     
        cleanText = myMatcher.replaceAll('');

        // repeat for open div tag
        string DIVTags = '<div>';        
        myPattern = pattern.compile(DIVTags );
        myMatcher = myPattern.matcher(cleanText);
        //remove the tags     
        cleanText = myMatcher.replaceAll('');
        
        // repeat for close div tag
        string clsDIVTags  = '</div>';        
        myPattern = pattern.compile(clsDIVTags);
        myMatcher = myPattern.matcher(cleanText);
        //remove the tags     
        cleanText = myMatcher.replaceAll('');
        
        //now we want to find <br> tags and replace them with <p> and </p>
        if (cleanText.contains('<br>')) {
            string[] words = cleanText.split('<br>', -1);  // change the limit to 0 to drop empty lines
            string newText = '';
            for (string s : words)
                newText += '<p>' + s + '</p>';
            cleanText = newText;
        }
        return cleanText;
    }
     
    // takes in a list of new jobs (pre-insertion).  Look for job description matching client/job title
    // before Insert trigger calls this so update jobs passed in with description and preview checkbox
    public static void SetJobDescription(List<SFDC_Job__c> newJobs) {
        // get map of record types by Id to find client name
        Schema.DescribeSObjectResult d = Schema.SObjectType.SFDC_Job__c;
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        
        // build map of job descriptions with client-job title (name field) as key
        Map<string, Job_Description__c> DescMap = new Map <string, Job_Description__c>();
        for (Job_Description__c jd : [select id, name, job_description__c from Job_Description__c])
            DescMap.put(jd.name, jd);
        //system.debug('descriptons map: '+descmap);
        // cycle through jobs passed in
        for (SFDC_Job__c j : newJobs) {
            // skip this for Franchise Jobs based on job status
            if (j.job_status__c == 'Pending Order')
                continue;        
            // if user has filled in the Job/Role Title text field, we don't look for desc and automatically send to Preview
            if (j.Job_Role_Title__c != null) {
                j.job_Preview_pending__c = true;
                continue;
            }
            // otherwise find the populated job title field (could be 1 of 3) and use that for matching - ignore 'Not Applicable' selection in all
            // can't use formula field since this job may not be saved in db yet
            string JobTitle = j.job_title_for_role__c == 'Not Applicable' ? null : j.job_title_for_role__c;
            // next try job title for banner
            if (JobTitle == null)
                    JobTitle = j.Job_Title_for_Banner__c == 'Not Applicable' ? null : j.Job_Title_for_Banner__c;
            // now try OWF job title
            if (JobTitle == null)
                JobTitle = j.OWF_Job_Title__c == 'Not Applicable' ? null : j.OWF_Job_Title__c;
            // also look for Banner of store/Banner of store OFG since that is part of the description name keyset - ignore 'Not Applicable' selection in all
            string BannerName = j.Banner_of_Store__c == 'Not Applicable' ? null : j.Banner_of_Store__c;
            if (BannerName == null)
                BannerName = j.OWF_Banner_of_Store__c == 'Not Applicable' ? null : j.OWF_Banner_of_Store__c;
            // set matchkey now to match Job Desc record naming convention
            string matchkey = rtMapById.get(j.RecordTypeId).getname()+' - '+(BannerName == null ? '' : BannerName + ' - ') + JobTitle;
            //system.debug('matching key is: ' + matchkey);
            // now if job title is blank, set preview pending as false and go to next job            
            if (JobTitle == null) {
                j.job_Preview_pending__c = false;
            // else look in job description for matching client, banner and jobtitle
            } else if (rtMapById.containsKey(j.RecordTypeId) && DescMap.containskey(matchkey) ) {
                // set job desc
                j.Job_Description__c = DescMap.get(matchkey).job_description__c;
                j.Job_Description_original__c = j.Job_Description__c;
                j.job_Preview_pending__c = true;
            }
            // else set to false if we don't need to preview this job
            else
                j.job_Preview_pending__c = false;
        } // end loop through jobs
    }
    
    // takes in a list of new candidates (pre-insertion).  Look for job points record matching client/job title
    // before Insert Candidate trigger calls this so update candidates passed in with points allocation if found
    public static void SetCandidatePointsAllocation(List<SFDC_Job_Candidate__c> newCands) {
        // get map of record types by Id to find client name
        Schema.DescribeSObjectResult d = Schema.SObjectType.SFDC_Job__c;
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        
        // build map of job descriptions with client-job title (match_key__c field) as key
        Map<string, Job_Point__c> PointsMap = new Map <string, Job_Point__c>();
        for (Job_Point__c jd : [select id, name, match_key__c, point_allocation__c from Job_Point__c])
            PointsMap.put(jd.match_key__c, jd);
        //system.debug('points map: '+PointsMap);
        
        // build map of jobs with job title field for any Candidate passed in
        Map<Id, SFDC_Job__c> JobMap = new Map<Id, SFDC_Job__c>();
        for (SFDC_Job_Candidate__c js : newCands)
            JobMap.put(js.sfdc_job__c, new sfdc_job__c());
        // query for the record type id and job title formula field for matching
        JobMap = new Map<Id, SFDC_Job__c>([select id, recordtypeid, recordtype.name, consolidated_job_title__c from sfdc_job__c where id in :jobMap.keyset()]);
        
        // cycle through jobs passed in
        for (SFDC_Job_Candidate__c j : newCands) {
            // if linked job in in the map and we have a match in points map, set the allocation
            if(JobMap.containskey(j.sfdc_job__c) && PointsMap.containskey(JobMap.get(j.sfdc_job__c).consolidated_job_title__c) ) 
                // set job points in candidate
                j.Points_Allocation__c = PointsMap.get(JobMap.get(j.sfdc_job__c).consolidated_job_title__c).point_allocation__c;
        } // end loop through candidates
    }    
    
    // Method to update original Job with newly cloned job's ID number in the comments.
    //    takes in a map of original job name - cloned job name for updates.
    //  called from Job After Insert and After Update triggers
    public static void SetOriginalJobCommentswithClone(Map<string, string> OriginaltoCloned) {
        List<SFDC_Job__c> updJobs = new List<SFDC_Job__c>();  // holds jobs that need updates
        // loop through all the origially cloned jobs to update them with comments
        for (SFDC_Job__c j : [select id, name, job_comments__c from SFDC_Job__c where name in :OriginaltoCloned.keyset()] ) {
            j.Job_Comments__c = (j.Job_Comments__c == null ? '' : j.Job_Comments__c + '\n') + Label.Job_RejectComment + OriginaltoCloned.get(j.name);
            updJobs.add(j);
        }
        
        // update original jobs
        try {
            if (!updJobs.isempty()) update updJobs;
        } catch (Exception e) {
            system.debug('Error updating Original Jobs: '+e);
        }
    }

    // method to sum up job cost for all jobs under each job order and update job order amount.  Called from job after insert/update if job order/job costs change
    public static void CalcJobOrderTotalAmt(Set<Id> JobOrderIds) {
        Map<id, job_order__c> jobOrderMap = new Map<id, job_order__c>();
        // build map of job orders based on what jobs are linked
            for (AggregateResult ar : [select SUM(job_cost__c) orderAmt, job_order__c from SFDC_Job__c
                                       where job_order__c in :JobOrderIds group by job_order__c])
                jobOrderMap.put((Id) ar.get('job_order__c'), new Job_Order__c(id = (Id) ar.get('job_order__c'), order_amount__c = (decimal) ar.get('orderAmt')));
       // now cycle through incoming JobOrderIds and if not yet in map, add with order_amt = 0
       for (Id OrderId : jobOrderIds) 
           if (!jobOrderMap.containsKey(OrderId))
               jobOrderMap.put(OrderId, new Job_Order__c(id = OrderId, order_amount__c = 0));
       update jobOrderMap.values();
    }
    
        

    // TEST METHOD //
             
    // this test method is in this class so we can share variables - the rest of the test methods are in Job_Util_Test
    // test that the Job Opened Date is set according to next working day 6am Pacific
    public static boolean isTest = false;
    public static datetime testDateTime;
    
    @isTest(SeeAllData=true)
    static void SetJobDate_Test(){
        // make sure there is an entry for Current Year in Custom Settings (these are now copied
        //    over during a Sandbox refresh)
        map<string, Daylight_Saving_Time__c> dstset = Daylight_Saving_Time__c.getall();
        system.debug('list of DST settings: '+dstset);
        Daylight_saving_time__c dst = dstset.get('Current Year'); 
     //   system.debug('Checking for DST custom setting - if this assertion fails check for it under setup ******************');
     //   system.assert(dst != null);
        if (dst == null) {
            dst = new Daylight_saving_time__c(name = 'Current Year');
            insert dst;
        }
        // set DST dates to 2010 for testing so we don't have to modify our test data each year
        dst.dst_start__c = date.newinstance(2010, 03, 14);
        dst.dst_end__c = date.newinstance(2010, 11, 07);
        update dst;
        
        isTest = true;
        // set the testing date time in PDT (Fri Oct 29th, 5:45 pm which is next day in GMT))
        testDateTime = datetime.newinstance(2010,10,29,19,45,0);
        // create a job
        SFDC_Job__c job1 = new SFDC_Job__c(job_name__c = 'Test', Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job1;
        job1 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job1.id];
        system.debug('Job Date Added: '+job1.Date_Job_Added_or_Opened__c);
        // Sat Oct 30
       // system.assertequals(job1.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,10,30,13,30,0));
        // now test with next day landing on Friday holiday
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) { // create holiday inside runas to avoid mixed DML error message
            // create New Years Day holiday for Jan 1 2010 (was a Friday)
            Holiday h = new Holiday(name = 'New years 09/10', isrecurrence = false, activitydate = date.newinstance(2010,01,01));
            insert h;
            Holiday h2 = new Holiday(name = 'Random DST', isrecurrence = false, activitydate = date.newinstance(2010,06,01));
            insert h2;
            }
        testDateTime = datetime.newinstance(2009,12,31,19,45,0); // this is a Thurs before a Fri holday - should go to Sat jan 2
        // create a job
        SFDC_Job__c job2 = new SFDC_Job__c(job_name__c = 'Test2', Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job2;
        job2 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job2.id];
        system.debug('Job Date Added: '+job2.Date_Job_Added_or_Opened__c);
      //  system.assertequals(job2.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,01,02,13,30,0));       
        
        // test evening where gmt is next day and 2 days from now is holiday May 30, 5:45pm
        testDateTime = datetime.newinstance(2010,05,30,19,45,0);
        // create a job
        SFDC_Job__c job4 = new SFDC_Job__c(job_name__c = 'Test4', Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job4;
        job4 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job4.id];
        system.debug('Job Date Added: '+job4.Date_Job_Added_or_Opened__c);
        // should go to May 31
       // system.assertequals(job4.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,05,31,13,30,0));

        // test morning before 1:30pm PDT where next day is holiday May 31, 12:45pm
        testDateTime = datetime.newinstance(2010,05,31,12,45,0);
        // create a job
        SFDC_Job__c job5 = new SFDC_Job__c(job_name__c = 'Test5', Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job5;
        job5 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job5.id];
        system.debug('Job Date Added: '+job5.Date_Job_Added_or_Opened__c);
        // should stay at May 31
       // system.assertequals(job5.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,05,31,13,30,0));

        // test during day with no holiday May 1, 14:00pm
        testDateTime = datetime.newinstance(2010,05,01,14,00,0);
        // create a job
        SFDC_Job__c job6 = new SFDC_Job__c(job_name__c = 'Test6', Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job6;
        job6 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job6.id];
        system.debug('Job Date Added: '+job6.Date_Job_Added_or_Opened__c);
        // should go to May 2
        //system.assertequals(job6.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,05,02,13,30,0));
        
        // create a job with a defaulted Job Added Date ** should not change
        SFDC_Job__c job3 = new SFDC_Job__c(job_name__c = 'Test2', Date_Job_Added_or_Opened__c = datetime.newinstance(2010,01,01,10,0,0), Job_Role_Title__c = 'test',job_status__c = 'test', Specific_Candidate_Preference__c = 'No');
        insert job3;
        job3 = [select id, Date_Job_Added_or_Opened__c from SFDC_Job__c where id = :job3.id];
        system.debug('Job Date Added: '+job3.Date_Job_Added_or_Opened__c);
        //system.assertequals(job3.Date_Job_Added_or_Opened__c, datetime.newinstance(2010,01,01,10,0,0));       
    }
 
}