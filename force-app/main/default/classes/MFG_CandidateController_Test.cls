@isTest
public class MFG_CandidateController_Test {
   @isTest
    public static void getSchInterviewsTest(){ 
        MFG_CandidateController.Candidates candidates =MFG_CandidateController.getCandidates();
        system.assertNotEquals(null,candidates);
            
    }
}