@isTest
private class jobHolidayUpdateBatch_Test {

    static testmethod void test() {
    
        //create test job
        SFDC_Job__c j = new SFDC_Job__c (
            recordtypeid='012U00000009Qqf', //FGL
            Banner_of_Store__c='Atmosphere',
            Job_Status__c='Open/Active Job',
            Name_of_Person_Submitting_Request__c='Jeff',
            Confidential__c='No',
            Number_Of_Hours_Per_Week__c='0 to 8 hours',
            Hours_of_Availability__c='Weekdays - 8am to 4pm',
            Specific_Candidate_Preference__c='No',
            MindField_Job_Type__c='Client Demo & Testing',
            Date_Job_Added_or_Opened__c=system.now().addDays(-1),
            Holiday_Deduction_in_days__c=0
            );
        insert j;

        DateTime now = system.now(); 
        Date today = date.newinstance(now.year(), now.month(), now.day());
        
        Test.startTest();
        //call batch, this should find and update our test job
        Id batchinstanceid = database.executeBatch(new jobHolidayUpdateBatch(today),200);
        Test.stopTest();

        // Verify holiday got updated
        Decimal d = [SELECT Holiday_Deduction_in_days__c FROM SFDC_Job__c WHERE id=:j.id].Holiday_Deduction_in_days__c;

        System.assertEquals(1, d.intValue());
    }
}