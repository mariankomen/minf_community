@isTest
public class CaseRecordTypes_Test {
    @isTest
    public static void getCaseRecordTypes_Test(){ 
        CaseRecordTypes caseRecordTypePickList=new CaseRecordTypes();
        system.assert(caseRecordTypePickList.getDefaultValue()!=null);
        system.assert(caseRecordTypePickList.getValues()!=null);
    }
}