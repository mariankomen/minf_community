@isTest(SeeAllData=true) 
public class surveyContactUpdateBatchUpdateBatchTest 
{
    static testMethod void testMethod1() 
    {
        if(!Test.isRunningTest()) {
            Test.startTest();
            surveyContactUpdateBatch obj = new surveyContactUpdateBatch();
            DataBase.executeBatch(obj,1); 
            Test.stopTest();
         }   
    }
}