@isTest public with sharing class CustomSettingsDataForCheckingTest {
    @isTest
    public static void testCustomSettingsDataForChecking(){
        CustomSettingsDataForChecking.setCustomSett('test');
        String str = CustomSettingsDataForChecking.getCustomSett();
        url_data_check__c testData = (url_data_check__c)JSON.deserialize(str, url_data_check__c.class);
        System.assertEquals(testData.front_url__c, 'test');
    }
}