@isTest
public class MFG_NewJobController_Test {
    @isTest
    public static void initJobFormTest(){ 
        
        
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId(); 
        
        Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(RecordTypeId=recordTypeId),true);
        Contact con = (Contact)MFG_TestDataFactory.createsObject(new Contact(AccountId=acc.id),true);
        User user = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false);       
        
        
        Hiring_Manager_Availability__c hra=new Hiring_Manager_Availability__c();
        hra.Start_Date__c=system.today();
        hra.End_Date__c=system.today().addDays(90);
        hra.Interviewer_s_Available__c =10;
        hra.Interview_Duration__c='60';
        hra.Hiring_Managers_Store__c=acc.id;
        insert hra;
        
        
        
        System.runAs(user){
            System.Test.StartTest();
            MFG_NewJobController.JobForm jf=   MFG_NewJobController.initJobForm();
            system.assertNotEquals(null, jf.defaultRecordTypeId);
            System.Test.StopTest();
        } 
        
    }
    
    @isTest
    public static void getSchInterviewsTest(){ 
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
            Interview_Availability__c aval = Interview_Availability__c.getInstance();
            aval.Max_Number_Of_Days__c = 3;
            aval.Number_of_days__c = 3;
            insert aval;  
            Boolean interviews=  MFG_NewJobController.chechInterviewAvailability();
            system.assertEquals(false, interviews);
            System.Test.StopTest();
        } 
    }

    @isTest
    public static void GetElapsedTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        MFG_NewJobController.GetElapsedTime(myTime,expected);
    }
    @isTest
    public static void GetGeneralTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        MFG_NewJobController.GetGeneralTime(myTime,expected);
    }

    @isTest
    public static void testCustomSettingsDataForChecking(){
        MFG_NewJobController.setStaticUrl('test');
        String str = MFG_NewJobController.getStaticUrl();
        url_data_check__c testData = (url_data_check__c)JSON.deserialize(str, url_data_check__c.class);
        System.assertEquals(testData.front_url__c, 'test');
    }

}