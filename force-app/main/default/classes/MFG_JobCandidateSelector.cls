public class MFG_JobCandidateSelector extends fflib_SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            SFDC_Job_Candidate__c.id,
                SFDC_Job_Candidate__c.Name,
                SFDC_Job_Candidate__c.Status__c, 
                SFDC_Job_Candidate__c.Candidate_Complete_Name__c ,
                SFDC_Job_Candidate__c.Phone_Number__c,
                SFDC_Job_Candidate__c.Job_ID__c,
                SFDC_Job_Candidate__c.Job_Title__c,
                SFDC_Job_Candidate__c.Location__c,
                SFDC_Job_Candidate__c.Scheduled_Interview_Date_Time__c,
                SFDC_Job_Candidate__c.Candidate_Rating__c,
                SFDC_Job_Candidate__c.Job_Department__c
                };
    }
    

    public Schema.SObjectType getSObjectType(){
        return SFDC_Job_Candidate__c.sObjectType;
    }
    public List<SFDC_Job_Candidate__c> selectById(Set<ID> idSet){
        return (List<SFDC_Job_Candidate__c>) selectSObjectsById(idSet);
    }
    
    public List<SFDC_Job_Candidate__c> selectByStatus(String condition){
        assertIsAccessible();
        
        // Include all the fields here (,) separated which must be queried regardless of user accessibility
		String includeFieldsToSOQL = ',SFDC_Job__r.RecordType.DeveloperName,toLabel(SFDC_Job__r.Job_Title_for_Banner__c),toLabel(SFDC_Job__r.Job_Title_for_Role__c)';
        
        String query = String.format('select {0} {1} FROM {2} {3} ', 
                                     new List<String>{
                                         	getFieldListString(),
                                            includeFieldsToSOQL,
                                            getSObjectName(),
                                            condition
                                          });
        
        system.debug(query);
        return (List<SFDC_Job_Candidate__c>) Database.query(query);
    }

}