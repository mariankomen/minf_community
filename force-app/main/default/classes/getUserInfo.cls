public with sharing class getUserInfo {
    @AuraEnabled
    public static string getUserProfile(){
        try{
            String profileId = UserInfo.getProfileId();
            Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            return JSON.serialize(profile);}catch(Exception e){throw new AuraHandledException(e.getMessage()); } }
}