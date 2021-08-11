/**
* Class TaskHandler
*
* Trigger Handler for the Task sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public class TaskHandler implements TriggerInterface {
    
    Map<Id,Id> jobAppsApplicantMap;
    
    // Constructor
    public TaskHandler(){
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
            for(Task tsk: (List<Task>) trigger.new){
                System.debug('tsk @>'+tsk);
                if(NULL != tsk.WhatId && tsk.WhatId.getSObjectType() == Applicant_Job_Apps__c.sObjectType){
                    applicantJobAppsIds.add(tsk.WhatId);
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
    public List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
    public void afterInsert(SObject so) {
        Task tsk = (Task)so;
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
        if(tsk.Type <> 'Outbound Email' && tsk.Type <> 'Inbound Email'){
            if(jobAppsApplicantMap.containsKey(tsk.WhatId)){
                TriggerFactory.isTriggerExecuted = true; 
                //TalemetryCandidateAsync.asyncUpsertCandidate(jobAppsApplicantMap.get(tsk.WhatId)); 
                tl = TalemetryParseResponseUtil.getLogging('Trigger TaskHandler', 'task trigger', null);
                tl.Status__c = 'Pending';
                tl.Applicant_Id__c = tsk.WhatId;
                tl.Source_Id__c = tsk.Id;
                loggerList.add(tl);
            } else if(NULL != tsk.WhatId && tsk.WhatId.getSObjectType() == Applicant__c.sObjectType){
                TriggerFactory.isTriggerExecuted = true; 
                //TalemetryCandidateAsync.asyncUpsertCandidate(tsk.WhatId);  
                 tl = TalemetryParseResponseUtil.getLogging('Trigger TaskHandler', 'task trigger', null);
                tl.Status__c = 'Pending';
                tl.Applicant_Id__c = tsk.WhatId;
                tl.Source_Id__c = tsk.Id;
                loggerList.add(tl);
            }
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