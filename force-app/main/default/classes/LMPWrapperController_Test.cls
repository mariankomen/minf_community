@isTest(SeeAllData=true)

public class LMPWrapperController_Test{
     public static testMethod void LMPWrapperController_Test() {
     
         PageReference pageRef = Page.LMP_Wrapper;
         Test.setCurrentPage(pageRef);
         
         //SFDC_Candidate__c cand = new SFDC_Candidate__c(name='Jeff Test',Candidate_Resume_Link__c='7A67E410-EF0E-469F-AAE9-95B3101F051A');
         //insert cand;
         SFDC_Candidate__c cand = [SELECT id, Name, LMP_Report_URL__c, LMP_Report_URL_Exception__c, Auto_HireDesk_GUID_Lookup__c
                                   FROM SFDC_Candidate__c 
                                   WHERE Auto_HireDesk_GUID_Lookup__c != '' AND LMP_Report_URL__c =: '' AND LMP_Report_URL_Exception__c =: ''
                                   Order By CreatedDate Desc Limit 1];
         
         Test.startTest();
         
         //ApexPages.currentPage().getParameters().put('id', cand.id); //pass new id
         System.currentPageReference().getParameters().put('id', cand.id);
         LMPWrapperController controller = new LMPWrapperController();

         boolean b1 = controller.haveLMP;
         boolean b2 = controller.cannotFindLMP;
         boolean b3 = controller.tryToGetLMP;
         controller.getLMP();
         controller.redirectToLMP();
         
         System.assert(!b1); //shouldn't have LMP
         System.assert(!b2); //shouldn't have any exceptions
         System.assert(b3); //should try to get LMP...first time
         
         Test.stopTest();
     
     }

}