/*****************************************************
      Class: CandidateUpdate
      Purpose: This class contains methods to support the CandidateUpdate visualforce page.

      1. CandidateUpdate(): method to initialize the page variables, including setting the New Status picklist values for each Candidate
              based on the current Status and querying for all fields in the Job and Job Candidate records to faciliate cloning
      2. Save(): method to save changes made to the fields on the page.  
              - If all Candidates are Rejected and the rejectAction boolean is checked, the store wants more candidates sent so clone the Job
                      and request more.
              - If at least 1 candidate was hired and the job status is Candidate Sent, close out the job.  Then:
                      - if more than 1 Candidate was hired and the job record type requires multiple job processing, ask user whether the
                          job is already in portal.  If so, create a Case, if not Clone the job and move the Candidate
                      - finally, send back null so the page button's action will open PSFT window and redirect to the Job

      Created: Aug 16/09 by Niki Vankerk, Vankerk Solutions, Inc
      Modification Log:
          Sept 24/09 (NVankerk): 
              1. Added check for OWF Jobs at end of Save to determine whether to popup the PSFT window or not
              2. Added boolean variable to determine if Job is in correct status to have Candidate updated.  This accounts for new, valid, Job
                 statuses added for New Store hires.
          Jan 4/10 (NVankerk):
              1. Added check for OWF Job when deciding to create multiple Jobs for >1 hire
          Feb 15/10 (NVankerk) :
              1. Added check for Job status after saving change to Candidates - if not Candidates Sent, don't run finishing logic
                 since there are more Candidates to come. 
          July 12/10 (Nvankerk):
               Rearchitected page to work for unlimited number of Candidates.
          Nov 3/10 (NVankerk): 
                  1. Updated Multiple Hire Logic to be opt in rather than opt out - empty list means no one sees this.  To add a Job type to follow
                      the logic, add the record type to the RequireMultipleHireLogicRecTypes set
                  2. Added logic to check req'd fields and then bypass save first time for OWF Hires, when they click Save the second time changes are saved
                  3. Add reference to new Job is old Job when all are rejected and a new job is requested.
          Dec 28/10 (NVankerk):
              1. added Leave in Current stage to New Status choices; added Comments field for every job rec type
          May 23/11 (NVankerk):  added flag to prevent Request More Candidate block from showing for some Job Types - used for Akzo to start
          June 6/11 (NVankerk): add check for On Demand billing type Accounts -if Candidate Sent and all hired/rejected, send email to CSM and don't change job status    
          June 17/11 (NVankerk): added cancel parameter to indicate if the save function should close job and if VF should force hire/reject status
          Aug 11/11 (NVankerk): added error handling in constructor method (put err=1 in URL to initiate), includes email with error message to Jeff/Niki
          Oct 3/11 (NVankerk) : changed Request more Candidates - made to a dropdown, added profiles to default to Yes and to autoClone new job instead of open for edit.
                                  also allowed GrowthWorks to have 45 day interview interval.
          Oct 30/11 (NVankerk): added Longos to Build Status method to allow for Interviewing 1/2 status
          Nov 7/11 (NVankerk): updated clone Job method to null out additional fields
          Jan 10/12: added No Show/No Contact workflow
          Mar 9/12: Changed save so Rejection details are not required for SLA Job Posting only
          Apr 14/12: FGL: updated candidate status values and require Scheduled Interview Date/Time instead of Interview Date field.
          Apr 22/12: FGL sports rejection action - don't require certain fields
          June 4/12: Glentel: added background check functionality for Glentel only but kept popup window off for now
          June 10/12: FGL: add reference check completed before hiring functionality
          June 12/12: Glentel: added popup window in to activate the BAckCheck feature
          June 30/12: FGL reference check can be skipped for hire if Job's specific candidate reqd is Yes - Yes - Same Store Rehire
          July 29/12: changed requirement for Is Candidate Suitable field based on Rejection Reasons
          Aug 28/12: added call to updateRejectionReason method in controller to see if we can fix the null pointer error for easyhome Rejection save.
          Sept 1/12: added Sent to Store/Manager status for Longo jobs
          Jan 1/13: FGL rejection candidates - require Is Candidate Suitable and make comments required for certain reasons
          Mar 5/13: replacement candidate question based on Interview Date or Date Candidate Sent
          Mar 30/13: added Msg Left for Candidate check when status = Left Message
          Mar 30/13: add support for highlighting specific Candidate that we launched this from using UpdateCandidatePage logic
          June 8/13: added dynamic Rejection Reason based on client/job fields
          June 12/13: added support for banned profiles not allowed to ask for more candidates
          June 15/12: add AN/Mark's to require reference check before hiring
          June 19/13: update Could not Contact rejection reason
          Sept 22/13: added check for Reason for Hire reqd when Hiring, commented out until we are ready to deploy this change
          Oct 1/13: updated code to refer to job record type name instead of ID values.
          Mar 24/14: update candidate query to only pull non formula fields to save view state
          March 2015: removed reference to Multiple Hire action and Candidate cloning.  Moved full job query into job clone function to reduce ViewState 
          
          July 2017: added functionallity to support new service model, candidate replacement
          
*****************************************************/
public with sharing class CandidateUpdate {
    // Job object that Candidates Submitted to Job are linked to
    public SFDC_Job__c Job { get; set;}     
    // holds the Contact associated with the current user
    private Id ContactId {get; set;}
    // holds the current users language
    public string userLanguage {get; set;}
    
    // error handling in constructor
    public boolean error {get; set;}

    // holds whether the Job Status is valid for Candidate updates
    public Boolean ValidStatus {get; set;}
    
    // to add Job records types that should display the Candidate Status Notes field, add the Job Record Type name to the list
    //        to use a comma separated list: new Set<string>{'Kal-Tire',’<next_record_name>’}
    //        empty list: new Set<string>()
    private Set<string> DisplayCanStatusRecTypes = new Set<string>{'Kal-Tire','Town Shoes', 
            'Prairie Lube', 'MFG Demo', 'Overwaitea Food Group', 'GrowthWorks', 
            'MindField OnDemand', 'Source for Sports', 'Fountain Tire'};
    public boolean DisplayCanStatus {get; set;}    
    
    // if all the Candidates have been rejected, most Job Types will allow requesting more.  The following set of Job Record Types
    //    DON'T want the Request More question to show
    //  Sept 13 2012, removed Akzo Nobel from this set: 'AkzoNobel'
    // Setp 2, 2015 added the 1800 got junk record types
    private Set<string> NoRequestMore = new Set<string>{'1800GotJunk-CSS','1800GotJunk-FCR','1800GotJunk-PO', 'Overwaitea Food Group', 'Overwaitea Food Group Sourcing'};
    public boolean RequestMoreCandidates {get; set;}

    //  The following set of Job Record Types want the Request More question to default to Yes
    //    Added for Glentel Oct 4 but removed again Oct 6/11
    private Set<string> AutoRequestMore = new Set<string>();
    public boolean AutoRequestMoreCandidates {get; set;}

    //  The following set of Job Record Types want the Job created for requesting more candidates after all rejected to simply be created
    //    rather than opened in edit form for the user to modify if desired.  Added for Glentel
    //private Set<string> AutoCloneRequestMore = new Set<string>{'Glentel', 'PPG USA'};  
    //public boolean AutoCloneRequestMoreCandidates {get; set;}
    
    //  The following set of Job Record Types should skip the No Show/No Contact rejection logic workflow
    //    Added for OWF
    private Set<string> SkipNoShowNoContact = new Set<string>{'Overwaitea Food Group'};  
    public boolean SkipNoShowNoContactCandidates {get; set;}    
            
    // if not yet filled, initialize Candidates list with all linked Candidates Submitted to Job
    public List<CandidateWrapper> Candidates {get; set;}  // Candidates are those in an open status (not Hired/Rejected)
    public List<CandidateWrapper> FinalizedCandidates {get; set;}  // finalized are those already in Hired/Rejected
    // initialize numCandidates with size of the list - used to determine which candidate segments to render on page
    public integer NumCandidates {get; set;} // number of "open" candidates         
    public integer NumFinalCandidates {get; set;}    // number of "final" candidates in Hired/Rejected
    public integer NumTotalCandidates {get; set;}   // number of total candidates linked to Job
        
    // boolean to track whether user wants to request more Candidates when all have been marked as rejected
    // public boolean rejectAction { get; set;}  -- removed to be replaced by a picklist rather than checkbox
    public List<SelectOption> rejAction {get; set;}
    public string selectedRejAction {get; set;}
    
    // string to hold the URL to send users for the cloned job created during rejection action
    private string rejectURL {get; set;}
    
    // is this job for a New store?  Used when updating the Job Status fo hiring/rejecting etc
    private boolean JobforNewStore {get; set;}
    
    //NSM, Transfer Hire into 2nd Job
    //display radio list of jobs that a candidate can be placed into
    public list<SFDC_Job__c> lJobToPlaceCandidate { 
        get { 
            if(lJobToPlaceCandidate==null) {
                lJobToPlaceCandidate = NewServiceModel_Util.FindMatchingJobs(Job);
            }
            return lJobToPlaceCandidate;
        }
        set;
    }
    public integer numJobsToPlaceHire { 
        get { return lJobToPlaceCandidate.size(); }
        set;
    } 
    public string jobHirePlaced { get; set;}
    public SFDC_Job__c jobHirePlacedObject { get; set;}
    /*public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for (SFDC_Job__c j : lJobToPlaceCandidate) {
            string jobTitle = j.recordtype.name != 'Overwaitea Food Group' ? (j.Banner_of_Store__c + ' - ' + j.Job_Title_for_Banner__c) : (j.OWF_Banner_of_Store__c + ' - ' + j.OWF_Job_Title__c);
            jobTitle = j.name + ' - '  + jobTitle;
            options.add(new SelectOption(j.id,jobTitle));
        }
        return options;
    }*/
    //method called when job radio button triggered
    public void checkSelectedValue(){        
        jobHirePlacedObject = null;
        
        //find selected job from radio id
        for (SFDC_Job__c j : lJobToPlaceCandidate) {
            if(j.id==jobHirePlaced) {
                jobHirePlacedObject = j; 
            }
        }      
    } 
   
    
    // find the current number of newly Rejected Candidates
    private list<SFDC_Job_Candidate__c> Candidate_Rejected {get; set;}
    public integer numRejected {set;        
        get{
            Candidate_Rejected = new List<SFDC_Job_Candidate__c>();
            for (CandidateWrapper c : Candidates){
                // count if Rejected and if NOT OFG, check either Rejection reason is not No Contact OR skipping No Contact/No Show OR status of Awaiting Contact 
                if (c.selectedstatus == 'Rejected' && (Job.recordtype.name == 'Overwaitea Food Group' || 
                                                      (Job.recordtype.name != 'Overwaitea Food Group' && (c.can.Rejection_Reason_for__c != 'Could not Contact Candidate' || SkipNoShowNoContactCandidates || c.can.status__c == 'Awaiting MindField Group Contact')))) {
                    Candidate_Rejected.add(c.can);
                }
            }
            return Candidate_Rejected.size();
         }
    }

    // find the current number of newly Hired Candidates
    private list<SFDC_Job_Candidate__c> Candidate_Hired {get; set;}
    // run this each time so we can see dynamically how many are hired as we change job statuses in page
    public integer numHired {set;        
        get{
            NewHiredList.Clear();
        
            // list of Hired Candidates
            Candidate_Hired = new List<SFDC_Job_Candidate__c>();
            for (CandidateWrapper c : Candidates){
                if (c.selectedstatus == 'Hired'){
                    Candidate_Hired.add(c.can);
                    NewHiredList.add(new CandidateWrapper(c.can, newServiceModel));
                }
            }
            return Candidate_Hired.size();
         }
    }
    
    
    public integer TotalHired{set;        
        get{
            return BuildTotalHiredList().size();
            }
            
    
    }
    
    //holds list of previous hires
    private list<CandidateWrapper> PreviousHiredList = new List<CandidateWrapper>(); 
    private list<CandidateWrapper> NewHiredList = new List<CandidateWrapper>();
    
    
    //Feb 1, 2018 --- build list of TOTAL hired
    private list<CandidateWrapper> BuildTotalHiredList() {
        list<CandidateWrapper> TotalHired = new List<CandidateWrapper>();
        TotalHired.addAll(PreviousHiredList); //built on page load
        TotalHired.addAll(NewHiredList);      //built when get/set numHired is called. 
        return TotalHired;
    }
     private list<CandidateWrapper> BuildTotalNotHiredList() {
        list<CandidateWrapper> TotalNotHired = new List<CandidateWrapper>();
        for (CandidateWrapper c : Candidates) {
            if (c.selectedstatus != 'Hired' && c.can.status__c != 'Hired'){
                TotalNotHired.add(c);
            }
        } 
        return TotalNotHired;
    }
    
    // find the current number of candidates replaced under NSM
    public integer numPreviouslyReplacementsGranted {get; set;}
    
    private list<SFDC_Job_Candidate__c> CurrentReplacementsGranted{get; set;}
    //build list of new replacements, have to count post as well because they are potential replacements
    public integer numCurrentReplacementsGranted {set;        
        get{
            // list of valid rejected candidates
            CurrentReplacementsGranted= new List<SFDC_Job_Candidate__c>();
            for (CandidateWrapper c : Candidates){    //not giving replacement if cancelled by CE          //temporarily count as valid so we dont display new job option
                if (c.selectedstatus == 'Rejected' && String.isEmpty(Job.Reason_for_Job_Cancellation__c) && (NewServiceModel_Util.IsValidRejectionReason(c) || String.isBlank(c.can.Rejection_Reason_for__c))){
                    CurrentReplacementsGranted.add(c.can);
                }
            }
            return CurrentReplacementsGranted.size();
         }
    }
    public integer numTotalReplacementsGranted { set;
        get {
            return numCurrentReplacementsGranted + numPreviouslyReplacementsGranted;
        }
    }
    
    //number of candidates that where rejected but didnt qualify for replacement
    public integer numRejectedWithoutReplacement { set;
        get {
            return numTotalRejected - numTotalReplacementsGranted;
        }
    }
    
    
    // find the current number of already Hired Candidates
    public integer numPreviouslyHired {get; set;}
    // find the current number of already Rejected Candidates
    public integer numPreviouslyRejected {get; set;}
    
    public integer numTotalHired { set;
        get {
            return numHired + numPreviouslyHired;
        }
    }
    public integer numTotalRejected { set;
        get {
            return numRejected + numPreviouslyRejected;
        }
    }

       


    // Confirm OWF Hire tracks whether they need to confirm the hire to make the save
    public boolean ConfirmOWFHire {get; set;}
    // count number of candidates with status of Background Check - used when set to Background Check status to open popup window to start Background Check process
    public integer NumBackgroundCheck {get; set;}    
    public boolean BackgroundCheckPop {get; set;}
    
    
    // Track whether job requires all references checked before allowing to hire - FGL only so far
    //        Add more clients with a comma separated list: new Set<string>{'Marks',’<next_rectype_name>’} 
    //        empty list: new Set<string>()
    //   June 2013: added AN, Mark's
    //private Set<string> RefCheckReqdJobTypes = new Set<string>{'FGL Sports', 'AkzoNobel', 'Marks'};
        
    // Project: PPG Canada (Interview Scheduling & Reference Removal), remove AkzoNobel 
    //private Set<string> RefCheckReqdJobTypes = new Set<string>{'FGL Sports', 'Marks'};
    private Set<string> RefCheckReqdJobTypes = new Set<string>{}; //Remove FGL and Marks since moving to the NSM
    private boolean RefCheckReqd {get; set;}    
    
    // boolean for forcing exception in test code
    private boolean istest = false;
    
    private string jobOwnerLanguage = 'English';
    
    // boolean to indicate using new service model
    public boolean newServiceModel {get; set;}
    
    // boolean to indicate if referred candidate or not
    //if so, they can't get another when they are rejected
    public boolean newServiceModelIsReferredCandidate {get; set;}
       
    public decimal numCandidatesForSLA{get; set;}
    
    // initialize page controller
    public CandidateUpdate(ApexPages.StandardController controller) {
        error = false;
        Job = (SFDC_Job__c) controller.getRecord();
        // pull in all required fields for processing - need to query directly instead of relying on fields added to the VF page in case some profiles
        //    don't have visibility to a field but we use it for processing
        Job = [SELECT id, Job_Status__c, job_owner_link__r.managerid, recordtype.name, Job_Billing_Type__c, Number_of_Replacement_Candidates_Require__c, Job_Comments__c, name, MindField_Job_Type__c, 
               SLA_Level__c, Specific_Candidate_Preference__c, Client_Profile_Workflow_FCR_Reference__c,Using_New_Service_Model__c, Num_of_Candidates_for_Delivery_Agreement__c,
               Banner_of_Store__c, OWF_Banner_of_Store__c, Job_Title_for_Banner__c, Career_Site_Alternate_Job_Title__c,
               Name_of_Person_Submitting_Request__c, Mindfield_Service__c, Role_type__c, Program_Type__c, 
               QCP_Acknowledgement__c, Number_Of_Hours_Per_Week__c, FT_or_PT__c, Hours_of_Availability__c, 
               NSM_Specific_Candidate_Requested__c, Specific_Candidate_Name__c, Specific_Candidate_Phone_Number__c,
               Specific_Candidate_Email__c, Specific_Candidate_Phone_Number_2nd__c, Job_to_Place_Candidate__c,Store__c,Store__r.id,
               Job_Title_for_Role__c, Department__c,OwnerId,Reason_for_Job_Cancellation__c,Job_Owner_Language_Profile__c,Date_Job_Added_or_Opened__c, Date_Delivery_Complete__c,
               Job_Code_OWF__c,OWF_Department__c,OFG_Job_Template_Description__c,OWF_Union_Code__c,OWF_Job_Title__c,Career_Site_Alternate_Job_Title_OFG__c,Record_Type_Developer_Name__c
              FROM sfdc_job__c WHERE id = :job.id];
        
        
        // test error message by using temp parameter in URL
        if (ApexPages.currentPage().getParameters().get('err') == '1') isTest = true;
        try {
            // force exception for test coverage
            if (isTest) {
                string e; e.tolowercase();
            }
            /*  default all fields/lists */
            // get current user details
            User currUser = [select id, contactid, languagelocalekey, managerid, profile.name from User where id = :UserInfo.getUserId()];
            ContactId = currUser.contactid;
            userLanguage = currUser.languagelocalekey;
            jobOwnerLanguage = Job.Job_Owner_Language_Profile__c;
    
            newServiceModel = Job.Using_New_Service_Model__c;
            newServiceModelIsReferredCandidate = Job.NSM_Specific_Candidate_Requested__c!=null ? Job.NSM_Specific_Candidate_Requested__c.contains('Yes_Referred_Candidate') : false;
            numCandidatesForSLA = Job.Num_of_Candidates_for_Delivery_Agreement__c;
    
            // March 2017, SCRAP THIS IDEA, GO BACK TO ORIGINAL WAY, LINE 178
            // Project: PPG Canada (Interview Scheduling & Reference Removal)
            // Dec 8, 2016
            //Use client profile so determine if reference checks are required.
            /*RefCheckReqd = (Job.Client_Profile_Workflow_FCR_Reference__c==null ||
                            string.isBlank(Job.Client_Profile_Workflow_FCR_Reference__c) ||
                            Job.Client_Profile_Workflow_FCR_Reference__c=='Disabled') ? false : true;*/
    
    
            // determine whether Job status is valid for Candidate updates; can be Open/Active or Candidates Sent/Additional Candidates Reqd and for new or existing stores
            if (Job.Job_Status__c.contains('Open/Active Job') || Job.Job_Status__c.contains('Candidate') )
                ValidStatus = true;
            else ValidStatus = false;
            
            // determine if the Job is for a New store based on the current Job status
            if (Job.Job_Status__c.contains('New Store')) JobforNewStore = true;
            else JobforNewStore = false;
    
            // determine whether this job should display the Candidate Status field
            if (DisplayCanStatusRecTypes.contains(job.recordtype.name))
                DisplayCanStatus= true;
            else 
                DisplayCanStatus= false;
            
            // determine whether the job should REQUEST MORE CANDIDATES if all are rejected
            // June 2013: want to check the user's profile against those in the Banned profile list - could be the client is 
            //   allowed to request more candidates but this particular user is not allowed to create new jobs
            // cycle through custom setting where full profile name is in Profile name field (too long for setting Name to be used)
            Map<string, BannedProfileList__c> bannedProfileNames = new Map<string, BannedProfileList__c>();
            for (BannedProfileList__c p : BannedProfileList__c.getall().values()) {
                bannedProfileNames.put(p.Profile_Name__c, p);
            }
            // either job type is in the list of Not allowed to request more OR user profile is banned OR the cancel parameter is set indicating we
            //  want to close this job out regardless
            if (NoRequestMore.contains(job.recordtype.name) || bannedProfileNames.containskey(currUser.profile.Name) || ApexPages.currentPage().getParameters().get('cancel') == '1')
                RequestMoreCandidates = false;
            else 
                RequestMoreCandidates = true;

            // determine whether the autoRequestMoreCandidates is true - meaning the Request More defaults to Yes
            if (AutoRequestMore.contains(job.recordtype.name))
                AutoRequestMoreCandidates = true;
            // if not then we don't default the value
             else AutoRequestMoreCandidates = false;
            
            // determine whether the autoCreateRequestMoreCandidates is true - used to send job through cloning when they request more
            //    during the save rather than opening a new job for edit
            //if (AutoCloneRequestMore.contains(job.recordtype.name))
            //    AutoCloneRequestMoreCandidates = true;
            //else 
            //    AutoCloneRequestMoreCandidates = false;

            // determine whether the SkipNoShowNoContactCandidates is true - used to skip No Show/No Contact processing on VF page and Save method
            SkipNoShowNoContactCandidates = SkipNoShowNoContact.contains(job.recordtype.name);
            // regardless of client record type, add this job to Skip No Show/Contact if the SLA is Job Posting Only
            if (job.SLA_Level__c == 'Job Posting Only') SkipNoShowNoContactCandidates = true;
            
            // make a list of open Candidates using the wrapper class so we can track their new status
            Candidates = new List<CandidateWrapper>();
            // use a temporary list of Candidates so we can control order of candidates in list
            List<CandidateWrapper> tempCandidates = new List<CandidateWrapper>();
            // URL parameter for featured Candidate that is passed in from CandidateUpdatePage
            string featuredCandidate = ApexPages.currentPage().getParameters().get('feature');
            // candidate record we will populate if we have a featured candidate, gets added to open Candidates list first
            CandidateWrapper featuredCanRecord;
            
            // workaround a bug where once rendered variable is false it will not render any other sections in repeat
            // have to make sure any Hired or Rejected Candidates are shown in a separate list
            FinalizedCandidates = new List<CandidateWrapper>();
            numPreviouslyHired = 0;
            numPreviouslyRejected = 0;
            numPreviouslyReplacementsGranted = 0;
            // for all Candidates, we initialize the record, picklist for Status and prepopulate the selected Status
            //  March 2015: here we only query the fields we need to cut down on the ViewState when there are hundreds of candidates
            for (SFDC_Job_Candidate__c can : [select id, Candidate_Name__c, Candidate__c, Status__c, Status_Text__c, Rejection_Comments__c, Rejection_Reason_for__c, Interview_Date__c, Candidate_Message_Date__c,
                        Candidate_Status_Notes_if_applicable__c, Candidate__r.First_Name__c, Candidate__r.Last_Name__c, SFDC_Job__r.SLA_Level__c, SFDC_Job__r.recordtypeid, SFDC_Job__r.recordtype.name, sfdc_job__r.createddate,
                        References_All_Reviewed__c, Scheduled_Interview_Date_Time_PST__c, Scheduled_Interview_Date_Time__c,  Was_Candidate_Contacted_for_Interview__c, Rejection_Is_Candidate_Suitable__c, Contact_Name__c,
                        Contact_Phone__c, Best_Time_for_Candidate_to_Contact_You__c, Request_Another_Candidate__c, Message_left_for_candidate__c, Date_Candidate_Sent__c, candidate__r.StarRating__c,Is_NOW_Within_Time_to_Disposition_Period__c,
                        Do_you_want_a_replacement_candidate__c,Candidate_Audit_Result__c,Datetime_Candidate_Rejected__c,Replacement_Candidate_Given__c,Using_Interview_Scheduling__c
                        from SFDC_Job_Candidate__c where SFDC_job__c = :job.id order by candidate__r.StarRating__c desc nulls last, Candidate_Name__c]) {            

                if (can.status__c == 'Hired' || can.status__c == 'Rejected') {
                    FinalizedCandidates.add(new CandidateWrapper(can, newServiceModel));
                    // set hired/rejected count
                    if (can.status__c == 'Hired') 
                    { 
                        numPreviouslyHired++;
                        PreviousHiredList.add(new CandidateWrapper(can, newServiceModel));
                    }    
                    else if (can.status__c == 'Rejected') 
                    { 
                        numPreviouslyRejected++;
                        if(can.Replacement_Candidate_Given__c) {
                            numPreviouslyReplacementsGranted++;
                        }     
                    }
                }
                // if this candidate is the featured one, put in separate record to hold
                else if (can.candidate__c == featuredCandidate)
                    featuredCanRecord = new CandidateWrapper(can, newServiceModel);
                // else add to open Candidates temp list
                else
                    tempCandidates.add(new CandidateWrapper(can, newServiceModel));
            }
            // now build open Candidates list with the featured Candidate first if we have one
            if (featuredCanRecord != null)
                Candidates.add(featuredCanRecord);
            Candidates.addall(tempCandidates);
                
            // Find number linked
            NumCandidates = Candidates.size();
            NumFinalCandidates = FinalizedCandidates.size();
            NumTotalCandidates = NumCandidates + NumFinalCandidates;
            
            ConfirmOWFHire = false;
            rejectURL = null;

            rejAction = new List<SelectOption>(); 
            rejAction.add(new selectOption('none', '--None--'));
            rejAction.add(new SelectOption('Yes', Label.CanUpd_Request_More_Yes)); 
            rejAction.add(new SelectOption('No', Label.CanUpd_Request_More_No));
            // default picklist choice 
            // if autoRequestMore is set, default to Yes
            if (AutoRequestMoreCandidates) selectedRejAction = 'Yes';
            else selectedRejAction = 'none';    

            NumNoShow = 0;
            NumBackgroundCheck = 0;
            BackgroundCheckPop = false;
            
            // determine whether the RefCheckReqd is true - used to send make sure new hires have their references all checked
            if (RefCheckReqdJobTypes.contains(job.recordtype.name))
                RefCheckReqd = true;
            else 
                RefCheckReqd = false;
                         
            // if we are in cancel mode, show info message in message block
            if ( ApexPages.currentPage().getParameters().get('cancel') == '1')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.CanUpd_CancelInfoText));
            
            // initialize Candidates NoShow and DisplayCandidateSuitable fields
            updateRejectionReason();  
           
        } catch (Exception e) {
            error = true;
            // call utility to send error email
            //exceptionEmail(e);
            NewServiceModel_Util.SendErrorEmail(e);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getstacktracestring()+': '+e));
        }
    }
    
    // method to send an email if there is a caught exception
    /*private void exceptionEmail(Exception e) {
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'jeff.perron@mindfieldgroup.com'};
         mail.setToAddresses(toAddresses);
         mail.setReplyTo('jeff.perron@mindfieldgroup.com');
         mail.setSenderDisplayName('Mindfield Group: Apex error message');
         mail.setSubject('Salesforce.com Error from ' + UserInfo.getOrganizationName());
         mail.setPlainTextBody(e.getStackTraceString()+': '+e+'\n\nUser: '+userinfo.getUserName()+'\nURL: '+ApexPages.currentpage().getURL());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }*/      

    public PageReference CheckCancel() {
        // if Cancel parameter is set and there are no open candidates, call save and let page redirect as needed
        if ( ApexPages.currentPage().getParameters().get('cancel') == '1' && Candidates.size() == 0) {
            //system.debug('no candidates in the cancel page');
            return OnSave();
        }
        else return null;
    }
            
    public PageReference OnSave() {
          //boolean newServiceModelCloseJob = false; //close job under NSM if HM didnt want additional candidate and opted to close job
          boolean newServiceModelHoldOnClosingJob = false; //we dont want to close the job if getting replacement candidate
          Savepoint sp = Database.setSavepoint(); 
          boolean DataError = false;
          boolean RejectNoContact = false;
          integer NumCandidatesRequested = 0;  // counts num candidates Rejected with No Show < 7 days and asks for an additional candidate
          List<SFDC_Job_Candidate__c> updCandidates = new List<SFDC_Job_Candidate__c>();
          try {
              // check required fields since VF page using required property will not allow processing status updates individually
                   
              //******************************************************************************************
              //Candidate Update Logic START ------------------------------------------------------------------
              //
              //******************************************************************************************                                         
              // iterate through Candidates list only, not Finalized Candidates since those can't be updated
              for (CandidateWrapper c : Candidates) {
                  boolean recordError = false; // track if this Candidate had an error
                  
                  
                  // check all Candidates have a selected status or kick them back with error messages - only required if SLA is not 'Job Posting Only'
                  if (c.selectedStatus == 'none' && job.sla_level__c != 'Job Posting Only') {
                      ApexPages.Message Msg1= new ApexPages.Message(ApexPages.Severity.FATAL, Label.Error_New_Status1+' '+c.can.Candidate_Name__c +'.  '+Label.Error_New_Status2+
                          ' '+c.can.Candidate_Name__c+' '+Label.Error_New_Status3,'');
                      ApexPages.addMessage(Msg1);
                      recordError = true;
                  }

                  // if Reference Check Reqd for this job and candidate changed to Hire, make sure all refs reviewed or switch back to original
                  //    status and add Warning type message; allowed to continue without references if Specific Can Reqd is Yes - Same Store Rehire
                  //April 2018, Removed for FGL and Marks...no one else uses anymore now.
                  //See field, RefCheckReqd
                  if (RefCheckReqd && c.selectedStatus == 'Hired' && !c.can.References_All_Reviewed__c && job.Specific_Candidate_Preference__c != 'Yes - Same Store Rehire') {
                      // change selectedStatus back to candidate status
                      c.selectedStatus = c.can.status__c;
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.Reminder_New_Desc1+' '+c.can.Candidate_Name__c+' '+Label.CanUpd_Reference_Check_Warning));
                      recordError = true; 
                      // set Reference Alert boolean on candidate to let hiring manager know there was an attempt to hire
                      c.can.reference_alert__c = true;                     
                  }
                  // if Leave Message, must have Date Message Left filled in
                  if (c.selectedStatus != null && c.selectedStatus.contains('Left Message') && c.can.candidate_message_date__c == null ) {
                      c.can.candidate_message_date__c.addError(Label.Error_Msg_Date_Required);
                      recordError = true;
                  }
                  // if Leave Message, must have Date Message Left less than 2 weeks ago
                  if (c.selectedStatus != null && c.selectedStatus.contains('Left Message') && c.can.candidate_message_date__c < date.today().adddays(-15) ) {
                      c.can.candidate_message_date__c.addError(Label.Error_Msg_Date_In_Past);
                      recordError = true;
                  }
 
                  // Interviewing Date check: for FGL Jobs/Marks/PL, we check Scheduled Interview Date/Time field, otherwise we look at the Interview Date field
                  // FGL, Marks, Prairie Lube, PPG USA, Canadian Tire check
                  //if (Job.recordtype.name == 'FGL Sports' || Job.recordtype.name == 'Marks' || Job.recordtype.name == 'Prairie Lube' || Job.recordtype.name == 'PPG USA' || Job.recordtype.name == 'Canadian Tire') {
                  //March 30, 2017 - we want PPG Canada frontline, we want date filled in
                  //July 2017 - if profile set to new service model then we need to validate interview scheduling
                  if (Job.recordtype.name == 'FGL Sports' || Job.recordtype.name == 'Marks' || Job.recordtype.name == 'Prairie Lube' || Job.recordtype.name == 'PPG USA' || Job.recordtype.name == 'Canadian Tire' ||
                      Job.recordtype.name == 'Country Grocer' ||
                      //(Job.recordtype.name == 'AkzoNobel' && Job.Role_type__c=='Frontline') ||
                      //AkzoNobel is doing interview scheduling for ALL now
                      Job.recordtype.name == 'AkzoNobel' ||
                      Job.recordtype.name == 'Direct Tap' ||
                      newServiceModel) {
                      // if Interviewing, must have scheduled interiew date/time filled in
                      if (c.selectedStatus.contains('Interviewing') && c.can.Scheduled_Interview_Date_Time__c == null ) {
                          c.can.Scheduled_Interview_Date_Time__c.addError(Label.Error_Interview_Date_Required);
                          recordError = true;
                      }   
                      // if Interviewing, must have interview date less than 30 days ago
                      else if (c.selectedStatus != null && c.selectedStatus.contains('Interviewing') && c.can.Scheduled_Interview_Date_Time__c.date() < date.today().adddays(-30) ) {
                          c.can.Scheduled_Interview_Date_Time__c.addError(Label.Error_Interview_Date_In_Past);
                          recordError = true;
                      }                                     
                  } // end if FGL/Marks/PL and checking Scheduled Interview field
                  
                  //Bug fix, May 2017
                  //else was letting AkzoNobel Management slip through (For this we dont want interview scheduling)
                  //above caught just AkzoNobel Frontline
                  //else {
                  else if(Job.recordtype.name != 'AkzoNobel') {
                      // if Interviewing, must have interview date filled in
                      if (c.selectedStatus != null && c.selectedStatus.contains('Interviewing') && c.can.interview_date__c == null ) {
                          c.can.interview_date__c.addError(Label.Error_Interview_Date_Required);
                          recordError = true;
                      }
                      // if Interviewing and not Growthworks, must have interview date less than 30 days ago
                      if (c.selectedStatus != null && c.selectedStatus.contains('Interviewing') && Job.recordtype.name != 'GrowthWorks' && c.can.interview_date__c < date.today().adddays(-30) ) {
                          c.can.interview_date__c.addError(Label.Error_Interview_Date_In_Past);
                          recordError = true;
                      }
                      // if Interviewing and client IS Growthworks, must have interview date less than 45 days ago
                      if (c.selectedStatus != null && c.selectedStatus.contains('Interviewing') && Job.recordtype.name == 'GrowthWorks' && c.can.interview_date__c < date.today().adddays(-45) ) {
                          c.can.interview_date__c.addError(Label.Error_Interview_Date_In_Past_45);
                          recordError = true;
                      }
                  } // if checking interview date (non FGL/Marks)
                  // if we don't skip No Show/No Contact processing and job is now Rejected and previous status was not Awaiting MFG, check Could not Contact Candidate reason and flip status out of Rejected if needed
                  if (!SkipNoShowNoContactCandidates && c.selectedStatus == 'Rejected' && c.can.status__c != 'Awaiting MindField Group Contact' && c.can.Rejection_Reason_for__c == 'Could not Contact Candidate') {
                      c.selectedStatus = 'Awaiting MindField Group Contact';
                      // default other Rejection Answers here
                      c.can.Was_Candidate_Contacted_for_Interview__c = 'Yes';
                      c.can.Rejection_Is_Candidate_Suitable__c = 'No - Candidate isn\'t suitable FOR ANY OF OUR Stores';
                      // set boolean to indicate successful save should redirect to a No Contact confirmation page
                      RejectNoContact = true;
                      // check for required fields for No Contact reason - Phone, Name, Time
                      if (c.can.Contact_Name__c == null) {
                          c.can.Contact_Name__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      } if (c.can.Contact_Phone__c == null) {
                          c.can.Contact_Phone__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      } if (c.can.Best_Time_for_Candidate_to_Contact_You__c == null) {
                          c.can.Best_Time_for_Candidate_to_Contact_You__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      }    
                      // if No Contact and Interview Date or Candidate sent < 7 days, check for answer to Request Additional Candidate
                      if ( c.CandSentorInterviewLessThan7Days && c.can.Request_Another_Candidate__c == null) {
                          c.can.Request_Another_Candidate__c.addError(Label.Error_Value_is_required);
                          recordError = true;                       
                      }                 
                  }
                  // if still Rejected, check each required Rejected field
                  if (c.selectedStatus == 'Rejected') {
                  
                      /*
                        Feb 6, 2018 .. . pull this out becasue we will no longer ask for other rejection reason
                      //July 2017, New Service Model validations-----------------------------------------------------------------
                       if(newServiceModel) {
                         recordError = NewServiceModel_Util.ValidateNSMCandidateRequiredFields(c, numTotalHired);
                       }
                       //END July 2017, New Service Model validations-----------------------------------------------------------------
                      */
                  
                      // July 2017, New Service Model... dont need to check this.
                      // was contacted is required except for SLA = job posting only and FGL sports/Marks
                      //April 2018, FLG and Marks on NSM
                      if (!newServiceModel && c.can.Was_Candidate_Contacted_for_Interview__c == null && job.sla_level__c != 'Job Posting Only' && Job.recordtype.name != 'FGL Sports' && Job.recordtype.name != 'Marks') {
                          c.can.Was_Candidate_Contacted_for_Interview__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      } 
                      // Rejection reason is required except for SLA = job posting only                     
                      if (c.can.Rejection_Reason_for__c == null && job.sla_level__c != 'Job Posting Only' ) {
                          c.can.Rejection_Reason_for__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      } 
                      
                      // Is Candidate Suitable is required except for SLA = job posting only and if FGL sports/Marks or is CAndidate Suitable should be displayed for this Candidate
                      //This doesnt apply when using new service model
                      if (!newServiceModel && c.can.Rejection_Is_Candidate_Suitable__c == null && job.sla_level__c != 'Job Posting Only' && (Job.recordtype.name == 'FGL Sports' || Job.recordtype.name == 'Marks' || c.DisplayIsCandidateSuitable ) ) {
                          c.can.Rejection_Is_Candidate_Suitable__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      }

                      // Update July 2018, now we require rejection reason for all auditable rejections in the NSM
                      // Rejection Comments are required for FGL sports/Marks with relevant Rejection Reason
                      //if ((c.can.Rejection_Comments__c == null || c.can.Rejection_Comments__c == '') && (Job.recordtype.name == 'FGL Sports' || Job.recordtype.name == 'Marks' ) 
                      //            && c.FGLRejectionCommentsReqd ) {
                      //    c.can.Rejection_Comments__c.addError(Label.Error_Value_is_required);
                      //    recordError = true;
                      //}
                      
                      if ( 
                           newServiceModel &&
                           (c.can.Rejection_Comments__c == null || c.can.Rejection_Comments__c == '') &&
                           
                           (
                             c.can.Rejection_Reason_for__c == 'Candidate does not have the appropriate language or communication skills for the role' ||
                             c.can.Rejection_Reason_for__c == 'Candidate does not have the appropriate skills and experience for the role' ||
                             c.can.Rejection_Reason_for__c == 'Candidate is unwilling or unavailable to work required shifts' ||
                             c.can.Rejection_Reason_for__c == 'Candidate’s wage expectation is too high' ||
                             c.can.Rejection_Reason_for__c == 'Candidate is unwilling or unable to commute to place of work'
                           )
                           
                         )  
                      {
                          c.can.Rejection_Comments__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      }
                      
                      //July 2018, DEPRECATED
                      // portal users can't choose 'No Update Provided' for the Rejection Reason field
                      //if (ContactId != null && c.can.Rejection_Reason_for__c == 'No Update Provided') {
                      //    c.can.Rejection_Reason_for__c.addError(Label.Error_Reject_No_Update);
                      //    recordError = true; 
                      //}   
                      //NSM, we handle replacemnet candidates diffrerently now   
                      // if No Show status and Interview Date/Candidate sent < 7 days, check for answer to Request Additional Candidate
                      if (!newServiceModel && c.NoShow && c.CandSentorInterviewLessThan7Days ) {
                          if (c.can.Request_Another_Candidate__c == null) {
                              c.can.Request_Another_Candidate__c.addError(Label.Error_Value_is_required);
                              recordError = true;                       
                          } // end if null
                          // if No Show status filled in, if Request is Yes, increment NumCandidatesRequested
                          else if (c.can.Request_Another_Candidate__c.startswith('Yes'))
                              NumCandidatesRequested++;                              
                      } // end if NoShow added less than 7 days ago          
                  } // end if Rejected

                  /****** commented out until we want to deploy this requirement
                  // if Hired, check each required Hired field for same clients that can see Candidate Status notes
                  if (c.selectedStatus == 'Hired') {
                      // reason for Hire is reqd
                      if (c.can.Reason_for_Hire__c== null && DisplayCanStatus ) {
                          c.can.Reason_for_Hire__c.addError(Label.Error_Value_is_required);
                          recordError = true;
                      } 
                  } // end if hired
                  **************/
                  
                  // if all candidates Rejected without any no shows less than a week ago, check they have selected something for rejAction
                  if (!newServiceModel && NumCandidates > 0 && Job.job_status__c.contains('Candidates Sent/Awaiting Hire') && numRejected == NumCandidates && numPreviouslyHired == 0 && RequestMoreCandidates
                            && selectedRejAction == 'none' && NumNoShow == 0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.CanUpd_Request_More_Missing));
                        recordError = true;                   
                  }
                  // done checking required fields - if we found an error set flag so we don't continue, else add to list of updates                         
                  if (recordError) {
                        DataError = true;
                        // if we are at Awaiting  MindField and have a data error, put back to Rejected
                        if (c.selectedStatus == 'Awaiting MindField Group Contact') c.selectedStatus = 'Rejected';
                  } // end if error
                  else { 
                      //New Service Model, no change required here
                      // build list of Candidates to update
                      // if Background Check, increment counter for NumBackgroundCheck
                      if (c.selectedStatus == 'Background Check')
                          NumBackgroundCheck ++;
                      // if Left Message in status, check the left msg box on Candidate
                      if (c.selectedStatus != null && c.selectedStatus.contains('Left Message'))
                          c.can.Message_left_for_candidate__c = true;
                          
                      // if the status was Left Message with Qualified Candidates/Leave in Qualified we reset status to 'Qualified Candidates'
                      if (c.selectedStatus == 'Leave in Qualified Candidates' || c.selectedStatus == 'Laisser en tant que candidat qualifié')
                          c.can.status__c = 'Qualified Candidates';
                      /* if the status was Left Message with Initial Applicant/Leave in Initial Applicant we reset status to 'Initial Applicant'
                      else if (c.selectedStatus == 'Left Message with Initial Applicant' || c.selectedStatus == 'Leave in Initial Applicant')
                          c.can.status__c = 'Initial Applicant';
                      */    
                      // NSM, if HM leaves as interviewing, just take previous value
                      else if (c.selectedStatus == 'Leave in Interviewing' || c.selectedStatus == 'Laisser en entrevue')
                          c.can.status__c = c.can.status__c;
                      // otherwise keep the selected Status for this Candidate if there was one chosen
                      else if (c.selectedStatus != 'none')
                          c.can.status__c = c.selectedStatus;
                          
                      //NSM Logic, job closure...will revisit later---------------------------------------------------------
                      /*if(newServiceModel) { 
                          //hold on closing job if valid rejection reason and dont have any hires, we will be giving replacemnet candidate
                          newServiceModelHoldOnClosingJob = NewServiceModel_Util.IsValidRejectionReason(c) && numTotalHired==0;
                      
                          //newly setting a candidate as rejected AND valid replacement reason with at least 1 hire
                          if(c.selectedStatus == 'Rejected' && !newServiceModelHoldOnClosingJob) {
                               //set so replacemnet process doesnt trigger
                              c.can.Do_you_want_a_replacement_candidate__c='No_Close_the_Job';
                          }
                      
                          //newly setting a candidate as hired AND have previous rejection in audit
                          //setting new audit result will cancel workflow and trigger new workflow 
                          if(c.can.status__c == 'Awaiting Replacement Adjudication' && numHired>0) {
                          //if(NewServiceModel_Util.IsValidPostInterviewScheduledRejectionReason(c) && numHired>0) {
                              //if we were in post rejection audit, we want to cancel
                              c.can.Candidate_Audit_Result__c='Adjudication Cancelled Due to Hire Made';
                              c.can.status__c='Rejected';
                          } 
                      }*/   
                      //------------------------------------------------------------------
                      
                       //NSM, Up to 2 hire------------------------------------------------------------------
                       //set value so any new replacement workflows are never triggered
                       //- Pre Interview Sched - All Candidate Replacement – NSM
                       //- Post Interview Sched - All Candidate Replacement – NSM
                       if(newServiceModel && numPreviouslyHired + numHired == 1) {
                            if(c.selectedStatus == 'Rejected') {
                               //set so replacemnet process doesnt trigger
                              c.can.Do_you_want_a_replacement_candidate__c='No_Close_the_Job';
                          }
                       }
                      
                      updCandidates.add(c.can);
                  } // end else
                  
                  //New service model, if we find one candidate where HM was offered replacement but choose to close job
                  //With new rule, 'Up to 2 Candidates', we dont need this anymore 
                  //newServiceModelCloseJob = c.can.Do_you_want_a_replacement_candidate__c=='No, a replacement candidate is not required. Please close the job';
                                    
                  //if valid pre/post interview sched rejection reason, we dont close the job...getting replacement candidate
                  //update March 2019 ER: 00173264. We don't want to hold off on closing job if CE marked as cancelled, Reason_for_Job_Cancellation__c
                  newServiceModelHoldOnClosingJob = NewServiceModel_Util.IsValidPostInterviewScheduledRejectionReason(c) && String.isEmpty(Job.Reason_for_Job_Cancellation__c);
                  //newServiceModelHoldOnClosingJob = NewServiceModel_Util.IsValidRejectionReason(c);
              }  // end loop through candidates
                       
              if (DataError)
                  return null;                   
    
              // if an OWF job that has a hire has come through to here with no errors for the first time, send them back with the ConfirmOWFHire 
              //    boolean marked.  This will cause the PSFT window to pop and change the screen to require one more Save button to click as
              //    confirmation of the hire.
              if (!ConfirmOWFHire && numHired > 0 && Job.RecordType.name == 'Overwaitea Food Group') {
                  ConfirmOWFHire = true;
                  return null;
              }
          

              // save Candidate records.  Then run logic on Job status updates
              update updCandidates;
              
              //******************************************************************************************
              //Job Update Logic START ------------------------------------------------------------------
              //
              //******************************************************************************************
              // if there was at least one Additional Candidates required (due to No Show) then change job status to Additional Candidate(s) Required
              //New Service Model, we can leave this since we will never hit this condition
              if (!newServiceModel && NumCandidatesRequested > 0) {
                  job.job_status__c = 'Additional Candidate(s) Required';
                  job.Number_of_Replacement_Candidates_Require__c = (job.Number_of_Replacement_Candidates_Require__c == null ? 0 : job.Number_of_Replacement_Candidates_Require__c) + NumCandidatesRequested;
                  update job;               
              } 
              // if Job Status is "Candidates Sent/Awaiting Hire" OR job being cancelled (thus all candidates hired/rejected), we continue with finishing actions.  If not, there could
              //    still be candidates that will be added to the Job
              //***********************************************************************************************************************
              //Job Closure Logic START ------------------------------------------------------------------
              //Job status is 'Candidates Sent/Awaiting Hire', therefore we check if candidates dispositioned and close job accordingly
              //*************************************************************************************************************************
              
              //***********************************************************************************************************************
              //NSM, Up to 2 hire------------------------------------------------------------------
              //if one hire made, no other candidates left to disposition
              //(numPreviouslyHired + numHired >= 2)... if 2 hires are made we want it to drop down to ProcessTransferToHireRule below
              //Note: above around line 722, we set flag on candidate so pre/post replacements are not triggered 
              //*************************************************************************************************************************
              if(newServiceModel && numPreviouslyHired + numHired == 1) {
                  string result = NewServiceModel_Util.ProcessUptoTwoCandidateRule(job, false); 
                  
                  if(result.contains('true')) { //we hit a case where one hire processed, stop and redirect back to page
                      PageReference JobPageOneHire = new PageReference('/' + job.id);
                      JobPageOneHire.setRedirect(true);
                      return JobPageOneHire;
                  }
                  else if(result.contains('Error')) { //exception occured
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.Error_processing_updates+': ' + result));
                      return null;
                  }
                  //else, no required processing so just continue....
              }
              
              if ( job.Job_Status__c.contains('Candidates Sent/Awaiting Hire') || ApexPages.currentPage().getParameters().get('cancel') == '1' ) {
                  //system.debug('job status: '+job.Job_Status__c+'; numPreviouslyHired: '+numPreviouslyHired +'; numHired: '+numHired+'; numRejected: '+numRejected+';  numTotalCandidates: '+numTotalCandidates );
                    // if this job is complete (all hired or rejected) and billing type is On Demand, send email and leave Job as is
                    if (job.job_billing_type__c != null && job.job_billing_type__c.contains('On Demand') && numPreviouslyHired + numHired + numPreviouslyRejected + numRejected == numTotalCandidates) {
                        // call email function
                        AlertCSMOnDemand();
                    } // end if On Demand job
                    //***********************************************************************************************************************
                    //ALL CANDIDATES REJECTED ------------------------------------------------------------------
                    //*************************************************************************************************************************
                    else if ( numRejected + numPreviouslyRejected == numTotalCandidates ) {
                        // did the user request more candidates, then clone job and update original to 'Re-Opened'
                        if (selectedRejAction == 'Yes') { //New Service Model wont hit this, go to job.Job_Status__c = 'Not Filled/Closed by Mgr'
                            job.Job_Status__c = 'Not Filled/Job Re-Opened';
                            update job;  // this sets any updates done thus far into the db for the JobClone method                          
                            
                            /* March 2018, PPG only client still using...Heather siad we can remove
                            // if client wants to autoCloneRequestMoreCandidates they don't want to see the job page, just create it
                            if (AutoCloneRequestMoreCandidates) {
                                // clone original job fields
                                SFDC_Job__c newJob = JobClone(job);
                                newJob = [select id, name from SFDC_Job__c where id = :newJob.id];
                                // we want to update the closed job with a reference to the new one
                                string jobComments = Label.Job_RejectComment+newJob.name;
                                job.Job_Comments__c = (job.Job_Comments__c == null ? jobComments : job.Job_Comments__c+'\n'+jobComments);
                                job.Job_Internal_Status__c = 'Broadcasting Needed';
                                update job;
                            } // end if auto request more
                            //  if not AutoCloneRequest, we don't want to save the job ourselves but open a new job with defaults
                            else {*/
                                // generate a URL that will open a new Job for the user with copied over values
                                // set new Job's status based on New Store or not
                                string newStatus = (JobforNewStore ? 'Open/Active Job for New Store' : 'Open/Active Job');
                                // build URL to take user to the newly created job in edit mode with various fields nulled out (if editable on the layout)
                                // 00NU0000003Aud1=1 is going to set the Created by cloning existing Job to true
                                // 00NU0000003AudQ=job.name is going to set the Cloned Job Id to this job's number
                                rejectURL = '/'+job.id+'/e?clone=1&00NU0000003Auge='+ newStatus + '&00NU0000003Aud1=1&00NU0000003AudQ=' + job.name + '&retURL=/'+job.id;
                                // now add other fields to be nulled out before the clone - stored in Custom Setting
                                //    skip nulling the cloning fields we just set above
                                for (CloneJobFields__c f : CloneJobFields__c.getall().values())
                                    if (f.name != '00NU0000003Aud1' && f.name != '00NU0000003AudQ')
                                        rejectURL += '&'+f.name+'='+(f.field_value__c == null ? '' : f.field_value__c); 
                                // system.debug(' reject URL is now: '+rejectURL);    
                            //} // end else not auto request so build URL
                        } // end if selected more candidates when all are rejected 
                        else {
                            //if valid pre/post interview sched rejection reason, we dont close the job...getting replacement candidate
                            //March 7th, 2018....  added 'numCurrentReplacementsGranted==0'.
                            //we want to not close if they have any pre rejection reason replacemnets coming
                            if(!newServiceModel || (newServiceModel && !newServiceModelHoldOnClosingJob && numCurrentReplacementsGranted==0)) {
                                job.Job_Status__c = 'Not Filled/Closed by Mgr';
                                update job;
                            }
                        } // end don't want more candidates
                    } // if all status is Rejected
                    //***********************************************************************************************************************
                    //END ALL CANDIDATES REJECTED ------------------------------------------------------------------
                    //*************************************************************************************************************************
                    
                    //***********************************************************************************************************************
                    //NSM, Transfer Hire into 2nd Job ------------------------------------------------------------------
                    //if made two hires made
                    //*************************************************************************************************************************
                    else if(newServiceModel && numTotalHired  >= 2) { //numPreviouslyHired + numHired >= 2) {
                        //run 'Transfer Hire into 2nd Job' rule 
                        
                        List<CandidateWrapper> totalHired = BuildTotalHiredList(); 
                        SFDC_Job_Candidate__c candidateToTransfer = totalHired[totalHired.size() - 1].can; //tranfer last candidate
                        SFDC_Job_Candidate__c remainingCandidate = totalHired.size() >= 2 ? totalHired[0].can : null; //take the first one, else null
                        
                        //List<CandidateWrapper> totalNotHired = BuildTotalNotHiredList(); //remaining candidates NOT being hired
                        
                        string result = NewServiceModel_Util.ProcessTransferToHireRule(job, jobHirePlacedObject, candidateToTransfer, remainingCandidate);
                        //result will hold 'true' if passed else strack trace
                        boolean status = result.contains('true');
                        string clonedJobId = null;
                       
                        //also, result will hold, 'true-01pU0000000m0iV', ID of cloned job if cloned
                        if(status && result.contains('-')) {
                            clonedJobId = result.split('-')[1]; //grab cloned job id
                        }
                                                
                        if(!status) {
                            //if process fails
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.Error_processing_updates+': ' + result));
                            return null;
                        } 
                        else { //success
                            
                            if(clonedJobId != null) { //if we cloned a job then redirect to new job
                                PageReference JobPageCloned = new PageReference('/' + clonedJobId);
                                JobPageCloned.setRedirect(true);
                                return JobPageCloned;
                            }
                            //else, just forward to current job as below
                        }
                    }
                    //***********************************************************************************************************************
                    //END Tranfer Hire into 2nd job ------------------------------------------------------------------
                    //*************************************************************************************************************************
                    
                    //***********************************************************************************************************************
                    //ALL CANDIDATES DISPOSITIONED ------------------------------------------------------------------
                    //if at least one person was hired and all candidates are hired/rejected, we close the job since status is Candidates Sent 
                    //*************************************************************************************************************************
                    else if ( numPreviouslyHired + numHired > 0 && numPreviouslyHired + numHired + numPreviouslyRejected + numRejected == numTotalCandidates ) {
                             //if valid pre/post interview sched rejection reason, we dont close the job...getting replacement candidate
                             if(!newServiceModel || (newServiceModel && !newServiceModelHoldOnClosingJob)) {
                                 // if original status includes "for New Store" then Filled status includes it as well
                                 if (JobforNewStore) {
                                     job.Job_Status__c = 'Filled Closed Job for New Store';
                                 }    
                                 else {
                                     job.Job_Status__c = 'Filled Closed Job';
                                 }    
                                 update job;
                              }
                    } // end if job closed with a hire   
                    //***********************************************************************************************************************
                    //ALL CANDIDATES DISPOSITIONED ------------------------------------------------------------------
                    //*************************************************************************************************************************                         
                } // end if status is Candidates Set
                //***********************************************************************************************************************
                //END Job Closure Logic for 'Candidates Sent/Awaiting Hire'------------------------------------------------------------------
                //*************************************************************************************************************************
                
                //close job under NSM if HM didnt want additional candidate and opted to close job
                //With new rule, 'Up to 2 Candidates', we dont need this anymore, it will close the job 
                /*
                if(newServiceModel && newServiceModelCloseJob) {
                    job.Job_Status__c = 'Filled Closed Job';
                    update job;
                }*/
                
          } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.Error_processing_updates+': '+e.getStackTraceString() + ': '+ e));
              Database.rollback(sp);
              NewServiceModel_Util.SendErrorEmail(e);
              return null;
          } // end catch exception
          
          PageReference JobPage;
          // if all Candidates were rejected we will have a rejectURL set so go there
          if (rejectURL != null) JobPage = new PageReference(rejectURL);
          // if we had someone Rejected with No Contact or we had a No Show, send to the confirmation page
          else if (RejectNoContact || NumNoShow > 0) JobPage = new PageReference('/apex/CanUpdateConfirmation?id='+Job.Id+'&reason='+(RejectNoContact ? 'No Contact' : '')+(NumNoShow>0 ? 'No Show' : ''));
          // if Akzo Nobel or Glentel and at least 1 Candidate in Background Check, set boolean and return null to have page open pop up
          /* add in AN record types when ready to implement */
          else if (Job.RecordType.name == 'Glentel' && NumBackgroundCheck > 0) {
              BackgroundCheckPop = true;
              return null;
          }  
          // else send them to the Job just updated
          else JobPage = new PageReference('/' + Job.Id);
          JobPage.setRedirect(true);
          return JobPage;

    }

    // helper function to clone a job
    private SFDC_Job__c JobClone(SFDC_Job__c job) {
        // first query DB for job values so we capture everything when cloning
        //   Mar 2015: used to do this in the controller but moved into Job Clone so we only run the query if needed to reduce ViewState
        // Get Job details - need all fields for the potential Clone operation later
        Map<String, Schema.SObjectField> Job_Flds = Schema.SObjectType.SFDC_Job__c.fields.getMap();
        
        string qryString = 'select ';
        // grab any field that is not a formula
        for (Schema.SObjectField a : Job_Flds.values()) { 
            Schema.DescribeFieldResult F = a.getDescribe();
            if (!f.isCalculated()) 
                qryString += f.getname()+', ';
        }
        qryString = qryString.substring(0,qryString.length()-2) + ' from SFDC_Job__c where id = \''+Job.Id+'\'';
        system.debug('query string: '+qryString);
        SFDC_Job__c origJob = database.query( qryString );
        
        SFDC_Job__c newJob = origJob.clone(false,true);
        // null out specific fields we dont want to copy
        // if we convert this to use the custom setting for Clearing Job fields on duplicate, make sure we don't clear out
        //    the Clone Job Id/checkbox since these were set above to track the original Job and will overwrite any existing values
        //    from original job.  Sept 13/2012
        newJob.ATS_Last_Updated_Date__c = null;
        newJob.ATS_Job_ID__c = null;
        newJob.ATS_Job_GUID__c = null;
        newJob.Job_Imported_into_ATS__c = null;
        newJob.Date_Last_Transferred_SF_HD__c = null;
        newJob.Date_Job_Re_Opened__c = null;
        newJob.Date_Job_Not_Filled_by_Store__c = null;
        newJob.Additional_Candidate_Sends_Reqd__c = false;
        newJob.Number_of_Replacement_Candidates_Require__c = null;
        newJob.Date_Candidates_Re_Sent__c = null;
        newJob.Online_Posting__c = null;
        newJob.Holiday_Deduction_in_days__c = null;
        newJob.Post__c = false;
        newJob.Email_Campaign__c = false;
        newJob.Social__c = false;
        newJob.refresh__c = false;
        newJob.Is_Cloned_Job__c = 'true';
        newJob.Is_Cloned_Job_ID__c = origJob.name;

        // dates, status and comments depend on where the clone came from
        // comments are built using Labels so we can translate into French
        newJob.Job_Comments__c = Label.Job_Comment1+': '+job.Name+' '+Label.Job_Comment2;
        if (JobforNewStore) newJob.Job_Status__c = 'Open/Active Job for New Store';
        else newJob.Job_Status__c = 'Open/Active Job';
        newJob.Date_Job_Filled__c = null;
        newJob.Date_Candidates_Sent__c = null;
        newJob.Date_Job_Added_or_Opened__c = null; // allow system to calculate
        newJob.Specific_Candidate_Preference__c = 'No';
        //March 1, 2018
        //Fixed bug, when job was cloned below was not reset causing validation rule to kick in
        newJob.NSM_Specific_Candidate_Requested__c = 'Mindfield_Sourced_Candidates'; 
        newJob.Specific_Candidate_Contact_Method__c = null;
        newJob.Address_of_Candidates__c = null;
        newJob.Specific_Candidate_Source__c = null;
        newJob.Specific_Candidate_Name__c = null;
        newJob.Specific_Candidate_Phone_Number__c = null;  
        
        //case 00112107, issue discovered where when cloning job
        //value for below field would take orignal job value.
        //we do not want this, we want to to be reset in to default, 2, in Job_Workflow_PPG_USA class
        //so we null it out
        newJob.Num_of_Candidates_for_Delivery_Agreement__c = null;            
        
        try {
            insert newJob;
            //system.debug('In Clone Job; new Job is: '+newJob);
            return newJob;
        } catch (System.DmlException e) {
            return null;
            // continue with logic
        }
        return null;
    }   
    
    // helper function to email the CSM about an On Demand job completed
    public void AlertCSMOnDemand() {
        //system.debug('emailing for job: '+Job);
        // build and send an email here
        try  {
            // set up Email settings
            Id TemplateId;
            for (EmailTemplate et: [select id from EmailTemplate where DeveloperName = 'On_Demand_Job_Completed_Alert_vf' and isactive = true]) TemplateId = et.id;      
            //system.debug('Email template found: '+TemplateId);
            // find the Job owner's CSM or default to Jeff as recipient
            Id MgrId;
            if (job.job_owner_link__r.managerid != null) MgrId = job.job_owner_link__r.managerid;
            else MgrId = [select id, username from user where email = 'jeff.summers@mindfieldgroup.com' limit 1].id; 
            // build single email to send to CSM with error details            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.settargetObjectId(MgrId);
            mail.setwhatId(job.id);
            mail.setTemplateId(TemplateId);
            mail.setsaveAsActivity(false);  // this is vital when sending an email to a User
            mail.setSenderDisplayName('Jeff Summers');
            mail.setUseSignature(false);
            //system.debug('Mail details, TargetObjectId: '+mail.getTargetObjectId()+' templateid: '+mail.getTemplateId()+' and isUserMail: '+mail.isUserMail());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {} // nothing to do if the error email won't go out
    }   

    // method called from page when Rejection Reason is changed - calls setNoShows and setIsCandidateSuitable methods
    public pageReference updateRejectionReason() {
        setNoShows();
        setIsCandidateSuitable();
        setFGLRejectionCommentsReqd();
        return null;
    }
    
    // rejection reasons that indicate a No Show for a Candidate
    private Set<String> NoShow = new Set<String>{'Withdrew from Interview Process', 'No Show for Interview', 'Accepted Other Employment'};
    public integer NumNoShow {get; set;}
    
    private void setNoShows(){
        integer cnt = 0;
        // cycle through Candidates to indicate if they have a current Rejection Reason of NoShow and added less than 7 days ago
        // only run if not skipping No Show/No Contact processing
        if (!SkipNoShowNoContactCandidates) {
            for (CandidateWrapper c : Candidates) {
                if (NoShow.contains(c.can.Rejection_Reason_for__c) ) {
                    // default other Rejection Answers here
                    c.can.Was_Candidate_Contacted_for_Interview__c = 'Yes';
                    c.can.Rejection_Is_Candidate_Suitable__c = 'No - Candidate isn\'t suitable FOR ANY OF OUR Stores';
                    // if interview date or date sent less than 7 days ago, count as a No Show
                    if (c.CandSentorInterviewLessThan7Days) {
                        cnt++;
                        c.NoShow = true;
                    } // end if No Show status and added less than 7 days
                }
                else c.NoShow = false;
            } // end loop through candidates
        } // end if not skipping no show/no contact
        NumNoShow = cnt;    
    }

    // rejection reasons that are valid for showing the IsCandidateSuitable field - if not in the list we don't show this field for a Candidate
    private Set<String> CandidateSuitableReasons = new Set<String>{'Not Available to Work Required Shifts', 'Lacked Relevant Experience/Skills', 'Physically Unable to Perform Job Requirements',
                                                 'Vacancy Filled - Other or Referred Candidate Selected','Vacancy Filled - Other/Referred Candidate Selected', 'Other - See Notes', 'Vacancy Not Filled - Candidates No Longer Required'};
    private void setIsCandidateSuitable(){
        // cycle through Candidates to indicate if they have a rejection reason that should make teh Is Candidate Suitable field show
        for (CandidateWrapper c : Candidates) {
            if (CandidateSuitableReasons.contains(c.selectedRejReason) )
                c.DisplayIsCandidateSuitable = true;
            else c.DisplayIsCandidateSuitable = false;
        } // end loop through candidates
    }

    // rejection reasons that are valid for FGL Jobs to make the Rejection Comments Required - if not in the list we don't show the field with required red bar and text
    //April 2018, FGL on NSM so these isn't applicable any more
    private Set<String> FGLRejectionCommentsReqdReasons = new Set<String>{'Appearance/Image Inappropriate', 'Attitude/Personality Inappropriate', 'Communication/Language Skills Inappropriate',
                                                    'Lacked Relevant Experience/Skills', 'Not Available to Work Required Shifts', 'Too Shy/Quiet for Position', 'Wage Expectation Too High'};
    //April 2018, FGL on NSM so these isn't applicable any more
    private void setFGLRejectionCommentsReqd(){
        // cycle through Candidates to indicate if they have a rejection reason that should make the Rejection Comments required
        for (CandidateWrapper c : Candidates) {
            if (FGLRejectionCommentsReqdReasons.contains(c.selectedRejReason) )
                c.FGLRejectionCommentsReqd = true;
            else c.FGLRejectionCommentsReqd = false;
        } // end loop through candidates
    } 
    
    // custom picklist of Rejection Reasons since we want to show/hide options based on job fields (record type and SLA) and Candidate doesn't have record type
    // also Rejection Reason is already a controlled picklist field based on Status
    public List<SelectOption> RejectionReasons {set; 
        get{
            if (RejectionReasons == null) return (newServiceModel) ? NewServiceModel_Util.BuildRejectionReasonsNewServiceModel(jobOwnerLanguage) : getRejOptions();
            return RejectionReasons;
        }
    }
    
    
    
    
    // method to dynamically build the list of Rejection Reasons based on Job values - always the same list for all Candidates in a Job
    public List<SelectOption> getRejOptions() {
            // set conditions for this job first 
            boolean OFG_Job = job.recordtype.name == 'Overwaitea Food Group';
            boolean FGL_Job = job.recordtype.name == 'FGL Sports';
            boolean TalentConnect_Job = job.MindField_Job_Type__c != null && job.MindField_Job_Type__c.startswith('TalentConnect');
            boolean RPO_Job = job.MindField_Job_Type__c != null && job.MindField_Job_Type__c.startswith('TalentRecruit');
            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
            options.add(new SelectOption('Accepted Other Employment', 'Accepted Other Employment'));
            options.add(new SelectOption('Appearance/Image Inappropriate', 'Appearance/Image Inappropriate'));
            options.add(new SelectOption('Attitude/Personality Inappropriate', 'Attitude/Personality Inappropriate'));
            options.add(new SelectOption('Communication/Language Skills Inappropriate', 'Communication/Language Skills Inappropriate'));
            // could not contact and Declined Offer not available for Talent Connect
            if (!TalentConnect_job) {
                options.add(new SelectOption('Could not Contact Candidate', 'Could not Contact Candidate'));
                options.add(new SelectOption('Declined Offer', 'Declined Offer'));
            }
            // failed background and failed reference  not available for Talent Connect or RPO
            if ( !TalentConnect_Job && !RPO_Job ) {
                options.add(new SelectOption('Failed Background Check', 'Failed Background Check'));
                options.add(new SelectOption('Failed Reference Check', 'Failed Reference Check'));
            }
            // Failed Background/Reference not available for OFG/FGL/TalentConnect/RPO
            if (!OFG_Job && !FGL_Job && !TalentConnect_Job && !RPO_Job) {
                options.add(new SelectOption('Failed Background/Reference Check', 'Failed Background/Reference Check'));
            }
            options.add(new SelectOption('Lacked Relevant Experience/Skills','Lacked Relevant Experience/Skills'));
            // no show/not available/physically unable not available for Talent Connect
            if (!TalentConnect_job) {
                options.add(new SelectOption('No Show for Interview', 'No Show for Interview'));
                options.add(new SelectOption('Not Available to Work Required Shifts','Not Available to Work Required Shifts'));
                options.add(new SelectOption('Physically Unable to Perform Job Requirements','Physically Unable to Perform Job Requirements'));
            }            
            options.add(new SelectOption('Too Shy/Quiet for Position', 'Too Shy/Quiet for Position'));
            // no commute not available for TC or RPO
            if ( !TalentConnect_Job && !RPO_Job ) {
                options.add(new SelectOption('Unable/Unwilling to Commute to Location', 'Unable/Unwilling to Commute to Location'));
            }
            // vacancy filled not available for TC jobs
            if (!TalentConnect_job) {
                options.add(new SelectOption('Vacancy Filled - Other/Referred Candidate Selected', 'Vacancy Filled - Other/Referred Candidate Selected'));
            }
            options.add(new SelectOption('Wage Expectation Too High', 'Wage Expectation Too High'));
            options.add(new SelectOption('Withdrew from Interview Process', 'Withdrew from Interview Process'));
            options.add(new SelectOption('Other - See Notes', 'Other - See Notes'));
            return options;
    }
    
    
    // create wrapper class for repeat inside page, made up of Candidate and selectlist for status
    public class CandidateWrapper{
        public SFDC_Job_Candidate__c can {get; set;}
        public List<selectOption> status {get; set;}
        public string selectedStatus {get; set;}
        // track the Rejection Reason selected for this Candidate in custom list but always keep candidate field in step
        public string selectedRejReason {get; 
            set
            { 
                selectedRejReason = value;
                can.rejection_reason_for__c = value;
            }
        }        
        public boolean NoShow {get; set;}
        public boolean DisplayIsCandidateSuitable {get; set;}
        public boolean FGLRejectionCommentsReqd {get; set;}
        public boolean CandSentorInterviewLessThan7Days {get; set;}
        public boolean newServiceModel {get; set;}
        
        // constructor method for class - set status list and default properties
        public CandidateWrapper(SFDC_Job_Candidate__c c, boolean nsm){
            newServiceModel = nsm; 
            can = c;
            selectedStatus = (can.Status__c == 'Qualified Candidates' || can.Status__c == 'Initial Applicant' ? 'none' : can.Status__c);
            status = buildList(can.status__c, c);
            NoShow = false;
            // No Show/No Contact rejections in less than 7 days has special workflow, based on Interview Date/Scheduled Interview Date or
            //    Candidate Sent Date being less than 7 days from today
            if (can.interview_date__c != null)
                CandSentorInterviewLessThan7Days = (can.interview_date__c  > date.today() - 7);
            else if (can.scheduled_interview_date_time__c != null)
                CandSentorInterviewLessThan7Days = (can.scheduled_interview_date_time__c > datetime.now() - 7);
            else if (can.Date_Candidate_Sent__c != null)
                CandSentorInterviewLessThan7Days = (can.Date_Candidate_Sent__c > date.today() - 7);
            else CandSentorInterviewLessThan7Days = false;
        }

        // helper function to generate the Status picklist options baed on the current status value passed in
        public List<selectOption> buildList(string curStatus, SFDC_Job_Candidate__c c) {
            if (curStatus != 'Hired' || curStatus != 'Rejected') {
                List<selectOption> status = new List<selectOption>();
                
                               
                // if job is being canceled, only add Hire or Rejected as options
                if (ApexPages.currentPage().getParameters().get('cancel') == '1') {
                    status.add(new selectOption('none', '-- '+Label.Status_Select+' --'));
                    status.add(new selectOption('Rejected',Label.Status_Rejected));
                    status.add(new selectOption('Hired',Label.Status_Hired));
                    return status;
                }
                
                 //NSM, allow HM to leave in interviewing
                if(newServiceModel && curStatus.contains('Interviewing')) {
                    status.add(new selectOption('none', '-- '+Label.Status_Select+' --'));
                    //status.add(new selectOption('Leave in Interviewing', 'Leave in Interviewing'));
                    status.add(new selectOption('Leave in Interviewing', Label.Status_Leave_in_Interviewing));
                }
                
                // otherwise add Interviewing, Hired, Rejected and other options to the list 
                // only add the "select status", "leave message" and "leave in current stage" if still at Qualified Candidates
                if (curStatus == 'Qualified Candidates') {
                    status.add(new selectOption('none', '-- '+Label.Status_Select+' --'));
                    status.add(new selectOption('Leave in Qualified Candidates', Label.Status_Leave));
                    //status.add(new selectOption('Left Message with Qualified Candidates', Label.Status_Msg)); ER: 00171859, removed this value, not relevant anymore
                }
                /* also add the "select status", "leave message" and "leave in current stage" for Initial Applicant
                else if (curStatus == 'Initial Applicant') {
                    status.add(new selectOption('none', '-- '+Label.Status_Select+' --'));
                    status.add(new selectOption('Leave in Initial Applicant', Label.Status_Leave_InitialApp));
                    status.add(new selectOption('Left Message with Initial Applicant', Label.Status_Msg_InitialApp));
                }
                // if currently in Awaiting MFG Contact, add that as an applicable/selected option
                else if (curStatus == 'Awaiting MindField Group Contact') 
                    status.add(new selectOption('Awaiting MindField Group Contact', Label.Status_Awaiting)); 
                */
                // if job sla is Job Posting Only or Longo's, add Sent to Store/Manager status
                if (c.sfdc_job__r.sla_level__c == 'Job Posting Only') //|| c.sfdc_job__r.recordtype.name == 'Longo\'s')
                    status.add(new selectOption('Sent to Store/Manager', Label.Status_SentMgr));
                
                // Add Interviewing statuses based on Job Record Type and Job SLA.  Note if you want to include other Job fields in the if
                //    statement, those fields should be included in the qryString2 variable in the constructor method above
                /*Feb 6, 2018... clean this up... removing old clients
                if (c.sfdc_job__r.recordtype.name == 'Town Shoes' || c.sfdc_job__r.recordtype.name == 'Longo\'s') {
                    // could add another if statement inside with c.sfdc_job__r.sla_level__c == 'Front Line' if needed
                    
                    if(!newServiceModel) { //we do not want 'interview' as an option with NSM. We schedule for them
                        // add Interviewing Round 1, Interviewing Round 2 and Background Check status
                        status.add(new selectOption('Interviewing Round 1',Label.Status_Interview_Rd1));
                        status.add(new selectOption('Interviewing Round 2',Label.Status_Interview_Rd2));
                    }
                        
                    status.add(new selectOption('Background Check',Label.Status_Background));
                }*/
                // if Akzo Nobel or FGL or Marks or Glentel, add Interviewing and Background Check as separate items
               // else if (c.sfdc_job__r.recordtype.name == 'AkzoNobel' || c.sfdc_job__r.recordtype.name == 'FGL Sports' || 
               //Jan 2018, remove PPG/AkzoNobel from this, we do interview scheduling for them now
               //if(!newServiceModel), actually keeps option from being added anyways
               else if (c.sfdc_job__r.recordtype.name == 'FGL Sports' || 
                         c.sfdc_job__r.recordtype.name == 'Marks' || c.sfdc_job__r.recordtype.name == 'PPG USA' ||
                         c.sfdc_job__r.recordtype.name == 'AkzoNobel' ||
                         c.sfdc_job__r.recordtype.name == 'Glentel' ||
                         c.sfdc_job__r.recordtype.name == 'Country Grocer' || //April 2017, added country grocer
                         c.sfdc_job__r.recordtype.name == 'Direct Tap') { //May 2017, added directtap
                    
                    if(!newServiceModel) { //we do not want 'interview' OR 'Background Check' as an option with NSM. We schedule for them
                        status.add(new selectOption('Interviewing',Label.Status_Interview_Only));
                        status.add(new selectOption('Background Check',Label.Status_Background)); 
                    }
                    
                    //Feb 2018, move this out when on NSM
                    //only keep if current status if BG Check, if not then they cannot pick
                    //status.add(new selectOption('Background Check',Label.Status_Background)); 
                    if(newServiceModel && curStatus == 'Background Check') {
                        status.add(new selectOption('Background Check',Label.Status_Background)); 
                    }             
                }
                
                /* Feb 6, 2018... clean this up... removing old clients
                else if ( c.sfdc_job__r.recordtype.name == 'HY Louie') {
                    if(!newServiceModel) { //we do not want 'interview' as an option with NSM. We schedule for them
                        status.add(new selectOption('Interviewing',Label.Status_Interview_Only));
                    }
                    status.add(new selectOption('Background Check',Label.Status_Background));                
                }*/
                // add the Interviewing/Background Check for other recordtypes
                else {
                    if(!newServiceModel) { //we do not want 'interview' as an option with NSM. We schedule for them
                        status.add(new selectOption('Interviewing/Background Check',Label.Status_Interviewing));   
                    }                     
                }
                
               
                 
                // everyone gets Rejected/Hired
                status.add(new selectOption('Rejected',Label.Status_Rejected));
                status.add(new selectOption('Hired',Label.Status_Hired));
                
                return status;
            } // end if 
            // otherwise the status is not shown
            return null;
        }      
    } // end Candidate class
    

}