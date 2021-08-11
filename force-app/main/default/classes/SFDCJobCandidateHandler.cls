/**
* Class SFDCJobCandidateHandler
*
* Trigger Handler for the SFDC_Job_Candidate__c  sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public without sharing class SFDCJobCandidateHandler implements TriggerInterface {
    
    //START TRIGGER_BEFORE (INSERT OR UPDATE)
    Map<String, Candidate_Interview__c> emailJobCandidateMap;
    Map<Id,List<Target_Volume__c>> contractTargetVolumeMap;
    Map<String, Id> sentbyMap;
    Set<Id> newJC_JobIds;  // holds job ids for any newly inserted JC
    Map<Id, SFDC_Job__c> jobMap;
    Set<Id> canRecIds; // holds candidate record ids for all newly inserted JC
    Map<Id, SFDC_Candidate__c> canMap;
    Map<String, Job_Point__c> pointsMap;
    Map<Id, Map<String, Blacklist__c>> emailList;
    Map<Id, Map<String, Blacklist__c>> phoneList;
    Map<Id, Map<String, Blacklist__c>> postalList;
    //END TRIGGER_BEFORE (INSERT OR UPDATE)
    
    //START TRIGGER_BEFORE (DELETE)
    Map<Id, List<Candidate_Interview__c>> candidicateInterviewMap;
    Map<Id, Candidate_Interview__c> deleteCandidicateInterviewMap;
    //END TRIGGER_BEFORE (DELETE)
    
    //START TRIGGER_AFTER (INSERT OR UPDATE)
    Map<Id, SFDC_Job_Candidate__c> jcmap;
    SFDC_Job_Candidate__c tempJC;
    SFDC_Candidate__c tempCandidate;
    Map<Id, SFDC_Candidate__c> candidateMap;// list of Candidate records that need updating
    Candidate_Interview__c tempInterview;
    Map<Id, Candidate_Interview__c> candidateInterviewMap;
    
    Map<String,String> APPLICANTAPP_TO_JOBCANDIDATE;
    Map<Id, Applicant_Job_Apps__c> jobCandidateApplicantJobMap;
    List<Applicant_Job_Apps__c> updateThesejobApps;
    private static final Map<String,String> CANDIDATE_STATUS_TO_JobAPP = new Map<String,String> {'Qualified Candidates'=>'Presented',
                                                                                                    'Interviewing'=>'Presented',
                                                                                                    'Interviewing/Background Check'=>'Presented',
                                                                                                    'Background Check'=>'Presented',
                                                                                                    'Would Like to Hire for Other Job'=>'Presented',
                                                                                                    'Hired'=>'Accepted',
                                                                                                    'Rejected'=>'Rejected by HM'
                                                                                                };
    //END TRIGGER_AFTER (INSERT OR UPDATE)
    
    // Constructor
    public SFDCJobCandidateHandler(){
        //START TRIGGER_BEFORE (INSERT OR UPDATE)
        emailJobCandidateMap = new Map<String, Candidate_Interview__c>();
        contractTargetVolumeMap = new Map<Id, List<Target_Volume__c>>();
        sentbyMap = new Map<String, Id>();
        newJC_JobIds = new Set<Id>();
        jobMap = new Map<Id, SFDC_Job__c>();
        canRecIds = new Set<Id>();
        canMap = new Map<Id, SFDC_Candidate__c>();
        pointsMap = new Map <String, Job_Point__c>();
        emailList = new Map<Id, Map<String, Blacklist__c>>();
        phoneList = new Map<Id, Map<String, Blacklist__c>>();
        postalList = new Map<Id, Map<String, Blacklist__c>>();
        //END TRIGGER_BEFORE (INSERT OR UPDATE)
        
        //START TRIGGER_BEFORE (DELETE)
        candidicateInterviewMap = new Map<Id, List<Candidate_Interview__c>>();
        deleteCandidicateInterviewMap = new Map<Id, Candidate_Interview__c>();
        //END TRIGGER_BEFORE (DELETE)
        
        //START TRIGGER_AFTER (INSERT OR UPDATE)
        jcmap = new Map<Id, SFDC_Job_Candidate__c>();
        candidateMap = new Map<Id, SFDC_Candidate__c>();
        candidateInterviewMap = new Map<Id,Candidate_Interview__c>();
        
        APPLICANTAPP_TO_JOBCANDIDATE = ApplicantJobAppTriggerHandler.getFieldsMapping('ApplicantJobApp->Job Candidate');
        jobCandidateApplicantJobMap = new Map<Id, Applicant_Job_Apps__c>();
        updateThesejobApps = new List<Applicant_Job_Apps__c>();
        Applicant_Job_Apps__c tempJobApps;
        //END TRIGGER_AFTER (INSERT OR UPDATE)
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        
        Set<String> emails = new Set<String>();
        Set<String> SFDCJobIds = new Set<String>();
        
        Set<Id> jobContractIds = new Set<Id>();
        Set<String> sentBy = new Set<String>();
        
        for (SFDC_Job_Candidate__c jobcan : (List<SFDC_Job_Candidate__c>) (Trigger.isDelete ? Trigger.old : Trigger.new)) {
            if(Trigger.isInsert){
                emails.add(jobcan.Email__c);
                SFDCJobIds.add(jobcan.SFDC_Job__c);
                
                // if this is an insert, add related JobId to set so we can set manager and LTAS flds, also
                newJC_JobIds.add(jobcan.sfdc_job__c);
                canRecIds.add(jobcan.candidate__c);
            }
            
            if(Trigger.isInsert || Trigger.isUpdate){
                if(jobcan.Revenue_Earned__c == null || jobcan.Revenue_Earned__c == 0) {
                    //try to get this as long as candidate hired and revenue is empty
                    jobContractIds.add(jobcan.Contract__c);  
                }
                
                sentBy.add(jobcan.sent_by__c);
            }
        }
        
        //Interview Scheduler ----------------------------------------------------------------------------------------------------
        //finds candidate interview match and gets interview date
        if(!emails.isEmpty() || !SFDCJobIds.isEmpty()){
            for(Candidate_Interview__c cil : [SELECT Id, Name, Start_Date__c, End_Date__c, Job__c 
                                              FROM Candidate_Interview__c WHERE Name IN:emails 
                                              AND Job__c IN:SFDCJobIds AND Start_Date__c<>null]){
                                                  emailJobCandidateMap.put(cil.Name+''+cil.Job__c,cil);
                                              }
        }
        //END Interview Scheduler ----------------------------------------------------------------------------------------------------
        
        if(!jobContractIds.isEmpty()){
            List<Target_Volume__c> tempTVlList;
            for(Target_Volume__c tvl: [SELECT id, Start_Date_of_Target_Month__c, End_Date_of_Target_Month__c, Frontline_Price__c, 
                                       Frontline_1_Price__c, Frontline_2_Price__c,  Specialty_1_Price__c, Specialty_2_Price__c,
                                       Management_1_Price__c, Management_2_Price__c, Admin_Fee__c, Contract__c
                                       FROM Target_Volume__c WHERE Contract__c IN:jobContractIds 
                                       Order By Start_Date_of_Target_Month__c ASC]){
                                           tempTVlList = new List<Target_Volume__c>();
                                           if(contractTargetVolumeMap.containsKey(tvl.Contract__c)){
                                               tempTVlList = contractTargetVolumeMap.get(tvl.Contract__c);
                                           } 
                                           tempTVlList.add(tvl);
                                           contractTargetVolumeMap.put(tvl.Contract__c,tempTVlList);
                                       }
        }
        
        if(!sentBy.isEmpty()){
            for(User u : [SELECT Id, Name FROM User WHERE Name IN:sentBy]) {
                sentbyMap.put(u.name, u.id);
            }
        }
        
        if (!newJC_JobIds.isEmpty()) {
            jobMap = new Map<Id, SFDC_Job__c>();
            Set<Id> jobRecordTypeIds = new Set<Id>();
            // build map of Job Id to Job to get mgr fields
            for (SFDC_Job__c j : [SELECT Id, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c,
                                  RecordTypeId, X4th_Level_Manager__c, X5th_Level_Manager__c, HR_User_Usual__c, 
                                  ltas__c, X1st_Level_Access__c,X2nd_Level_Access__c, job_owner_link__r.ManagerId, 
                                  sla_level__c, external_alert_email_address__c, Store_Email_Address__c, consolidated_job_title__c FROM SFDC_Job__c 
                                  WHERE Id IN: newJC_JobIds]) {
                                      
                                      jobMap.put(j.id, j);
                                      jobRecordTypeIds.add(j.RecordTypeId);
                                  }
            
            if(!jobRecordTypeIds.isEmpty()){
                // prepare Blacklist maps for matching - Job Record Type id to map of matching string/Blacklist
                // this way each Candidate's job record type can find it's own assoc map of matching string/Blacklist
                
                // for each Blacklist Job Type that matches a job being referenced here, add entries into 3 maps
                for(Blacklist_Job_type__c bjt : [SELECT Id, Job_Record_Type__r.Record_Type_Id__c, Blacklist__r.Name,
                                                 Blacklist__r.First_Name__c, Blacklist__r.Email__c, Blacklist__r.Phone__c, 
                                                 Blacklist__r.Postal_Code__c FROM Blacklist_Job_Type__c 
                                                 WHERE Job_Record_Type__r.Record_Type_Id__c IN :jobRecordTypeIds]){
                                                     
                                                     if (bjt.Blacklist__r.Email__c != null) {
                                                         // set match string
                                                         String emailString = bjt.Blacklist__r.Email__c;  
                                                         // if Rec Type already in map, add to existing search map
                                                         if (emailList.containskey(bjt.Job_Record_Type__r.Record_Type_Id__c)) {
                                                             Map<String, Blacklist__c> temp = emailList.get(bjt.Job_Record_Type__r.Record_Type_Id__c);
                                                             temp.put(emailString, bjt.Blacklist__r);
                                                             emailList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, temp);
                                                         } // end if emaillist contains entry for recordType already
                                                         // else add new entry with job RT and new map with match string and Blacklist
                                                         else emailList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, new Map<String, Blacklist__c>{emailString => bjt.Blacklist__r});
                                                     } // end if email not null
                                                     
                                                     // add to PhoneList if there is a phone number
                                                     if (bjt.Blacklist__r.Phone__c != null) {
                                                         // set match string
                                                         String phoneString = bjt.Blacklist__r.Name+bjt.Blacklist__r.Phone__c;  
                                                         // if Rec Type already in map, add to existing search map
                                                         if (phoneList.containskey(bjt.Job_Record_Type__r.Record_Type_Id__c)) {
                                                             Map<String, Blacklist__c> temp = phoneList.get(bjt.Job_Record_Type__r.Record_Type_Id__c);
                                                             temp.put(phoneString, bjt.Blacklist__r);
                                                             phoneList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, temp);
                                                         } // end if phonelist contains entry for recordType already
                                                         // else add new entry with job RT and new map with match string and Blacklist
                                                         else phoneList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, new Map<String, Blacklist__c>{phoneString => bjt.Blacklist__r});
                                                     } // end  if phone not null
                                                     
                                                     // add to PostalList if postal code not null
                                                     if (bjt.Blacklist__r.Postal_Code__c != null) {
                                                         // set match string
                                                         String postalString = bjt.Blacklist__r.Name+(bjt.Blacklist__r.Postal_code__c == null ? '' : bjt.Blacklist__r.Postal_Code__c.replaceAll(' ',''));  
                                                         // if Rec Type already in map, add to existing search map
                                                         if (postalList.containskey(bjt.Job_Record_Type__r.Record_Type_Id__c)) {
                                                             Map<string, Blacklist__c> temp = postalList.get(bjt.Job_Record_Type__r.Record_Type_Id__c);
                                                             temp.put(postalString, bjt.Blacklist__r);
                                                             postalList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, temp);
                                                         } // end if postallist contains entry for recordType already
                                                         // else add new entry with job RT and new map with match string and Blacklist
                                                         else postalList.put(bjt.Job_Record_Type__r.Record_Type_Id__c, new Map<String, Blacklist__c>{postalString => bjt.Blacklist__r});
                                                     } // end if postal code not null
                                                 }
            }
        }
        
        /* Set Candidate Recruiter Summary and Email field on insert */
        /* also push candidates through method to find/set points allocation */
        if (!canRecIds.isempty()) {
            // build map of candidate Id to Candidate to get summary and email field
            canMap = new Map<Id, SFDC_Candidate__c>([SELECT Id, recruiter_summary_on_candidate__c, SFDC_Candidate_Email__c,
                                                     first_name__c, last_name__c, Primary_phone__c, Postal_Zip_Code__c 
                                                     FROM SFDC_Candidate__c WHERE Id IN:canRecIds]);
        }
        
        if(Trigger.isInsert){
            for (Job_Point__c jd : [SELECT Id, Name, match_key__c, point_allocation__c FROM Job_Point__c Limit 50000])
                pointsMap.put(jd.match_key__c, jd);
        }
        
        if(Trigger.isDelete){
            List<Candidate_Interview__c> tempInterviewList;
            for(Candidate_Interview__c ciL : [SELECT Id, Job_Candidate__c FROM Candidate_Interview__c WHERE Job_Candidate__c IN: Trigger.oldMap.keySet()]){
                tempInterviewList = new List<Candidate_Interview__c>();
                if(candidicateInterviewMap.containsKey(ciL.Job_Candidate__c)){
                    tempInterviewList = candidicateInterviewMap.get(ciL.Job_Candidate__c);
                }
                tempInterviewList.add(cil);
                candidicateInterviewMap.put(cil.Job_Candidate__c,tempInterviewList);
            }
        }
    }
    
    public void bulkAfter() {
        
        if(Trigger.isInsert){
            jcmap = new Map<id, SFDC_Job_Candidate__c>([SELECT Id, Status__c, Phone_Number__c, SFDC_Job__c, Background_Check_Results_URL__c,
                                                        SFDC_Job__r.OwnerId, 
                                                        SFDC_Job__r.Owner.IsActive, 
                                                        SFDC_Job__r.Job_Owner_Link__r.Contact.Account.Parent.Name, 
                                                        SFDC_Job__r.RecordType.Name, 
                                                        SFDC_Job__r.Banner_of_Store__c, 
                                                        SFDC_Job__r.OWF_Banner_of_Store__c, 
                                                        SFDC_Job__r.X1st_Level_Manager__c,
                                                        SFDC_Job__r.X2nd_Level_Manager__c,
                                                        SFDC_Job__r.X3rd_Level_Manager__c,
                                                        SFDC_Job__r.X4th_Level_Manager__c,
                                                        SFDC_Job__r.X5th_Level_Manager__c,
                                                        SFDC_Job__r.HR_User_Usual__c, 
                                                        SFDC_Job__r.Job_Owner_Link__r.Contact.Account.Name, 
                                                        SFDC_Job__r.SLA_Level__c, 
                                                        SFDC_Job__r.Specific_Candidate_Preference__c, 
                                                        SFDC_Job__r.Store__c, 
                                                        SFDC_Job__r.Parent_Account__c, 
                                                        SFDC_Job__r.X1st_Level_Access__c, 
                                                        SFDC_Job__r.X2nd_Level_Access__c,
                                                        SFDC_Job__r.Specific_Candidate_Phone_Number__c,
                                                        SFDC_Job__r.Specific_Candidate_Name__c,
                                                        Candidate__c, 
                                                        Candidate__r.OwnerId, 
                                                        Candidate__r.Name, 
                                                        Candidate__r.X1st_Level_Manager__c, 
                                                        Candidate__r.X2nd_Level_Manager__c, 
                                                        Candidate__r.X3rd_Level_Manager__c, 
                                                        Candidate__r.X4th_Level_Manager__c, 
                                                        Candidate__r.X5th_Level_Manager__c, 
                                                        Candidate__r.HR_User_Usual__c, 
                                                        Candidate__r.Background_Check_Results_URL__c,
                                                        Scheduled_Interview_Date_Time__c
                                                        FROM SFDC_Job_Candidate__c WHERE Id IN :trigger.newMap.keySet()]);
            
            Set<String> emails = new Set<String>();
            Set<String> sfdcJobIds = new Set<String>();
            for (SFDC_Job_Candidate__c jobcan : (List<SFDC_Job_Candidate__c>) Trigger.new) {
                emails.add(jobcan.Email__c);
                sfdcJobIds.add(jobcan.SFDC_Job__c);
            }
            
            if(!emails.isEmpty() || !sfdcJobIds.isEmpty()){
                for(Candidate_Interview__c cil : [SELECT Id, Name, Start_Date__c, End_Date__c, Job__c 
                                                  FROM Candidate_Interview__c WHERE Name IN:emails 
                                                  AND Job__c IN:sfdcJobIds]){
                                                      emailJobCandidateMap.put(cil.Name+''+cil.Job__c,cil);
                                                  }
            }
        }
        
        if(Trigger.isUpdate){
            Set<String> sfdcJobIds = new Set<String>();
            for (SFDC_Job_Candidate__c jobcan : (List<SFDC_Job_Candidate__c>) Trigger.new) {
                sfdcJobIds.add(jobcan.SFDC_Job__c);
            }
            
            if(!sfdcJobIds.isEmpty()){
                for(Candidate_Interview__c cil : [SELECT Id, Name, Start_Date__c, End_Date__c, Job__c 
                                                  FROM Candidate_Interview__c WHERE Job__c IN:sfdcJobIds]){
                                                      emailJobCandidateMap.put(cil.Job__c,cil);
                                                  }
            }
            
            for(Applicant_Job_Apps__c aja: [SELECT Id, Name, Candidate_Link_to_HirePortal_Record__c FROM Applicant_Job_Apps__c WHERE Candidate_Link_to_HirePortal_Record__c IN:trigger.newMap.keySet() Order by createddate ASC]){
                jobCandidateApplicantJobMap.put(aja.Candidate_Link_to_HirePortal_Record__c, aja);
            }
        }
    }
    
    public void beforeInsert(SObject so){
        SFDC_Job_Candidate__c jobcan = (SFDC_Job_Candidate__c) so;
        
        //Interview Scheduler ----------------------------------------------------------------------------------------------------
        //finds candidate interview match and gets interview date
        if(emailJobCandidateMap.containsKey(jobcan.Email__c+''+jobcan.SFDC_Job__c)){
            jobcan.Scheduled_Interview_Date_Time__c = (emailJobCandidateMap.get(jobcan.Email__c+''+jobcan.SFDC_Job__c)).Start_Date__c;
        }
        //END Interview Scheduler ----------------------------------------------------------------------------------------------------
        
        //New Service Model ----------------------------------------------------------------------------------------------------
        //set date candidate rejected field, part of new service model
        if (jobcan.Status__c=='Rejected'){
            //only fill in first time it gets rejected, we could have case where gets rejected but then triggers audit
            //then after audit sets rejection agian....we don't want to overrite date at this time
            if(jobcan.Datetime_Candidate_Rejected__c == null) {  
                jobcan.Datetime_Candidate_Rejected__c = Datetime.now();
            } 
        }
        
        //set date candidate hired field, part of new service model
        if (jobcan.Status__c=='Hired') {
            if(jobcan.Datetime_Candidate_Hired__c== null) { //only fill in first time it gets hired
                jobcan.Datetime_Candidate_Hired__c = Datetime.now();
            }  
            //Enhancement Request (00160600)
            if((jobcan.Revenue_Earned__c == null || jobcan.Revenue_Earned__c == 0) && contractTargetVolumeMap.containsKey(jobcan.Contract__c)){
                //try to get this as long as candidate hired and revenue is empty
                jobcan.Revenue_Earned__c = findTargetVolumePrice(contractTargetVolumeMap.get(jobcan.Contract__c), jobcan.Role_type__c, jobcan.SLA_Level__c, (jobcan.NSM_Specific_Candidate_Requested__c=='Yes – Referred Candidate') ,jobcan.Datetime_Candidate_Hired__c, (jobcan.SFDC_Job__r.Record_Type_Developer_Name__c=='FGL_Sports'));  
            }    
        }
        
        jobcan.Name = (jobcan.job_id__c == null ? 'job_id__c' : 'Job#' + jobcan.job_id__c+' - ') + (jobcan.candidate_last_name__c == null ? '' : jobcan.candidate_last_name__c);
        
        if (sentbyMap.containskey(jobcan.sent_by__c)){ 
            jobcan.sent_by_lookup__c = sentbyMap.get(jobcan.sent_by__c);
        } else {
            jobcan.sent_by_lookup__c = null;// if no match,  null out value
        }   
        
        if (jobMap.containskey(jobcan.SFDC_Job__c)) {
            SFDC_Job__c j = jobMap.get(jobcan.SFDC_Job__c);
            jobcan.X1st_Level_Manager__c = j.X1st_Level_Manager__c;
            jobcan.X2nd_Level_Manager__c = j.X2nd_Level_Manager__c; 
            jobcan.X3rd_Level_Manager__c = j.X3rd_Level_Manager__c;
            jobcan.X4th_Level_Manager__c = j.X4th_Level_Manager__c; 
            jobcan.X5th_Level_Manager__c = j.X5th_Level_Manager__c;
            jobcan.X1st_Level_Access__c  = j.X1st_Level_Access__c; 
            jobcan.X2nd_Level_Access__c  = j.X2nd_Level_Access__c;
            jobcan.HR_User_Usual__c      = j.HR_User_Usual__c;
            jobcan.ltas__c               = j.ltas__c;
            jobcan.job_owner_manager__c  = j.job_owner_link__r.managerid;
            jobcan.external_alert_email_address__c = j.external_alert_email_address__c;
            jobcan.Store_Email_Address__c = j.Store_Email_Address__c;
            // also check job sla, if Job Posting Only, change candidat status to initial candidate
            if (j.sla_level__c == 'Job Posting Only' && j.RecordTypeId != '012U0000000A2vi')
                jobcan.status__c = 'Initial Applicant';
            
            // if linked job in in the map and we have a match in points map, set the allocation
            if(pointsMap.containskey(j.consolidated_job_title__c)){ 
                // set job points in candidate
                jobcan.Points_Allocation__c = pointsMap.get(j.consolidated_job_title__c).point_allocation__c;
            }
        }
        
        if (canMap.containskey(jobcan.candidate__c)) {
            SFDC_Candidate__c c = canMap.get(jobcan.candidate__c);
            // populate summary, email field from map
            jobcan.recruiter_summary_on_candidate__c = c.recruiter_summary_on_candidate__c;
            jobcan.candidate_email_address__c = c.SFDC_Candidate_Email__c;
            // end if can rec is in map
        
            // create match strings
            String emailmatch = c.SFDC_candidate_email__c;
            String phoneMatch = c.last_name__c+c.primary_phone__c;
            String postalMatch = c.last_name__c+(c.Postal_Zip_code__c == null ? '' : c.Postal_Zip_Code__c.replaceAll(' ',''));
            // match is the record we found as our match, to be linked to the Candidate
            Blacklist__c match;
            // track what the match result is, either none or email/phone/postal match
            String matchType = 'No Entries';
            Id recId = jobMap.get(jobcan.sfdc_job__c).RecordTypeId;
            
            // cycle through EmailList first for match
            if (emailList.size() > 0) {
                for (String s : emailList.get(recId).keyset()) {
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
            if (match  == null && phoneList.size() > 0){
                // cycle through PhoneList first for match
                for (String s : phoneList.get(recId).keyset()) {
                    //system.debug(s+ ' compared to can phone key: '+phoneMatch);
                    // if the phoneMatch string matches, set the associated Blacklist and break out of loop
                    if (s == phonematch) {
                        match = phoneList.get(RecId).get(s);
                        matchType = 'Blacklisted - Phone Match';                                
                        break;
                    } // end if match
                } // end loop through Phonelist 
            } 
            
            // if match not found, check postalmatch
            if (match  == null && postalList.size() > 0){
                // cycle through postalList first for match
                for (String s : postalList.get(recId).keyset()) {
                    //system.debug(s+ ' compared to can postal key: '+postalMatch);
                    // if the postalMatch string matches, set the associated Blacklist and break out of loop
                    if (s == postalmatch) {
                        match = postalList.get(RecId).get(s);
                        matchType = 'Blacklisted - Postal Code Match';                                
                        break;
                    } // end if match
                } // end loop through postallist
            }
            
            // now set our match link and status
            jobcan.Candidate_blacklist_status__c = matchType;
            // if we found a match link, add it now
            if (match != null)
                jobcan.blacklist__c = match.id;
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        SFDC_Job_Candidate__c jobcan = (SFDC_Job_Candidate__c) so;
        SFDC_Job_Candidate__c oldJobCan = (SFDC_Job_Candidate__c) oldSo;
        
        //New Service Model ----------------------------------------------------------------------------------------------------
        //set date candidate rejected field, part of new service model
        if (jobcan.Status__c=='Rejected' && jobcan.Status__c <> oldJobCan.Status__c) {
            //only fill in first time it gets rejected, we could have case where gets rejected but then triggers audit
            //then after audit sets rejection agian....we don't want to overrite date at this time
            if(jobcan.Datetime_Candidate_Rejected__c == null) {  
                jobcan.Datetime_Candidate_Rejected__c = Datetime.now();
            }    
        }
        
        //set date candidate hired field, part of new service model
        if (jobcan.Status__c=='Hired' && jobcan.Status__c <> oldJobCan.Status__c) {
            if(jobcan.Datetime_Candidate_Hired__c== null) { //only fill in first time it gets hired
                jobcan.Datetime_Candidate_Hired__c=datetime.now();
            }  
            //Enhancement Request (00160600)
            if(jobcan.Revenue_Earned__c == null || jobcan.Revenue_Earned__c == 0) {
                //try to get this as long as candidate hired and revenue is empty
                jobcan.Revenue_Earned__c = findTargetVolumePrice(contractTargetVolumeMap.get(jobcan.Contract__c), jobcan.Role_type__c, jobcan.SLA_Level__c, (jobcan.NSM_Specific_Candidate_Requested__c=='Yes – Referred Candidate') ,jobcan.Datetime_Candidate_Hired__c, (jobcan.SFDC_Job__r.Record_Type_Developer_Name__c=='FGL_Sports')); 
            }    
        }
        //////////////////////////////////////////////////////////////
        
        jobcan.Name = (jobcan.job_id__c == null ? '' : 'Job#' + jobcan.job_id__c+' - ') + (jobcan.candidate_last_name__c == null ? '' : jobcan.candidate_last_name__c);
    
        if(jobcan.Sent_By__c <> oldJobCan.Sent_By__c){
            if (sentbyMap.containskey(jobcan.sent_by__c)){ 
                jobcan.sent_by_lookup__c = sentbyMap.get(jobcan.sent_by__c);
            } else {
                jobcan.sent_by_lookup__c = null;// if no match,  null out value
            }
        }
    }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){
        SFDC_Job_Candidate__c oldJobCan = (SFDC_Job_Candidate__c) so;
        
        if(candidicateInterviewMap.containsKey(oldJobCan.Id)){
            //disassociate job candidate relationship before deletion.
            // Candidate_Interview_AfterInsertUpdate_BeforeDelete trigger will stop any deletion with association...which we want when trying to delete individually
            for(Candidate_Interview__c cil: candidicateInterviewMap.get(oldJobCan.Id)){
                cil.Job_Candidate__c = null;
                deleteCandidicateInterviewMap.put(cil.Id, cil);
            }
        }
    }
    
    public void afterInsert(SObject so) { 
        SFDC_Job_Candidate__c jobCan = (SFDC_Job_Candidate__c) so;
        
        if(jcmap.containsKey(jobCan.Id)){
            tempJC = jcmap.get(jobCan.id);
            
            // check if we already have an update for this candidate and overwrite if we do
            if (candidateMap.containskey(tempJC.Candidate__c))
                tempCandidate = candidateMap.get(tempJC.Candidate__c);
            else
                tempCandidate = new SFDC_Candidate__c(Id = tempJC.Candidate__c);
            
            // change the candidate owner only if we have a new active owner for the JC, otherwise this will fail
            if (tempJC.SFDC_Job__r.Owner.IsActive) tempCandidate.OwnerId = tempJC.SFDC_Job__r.OwnerId;
            // set the manager fields as well
            tempCandidate.X1st_Level_Manager__c = tempJC.SFDC_Job__r.X1st_Level_Manager__c;
            tempCandidate.x2nd_level_manager__c = tempJC.SFDC_Job__r.X2nd_Level_Manager__c;
            tempCandidate.X2nd_Level_Manager__c = tempJC.SFDC_Job__r.X3rd_Level_Manager__c;
            tempCandidate.X4th_Level_Manager__c = tempJC.SFDC_Job__r.X4th_Level_Manager__c;
            tempCandidate.X5th_Level_Manager__c = tempJC.SFDC_Job__r.X5th_Level_Manager__c;     
            tempCandidate.X1st_Level_Access__c = tempJC.SFDC_Job__r.X1st_Level_Access__c;
            tempCandidate.X2nd_Level_Access__c = tempJC.SFDC_Job__r.X2nd_Level_Access__c;           
            tempCandidate.HR_User_Usual__c = tempJC.SFDC_Job__r.HR_User_Usual__c;
            // set store and related account fields
            tempCandidate.Store__c = tempJC.SFDC_Job__r.Store__c;
            tempCandidate.Parent_Account__c = tempJC.SFDC_Job__r.Parent_Account__c;
            // move various fields from Job/Candidate to Can Rec
            tempCandidate.SLA_Level__c = tempJC.SFDC_Job__r.SLA_Level__c; 
            
            String reqNum = String.valueOf(tempJC.SFDC_Job__r.Specific_Candidate_Phone_Number__c);
            String canNum = String.valueOf(tempJC.Phone_Number__c);
            if(reqnum != null)
                reqnum = trimPhone(reqnum);
                
            if(canNum != null)
                canNum = trimPhone(canNum);
            
            String reqName = String.valueof(tempJC.SFDC_Job__r.Specific_Candidate_Name__c);
            String canName = String.valueOf(tempJC.Candidate__r.Name);
                
            if(reqNum == canNum || reqName == canName){
                tempCandidate.Specific_Candidate_requested__c = tempJC.SFDC_Job__r.Specific_Candidate_Preference__c;
            } else {
                tempCandidate.Specific_Candidate_requested__c = 'No';
            }
            
            tempCandidate.Scheduled_Interview_Date_Time__c = tempJC.scheduled_interview_date_time__c; 
            // use banner of store if populated, else store parent account
            String displayName = tempJC.SFDC_Job__r.Banner_of_Store__c;
            if (displayName == null || displayName == '') displayName = tempJC.SFDC_Job__r.OWF_Banner_of_Store__c;
            if (displayName == null || displayName == '') displayName = tempJC.SFDC_Job__r.Job_Owner_Link__r.Contact.Account.Parent.Name;
            // if we ended up with Husaro in the display name or in the contacts account name, replace with Mr. Lube Husaro
            if ((displayName != null && displayName.contains('Husaro')) || 
                (tempJC.SFDC_Job__r.Job_Owner_Link__r.Contact.Account.Name != null &&
                 tempJC.SFDC_Job__r.Job_Owner_Link__r.Contact.Account.Name.contains('Husaro'))) displayName = 'Mr. Lube Husaro';
            tempCandidate.client_display_name__c = displayName ;
            tempCandidate.client_short_name__c = tempJC.SFDC_Job__r.recordtype.name;   
            tempCandidate.most_recent_job__c = tempJC.SFDC_Job__c;
            
            candidateMap.put(tempCandidate.id, tempCandidate);
        }
        
        if(emailJobCandidateMap.containsKey(jobCan.Email__c+''+jobCan.SFDC_Job__c)){
            tempInterview = emailJobCandidateMap.get(jobcan.Email__c+''+jobcan.SFDC_Job__c);
            tempInterview.Job_Candidate__c = jobCan.Id;
            candidateInterviewMap.put(tempInterview.Id, tempInterview);
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        SFDC_Job_Candidate__c jobCan = (SFDC_Job_Candidate__c) so;
        SFDC_Job_Candidate__c oldJobCan = (SFDC_Job_Candidate__c) oldSo;
        
        if(emailJobCandidateMap.containsKey(jobCan.SFDC_Job__c)){
            
            if (jobCan.status__c != oldJobCan.status__c && //if status changed
                jobCan.status__c == 'Rejected' &&                            //if status changed to rejected
                jobCan.Scheduled_Interview_Date_Time__c > Datetime.now())             //if interview is in the future
            {           
                //delete associated candidate interview so space if no taken up
                tempInterview = emailJobCandidateMap.get(jobcan.SFDC_Job__c);
                tempInterview.Job_Candidate__c = null; 
                deleteCandidicateInterviewMap.put(tempInterview.Id, tempInterview);
            }
            
            if (jobCan.SFDC_Job__c != oldJobCan.SFDC_Job__c) //if swapped candidate to a differnt job
            {      
                tempInterview = emailJobCandidateMap.get(jobcan.SFDC_Job__c);
                tempInterview.Job__c = jobcan.SFDC_Job__c;
                candidateInterviewMap.put(tempInterview.Id, tempInterview);
            }
        }
        
        // Since this trigger runs methods related to candidate object, we prevent that both run in the same transaction.
        //if (!ApplicantJobAppTriggerHandler.isCreatingCandidateRecord && !ApplicantJobAppTriggerHandler.isSyncCandidateToJobApp && !ApplicantJobAppTriggerHandler.isSyncJobAppToCandidate){
            
            if(jobCandidateApplicantJobMap.containsKey(jobCan.Id)){
                Applicant_Job_Apps__c jobApps =  jobCandidateApplicantJobMap.get(jobCan.Id);
                boolean foundChanges=false;
                for (String target_field : APPLICANTAPP_TO_JOBCANDIDATE.keyset()) {   
                    String source_field = APPLICANTAPP_TO_JOBCANDIDATE.get(target_field);
                    if (jobCan.get(source_field )!=null &&  jobCan.get(source_field) != oldJobCan.get(source_field) ) {
                        System.debug('target_field : '+target_field+' jobCan.get(source_field) : '+jobCan.get(source_field));
                        if (target_field.equalsIgnoreCase('status__c') && CANDIDATE_STATUS_TO_JobAPP.containsKey((String)jobCan.get(source_field)))
                            jobApps.put( target_field , CANDIDATE_STATUS_TO_JobAPP.get((String)jobCan.get(source_field)));      
                        else                        
                            jobApps.put( target_field , jobCan.get(source_field) );                             
                        foundChanges=true;
                    }
                }
                
                if (foundChanges) {
                    updateThesejobApps.add(jobApps);
                }
            }
        //}
    }
    
    public void afterDelete(SObject so){ }
    
    public void afterUndelete(SObject so){ }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        
        if(!deleteCandidicateInterviewMap.isEmpty()){
            update deleteCandidicateInterviewMap.values();
            delete deleteCandidicateInterviewMap.values();
        }
        
        if(!candidateInterviewMap.isEmpty()){
            update candidateInterviewMap.values();
        }
        
        if(!candidateMap.isEmpty()){
            update candidateMap.values(); 
        }
        
        if(!updateThesejobApps.isEmpty()){
            //ApplicantJobAppTriggerHandler.isSyncCandidateToJobApp=true;
            update updateThesejobApps;
        }
    }
    
    public String trimPhone(String s){
        s = s.removeStart('+1');
        s = s.remove('(');
        s = s.remove(')');
        s = s.remove(' ');
        s = s.remove('-');
        return s; 
    }
    
    //Method to find target volume price associated with client profile contract for the specific time a job candidate is hired.
    public decimal findTargetVolumePrice(List<Target_Volume__c> tvlList, String roleType, String SLALevel, Boolean applyAdminFee, DateTime dateTimeCandidateHired, Boolean isFGL) {
        decimal dPrice = 0;
        Date dateCandidateHired = Date.newinstance(dateTimeCandidateHired.year(), dateTimeCandidateHired.month(), dateTimeCandidateHired.day());
              
        String JobType = roleType != null ? roleType : SLALevel; //try to get off role type but if empty try sla level
        Target_Volume__c foundTargetVolume = null;
        
        //find target volume associated with contract
        List<Target_Volume__c> tvl = tvlList;
        
        if(tvl!=null && tvl.size() > 0) {
            
            //LOOP try to find TV within date range----------------------------------------------------------------------------------
            for (Target_Volume__c tv : tvl) {
                if(tv.Start_Date_of_Target_Month__c <= dateCandidateHired && tv.End_Date_of_Target_Month__c >= dateCandidateHired) {
                    foundTargetVolume = tv;
                    break;
                }
            }
            //END LOOP --------------------------------------------------------------------------------------------------------------
            
            //if didnt find from above, just take last one...if any
            if(foundTargetVolume == null) {
                foundTargetVolume = tvl[tvl.size() - 1];
            }
            
            //now get price from found target volume based on role or sla
            if(JobType == 'Front Line' || JobType == 'Frontline') {
                dPrice = foundTargetVolume.Frontline_Price__c;
            }
            if(JobType == 'Front Line 1' || JobType == 'Frontline 1') {
                dPrice = foundTargetVolume.Frontline_1_Price__c;
            }
            if(JobType == 'Front Line 2' || JobType == 'Frontline 2') {
                dPrice = foundTargetVolume.Frontline_2_Price__c;
            }
            else if(JobType == 'Specialty 1') {
                dPrice = foundTargetVolume.Specialty_1_Price__c;
            }
            else if(JobType == 'Specialty 2') {
                dPrice = foundTargetVolume.Specialty_2_Price__c;
            }
            else if(JobType == 'Management 1') {
                dPrice = foundTargetVolume.Management_1_Price__c;
            }
            else if(JobType == 'Management 2') {
                dPrice = foundTargetVolume.Management_2_Price__c;
            }
            
            //August 2019
            //Referred candidates for FGL now have a hard coded value of $96.50 rather then calculating off the admin fee percentage.
            if(isFGL && applyAdminFee) {
                dPrice = 96.50; 
            }
            //apply admin fee if applicable, referred candidate
            else if(applyAdminFee && foundTargetVolume.Admin_Fee__c != null) {
                dPrice =  dPrice * (foundTargetVolume.Admin_Fee__c / 100);
            }
        }
        
        return dPrice;
    } 
}