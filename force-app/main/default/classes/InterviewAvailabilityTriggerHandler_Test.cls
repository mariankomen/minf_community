@isTest
public class InterviewAvailabilityTriggerHandler_Test {
    
        @isTest
    public static void hiring_Manager_AvailabilitInsertTest(){ 
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId(); 
        
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(RecordTypeId=recordTypeId),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false);       
        
        
        Hiring_Manager_Availability__c hra=new Hiring_Manager_Availability__c();
        hra.Start_Date__c=system.today().addDays(10);
        hra.End_Date__c=system.today().addDays(10);
        hra.Interviewer_s_Available__c =10;
        hra.Interview_Duration__c='60';
        system.debug(acc.id);
        hra.Hiring_Managers_Store__c=acc.id;
       
        
        
        
        System.runAs(user){
            System.Test.StartTest();
            insert hra;
            System.Test.StopTest();
        } 
    }
    @isTest
    public static void hiring_Manager_AvailabilitUpdateTest(){ 
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId(); 
        
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(RecordTypeId=recordTypeId),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false);       
        
        
        Hiring_Manager_Availability__c hra=new Hiring_Manager_Availability__c();
        hra.Start_Date__c=system.today().addDays(10);
        hra.End_Date__c=system.today().addDays(10);
        hra.Interviewer_s_Available__c =10;
        hra.Interview_Duration__c='60';
        system.debug(acc.id);
        hra.Hiring_Managers_Store__c=acc.id;
        insert hra;
        
        
        
        System.runAs(user){
            System.Test.StartTest();
            hra.Start_Date__c=hra.Start_Date__c.addDays(1);
            hra.End_Date__c=hra.End_Date__c.addDays(1);
            update hra;
            System.Test.StopTest();
        } 
    }
}