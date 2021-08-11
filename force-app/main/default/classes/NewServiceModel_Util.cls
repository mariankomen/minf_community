/**********************************************************************************
    Author: Jeff Perron
    Date: July 2017
    Class: NewServiceModel_Util 
    Purpose: This class contains methods to handle new service model functionallity.
***********************************************************************************/   
global without sharing class NewServiceModel_Util {


    /*
    public static void UpdateJobChatter(id jId) {
        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, 'a0P3D000000e02qUAA', ConnectApi.FeedElementType.FeedItem, 'The job is now closed due to hire being made in the job. Please stop recruitment work on this job immediately.');
      //FeedItem post = new FeedItem();
//post.Body = 'HelloThere';
//post.ParentId = 'a0Q3D000000YWOB';
//post.Title = 'FileName';
//insert post;

    }
    */

    //Enhancement Request (00138531) ------------------------------------------------------------------------------------------------------------------------------
    //check if client profile is setup to use NSM from the store number.
    /* FORGET THIS
    public static boolean IsAccountOnNSMByStoreNumber(string sStoreNumber) {
        Account acc = [SELECT id, name, Client_Profile__r.Using_New_Service_Model__c, Parent.Client_Profile__r.Using_New_Service_Model__c
                       FROM Account WHERE Store_Number_NonOFG__c =: sStoreNumber];
        
        return (
         acc != null &&
         (
          (
             acc.Client_Profile__r.Using_New_Service_Model__c != null && 
             acc.Client_Profile__r.Using_New_Service_Model__c
          ) 
          ||
          (
             acc.Parent.Client_Profile__r.Using_New_Service_Model__c != null && 
             acc.Parent.Client_Profile__r.Using_New_Service_Model__c
          ) 
         )
        ); 
    }*/
    //END Enhancement Request (00138531) --------------------------------------------------------------------------------------------------------------------------
    
    
    //Enhancement Request (00160600) ------------------------------------------------------------------------------------------------------------------------------
    //Method to find target volume price associated with client profile contract for the specific time a job candidate is hired.
    public static decimal FindTargetVolumePrice(Id jobId, DateTime dateTimeCandidateHired, Boolean isFGL) {
        decimal dPrice = 0;
        Date dateCandidateHired = date.newinstance(dateTimeCandidateHired.year(), dateTimeCandidateHired.month(), dateTimeCandidateHired.day());
              
        SFDC_Job__c j = [SELECT Contract__c, Role_type__c, SLA_Level__c, NSM_Specific_Candidate_Requested__c FROM SFDC_Job__c WHERE id=:jobId]; //get job
        string JobType = j.Role_type__c != null ? j.Role_type__c : j.SLA_Level__c; //try to get off role type but if empty try sla level
        Boolean applyAdminFee = j.NSM_Specific_Candidate_Requested__c=='Yes_Referred_Candidate';
        Target_Volume__c foundTargetVolume = null;
        
        //find target volume associated with contract
        List<Target_Volume__c> tvl = [SELECT id, Start_Date_of_Target_Month__c, End_Date_of_Target_Month__c, Frontline_Price__c,Frontline_1_Price__c, Frontline_2_Price__c,
                                      Specialty_1_Price__c, Specialty_2_Price__c,
                                      Management_1_Price__c, Management_2_Price__c, Admin_Fee__c
                                      FROM Target_Volume__c
                                      WHERE Contract__c=: j.Contract__c 
                                      Order By Start_Date_of_Target_Month__c ASC
                                     ];
        
        if(tvl.size() > 0) {
            
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
    //END Enhancement Request (00160600) ------------------------------------------------------------------------------------------------------------------------------
    
    //Methods for NSM, Target Volumes -------------------------------------------------------------------------------------------------------------------------------
     public static string CreateTargetVolumes(Contract contr) {
        Savepoint sp = Database.setSavepoint();
        string status='Nothing Processed';
        
        try {
            List<Target_Volume__c> tvl = [SELECT id FROM Target_Volume__c WHERE Contract__r.Id =: contr.Id];
            if(tvl.size() > 0) { //dont create if have existing
                status = 'Target volumes already exist on this contract. If you want to regenerate new ones, all existing must be deleted.';
            }
            else if(contr.StartDate == null || contr.EndDate == null) {
                status = 'Target volumes without contract start and end date defined.';
            }
            else { //create new...
                Date sDate = contr.StartDate;
                Date eDate = contr.EndDate;
                Decimal fl = (contr.Frontline__c != null) ? contr.Frontline__c : 0;
                Decimal flp = (contr.Frontline_Price__c != null) ? contr.Frontline_Price__c : 0;
                
                Decimal fl1 = (contr.Frontline_1__c != null) ? contr.Frontline_1__c : 0;
                Decimal flp1 = (contr.Frontline_1_Price__c != null) ? contr.Frontline_1_Price__c : 0;
                
                Decimal fl2 = (contr.Frontline_2__c != null) ? contr.Frontline_2__c : 0;
                Decimal flp2 = (contr.Frontline_2_Price__c != null) ? contr.Frontline_2_Price__c : 0;
                
                Decimal sp1 = (contr.Specialty_1__c != null) ? contr.Specialty_1__c : 0;
                Decimal sp1p = (contr.Specialty_1_Price__c != null) ? contr.Specialty_1_Price__c : 0;
                Decimal sp2 = (contr.Specialty_2__c != null) ? contr.Specialty_2__c : 0;
                Decimal sp2p = (contr.Specialty_2_Price__c != null) ? contr.Specialty_2_Price__c : 0;
                Decimal m1 = (contr.Management_1__c != null) ? contr.Management_1__c : 0;
                Decimal m1p = (contr.Management_1_Price__c != null) ? contr.Management_1_Price__c : 0;
                Decimal m2 = (contr.Management_2__c != null) ? contr.Management_2__c : 0;
                Decimal m2p = (contr.Management_2_Price__c != null) ? contr.Management_2_Price__c : 0;
                Decimal af = (contr.Admin_Fee__c!= null) ? contr.Admin_Fee__c : 100;
                
                tvl = new List<Target_Volume__c>();
                
                //loop through and create one object for each month between contract dates
                while (sDate < eDate) {
                    Target_Volume__c tv = new Target_Volume__c(Month_Targeted__c=sDate, 
                                                               Number_of_Hires_Frontline__c=fl, Frontline_Price__c=flp,
                                                               Number_of_Hires_Frontline_1__c=fl1, Frontline_1_Price__c=flp1,
                                                               Number_of_Hires_Frontline_2__c=fl2, Frontline_2_Price__c=flp2,
                                                               Number_of_Hires_Specialty_1__c=sp1, Specialty_1_Price__c=sp1p,
                                                               Number_of_Hires_Specialty_2__c=sp2, Specialty_2_Price__c=sp2p,
                                                               Number_of_Hires_Management_1__c=m1, Management_1_Price__c=m1p,
                                                               Number_of_Hires_Management_2__c=m2, Management_2_Price__c=m2p,
                                                               Admin_Fee__c=af,
                                                               Contract__c=contr.Id);
                    tvl.add(tv);
                    sDate = sDate.addMonths(1);
                }
                insert tvl;
                
                status = 'true';
            }
        } 
        catch (Exception e) {
            Database.rollback(sp);
            SendErrorEmail(e);
            status = 'Error: ' + e.getMessage();
        } 
        return status;
    }    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------

    //Methods for NSM, Up to 2 hire -------------------------------------------------------------------------------------------------------------------------------
    //main method to handle up to two hires made operation
    //we can close if one hire is made and no other candidates left to disposition
    public static string ProcessUptoTwoCandidateRule(SFDC_Job__c originalJob, boolean cameFromJobTransfer) {
        Savepoint sp = Database.setSavepoint();
        string status='Nothing Processed';
        
        try {
        
            integer cHired = 0;
            integer cRejected = 0;
            integer cInAudit = 0;
            integer cToBeDispositioned = 0;
            integer cTotal = 0;
            List<SFDC_Job_Candidate__c> canInAudit = new List<SFDC_Job_Candidate__c>();
            
        
            List<SFDC_Job_Candidate__c> candidates = [SELECT Id, Name, Candidate_Audit_Result__c, Status__c 
                                                      FROM SFDC_Job_Candidate__c 
                                                      WHERE SFDC_job__c =: originalJob.id];
        
            //count up number of candidate in the various status'
            for (SFDC_Job_Candidate__c c : candidates) {
                cTotal++;
                if(c.Status__c.contains('Hired')) {
                    cHired++;
                }
                else if(c.Status__c.contains('Rejected') || c.Status__c.contains('Awaiting Replacement Adjudication')) {
                    cRejected++;
                    //process ones in audit
                    if(c.Status__c.contains('Awaiting Replacement Adjudication')) {
                        cInAudit++; 
                        //this will trigger workflow, 'Post Interview Sched (Cancelled) - All Candidate Replacement – NSM'
                        //the workflow will notify that audit is no longer required and set the candidate to rejected
                        c.Candidate_Audit_Result__c='Adjudication Not Required Due to Hire Made';
                        canInAudit.add(c);
                    }
                }
                else {
                    cToBeDispositioned++;
                }
            }
        
            //one hire made, no more left to disposition, 
            //even if this job transfer, if no more candidates to dispositon then we can close
            if(cHired >= 1 && cToBeDispositioned == 0) { 
                //originalJob.NSM_Job_Auto_Closure__c='Delivery Stopped, Hire Made'; 
                
                //if current status is we need more candidates...
                if(originalJob.Job_Status__c.contains('Additional Candidate(s) Required') || originalJob.Job_Status__c.contains('Open/Active Job')) {
                    originalJob.NSM_Job_Auto_Closure__c='Delivery Stopped, Hire Made'; 
                    //if job status IS 'Additional Candidate(s) Required' OR 'Open/Active Job'then we dont close here 
                    //worflow, 'NSM - Single Hire Made' will pick it up, send email notification that no more sourcing required then close
                } 
                else {
                    originalJob.Job_Status__c = 'Filled Closed Job'; 
                }   
                
                //catch candidates in audit
                //this will trigger workflow, 'Post Interview Sched (Cancelled) - All Candidate Replacement – NSM'
                //the workflow will notify that audit is no longer required and set the candidate to rejected
                if(cInAudit > 0) {
                    update canInAudit;
                }
                
                update originalJob;
                status='true';
            }
            else {
                //came from transfer but still more candidates left to dispositon
                //if hire added to transfer job pushes num candidates to delivery agreement, then we can switch job status
                
                //June 2019, small update. We could be in a situation where the num of cads is more then delivery.
                //if(cameFromJobTransfer && cTotal==originalJob.Num_of_Candidates_for_Delivery_Agreement__c) {
                if(cameFromJobTransfer && cTotal>=originalJob.Num_of_Candidates_for_Delivery_Agreement__c) {
                    originalJob.Job_Status__c = 'Candidates Sent/Awaiting Hire';
                    originalJob.NSM_Job_Auto_Closure__c='Two Hires Made, Transfer';
                    update originalJob;
                    status='true';
                }
            }
        
            
        
            /*if(originalJob.Job_Status__c.contains('Additional Candidate(s) Required') || originalJob.Job_Status__c.contains('Candidates Sent/Awaiting Hire'))
            {
                //get any candidates awaiting post rejection reason audit
                List<SFDC_Job_Candidate__c> updCandidates = [SELECT Id, Name, Candidate_Audit_Result__c, Status__c 
                                                             FROM SFDC_Job_Candidate__c 
                                                             WHERE SFDC_job__c =: originalJob.id AND Status__c='Awaiting Replacement Adjudication'];
            
                //update candidate status and audit result                                             
                for (SFDC_Job_Candidate__c c : updCandidates) {
                    //this will trigger workflow, 'Post Interview Sched (Cancelled) - All Candidate Replacement – NSM'
                    //the workflow will notify that audit is no longer required and set the candidate to rejected
                    c.Candidate_Audit_Result__c='Adjudication Not Required Due to Hire Made';
                }   
                update updCandidates;                                           
        
                originalJob.NSM_Job_Auto_Closure__c='Delivery Stopped, Hire Made'; 
            
                //if job status IS 'Additional Candidate(s) Required' then we dont close here 
                //worflow, 'NSM - Single Hire Made' will pick it up, send email notification that no more sourcing required then close
                if(!originalJob.Job_Status__c.contains('Additional Candidate(s) Required')) {
                    originalJob.Job_Status__c = 'Filled Closed Job'; 
                }
                        
                update originalJob;
            }*/
        } 
        catch (Exception e) {
            Database.rollback(sp);
            SendErrorEmail(e);
            status = 'Error: ' + e.getMessage();
        } 
        return status;  
    }
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //Methods for NSM, Transfer 2 hire -----------------------------------------------------------------------------------------------------------------------------------------
    //main method to handle candidate transfer operation
    public static string ProcessTransferToHireRule(SFDC_Job__c originalJob, SFDC_Job__c jToTranferTo, SFDC_Job_Candidate__c cToTransfer, SFDC_Job_Candidate__c cRemainingCandidate) {
        Savepoint sp = Database.setSavepoint();
        boolean isCloned = false;
        
        try {
            //no job to transfer candidate to so clone the job
            if(jToTranferTo == null) {
                jToTranferTo = CloneJob(originalJob);
                isCloned = true;
            }
        
            //transfers hired candidate to new or selected job and closes job if needed
            TransferCandidateToMatchedOrClonedJobAndCloseIfRequired(jToTranferTo, cToTransfer, isCloned);
            
            //close our orignal job
            CloseOriginalJob(originalJob, cRemainingCandidate);
        } 
        catch (Exception e) {
            Database.rollback(sp);
            SendErrorEmail(e);
            return e.getMessage();
        } 
        //send back true if success as well as cloned job id 
        return isCloned ? 'true-' + jToTranferTo.Id : 'true';  
    }
    
    //find jobs that match current job for potential candidate placement
    //Update, Q3 Job Auto Billing, do not inclide 'Yes – Referred Candidate' jobs in match
    //Update ER: 00182313
    public static List<SFDC_Job__c> FindMatchingJobs(SFDC_Job__c j) {
        List<SFDC_Job__c> jl = new List<SFDC_Job__c>();
        
        /* Orignal Query, Updated with ER: 00182313 
        jl = [SELECT id, name, store__c, store__r.id, store__r.name, owner.name, of_Candidates_Awaiting_Feedback__c, Job_Title_for_Role__c, Department__c,
                     NSM_Job_Auto_Closure__c, Job_Status__c, Job_Title_for_Banner__c, Banner_of_Store__c, OWF_Job_Title__c, OWF_Banner_of_Store__c,
                     RecordType.Id, RecordType.name, Num_of_Candidates_for_Delivery_Agreement__c, NSM_Specific_Candidate_Requested__c,New_Job_Title__c
              FROM SFDC_Job__c 
               WHERE store__r.id =: j.store__r.id AND Using_New_Service_Model__c=true AND RecordType.Id =: j.RecordType.Id AND
                     (Job_Status__c='Additional Candidate(s) Required' OR Job_Status__c='Open/Active Job') AND
                     NSM_Specific_Candidate_Requested__c!='Yes – Referred Candidate' AND
                     MindField_Job_Type__c!='TalentReach'
                     ORDER BY name];
        */             
            
        jl = [SELECT id, name, store__c, store__r.id, store__r.name, owner.name, of_Candidates_Awaiting_Feedback__c, Job_Title_for_Role__c, Department__c,
                     NSM_Job_Auto_Closure__c, Job_Status__c, Job_Title_for_Banner__c, Banner_of_Store__c, OWF_Job_Title__c, OWF_Banner_of_Store__c,
                     RecordType.Id, RecordType.name, Num_of_Candidates_for_Delivery_Agreement__c, NSM_Specific_Candidate_Requested__c,New_Job_Title__c,
                     Date_Job_Added_or_Opened__c, Date_Delivery_Complete__c
              FROM SFDC_Job__c 
               WHERE 
                  (
                     id <>: j.id AND
                     store__r.id =: j.store__r.id AND 
                     Using_New_Service_Model__c=true AND 
                     RecordType.Id =: j.RecordType.Id AND
                     NSM_Specific_Candidate_Requested__c!='Yes_Referred_Candidate' AND
                     MindField_Job_Type__c!='TalentReach' AND
                     
                     (
                        (Job_Status__c='Additional Candidate(s) Required' OR Job_Status__c='Open/Active Job') 
                        OR
                        (
                          (
                             (
                               (
                                 Date_Job_Added_or_Opened__c >=: j.Date_Job_Added_or_Opened__c AND
                                 Date_Job_Added_or_Opened__c <=: j.Date_Delivery_Complete__c
                               )  
                               OR
                               (
                                 Date_Job_Added_or_Opened__c <=: j.Date_Job_Added_or_Opened__c AND
                                 Date_Delivery_Complete__c >=: j.Date_Job_Added_or_Opened__c
                               )  
                             )
                             AND
                             (Job_Status__c='Candidates Sent/Awaiting Hire' OR Job_Status__c='Not Filled/Closed by Mgr' OR Job_Status__c='Not Filled/Job Re-Opened')
                         )  
                        )   
                     )   
                     
                  )   
                  ORDER BY name];    
            
                     
        return jl;
    }
    
    //does a deep clone of our original job
    private static SFDC_Job__c CloneJob(SFDC_Job__c jobToClone) {
        SFDC_Job__c newJob = jobToClone.clone(false, true, false, false);
        
        newJob.OwnerID = jobToClone.OwnerID; //July 2018, keep same owner
        
        newJob.Online_Posting__c='No';
        newJob.Confidential__c='Yes';
        
        newJob.Banner_of_Store__c=jobToClone.Banner_of_Store__c;
        //newJob.OWF_Banner_of_Store__c=jobToClone.OWF_Banner_of_Store__c;
        
        newJob.Job_Title_for_Banner__c=jobToClone.Job_Title_for_Banner__c;
        //newJob.OWF_Job_Title__c=jobToClone.OWF_Job_Title__c;
                
        newJob.Career_Site_Alternate_Job_Title__c=jobToClone.Career_Site_Alternate_Job_Title__c;
        //newJob.Career_Site_Alternate_Job_Title_OFG__c=jobToClone.Career_Site_Alternate_Job_Title_OFG__c;
        
        //April 2018....Marks uses this fields
        newJob.Job_Title_for_Role__c=jobToClone.Job_Title_for_Role__c;
        newJob.Department__c=jobToClone.Department__c;
        
        newJob.Name_of_Person_Submitting_Request__c=jobToClone.Name_of_Person_Submitting_Request__c;
        
        newJob.Mindfield_Service__c=jobToClone.Mindfield_Service__c;
        newJob.Role_type__c=jobToClone.Role_type__c;
        newJob.Program_Type__c=jobToClone.Program_Type__c;
        newJob.QCP_Acknowledgement__c=jobToClone.QCP_Acknowledgement__c;
        
        newJob.Number_Of_Hours_Per_Week__c=jobToClone.Number_Of_Hours_Per_Week__c;
        newJob.FT_or_PT__c=jobToClone.FT_or_PT__c;
        newJob.Hours_of_Availability__c=jobToClone.Hours_of_Availability__c;
                
        newJob.Specific_Candidate_Preference__c = 'No'; //not used in NSM anymore so just default.      
        newJob.NSM_Specific_Candidate_Requested__c='Mindfield_Sourced_Candidates'; //jobToClone.NSM_Specific_Candidate_Requested__c;
        newJob.Specific_Candidate_Name__c=jobToClone.Specific_Candidate_Name__c;
        newJob.Specific_Candidate_Phone_Number__c=jobToClone.Specific_Candidate_Phone_Number__c;
        newJob.Specific_Candidate_Email__c=jobToClone.Specific_Candidate_Email__c;
        newJob.Specific_Candidate_Phone_Number_2nd__c=jobToClone.Specific_Candidate_Phone_Number_2nd__c;
        
        /*newJob.Job_Code_OWF__c=jobToClone.Job_Code_OWF__c;
        newJob.OWF_Department__c=jobToClone.OWF_Department__c;
        newJob.OFG_Job_Template_Description__c=jobToClone.OFG_Job_Template_Description__c;
        newJob.OWF_Union_Code__c=jobToClone.OWF_Union_Code__c;*/
        
        newJob.Is_Cloned_Job__c = 'true'; //this will allow to bypass PPG USA approval
        newJob.Is_Cloned_Job_ID__c = jobToClone.name;
        
        insert newJob;
        
        return newJob;
    }
    
    //sets non transfered candidate to hired and closes the orignal job
    private static void CloseOriginalJob(SFDC_Job__c originalJob, SFDC_Job_Candidate__c cRemainingCandidate) {
        if(cRemainingCandidate != null) //we'll pass in null if candidate already hired
        {
            cRemainingCandidate.Status__c='Hired';
            update cRemainingCandidate;
        }
        
        originalJob.NSM_Job_Auto_Closure__c='Two Hires Made, Original';
        originalJob.Job_Status__c = 'Filled Closed Job';
        update originalJob;
    }
    
    //transfer the new hire into either the selected or cloned job
    private static void TransferCandidateToMatchedOrClonedJobAndCloseIfRequired(SFDC_Job__c jToTranferTo, SFDC_Job_Candidate__c cToTransfer, boolean isCloned) {
        cToTransfer.SFDC_Job__c=jToTranferTo.Id;
        cToTransfer.Status__c='Hired';
        //NOTE: we might need to update some other feilds in SFDC_Job_Candidate__c...dates ect.
        //we'll see if just setting to hired handles this stuff automatically in triggers or feild updates
        update cToTransfer;
        
        //if job candidate transferred to has no candidates left to process OR was cloned, then close 
        //if(jToTranferTo.of_Candidates_Awaiting_Feedback__c==0 || isCloned) {
        if(isCloned) {
            jToTranferTo.NSM_Job_Auto_Closure__c='Two Hires Made, Cloned';
            jToTranferTo.Job_Status__c = 'Filled Closed Job';
            update jToTranferTo;
        }
        else {
            //if transfered to other job let below rule run it through
            ProcessUptoTwoCandidateRule(jToTranferTo, true);
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //Methods for NSM, QCP -----------------------------------------------------------------------------------------------------------------------------------------
    
    //identifies if user on NSM by contact
    public static boolean IsUserOnNSMByContact(Contact c) {
        return (
         (
             c.account.Client_Profile__r.Using_New_Service_Model__c != null && 
             c.account.Client_Profile__r.Using_New_Service_Model__c
         ) 
         ||
         (
             c.account.Parent.Client_Profile__r.Using_New_Service_Model__c != null && 
             c.account.Parent.Client_Profile__r.Using_New_Service_Model__c
         ) 
        ); 
    }
    
    //finds list of users associated with the respective client profile, looks on account and parent account
    public static List<User> FindUsersByClientProfile(Id cpId) {
        List<User> ul = [SELECT id, Client_Profile_Using_New_Service_Model__c FROM User WHERE contact.account.Client_Profile__r.Id=:cpId OR contact.account.Parent.Client_Profile__r.Id=:cpId];
        return ul;
    }
    
    public static void UpdateUsersToNSMByClientProfile(Client_Profile__c c) {
        List<User> ul = FindUsersByClientProfile(c.Id);
        if(ul.size()>0) {
            for (User u : ul) {
                u.Client_Profile_Using_New_Service_Model__c=c.Using_New_Service_Model__c;
            }
            update ul;
         }
    }
    
    public static Boolean IsSOFSourcingUser(Id userId) {
        Client_Profile__c cp = FindCurrentUserClientProfile(userId);
        if(cp != null && cp.Enable_OFG_Sourcing__c) {
            return true;
        }
        return false;
    }
    
    //we'll look three levels to try to find a client profile
    public static Client_Profile__c FindCurrentUserClientProfile(Id userId) {
        User u = [SELECT Contact.Account.Client_Profile__c, Contact.Account.Parent.Client_Profile__c, Contact.Account.Parent.Parent.Client_Profile__c FROM User WHERE Id =:userId];
              
        Id cpId = null;      
                
        if(u.Contact.Account.Client_Profile__c != null) {
            cpId = u.Contact.Account.Client_Profile__c;
        }
        else if(u.Contact.Account.Parent.Client_Profile__c != null) {
            cpId = u.Contact.Account.Parent.Client_Profile__c;
        }
        else if(u.Contact.Account.Parent.Parent.Client_Profile__c != null) {
            cpId  = u.Contact.Account.Parent.Parent.Client_Profile__c;
        }
        
        if(cpId != null) {
            return [SELECT Id, Name, Enable_OFG_Sourcing__c, Using_New_Service_Model__c, Time_to_Disposition_Job_Close_hrs__c, Date_New_Service_Model_Applied__c, Time_to_Disposition_hrs__c FROM Client_Profile__c WHERE Id =:cpId];
        }
        
        return null;
    }
    
    public static List<QCPSectionWrapper> BuildQCPList(List<Attachment> lQCP) {
        List<QCPSectionWrapper> lQCPSectionWrapper = new List<QCPSectionWrapper>();
        for (Attachment a : lQCP) {
             List<String> names = a.Name.split('-');
             
             if(names.size() == 2) { //should be in format, 'Section - File'
             
                 string sectionName=names[0];
                 string fileName=names[1];
             
                 //create new qcp wrapper
                 QCPWrapper w = new QCPWrapper();
                 w.attId = a.Id;
                 w.fileName = fileName;
                 w.att = a;
             
                 QCPSectionWrapper swToFind = Find_QCPSectionWrapper(sectionName, lQCPSectionWrapper);
                 if(swToFind == null) //if we dont have unique section name yet
                 {
                     QCPSectionWrapper newSW = new QCPSectionWrapper(); //new section wrapper
                     newSW.sectionName = sectionName;
                     newSW.lQCPW = new List<QCPWrapper>(); //new qcpwrapper held by section wrapper
             
                     newSW.lQCPW.add(w); //add above qcp to new wrapper list
                     lQCPSectionWrapper.add(newSW); //add new section wrapper to list
                 }
                 else //found key, add to existing list
                 {
                     swToFind.lQCPW.add(w); //add above qcp to new wrapper list 
                 }
            }         
        }
        return lQCPSectionWrapper;
    }
    
    private static QCPSectionWrapper Find_QCPSectionWrapper(string key, List<QCPSectionWrapper> lQCPSectionWrapper) {
        for (QCPSectionWrapper sw : lQCPSectionWrapper) {
            if(sw.sectionName.equals(key)) {
                return sw;
            }
        }
        return null;
    }
    
     //Helper classes---------------------------------------------------------------------------------------------
    public class QCPSectionWrapper{
        public String sectionName {get; set;}
        public List<QCPWrapper> lQCPW {get; set;}
    }

    public class QCPWrapper{
        public Id attId {get; set;}
        public String fileName {get; set;}
        public Attachment att {get; set;}
    }
    //END Helper classes---------------------------------------------------------------------------------------------
    //END Methods for NSM, qcp -----------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    //Methods for NSM, rejection reasons -----------------------------------------------------------------------------------------------------------------------------------------
    
    public static List<SelectOption> BuildRejectionReasonsNewServiceModel() {
        return BuildRejectionReasonsNewServiceModel('English');
    }
    
    //New rejection reasons for new service model, displayed on apex page CandidateUpdate
    // method to dynamically build the list of Rejection Reasons based on Job values - always the same list for all Candidates in a Job
    public static List<SelectOption> BuildRejectionReasonsNewServiceModel(string Language) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        
        //pre interview rejection reasons, valid for potential replacement candidate
        options.add(new SelectOption('Candidate did not show for interview',  Language == 'English' ? 'Candidate did not show for interview' : 'Le candidat ne s’est pas présenté à l’entrevue'));
        options.add(new SelectOption('Candidate withdrew prior to interview – unknown or undisclosed reason', Language == 'English' ? 'Candidate withdrew prior to interview – unknown or undisclosed reason' : 'Le candidat s’est retiré avant l’entrevue – raison non-divulguée ou inconnue'));
        options.add(new SelectOption('Candidate withdrew prior to interview – accepted other employment', Language == 'English' ? 'Candidate withdrew prior to interview – accepted other employment' : 'Le candidat s’est retiré avant l’entrevue – accepté un autre emploi'));
        options.add(new SelectOption('Candidate withdrew prior to interview – circumstances changed', Language == 'English' ? 'Candidate withdrew prior to interview – circumstances changed' : 'Le candidat s’est retiré avant l’entrevue – changement de circonstances'));
        options.add(new SelectOption('Candidate withdrew prior to interview – reconsidered the opportunity', Language == 'English' ? 'Candidate withdrew prior to interview – reconsidered the opportunity' : 'Le candidat s’est retiré avant l’entrevue – reconsidération de l’opportunité'));
            
        //post interview rejection reasons, valid for potential replacement candidate
        options.add(new SelectOption('Candidate does not have the appropriate language or communication skills for the role', Language == 'English' ? 'Candidate does not have the appropriate language or communication skills for the role' : 'Le candidat n’a pas le langage ou les capacités de communication appropriée pour le poste'));
        options.add(new SelectOption('Candidate does not have the appropriate skills and experience for the role', Language == 'English' ? 'Candidate does not have the appropriate skills and experience for the role' : 'Le candidat n’a pas les compétences et l’expérience appropriées pour le poste'));
        options.add(new SelectOption('Candidate is unwilling or unavailable to work required shifts', Language == 'English' ? 'Candidate is unwilling or unavailable to work required shifts' : 'Le candidat ne veut ou ne peut pas travailler les quarts de travails requis'));
        options.add(new SelectOption('Candidate’s wage expectation is too high', Language == 'English' ? 'Candidate’s wage expectation is too high' : 'Les attentes salariales du candidat sont trop élevées'));
        options.add(new SelectOption('Candidate is unwilling or unable to commute to place of work', Language == 'English' ? 'Candidate is unwilling or unable to commute to place of work' : 'Le candidat ne veut/peu se déplacer au lieu de travail'));
            
        //NOT valid for replacement candidate
        //Feb 6, 2018 ... remove 
        //options.add(new SelectOption('Candidate is not suitable for another reason – please specify', Language == 'English' ? 'Candidate is not suitable for another reason – please specify'));
        options.add(new SelectOption('Candidate declined offer', Language == 'English' ? 'Candidate declined offer' : 'Le candidat a refusé l’offre'));
        options.add(new SelectOption('Candidate failed background/reference check', Language == 'English' ? 'Candidate failed background/reference check' : 'Le candidat a complété la vérification des antécédents/références'));
        options.add(new SelectOption('Other Mindfield candidate was hired', Language == 'English' ? 'Other Mindfield candidate was hired' : 'Un autre candidat de Mindfield a été embauché'));
        options.add(new SelectOption('An internal hire made', Language == 'English' ? 'An internal hire made' : 'Une embauche interne a été faite'));
        options.add(new SelectOption('The position is no longer required', Language == 'English' ? 'The position is no longer required' : 'Le poste n’est plus nécessaire'));
            
        return options;
    }
    
    //if got replacement candidate either immediately, pre interview, or through audit, post interview
    /*public static boolean WasCandidateReplaced(CandidateUpdate.CandidateWrapper c) {
        return (
          IsValidPreInterviewScheduledRejectionReason(c) || 
          (
           IsValidPostInterviewScheduledRejectionReason(c) && 
           ( 
            c.can.Candidate_Audit_Result__c=='Replacement Candidate Due to QCP Omissions' ||
            c.can.Candidate_Audit_Result__c=='Adjudication Timed-out'
           )  
          )  
        );  
    }*/
    public static boolean IsValidRejectionReason(CandidateUpdate.CandidateWrapper c) {
        return (IsValidPostInterviewScheduledRejectionReason(c) || IsValidPreInterviewScheduledRejectionReason(c));
    }
    public static boolean IsValidPostInterviewScheduledRejectionReason(CandidateUpdate.CandidateWrapper c) {
        return (
         (
           c.can.Rejection_Reason_for__c == 'Candidate does not have the appropriate language or communication skills for the role' ||
           c.can.Rejection_Reason_for__c == 'Candidate does not have the appropriate skills and experience for the role' ||
           c.can.Rejection_Reason_for__c == 'Candidate is unwilling or unavailable to work required shifts' ||
           c.can.Rejection_Reason_for__c == 'Candidate’s wage expectation is too high' ||
           c.can.Rejection_Reason_for__c == 'Candidate is unwilling or unable to commute to place of work'
          ) &&  c.can.Is_NOW_Within_Time_to_Disposition_Period__c); 
    }
    public static boolean IsValidPreInterviewScheduledRejectionReason(CandidateUpdate.CandidateWrapper c) {
         return (
          ( 
            c.can.Rejection_Reason_for__c == 'Candidate did not show for interview' ||
            c.can.Rejection_Reason_for__c == 'Candidate withdrew prior to interview – unknown or undisclosed reason' ||
            c.can.Rejection_Reason_for__c == 'Candidate withdrew prior to interview – accepted other employment' ||
            c.can.Rejection_Reason_for__c == 'Candidate withdrew prior to interview – circumstances changed' ||
            c.can.Rejection_Reason_for__c == 'Candidate withdrew prior to interview – reconsidered the opportunity'
          ) &&  c.can.Is_NOW_Within_Time_to_Disposition_Period__c && c.can.Using_Interview_Scheduling__c);
    }
    
    //if we have rejection datetime stores then use its formula, else use current time formula
    /*private static boolean IsValidDispositionTime(CandidateUpdate.CandidateWrapper c) {
        if(c.can.Datetime_Candidate_Rejected__c != null) {
            return c.can.Cls_Dt_Wthn_Time_to_Disposition_Period__c;
        }
        else {
            return c.can.Is_NOW_Within_Time_to_Disposition_Period__c;
        }
    }*/
    
    //validate the required fields for candidates on apex page, CandidateUpdate
    /* Feb 6, 2018 .. . pull this out becasue we will no longer ask for other rejection reason
    public static boolean ValidateNSMCandidateRequiredFields(CandidateUpdate.CandidateWrapper c, integer numHired) {
        
        boolean recordError = false;
      
        //Check that have rejection reason--------------------------------------------------------------------
        if (c.selectedStatus == 'Rejected') 
        {
            //have to have reject comments for below rejection reason
            if((c.can.Rejection_Comments__c == null || c.can.Rejection_Comments__c == '') && 
                c.can.Rejection_Reason_for__c == 'Candidate is not suitable for another reason – please specify' ) 
            {
                c.can.Rejection_Comments__c.addError(Label.Error_Value_is_required);
                recordError = true;
            }
            
            // With new rule, 'Up to 2 Candidates', we dont need this anymore        
            //if given choice for another candidate, they have to make selection
            //if(numHired >= 1 &&
            //    (
            //       (
            //           IsValidPreInterviewScheduledRejectionReason(c)
            //       )
            //       ||
            //       (                                                           
            //           IsValidPostInterviewScheduledRejectionReason(c)
            //       ) 
            //     )
            //     && 
            //     (c.can.Do_you_want_a_replacement_candidate__c == null || c.can.Do_you_want_a_replacement_candidate__c == '')
            //  )
            //{
            //    c.can.Do_you_want_a_replacement_candidate__c.addError(Label.Error_Value_is_required);
            //    recordError = true;
            //}
          }
          return recordError; 
    }*/
    //END Methods for NSM, rejection reasons -----------------------------------------------------------------------------------------------------------------------------------------
    
    //Feb 1, 2018 --- add so can see if any errors are occuring
    public static void SendErrorEmail(Exception e) {
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'jeff.perron@mindfieldgroup.com', 'mfgsysadmin@mindfieldgroup.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('jeff.perron@mindfieldgroup.com');
        mail.setSenderDisplayName('Mindfield Group: Apex error message');
        mail.setSubject('Salesforce.com Error from ' + UserInfo.getOrganizationName());
        mail.setPlainTextBody(e.getStackTraceString() + ': ' + e + '\n\nUser: ' + userinfo.getUserName());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    
    }
}