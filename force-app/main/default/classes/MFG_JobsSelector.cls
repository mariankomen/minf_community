public class MFG_JobsSelector extends fflib_SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            SFDC_Job__c.id,
                SFDC_Job__c.Name,
                SFDC_Job__c.New_Job_Title__c,
                SFDC_Job__c.CreatedDate,
                SFDC_Job__c.FT_or_PT__c,
                SFDC_Job__c.Job_City__c,
                SFDC_Job__c.Days_Job_Open__c,
                SFDC_Job__c.Hours_of_Availability__c,
                SFDC_Job__c.Hours_of_Availability_Comments__c,
                SFDC_Job__c.of_Candidates_Awaiting_Feedback__c,
                SFDC_Job__c.of_Candidates_In_Job__c,
                SFDC_Job__c.Maximum_Hours__c,
                SFDC_Job__c.Minimum_Hours__c,
                SFDC_Job__c.Banner_of_Store__c,
                SFDC_Job__c.Specific_Candidate_Name__c,
                SFDC_Job__c.Specific_Candidate_Email__c,
                SFDC_Job__c.Specific_Candidate_Name__c,
                SFDC_Job__c.Specific_Candidate_Phone_Number__c,
                SFDC_Job__c.External_Alert_Email_Address__c,
                SFDC_Job__c.Role_Classification__c,
                SFDC_Job__c.Store__r.Name,
                SFDC_Job__c.Job_Comments__c,
                SFDC_JOB__c.Department__c,
                SFDC_JOB__c.Record_Type_Developer_Name__c            
                
                };
    }
    

    public Schema.SObjectType getSObjectType(){
        return SFDC_Job__c.sObjectType;
    }
    public List<SFDC_Job__c> selectById(Set<ID> idSet){
        return (List<SFDC_Job__c>) selectSObjectsById(idSet);
    }
    
    public List<SFDC_Job__c> selectForCurrentUser(String condition){
        assertIsAccessible();
        
        // Include all the fields here (,) separated which must be queried regardless of user accessibility
        String includeFieldsToSOQL = ',RecordType.DeveloperName,toLabel(Job_Status__c),toLabel(Job_Title_for_Role__c),' +
                                     'toLabel(Job_Title_for_Banner__c),toLabel(Full_Time_Part_Time__c),toLabel(Availability_Required__c)';
        
        String query = String.format('select {0} {1} FROM {2} {3} ', 
                                     new List<String>{
                                            getFieldListString(),
                                            includeFieldsToSOQL,
                                            getSObjectName(),
                                            condition
                                          });
        
        System.debug(query);
        
        return (List<SFDC_Job__c>) Database.query(query);
    }

}