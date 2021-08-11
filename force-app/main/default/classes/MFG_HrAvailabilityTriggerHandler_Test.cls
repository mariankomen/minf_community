@isTest
public class MFG_HrAvailabilityTriggerHandler_Test {
    @isTest
    public static void newAvailability_Test(){
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false); 
        
        
        
        
        MFG_Hiring_Manager_Availability__c hra=new MFG_Hiring_Manager_Availability__c();
        hra.Start_Date__c=system.today();
        hra.End_Date__c=system.today().addDays(90);
        hra.Repeat_for_x_Weeks__c='2';
        hra.Interviewer_s_Available__c =10;
        hra.Interview_Duration__c='60';
        hra.Hiring_Managers_Store__c=acc.id;
        hra.Recurs_every_week_on__c='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
        
        hra.Interview_Start_Date__c=date.today();
        hra.Recurrence_Ends_On__c=date.today().addDays(90);
        hra.Start_Time__c=time.newInstance(9, 0, 0, 0);
        hra.End_Time__c=time.newInstance(18, 0, 0, 0);
        
        MFG_Hiring_Manager_Availability__c hra1=new MFG_Hiring_Manager_Availability__c();
        hra1.Start_Date__c=system.today().addDays(2);
        hra1.End_Date__c=system.today().addDays(2);
        
        hra1.Interview_Start_Date__c=date.today().addDays(2);
        hra1.Recurrence_Ends_On__c=date.today().addDays(2);
        
        hra1.Repeat_for_x_Weeks__c='2';
        hra1.Interviewer_s_Available__c =10;
        hra1.Interview_Duration__c='60';
        hra1.Hiring_Managers_Store__c=acc.id;
        hra1.Recurs_every_week_on__c='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';    
        hra1.Start_Time__c=time.newInstance(18, 0, 0, 0);
        hra1.End_Time__c=time.newInstance(20, 0, 0, 0);
        List<MFG_Hiring_Manager_Availability__c> hraList=new List<MFG_Hiring_Manager_Availability__c>();
        hraList.add(hra);
        hraList.add(hra1);
        
        
        system.runAs(user){
            system.Test.startTest();
            insert hraList;
            system.Test.stopTest();
            List<Hiring_Manager_Availability__c> expected=new List<Hiring_Manager_Availability__c>([SELECT id FROM Hiring_Manager_Availability__c WHERE Hiring_Managers_Store__c=:acc.id]);
            
        }
        
        
    }
    @isTest
    public static void getUserAccountId_Test(){
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false); 
        
        system.runAs(user){
            system.Test.startTest();
            String accID= MFG_HiringManagerAvailabilityController.getUserAccountId();
            system.assertEquals(acc.id, accID);
            system.Test.stopTest();
            
        }
    }
    
}