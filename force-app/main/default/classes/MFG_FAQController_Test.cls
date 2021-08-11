@isTest
public class MFG_FAQController_Test {
    @isTest
    public static void selectAllDisplayed_Test(){
        List<FAQ__c> faqsYes = (List<FAQ__c>)MFG_TestDataFactory.createsObjectList(new FAQ__c(),10,null,true);
        List<FAQ__c> faqsNo = (List<FAQ__c>)MFG_TestDataFactory.createsObjectList(new FAQ__c(Display__c='No'),10,null,true);
        List<Case> cases = (List<Case>)MFG_TestDataFactory.createsObjectList(new Case(),10,null,true);
        System.Test.startTest();
        System.assertEquals(10, MFG_FAQController.getFAQ().size());
        System.assertEquals(10, MFG_FAQController.getSupport(true).size());
       System.assertEquals(0, MFG_FAQController.getPublicCaseComments(cases.get(0).id).size());  
        System.Test.stopTest();
    }
}