/**
* Class ContentVersionHandler
*
* Trigger Handler for the ContentVersion sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public class ContentVersionHandler implements TriggerInterface {
	
    Map<Id,Id> jobAppsApplicantMap;
    Map<Id,Id> documentLinkMap;
    public List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
    // Constructor
    public ContentVersionHandler(){
        jobAppsApplicantMap = new Map<Id,Id>();
        documentLinkMap = new Map<Id,Id>();
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
            
            Set<Id> contentDocumentIds = new Set<Id>();
            for(ContentVersion cv: (List<ContentVersion>) trigger.new){
                contentDocumentIds.add(cv.ContentDocumentId);
            }
            
            if(!contentDocumentIds.isEmpty()){
                
                for(ContentDocumentLink cdl:[SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN:contentDocumentIds]){
                    System.debug('cdl @>'+cdl);
                    if(cdl.LinkedEntityId.getSObjectType() == Applicant_Job_Apps__c.sObjectType ||
                      cdl.LinkedEntityId.getSObjectType() == Applicant__c.sObjectType){
                        documentLinkMap.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
                    }
                }
                
                if(!documentLinkMap.isEmpty()){
                    for(Applicant_Job_Apps__c aja:[SELECT Id, Applicant__c FROM Applicant_Job_Apps__c WHERE Id IN:documentLinkMap.values()]){
                        jobAppsApplicantMap.put(aja.Id,aja.Applicant__c);
                    }
                }
            }
        }
        System.debug('jobAppsApplicantMap @>'+jobAppsApplicantMap);
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
        ContentVersion cv = (ContentVersion)so;
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
        System.debug('cv.ContentDocumentId @>'+cv.ContentDocumentId);
        System.debug('documentLinkMap @>'+documentLinkMap);
        if(documentLinkMap.containsKey(cv.ContentDocumentId)){
            Id parentId = documentLinkMap.get(cv.ContentDocumentId);
            if(parentId.getSObjectType() == Applicant__c.sObjectType){
                //String candidatePaylod = TalemetryParseResponseUtil.upsertCandidatePayload(parentId);
        		//TalemetryCandidateAsync.upsertCandidate(candidatePaylod,parentId);
                tl = TalemetryParseResponseUtil.getLogging('Trigger ContentVersionHandler', 'task trigger', null);
                tl.Status__c = 'Pending';
                tl.Applicant_Id__c = parentId;
                tl.Source_Id__c = cv.ContentDocumentId;
                loggerList.add(tl);
            	TriggerFactory.isTriggerExecuted = true;
            } 
            else if(parentId.getSObjectType() == Applicant_Job_Apps__c.sObjectType){
                //String candidatePaylod = TalemetryParseResponseUtil.upsertCandidatePayload(jobAppsApplicantMap.get(parentId));
        		//TalemetryCandidateAsync.upsertCandidate(candidatePaylod,jobAppsApplicantMap.get(parentId));
                tl = TalemetryParseResponseUtil.getLogging('Trigger ContentVersionHandler', 'task trigger', null);
                tl.Status__c = 'Pending';
                tl.Applicant_Id__c = jobAppsApplicantMap.get(parentId);
                tl.Source_Id__c = cv.ContentDocumentId;
                loggerList.add(tl);
            	TriggerFactory.isTriggerExecuted = true;
            }
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        
        
        System.debug('afterUpdate');
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
        if(!loggerList.isEmpty()){
            insert loggerList;
        }
    }
}