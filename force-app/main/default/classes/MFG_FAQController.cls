public without sharing class  MFG_FAQController {
    @AuraEnabled
    public static List<sObject> getFAQ(){
        return new MFG_FAQSelector().selectAllDisplayed();
    }

    @AuraEnabled
    public static List<sObject> getSupport(Boolean open){
        return selectSObject('Case',new Set<Id>{UserInfo.getUserId()},open);
        
    }
        @AuraEnabled
    public static List<sObject> getPublicCaseComments(Id caseId){
        
        return [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate FROM CaseComment WHERE IsPublished=true AND ParentId=:caseId  ORDER BY CreatedDate DESC];
        
    }
    
    
    public static List<sObject> selectSObject(String sobjectName,Set<id> objId,Boolean open) { 
        Boolean isClosed=open!=null?!open:false;
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap(); 
        Set<String> fieldNames=new Set<String>(); 
        for(Schema.SObjectField fld :objectFields.values()){
            if(fld.getDescribe().isAccessible()){ 
                fieldNames.add(fld.getDescribe().getName()); 
            } 
        }
        List<String> iterableFields = new List<String>(fieldNames); 
        system.debug('open '+open);
        system.debug('isClosed '+isClosed);
        return Database.query(String.format('SELECT {0} FROM {1} WHERE IsClosed=:isClosed AND CreatedById IN :objId ORDER BY CreatedDate DESC' , new String[] {String.join(iterableFields, ','), sobjectName}));
       
    }
}