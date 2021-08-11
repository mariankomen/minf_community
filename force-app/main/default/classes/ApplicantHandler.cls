/**
* Class ApplicantHandler
*
* Trigger Handler for the Applicant SObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public class ApplicantHandler implements TriggerInterface {
	
    // Constructor
    public ApplicantHandler(){ }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){ }
    
    public void bulkAfter() { }
    
    public void beforeInsert(SObject so){ }
    
    public void beforeUpdate(SObject oldSo, SObject so){ }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){ }
    
    public void afterInsert(SObject so) { }

    public List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
    public void afterUpdate(SObject oldSo, SObject so){
        Applicant__c app = (Applicant__c) so;
        Applicant__c appOld = (Applicant__c) oldSo;
        Talemetry_Logger__c tl = new Talemetry_Logger__c();
        if(!System.isFuture()){
            TriggerFactory.isTriggerExecuted = true;
        	//String candidatePaylod = TalemetryParseResponseUtil.upsertCandidatePayload(app.Id);
            //TalemetryCandidateAsync.upsertCandidate(candidatePaylod,app.Id);
            tl = TalemetryParseResponseUtil.getLogging('Trigger ApplicantHandler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Applicant_Id__c = app.Id;
            tl.Source_Id__c = app.Id;
            loggerList.add(tl);
        }
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