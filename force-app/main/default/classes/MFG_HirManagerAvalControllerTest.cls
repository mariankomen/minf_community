@isTest
public with sharing class MFG_HirManagerAvalControllerTest {
    private static testmethod void chechInterviewAvailabilityTest(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Max_Number_Of_Days__c = 3;
        aval.Number_of_days__c = 3;
        insert aval;

        MFG_HiringManagerAvailabilityController.chechInterviewAvailability();
    }
    private static testmethod void sentEmailTest(){
        MFG_HiringManagerAvailabilityController.helpText();
        // MFG_HiringManagerAvailabilityController.sentEmail('testJobID');
    }
    private static testmethod void GetElapsedTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        MFG_HiringManagerAvailabilityController.GetElapsedTime(myTime,expected);

    }
    private static testmethod void GetGeneralTimeTest(){
        Time myTime = Time.newInstance(1, 2, 3, 4);
        Time expected = Time.newInstance(4, 2, 3, 4);
        MFG_HiringManagerAvailabilityController.GetGeneralTime(myTime,expected);
    }
    private static testmethod void getUserAccountIdTest(){
        MFG_HiringManagerAvailabilityController.getUserAccountId();
    }

    private static testmethod void getMinimumInterviewHours(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Number_of_hours__c = 1;
        insert aval;
        System.assertEquals(aval.Number_of_hours__c, 1);
        MFG_HiringManagerAvailabilityController.getMinimumInterviewHours();
    }
    private static testmethod void getMinimumInterviewDaysTest(){
        Interview_Availability__c aval = Interview_Availability__c.getInstance();
        aval.Number_of_days__c = 1;
        insert aval;
        System.assertEquals(aval.Number_of_days__c, 1);
        MFG_HiringManagerAvailabilityController.getMinimumInterviewDays();
    }
    private static testmethod void getMaxAmountOfDaysTest(){
        MFG_HiringManagerAvailabilityController.getMaxAmountOfDays();
    }
    private static testmethod void getUserLanguageTest(){
        MFG_HiringManagerAvailabilityController.getUserLanguage();

    }


}