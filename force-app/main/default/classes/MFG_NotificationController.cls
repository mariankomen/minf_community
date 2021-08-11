public without sharing class MFG_NotificationController {
    @AuraEnabled
    public static List<sObject> getNotifications(){
        return new List<Notification__c>([SELECT id FROM Notification__c WHERE Displays__c='Yes' ORDER BY CreatedDate DESC]);
    }
}