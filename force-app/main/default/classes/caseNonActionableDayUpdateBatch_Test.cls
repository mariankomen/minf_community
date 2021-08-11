//Test class for caseNonActionableDayUpdateBatch

@isTest
public class caseNonActionableDayUpdateBatch_Test
{
   static testmethod void test() {
    
        //create test job
        Case c = new Case (
            recordtypeid='012U00000009elZ', //Helpdesk
            Status='On Hold',
            NonActionable_Days__c=1
            );
        insert c;

        Test.startTest();
        //call batch, this should find and update our test case
        Id batchinstanceid = database.executeBatch(new caseNonActionableDayUpdateBatch(),200);
        Test.stopTest();

        // Verify holiday got updated
        Decimal d = [SELECT NonActionable_Days__c FROM Case WHERE id=:c.id].NonActionable_Days__c;

        System.assertEquals(2, d.intValue());
    }
}