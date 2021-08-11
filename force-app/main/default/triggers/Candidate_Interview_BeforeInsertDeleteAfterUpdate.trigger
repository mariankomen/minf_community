trigger Candidate_Interview_BeforeInsertDeleteAfterUpdate on Candidate_Interview__c (before insert, before delete, after update) {

    List<SFDC_Job_Candidate__c> jcList = new List<SFDC_Job_Candidate__c>(); 

    //before insert ----------------------------------------------------------------------------------------
    if(trigger.isInsert && trigger.isBefore) {
         for (Candidate_Interview__c ci : trigger.new) {
             //try to find matching job candidate, if found then associate
             Id jcId = Interview_Scheduler_Util.FindJobCandidateByEmailAndJobIdAndReturnId(ci.name, ci.Job__c);
             if(jcId != null) {
                 ci.Job_Candidate__c = jcId; // associcate
                 jcList.add(new SFDC_Job_Candidate__c(id=ci.Job_Candidate__c, Scheduled_Interview_Date_Time__c=ci.start_date__c)); //update  interview
             }
         }
    }
    //END before insert ----------------------------------------------------------------------------------------

    //before delete ----------------------------------------------------------------------------------------
    if(trigger.isDelete && trigger.isBefore) {
        for (Candidate_Interview__c ci : trigger.old) {
            //cant delete record if associated with a job candidate
            if(ci.Job_Candidate__c != null) {
                ci.adderror('You cannot delete a candidate interview associcated with a job candidate.');
            }
        }
    }
    //END before delete ----------------------------------------------------------------------------------------
    
    //after update ----------------------------------------------------------------------------------------
    if(trigger.isUpdate && trigger.isAfter) {
        for (Candidate_Interview__c ci : trigger.new) {
            //if has associated job candidate and start date has changed, update job candidate interview date
            if(ci.Job_Candidate__c != null && ci.start_date__c != trigger.oldMap.get(ci.id).start_date__c) {
                jcList.add(new SFDC_Job_Candidate__c(id=ci.Job_Candidate__c, Scheduled_Interview_Date_Time__c=ci.start_date__c));
            }
        }
    }
    //END after Update ----------------------------------------------------------------------------------------

    if(jcList.size() > 0) {
        update jcList;
    }
}