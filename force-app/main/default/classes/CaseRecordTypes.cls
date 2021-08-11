global  class CaseRecordTypes extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('MFG_Clients');
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(recordTypeInfo.getName(), (String)recordTypeInfo.getRecordTypeId());
        return defaultValue;
        
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        for(Schema.RecordTypeInfo rtInfo:Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            myValues.addRow(
                new VisualEditor.DataRow(rtInfo.getName(), (String)rtInfo.getRecordTypeId())          
            );
        }
        return myValues;
    }
 
}