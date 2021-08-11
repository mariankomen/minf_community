/**
* Class SFDCCandidateHandler
*
* Trigger Handler for the SFDC_Candidate__c sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public class SFDCCandidateHandler implements TriggerInterface {
	
    Map<Id, List<SFDC_Job_Candidate__c>> candidateJobCandidateMap;
    Map<Id, SFDC_Job_Candidate__c> updateCandidate;
    
    // Constructor
    public SFDCCandidateHandler(){
        candidateJobCandidateMap = new Map<Id, List<SFDC_Job_Candidate__c>>();
        updateCandidate = new Map<Id, SFDC_Job_Candidate__c>();
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){ }
    
    public void bulkAfter() {
        
        if(Trigger.isUpdate){
            // set of Candidate Ids that have new Recruiter Summary to copy
            Set<Id> canRecRecruiterIds = new Set<Id>();
            // set of Candidate Ids that have Escalated Reference checked
            Set<Id> canRecEscalatedIds = new Set<Id>();    
            //set of Candidate Ids whose Phone_Screen_Content_URL or Resume_Content_URL updated
            Set<Id> resumeCandidateIds = new Set<Id>();
            
            // cycle through updated records to see if the Recruiter Summary changed
            for (SFDC_Candidate__c can :(List<SFDC_Candidate__c>)trigger.new) {
                if (can.Recruiter_Summary_on_Candidate__c != ((SFDC_Candidate__c)trigger.oldmap.get(can.id)).Recruiter_Summary_on_Candidate__c ||
                    can.SFDC_Candidate_Email__c != ((SFDC_Candidate__c)trigger.oldmap.get(can.id)).SFDC_Candidate_Email__c )
                    canRecRecruiterIds.add(can.id);
                
                // if escalated ref check changed, add to set for updates
                if (can.Escalated_Reference_Check__c  != ((SFDC_Candidate__c)trigger.oldmap.get(can.id)).Escalated_Reference_Check__c) 
                    canRecEscalatedIds.add(can.id);
                
                //if Phone_Screen_Content_URL or Resume_Content_URL updated
                if(can.Phone_Screen_Content_URL__c != ((SFDC_Candidate__c)trigger.oldmap.get(can.id)).Phone_Screen_Content_URL__c ||
                  can.Resume_Content_URL__c  != ((SFDC_Candidate__c)trigger.oldmap.get(can.id)).Resume_Content_URL__c ){
                    resumeCandidateIds.add(can.Id);
                }
            }
            
            // if there are summary changes to process, do it now
            if (!canRecRecruiterIds.isEmpty() || !canRecEscalatedIds.isEmpty() || !resumeCandidateIds.isEmpty()) {
                
                List<SFDC_Job_Candidate__c> tempJobCandidateList;
                // cycle through all candidates linked to the modified can record and copy the summary
                for (SFDC_Job_Candidate__c jc : [SELECT Id, Status__c, Recruiter_Summary_on_Candidate__c, candidate_email_address__c, 
                                                 Candidate__c, Candidate__r.Recruiter_Summary_on_Candidate__c, Candidate__r.SFDC_Candidate_Email__c, 
                                                 Escalated_Reference_Check__c, Candidate__r.Escalated_Reference_Check__c FROM SFDC_Job_Candidate__c 
                                                 WHERE Candidate__c IN:canRecRecruiterIds OR Candidate__c IN:canRecEscalatedIds OR 
                                                Candidate__c IN:resumeCandidateIds]) {
                                                     
                                                     tempJobCandidateList = new List<SFDC_Job_Candidate__c>();
                                                     if(candidateJobCandidateMap.containsKey(jc.Candidate__c)){
                                                         tempJobCandidateList = candidateJobCandidateMap.get(jc.Candidate__c);
                                                     }
                                                     tempJobCandidateList.add(jc);
                                                     candidateJobCandidateMap.put(jc.Candidate__c,tempJobCandidateList);
                                                 } 
            }
        }
    }
    
    public void beforeInsert(SObject so){
        SFDC_Candidate__c can = (SFDC_Candidate__c) so;
        can.Name = (can.first_Name__c == null ? '' : can.first_Name__c) + ' ' + (can.Last_Name__c == null ? '' : can.Last_Name__c);
        can.Candidate_Owner_Link__c = can.OwnerId;
        System.debug('can.Name : '+can.Name);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        SFDC_Candidate__c can = (SFDC_Candidate__c) so;
        
        can.Name = (can.first_Name__c == null ? '' : can.first_Name__c) + ' ' + (can.Last_Name__c == null ? '' : can.Last_Name__c);
        can.Candidate_Owner_Link__c = can.OwnerId;
    }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){ }
    
    public void afterInsert(SObject so) { }
    
    public void afterUpdate(SObject oldSo, SObject so){ 
        SFDC_Candidate__c can = (SFDC_Candidate__c) so;
        SFDC_Candidate__c oldCan = (SFDC_Candidate__c) oldSo;
        
        if(candidateJobCandidateMap.containsKey(can.Id)){
            for (SFDC_Job_Candidate__c jc :candidateJobCandidateMap.get(can.Id)){
                
                if (can.Recruiter_Summary_on_Candidate__c != oldCan.Recruiter_Summary_on_Candidate__c ||
                    can.SFDC_Candidate_Email__c != oldCan.SFDC_Candidate_Email__c){
                        
                        jc.Recruiter_Summary_on_Candidate__c = can.Recruiter_Summary_on_Candidate__c;
                        jc.candidate_email_address__c = can.SFDC_Candidate_Email__c;
                        updateCandidate.put(jc.Id, jc);
                    }
                
                if (can.Escalated_Reference_Check__c  != oldCan.Escalated_Reference_Check__c &&
                    jc.Escalated_Reference_Check__c != can.Escalated_Reference_Check__c) {
                        
                        if(jc.Status__c <> 'Hired' && jc.Status__c <> 'Rejected'){
                            jc.Escalated_Reference_Check__c = can.Escalated_Reference_Check__c;
                            updateCandidate.put(jc.Id, jc);
                        }
                    }
                
                if(can.Resume_Content_URL__c != oldCan.Resume_Content_URL__c){
                    jc.View_Candidate_Resume_Updated__c = true;
                    updateCandidate.put(jc.Id, jc);
                }
                
                if(can.Phone_Screen_Content_URL__c != oldCan.Phone_Screen_Content_URL__c){
                    jc.View_Candidate_Phone_Screen_Updated__c = true;
                    updateCandidate.put(jc.Id, jc);
                }
            }
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
        
        if(!updateCandidate.isEmpty()){
            update updateCandidate.values();
        }
    }
}