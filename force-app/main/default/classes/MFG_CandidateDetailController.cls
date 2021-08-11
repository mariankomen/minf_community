public without sharing class MFG_CandidateDetailController {
    @AuraEnabled
    public static sObject getjobDet(String sid){
        List<SFDC_Job_Candidate__c>  Job_Candidate=new List<SFDC_Job_Candidate__c>([SELECT id,
                                                                                    SFDC_Job__c,
                                                                                    SFDC_Job__r.New_Job_Title__c,
                                                                                    SFDC_Job__r.RecordType.DeveloperName,
                                                                                    toLabel(SFDC_Job__r.Job_Title_for_Banner__c),
                                                                                    toLabel(SFDC_Job__r.Job_Title_for_Role__c),
                                                                                    SFDC_Job__r.Name,
                                                                                    Name,
                                                                                    RecordTypeId,
                                                                                    Status__c,
                                                                                    Candidate_Complete_Name__c,
                                                                                    Scheduled_Interview_Date_Time__c,
                                                                                    Candidate_Rating__c,
                                                                                    Phone_Number__c,
                                                                                    Candidate_Email__c,
                                                                                    Candidate_Address__c,
                                                                                    Candidate_City__c,
                                                                                    Candidate_Country__c,
                                                                                    Candidate_Postal_Zip_Code__c,
                                                                                    Candidate_Province_State__c,
                                                                                    Recruiter_Summary_on_Candidate__c,
                                                                                    View_Candidate_Phone_Screen__c,
                                                                                    Rejection_Reason_for__c,
                                                                                    Rejection_Comments__c,
                                                                                    View_Candidate_Resume__c,
                                                                                    Secondary_Phone_Number__c
                                                                                    
                                                                                    FROM SFDC_Job_Candidate__c
                                                                                   WHERE id=:sid]);
        return Job_Candidate.get(0);
        
        
    }
    
    
    
    @AuraEnabled
    public static void updateCandidateStatusRating(String status, String rating, String rejectionReason, String rejectionComments, String cId){
        try{
            SFDC_Job_Candidate__c jobCandidate=new SFDC_Job_Candidate__c();
            
            jobCandidate.Status__c=status;
            jobCandidate.Candidate_Rating__c=rating;
            jobCandidate.Rejection_Reason_for__c=rejectionReason;
            jobCandidate.Rejection_Comments__c=rejectionComments;
            jobCandidate.Id=cId;
            update jobCandidate;   
        }Catch(Exception e){
            system.debug('e'+e.getStackTraceString());
             system.debug('e'+e.getMessage());
             throw new AuraHandledException(e.getMessage());
        }
        
        
    }   
    
    
    @AuraEnabled
    public static FieldOptions getStatusRatingOptions(String recordTypeId){
        if(recordTypeId!=null && !String.isEmpty(recordTypeId)){
            return new FieldOptions(recordTypeId); 
        }else{
            return new FieldOptions(Schema.SObjectType.SFDC_Job_Candidate__c.getRecordTypeInfosByDeveloperName().get('Recruitment').getRecordTypeId());
        }
        
    }
    public class FieldOptions{
        @AuraEnabled public List<MFG_SelectController.PicklistValue> statusOptions;
        @AuraEnabled public List<MFG_SelectController.PicklistValue> ratingOptions;
        @AuraEnabled public List<PicklistValue> rejectionReasons;
        
        public FieldOptions(String recordTypeId){
            this.statusOptions =  MFG_SelectController.getPicklistValueBasedonRecordType('SFDC_Job_Candidate__c', 'Status__c', recordTypeId); 
            this.ratingOptions =  MFG_SelectController.getPicklistValueBasedonRecordType('SFDC_Job_Candidate__c', 'Candidate_Rating__c', recordTypeId); 
            this.rejectionReasons = getPicklistValues('SFDC_Job_Candidate__c', 'Rejection_Reason_for__c'); 
        }
        
    }
    public class PicklistValue{
        @AuraEnabled   public String value;
        @AuraEnabled   public String label;
        @AuraEnabled   public String label_fr;
        public PicklistValue(String value, String label, String label_fr){
            this.value=value;
            this.label=label;
            this.label_fr=label_fr;
        }
    }
    public static list<PicklistValue> getPicklistValues(String ObjectApi_name, String fld){
        list<PicklistValue> options = new list<PicklistValue>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType objType = Object_name.getSObjectType();
        
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values){ 
            if(REASONS_FOR_REJECTING.contains(a.getValue())){
                  options.add(new PicklistValue(a.getValue(),a.getLabel(),a.getLabel())); 
            }
          
        }
        return options;
    }
    public static final Set<String>  REASONS_FOR_REJECTING =new Set<String>{
        'Other candidate more qualified',
            'Candidate did not attend interview',
            'Candidate did not present well',
            'Lacked experience requirements',
            'Lacked communication skills',
            'Not the right fit',
            'Lacked shift availability'
            };
    
    
    
}