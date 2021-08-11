@isTest // test class for Candidate Record Rating class
public class CandidateRecordRating_Test{
@istest
    static void testPg(){
     // create test candidate record
        SFDC_Candidate__c can = new SFDC_Candidate__c(first_name__c = 'test', last_name__c = 'last test');
        insert can;
        // initialize controller
        ApexPages.StandardController con = new ApexPages.StandardController(can);
        CandidateRecordRating ext = new CandidateRecordRating(con);
        ext.getstars();
        // select 2 stars
        ext.selectedRating = 2;
        ext.ratingnotes = 'testing notes';
        // call save and refresh to redirect to candidate page
        ext.SaveRatingRefresh();
        can = [select id, starrating__c, rating_notes__c from SFDC_Candidate__c where id = :can.id];
        system.assertequals(can.starrating__c, 2);
        system.assertequals(can.rating_notes__c, 'testing notes');
    }
}