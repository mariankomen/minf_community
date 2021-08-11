@isTest
public class MFG_JobsSelector_Test {
 @isTest
    public static void getSObjectFieldListTest(){ 
        MFG_JobsSelector selector = new MFG_JobsSelector();
        System.Test.startTest();
        system.assert(!selector.getSObjectFieldList().isEmpty());
        System.Test.stopTest();
    }
        @isTest
    public static void getSObjectTypeTest(){
        MFG_JobsSelector selector = new MFG_JobsSelector();
        System.Test.startTest();
        system.assertEquals( SFDC_Job__c.sObjectType, selector.getSObjectType()) ;
        System.Test.stopTest();
    }
    @isTest
    public static void selectByIdTest(){
        List<SFDC_Job__c> faqs = (List<SFDC_Job__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job__c(),10,null,true);
        set<id> faqIds=new Set<id>();
        for(SFDC_Job__c  f:faqs){
            faqIds.add(f.id);
        }
        MFG_JobsSelector selector = new MFG_JobsSelector();
        System.Test.startTest();
        System.assertEquals(10, selector.selectById(faqIds).size());
        System.Test.stopTest();
    }
     @isTest
    public static void selectAllDisplayed_Test(){
     
        List<SFDC_Job__c> faqs2 = (List<SFDC_Job__c>)MFG_TestDataFactory.createsObjectList(new SFDC_Job__c(),10,null,true);
        MFG_JobsSelector selector = new MFG_JobsSelector();
        System.Test.startTest();
        System.assertEquals(10, selector.selectForCurrentUser('').size());
        System.Test.stopTest();
    }
}