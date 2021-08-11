@isTest(SeeAllData=true) 
public class candidateRevenueUpdateBatchTest 
{
    static testMethod void testMethod1() 
    {
        if(!Test.isRunningTest()) {
            Test.startTest();
            candidateRevenueUpdateBatch obj = new candidateRevenueUpdateBatch();
            DataBase.executeBatch(obj,1); 
            Test.stopTest();
        }    
    }
}