public  class MFG_SelectController {
    @AuraEnabled
    public static list<SelectOpt> getPicklistOptions(String objectApiName, String fieldApiName){
        return getPicklistValues(objectApiName, fieldApiName);
    }
    
    public static list<SelectOpt> getPicklistValues(String ObjectApi_name, String fld){
        list<SelectOpt> options = new list<SelectOpt>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType objType = Object_name.getSObjectType();
        
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values){ 
            options.add(new SelectOpt(a.getLabel(), a.getValue())); 
        }
        return options;
    }
    public class SelectOpt{
        @AuraEnabled  public String label;
        @AuraEnabled   public String value;
        public SelectOpt(String label,String value){
            this.label=label;
            this.value=value;
        }
    }
    
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content ='';
        if(!Test.isRunningTest()) {
            content = visualforcePage.getContent().toString();
        }else{
            content='Start_Of_Session_IdSession_IDEnd_Of_Session_Id';
        }
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
    
 
    
    
    
    @AuraEnabled                                                         
    public static list<PicklistValue> getPicklistValueBasedonRecordType(String objectApiName, String fieldApiName, String recordTypeId){
        
        list<PicklistValue> picklistValues = new list<PicklistValue>();
        if(recordTypeId != null){
            
            String method = 'GET';
            String endpoint = String.format('/services/data/v43.0/ui-api/object-info/{0}/picklist-values/{1}/{2}', new String[]{ objectApiName, recordTypeId, fieldApiName });
            
            HttpRequest request = new HttpRequest();
         
            request.setEndpoint('callout:MFG_UI_API'+endPoint);
            request.setMethod(method);
            
            HTTPResponse response = (new Http()).send(request);
            
            if(response.getStatusCode() == 200){
                system.debug(response.getBody());
                Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                if(root.containsKey('values')){ 
                    List<Object> picklistVals = (List<Object>)root.get('values');
                    
                    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectApiName);
                    Sobject Object_name = targetType.newSObject();
                    Schema.sObjectType objType = Object_name.getSObjectType();
                    
                    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
                    map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
                    list<Schema.PicklistEntry> values = fieldMap.get(fieldApiName).getDescribe().getPickListValues(); 
                    Map<String, String> PicklistEntryMAp=new Map<String, String>();
                    for (Schema.PicklistEntry a : values){ 
                        PicklistEntryMAp.put(a.getValue(), a.getLabel());
                    }
                    
                    
                    
                    
                    
                    for(Object picklistVal : picklistVals){
                        Map<String,Object> picklistValMap = (Map<String,Object>) picklistVal;
                        picklistValue pickVal = new picklistValue();
                        pickVal.value = (String) picklistValMap.get('value');
                        pickVal.label = (String) picklistValMap.get('label');
                        if(PicklistEntryMAp.containsKey(pickVal.value)){
                             pickVal.label_fr=PicklistEntryMAp.get(pickVal.value);
                        }
                        picklistValues.add(pickVal);
                    }
                }
                
            }
            
        }
        
        return picklistValues;
    }
    
    public class PicklistValue{
        @AuraEnabled   public String value {get;set;}
        @AuraEnabled   public String label {get;set;}
        @AuraEnabled   public String label_fr {get;set;}
    }
}