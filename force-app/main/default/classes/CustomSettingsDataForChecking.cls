public with sharing class CustomSettingsDataForChecking {
    @AuraEnabled
    public static string getCustomSett(){
        url_data_check__c data = url_data_check__c.getInstance();

        return JSON.serialize(data);
    }
    @AuraEnabled
    public static void setCustomSett(String url){
        url_data_check__c data = url_data_check__c.getInstance();
        data.front_url__c = url;
        upsert data;
    }

}