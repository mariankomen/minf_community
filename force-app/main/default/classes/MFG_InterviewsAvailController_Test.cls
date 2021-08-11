@isTest
public class MFG_InterviewsAvailController_Test {
    
    private static testmethod void HRAvailabilityCreatedAndDeteleTest(){
        Account acc = (Account) MFG_TestDataFactory.createSObject(new Account(Name = 'Test 1', Location_Type__c = 'Commercial', RecordTypeId = '012U0000000A2tLIAS'),true);
        Hiring_Manager_Availability__c hra = (Hiring_Manager_Availability__c) MFG_TestDataFactory.createSObject(new Hiring_Manager_Availability__c(
            Hiring_Managers_Store__c=acc.id,
            Start_Date__c=dateTime.now(),
            End_Date__c=dateTime.now().addHours(3)
        ),true);
        Test.startTest();
        InterviewsAvailabilityController.HRAvailability hrav = InterviewsAvailabilityController.getCreatedHRAvailability(hra.id);
        System.assertEquals(hra.id, hrav.hra.id);
        
        InterviewsAvailabilityController.deleteInterviewAvailability(hra.id);
        System.assertEquals(0, [SELECT Id
                    FROM Hiring_Manager_Availability__c
                    WHERE id=:hra.id
                    LIMIT 1
                   ].size());
        try{
        InterviewsAvailabilityController.deleteInterviewAvailability(hra.id);
        }catch(Exception ex){
            System.assert(true);
        }
        Test.stopTest();
    }
    
    private static testmethod void getAccountIdTest(){
         User portalUser=[SELECT id, AccountId, TimeZoneSidKey 
                          FROM User 
                          WHERE Id=:UserInfo.getUserId()];
            InterviewsAvailabilityController.UserDetails ud = new InterviewsAvailabilityController.UserDetails();
             
            TimeZone tz = UserInfo.getTimeZone();
            Integer offset= tz.getOffset(system.now());
        Test.startTest();
        	InterviewsAvailabilityController.UserDetails udTest = InterviewsAvailabilityController.getUserAccountId();
        	System.assertEquals(offset, udTest.offset);
        	System.assertEquals(portalUser.AccountId, udTest.accountId);
        	System.assertEquals(portalUser.TimeZoneSidKey, udTest.timeZoneSidKey);
        Test.stopTest();
    }
    
    private static testmethod void initCalendarTest(){
        Account acc = (Account) MFG_TestDataFactory.createSObject(new Account(Name = 'Test 1', Location_Type__c = 'Commercial', RecordTypeId = '012U0000000A2tLIAS'),true);
        Hiring_Manager_Availability__c hra = (Hiring_Manager_Availability__c) MFG_TestDataFactory.createSObject(new Hiring_Manager_Availability__c(Hiring_Managers_Store__c=acc.Id, Start_date__c = System.today().addDays(10)),true);
        Hiring_Manager_Availability__c hra1 = (Hiring_Manager_Availability__c) MFG_TestDataFactory.createSObject(new Hiring_Manager_Availability__c(Hiring_Managers_Store__c=acc.Id, Start_date__c = System.today().addDays(11)),true);
        Test.startTest();
        System.debug(hra.id);
        InterviewsAvailabilityController.Calendar calendar = InterviewsAvailabilityController.initCalendar();
        System.assert(calendar != null);
        Test.stopTest();
    }
    
    private static testmethod void isHolidayAndIsWorkingDayTest(){
        Date d = Date.today().toStartOfWeek();
        Holiday h = new Holiday(ActivityDate = d.addDays(3));
       	BusinessHours bh = new BusinessHours();
        
        List<Holiday> hList = new List<Holiday>{h};
        Test.startTest();
        Boolean isHoliday = InterviewsAvailabilityController.isWorkingDay(d.addDays(3), hList);
        Boolean isSunday = InterviewsAvailabilityController.isWorkingDay(d.addDays(-1), hList);
        Boolean isWorkDay = InterviewsAvailabilityController.isWorkingDay(d.addDays(2), hList);
        Boolean isHolidayTest = InterviewsAvailabilityController.isHoliday(d, bh);
        System.assertEquals(false, isHoliday);
        System.assertEquals(false, isSunday);
        System.assertEquals(true, isWorkDay);
        Test.stopTest();
    }
    // private static testmethod void sentEmailTest(){
    //     InterviewsAvailabilityController.sentEmail('a0P7A000005IeUgUAK');
    // }
    private static testmethod void getSetCustomSettTest(){
        InterviewsAvailabilityController.setStaticUrl('test');
        String str = InterviewsAvailabilityController.getStaticUrl();
        url_data_check__c testData = (url_data_check__c)JSON.deserialize(str, url_data_check__c.class);
        System.assertEquals(testData.front_url__c, 'test');
    }

    private static testmethod void deletejobTest(){
        InterviewsAvailabilityController.deletejob('a0P7A000005IeUgUAK');
    }
    private static testmethod void getMinimumInterviewHours(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Number_of_hours__c = 1;
        insert aval;
        System.assertEquals(aval.Number_of_hours__c, 1);
        InterviewsAvailabilityController.getMinimumInterviewHours();
    }
    private static testmethod void getMinimumInterviewDaysTest(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Number_of_days__c = 1;
        insert aval;
        System.assertEquals(aval.Number_of_days__c, 1);
        InterviewsAvailabilityController.getMinimumInterviewDays();
    }
    private static testmethod void getMaxAmountOfDaysTest(){
        InterviewsAvailabilityController.getMaxAmountOfDays();
    }
    private static testmethod void chechInterviewAvailabilityTest(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Max_Number_Of_Days__c = 3;
        aval.Number_of_days__c = 3;
        insert aval;
        InterviewsAvailabilityController.chechInterviewAvailability();
    }
    private static testmethod void getUserLanguageTest(){
        InterviewsAvailabilityController.getUserLanguage();
    }
    private static testmethod void GetElapsedTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        InterviewsAvailabilityController.GetElapsedTime(myTime, expected);
    }
    private static testmethod void GetGeneralTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        InterviewsAvailabilityController.GetGeneralTime(myTime, expected);
    }
}