@isTest
public class MFG_NewSupportCase_Test {
    @isTest
    public static void initCaseFormTest(){ 
        system.Test.startTest();
        system.assertEquals(false, MFG_NewSupportCase.initCaseForm().isEmpty());
        system.Test.stopTest();
    }
}