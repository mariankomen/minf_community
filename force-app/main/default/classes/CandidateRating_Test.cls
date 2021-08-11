@isTest // test class for Candidate Rating class
public class CandidateRating_Test{

    static testmethod void testPg(){
     // create test candidate record
        SFDC_Candidate__c can = new SFDC_Candidate__c(first_name__c = 'test', last_name__c = 'last test');
        insert can;
        
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Overwaitea Food Group Sourcing').getrecordtypeid();
        SFDC_Job__c j = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
        insert j;
        
        SFDC_Job_Candidate__c jcan = new SFDC_Job_Candidate__c(SFDC_Job__c=j.Id, Candidate__c=can.Id);
        insert jcan;
        
        // initialize controller
        ApexPages.StandardController con = new ApexPages.StandardController(jcan);
        CandidateRating ext = new CandidateRating(con);
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