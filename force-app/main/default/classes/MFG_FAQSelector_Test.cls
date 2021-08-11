@isTest
public class MFG_FAQSelector_Test {
    @isTest
    public static void getSObjectFieldListTest(){ 
        MFG_FAQSelector selector = new MFG_FAQSelector();
        System.Test.startTest();
        system.assert(!selector.getSObjectFieldList().isEmpty());
        System.Test.stopTest();
    }
        @isTest
    public static void getSObjectTypeTest(){
        MFG_FAQSelector selector = new MFG_FAQSelector();
        System.Test.startTest();
        system.assertEquals( FAQ__c.sObjectType, selector.getSObjectType()) ;
        System.Test.stopTest();
    }
    @isTest
    public static void selectByIdTest(){
        List<FAQ__c> faqs = (List<FAQ__c>)MFG_TestDataFactory.createsObjectList(new FAQ__c(),10,null,true);
        set<id> faqIds=new Set<id>();
        for(FAQ__c f:faqs){
            faqIds.add(f.id);
        }
        MFG_FAQSelector selector = new MFG_FAQSelector();
        System.Test.startTest();
        System.assertEquals(10, selector.selectById(faqIds).size());
        System.Test.stopTest();
    }
     @isTest
    public static void selectAllDisplayed_Test(){
       List<FAQ__c> faqs = (List<FAQ__c>)MFG_TestDataFactory.createsObjectList(new FAQ__c(),10,null,true);
        List<FAQ__c> faqs2 = (List<FAQ__c>)MFG_TestDataFactory.createsObjectList(new FAQ__c(Display__c='No'),10,null,true);
        MFG_FAQSelector selector = new MFG_FAQSelector();
        System.Test.startTest();
        System.assertEquals(10, selector.selectAllDisplayed().size());
        System.Test.stopTest();
    }
    
}