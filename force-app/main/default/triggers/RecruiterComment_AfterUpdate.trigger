/*******************
Trigger: Recruiter Comment After Update
Description: when main values of a recruiter comment record changes, cycle through any linked jobs to update Job field: date last recruiter comment posted.
        Test coverage in RecruiterCommentNew class

Created: Vankerk Solutions, July 28/12
Modification Log:

*******************/
trigger RecruiterComment_AfterUpdate on Recruiter_Comment__c (after update) {
    // Jobs to update
    Map<Id, SFDC_Job__c> jobUpdate = new Map<Id, SFDC_Job__c>();
    Set<Id> CommentIds = new Set<Id>();
    
    // cycle through comments to see if certain fields have changed
    for (Recruiter_Comment__c r : trigger.new) {
        Recruiter_Comment__c old = trigger.oldmap.get(r.id);
        if (r.shortlisted_candidates__c != old.shortlisted_candidates__c ||
                r.calls__c != old.calls__c ||
                r.voicemails__c != old.voicemails__c ||
                r.number_of_candidates_rejected__c != old.number_of_candidates_rejected__c ||
                r.most_common_rejection_reasons__c != old.most_common_rejection_reasons__c ||
                r.additional_comments__c != old.additional_comments__c )
           commentIds.add(r.id);
    } // end loop through comments
    
    // if we have comments that changed, find jobs that need updating
    if (commentIds.size() > 0) {
        // get all job ids from applicable job comments
        for (Job_Recruiter_Comment__c jr : [select id, job__c from Job_Recruiter_comment__c where recruiter_comment__c in :CommentIds]) 
            // add the related job with todays date for the comment posted date value
            jobUpdate.put(jr.job__c, new SFDC_Job__c(id = jr.job__c, Date_Last_Recruiter_Comment_Posted__c = date.today()));
        // if we have jobs to update, do so now
        if (jobUPdate.size() > 0)
            update jobUpdate.values();        
    } // end if comments changed
}