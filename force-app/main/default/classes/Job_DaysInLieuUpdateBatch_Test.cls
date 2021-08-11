//Test class for Job_DaysInLieuUpdateBatch

@isTest
public class Job_DaysInLieuUpdateBatch_Test
{
   static testmethod void test() {
    
        //create test job
        SFDC_Job__c j = new SFDC_Job__c (
        
            recordtypeid='0120P000000AqJ9', //FGL
            Job_Status__c='Open/Active Job',
            Name_of_Person_Submitting_Request__c='Jami',
            Confidential__c='No',
            Number_Of_Hours_Per_Week__c='0 to 8 hours',
            Hours_of_Availability__c='Weekdays - 8am to 4pm',
            Specific_Candidate_Preference__c='No',
            MindField_Job_Type__c='Client Demo & Testing',
            Date_Job_Added_or_Opened__c=system.now().addDays(-1),
            Parent_Account__c='0010P00001tE6a5',
            Days_In_Lieu__c=1
            );
        insert j;

        Test.startTest();
        //call batch, this should find and update our test case
        Id batchinstanceid = database.executeBatch(new Job_DaysInLieuUpdateBatch(),200);
        Test.stopTest();

        // Verify holiday got updated
        Decimal d = [SELECT Days_In_Lieu__c FROM SFDC_Job__c WHERE id=:j.id].Days_In_Lieu__c;

        System.assertEquals(1, d.intValue());
    }
}