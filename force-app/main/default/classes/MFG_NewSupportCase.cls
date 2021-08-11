public class MFG_NewSupportCase {
    @AuraEnabled
    public static List<FieldSetMember> initCaseForm(){
        return readFieldSet('SupportCase','Case');

    }
    @AuraEnabled
    public static List<FieldSetMember> initCaseViewForm(){
        return readFieldSet('SupportCaseView','Case');

    } 
    public static List<FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        List<FieldSetMember> fields=new List<FieldSetMember>();
        for(Schema.FieldSetMember field: fieldSetObj.getFields()){
            fields.add(new  FieldSetMember(field.getDbRequired(), field.getRequired(),field.getFieldPath()));
        }
        return fields;
    }  
    
    public class FieldSetMember{
     @AuraEnabled public String fieldPath;
     @AuraEnabled public Boolean required;
        public FieldSetMember(Boolean dbrequired, Boolean fsrequired, String fieldPath){
            this.fieldPath=fieldPath;
            if(dbrequired){
                this.required=true;
            }else{
                if(fsrequired) {
                     this.required=true;
                }else{
                      this.required=false;
                }
            }
            
        }
    }
}