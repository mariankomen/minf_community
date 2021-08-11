/******************
Trigger: Case Before Insert
Description:  if a new case is linked to a specific Job, query for the job's store and fill in on Case - used for sharing rules

Created: Niki Vankerk, Feb 27/13
Modification Log:
    Aug 7/13: link case field Recruiter/MFG Employee based on employee Id field passed in from web to lead on Submit Case page
    July 10/14: added call to utility for any HelpDesk cases that need the Recruiter field set
    
******************/
trigger Case_BeforeInsert on Case (before insert) {
    
    // map of jobs to find Store field
    Map<Id, SFDC_Job__c> jobMap = new Map<Id, SFDC_Job__c>();
    // map of accounts to find parent account where there is no job linked
    Map<Id, Account> AccMap = new Map<Id, Account>();
    // list of cases that are MFG HelpDesk and need the Recruiter field set
    List<Case> HelpDeskCases = new List<Case>();
    LIST<SFDC_Job__c> recruiterJob = new LIST<SFDC_Job__c>();
    
    // MFG HelpDesk record type id
    Id MFGHelpDeskRecId;
    try {
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
        if (rtMapByName.containskey('MFG Helpdesk'))
            MFGHelpDeskRecId = rtMapByName.get('MFG Helpdesk').getrecordtypeid();
    } catch (Exception e) {}
    
    // cycle through new cases to see if there is a value in Case is for Specific Job or else grab case account
    for (Case c : trigger.new) {
        if(c.Case_is_Related_to_Job_from_Recruiters__c != null && c.Case_Is_Related_to_Specific_Job__c == null){
            
            recruiterJob = [SELECT id FROM SFDC_Job__c WHERE NAME = : c.Case_is_Related_to_Job_from_Recruiters__c];
            if (recruiterJob.size() > 0){
            c.Case_Is_Related_to_Specific_Job__c = recruiterJob.get(0).ID;
            }
            
            }
        if (c.Case_Is_Related_to_Specific_Job__c != null)
            jobMap.put(c.Case_Is_Related_to_Specific_Job__c, new SFDC_Job__c());
        else if (c.accountid != null)
            accMap.put(c.accountid, new account());
        // if case has recruiter user id text value passed from web to case, add to set for lookup
        if (c.Recruiter_MFG_Employee_Id_Text__c != null) {
            // use try catch in case this value is not a valid Id field for some reason
            try {
                c.recruiter_mfg_employee__c = c.Recruiter_MFG_Employee_Id_Text__c;
                // default recruiter mfg email with the web email entered
                c.Recruiter_MFG_Employee_Email__c = c.suppliedemail;
            } catch (Exception e) {} // don't do anything if the id is not valid
        } // end if mfg employee text
        // if this case is MFGHelpDesk record type and has a blank Recruiter/MFG Employee field, add to list for setting
        if (c.recruiter_mfg_employee__c == null && c.recordtypeid == MFGHelpDeskRecId)
            HelpDeskCases.add(c);
        
    }
    // if there are jobs/accounts in map, continue
    if (jobMap.size() > 0 || accMap.size() > 0) {
        // query for job store value
        jobMap = new Map<Id, SFDC_Job__c>([select id, X1st_Level_Manager__r.id, store__c, store__r.parentid from SFDC_Job__c where id in :jobMap.keyset()]);
        // query for accoutn parent account
        accMap = new Map<Id, Account>([select id, parentid, X1st_Level_Manager__r.id from Account where id in :accMap.keyset()]);
        // cycle through cases again and find the job in the map to populate the account field on case
        // and the parent account value
        for (Case c :trigger.new) {
            if (c.Case_Is_Related_to_Specific_Job__c != null && jobMap.containskey(c.Case_Is_Related_to_Specific_Job__c)) 
            {
                c.Case_Is_Related_to_Specific_Account__c = jobMap.get(c.Case_Is_Related_to_Specific_job__c).store__c;
                c.X1st_Level_Manager__c = jobmap.get(c.Case_Is_Related_to_Specific_job__c).X1st_Level_Manager__r.id;
                c.Case_Parent_Account__c = jobMap.get(c.Case_Is_Related_to_Specific_job__c).store__r.parentid;
            } // if job filled in
            else if (c.accountid != null && accMap.containskey(c.accountid) ){
                c.Case_Parent_Account__c = accMap.get(c.accountid).parentid;
               if(accMap.get(c.accountid).X1st_Level_Manager__r.id != null){
               c.X1st_Level_Manager__c = accMap.get(c.accountid).X1st_Level_Manager__r.id;}}
        } // end loop
    }
    // if we have MFG Helpdesk cases to process, call util function
    if (HelpDeskCases.size() > 0)
        Case_util.MFGHelpdeskCaseLinktoRecruiter(HelpDeskCases);

}