/******************
Trigger: Case After Insert
Description:  creates a Case Job Link for any new case that is linked to a specific Job

Created: Niki Vankerk, Sept 9/12
Modification Log:
    Aug 7/13: added logic to take job Id numbers in Case is Related to Job Recruiter and link to Jobs if ID is found
    Sept 9/13: used set instead of list on case to jobs to remove dup job ids
    
******************/
trigger Case_AfterInsert on Case (after insert) {
    // list of Case Job link records to create
    List<Case_Job_Link__c> cjlinks = new List<Case_Job_Link__c>();
    // map of cases with job id set to link to jobs
    Map<Id, set<string>> CaseToJobs = new Map<Id, set<string>>();
        
    // cycle through new cases to see if there is a value in Case is for Specific Job
    for (Case c : trigger.new) {
        if (c.Case_Is_Related_to_Specific_Job__c != null && c.Case_is_Related_to_Job_from_Recruiters__c == null )
            cjlinks.add(new Case_Job_Link__c(job__c = c.Case_Is_Related_to_Specific_Job__c, case__c = c.id));
            
        // check for values in recruiter job list field
        if (c.Case_is_Related_to_Job_from_Recruiters__c != null) {
            Set<string> jobIds = new Set<string>();
            jobIds.addall(c.Case_is_Related_to_Job_from_Recruiters__c.split(','));
            CaseToJobs.put(c.id, jobIds);
        } // end if recruiter field has values
        
    }
    
    // if we have CaseToJob entries, continue with processing links to jobs
    if (CaseToJobs.size() > 0) {
        // go through any cases with list of job numbers and create single list of job numbers to look up in job object
        Set<string> JobNumSet = new Set<String>();
        for (set<string> numbers : CaseToJobs.values()) {
            for (string num : numbers)
                JobNumSet.add(num.trim());
        }
    
        // need a map of Job number to Job
        Map<string, SFDC_Job__c> JobMatchMap = new Map<string, SFDC_Job__c>();
        for (SFDC_Job__c j : [select id, name from SFDC_Job__c where name in :JobNumSet order by name]) JobMatchMap.put(j.name, j);
        // cycle through cases with job list and add links for any that match
        for (Id cId : CaseToJobs.keyset()) {
            // cycle through set of job numbers and if we have any in the JobMatchMap, add a link record to the list
            for (string num : CaseToJobs.get(cId)) {
                // did we find a match?
                if (JobMatchMap.containskey(num.trim()))
                    cjlinks.add(new Case_Job_Link__c(job__c = JobMatchMap.get(num.trim()).id, case__c = cid));
            } // end loop through job ids on a case
        } // end loop through cases with job ids
    } // end if we have CaseToJobs entries
    
    // if we have links to create, do so now
    if (cjlinks.size() > 0)
        insert cjlinks;
}