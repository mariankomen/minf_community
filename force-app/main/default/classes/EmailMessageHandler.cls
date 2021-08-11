/**
* Class EmailMessageHandler
*
* Trigger Handler for the EmailMessage sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public class EmailMessageHandler implements TriggerInterface {
	
    Map<Id,Id> jobAppsApplicantMap;
    public List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
    // Constructor
    public EmailMessageHandler(){
        jobAppsApplicantMap = new Map<Id,Id>();
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){ }
    
    public void bulkAfter() {
        
        if(Trigger.isInsert){
            Set<Id> applicantJobAppsIds = new Set<Id>();
            for(EmailMessage em: (List<EmailMessage>) trigger.new){
                if(em.RelatedToId<>null && em.RelatedToId.getSObjectType() == Applicant_Job_Apps__c.sObjectType){
                    applicantJobAppsIds.add(em.RelatedToId);
                }
            }
            
            if(!applicantJobAppsIds.isEmpty()){
                for(Applicant_Job_Apps__c aja:[SELECT Id, Applicant__c FROM Applicant_Job_Apps__c WHERE Id IN:applicantJobAppsIds]){
                    jobAppsApplicantMap.put(aja.Id,aja.Applicant__c);
                }
            }
        }
    }
    
    public void beforeInsert(SObject so){ }
    
    public void beforeUpdate(SObject oldSo, SObject so){ }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){ }
    
    public void afterInsert(SObject so) {
        EmailMessage em = (EmailMessage)so;
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
        if(jobAppsApplicantMap.containsKey(em.RelatedToId)){
            TriggerFactory.isTriggerExecuted = true;
            //String candidatePaylod = TalemetryParseResponseUtil.upsertCandidatePayload(jobAppsApplicantMap.get(em.RelatedToId));
        	//TalemetryCandidateAsync.upsertCandidate(candidatePaylod,jobAppsApplicantMap.get(em.RelatedToId));
            tl = TalemetryParseResponseUtil.getLogging('Trigger EmailMessageHandler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Applicant_Id__c = jobAppsApplicantMap.get(em.RelatedToId);
            tl.Source_Id__c = em.Id;
            loggerList.add(tl);
            
        } else if(em.RelatedToId<>null && em.RelatedToId.getSObjectType() == Applicant__c.sObjectType){
            TriggerFactory.isTriggerExecuted = true;
            //String candidatePaylod = TalemetryParseResponseUtil.upsertCandidatePayload(em.RelatedToId);
        	//TalemetryCandidateAsync.upsertCandidate(candidatePaylod,em.RelatedToId);
            tl = TalemetryParseResponseUtil.getLogging('Trigger EmailMessageHandler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Applicant_Id__c = em.RelatedToId;
             tl.Source_Id__c = em.Id;
            loggerList.add(tl);
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){ }
    
    public void afterDelete(SObject so){ }
    
    public void afterUndelete(SObject so){ }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){ 
        if(!loggerList.isEmpty()){
            insert loggerList;
        }
    }
}