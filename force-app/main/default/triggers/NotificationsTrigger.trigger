trigger NotificationsTrigger on Notification__c (after insert,after update) {
    fflib_SObjectDomain.triggerHandler(NotificationsTriggerHandler.class);
    List<notificationState__c> data = [SELECT id, Name, needShow__c FROM notificationState__c];
    for(Integer i = 0; i<data.size(); i++){
        data[i].needShow__c = 'true';
        upsert data;    
    }
}