@isTest
public class MFG_SelectController_Test {
    
    Public static final String SCS_R='{"controllerValues":{},"defaultValue":null,"eTag":"574244a2616492c1e4eeb9cdaa178317","url":"/services/data/v43.0/ui-api/object-info/SFDC_Job__c/picklist-values/012U00000009QqVIAU/Job_Title_for_Role__c","values":[{"attributes":null,"label":"Other","validFor":[],"value":"Other"}]}';
    @isTest
    public static void insertNotification(){ 
        
        NotificationsTriggerHandler_Test.SalesforceEndpointMock sem = new NotificationsTriggerHandler_Test.SalesforceEndpointMock(SCS_R,200);
        System.Test.setMock(HttpCalloutMock.class, sem);
        System.Test.StartTest();
        
        List<MFG_SelectController.SelectOpt> opt=MFG_SelectController.getPicklistOptions('Account','AccountSource');
        system.assertNotEquals(null, opt);
        
        Id recordTypeId =Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByDeveloperName().get('Golf_Town').getRecordTypeId();
        
        list<MFG_SelectController.PicklistValue> picklistValues= MFG_SelectController.getPicklistValueBasedonRecordType( 'SFDC_Job__c',  'Job_Title_for_Role__c', recordTypeId);
        system.assertEquals('Other', picklistValues.get(0).value);
        
        System.Test.StopTest();
        
        
    }
}