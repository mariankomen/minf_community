/*******************
Trigger: Job Recruiter Comment After Insert
Description: when main values of a recruiter comment record changes, cycle through any linked jobs to update Job field: date last recruiter comment posted.
        Test coverage in RecruiterCommentNew class
        
Created: Vankerk Solutions, July 28/12
Modification Log:

*******************/
trigger JobRecruiterComment_AfterInsert on Job_Recruiter_Comment__c (after insert) {
    // Jobs to update
    Map<Id, SFDC_Job__c> jobUpdate = new Map<Id, SFDC_Job__c>();
    
    // cycle through job comments to update related Job's date field
    for (Job_Recruiter_Comment__c r : trigger.new)
        // add the related job with todays date for the comment posted date value
        jobUpdate.put(r.job__c, new SFDC_Job__c(id = r.job__c, Date_Last_Recruiter_Comment_Posted__c = date.today()));  
    // if we have jobs to update, do so now
    if (jobUpdate.size() > 0)
        update jobUpdate.values(); 
}