@isTest
public class MFG_NotificationController_Test {
    @isTest
    public static void getNotificationsTest(){ 
        List<Notification__c> notifications = (List<Notification__c>)MFG_TestDataFactory.createsObjectList(new Notification__c(),10,null,true);
        NotificationsTriggerHandler_Test.SalesforceEndpointMock sem = new NotificationsTriggerHandler_Test.SalesforceEndpointMock(NotificationsTriggerHandler_Test.SCS_CR,200);
        System.Test.setMock(HttpCalloutMock.class, sem);
        system.Test.startTest();
        system.assertEquals(10, MFG_NotificationController.getNotifications().size()) ;
        system.Test.stopTest();
    }

}