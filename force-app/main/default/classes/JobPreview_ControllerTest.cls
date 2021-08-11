@isTest
public class JobPreview_ControllerTest{
	// test Job Preview controller and page
    static testmethod void testPg() {
        // get map of record types by Id to find client name
        Schema.DescribeSObjectResult d = Schema.SObjectType.SFDC_Job__c;
        Map<string,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByname();
        Schema.RecordTypeInfo OFGrt = rtMapbyName.get('Overwaitea Food Group');
        // set up at least 1 clone field custom setting for the modify call
        CloneJobFields__c f = new CloneJobFields__c (name = 'firstname', field_value__c = 'test');
        insert f;
        CloneJobFields__c f2 = new CloneJobFields__c (name = 'secondname');
        insert f2;        
     	// create Job with a job desc and job role title and manually set Job Preview pending check
        SFDC_Job__c j1 = new SFDC_Job__C(recordtypeid = ofgRt.getrecordtypeid(), Job_Role_Title__c = 'sample title', job_description__c = 'banner');
        insert j1;
        j1 = [select id, name, recordtypeid, Job_role_title__c, candidate_requirements__c,
                         Job_Description__c, Job_Preview_Pending__c, Job_Description_original__c
                         from SFDC_Job__c where id = :j1.id];
        if (!j1.Job_Preview_Pending__c) {
         	j1.Job_Preview_Pending__c = true;
            update j1;
        }
        j1 = [select id, name, recordtypeid, Job_role_title__c, candidate_requirements__c,
              Job_Description__c, Job_Preview_Pending__c, Job_Description_original__c
              from SFDC_Job__c where id = :j1.id];
		system.assert(j1.Job_Preview_Pending__c);
        // page should have showCandReqt and showDesc true
        PageReference pageRef = Page.JobPreview;
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('newid', j1.id);      
        JobPreview_Controller con = new JobPreview_Controller();
		string results = 'start';
        try { results = con.PreviewRedirect().geturl(); results = 'fail';}
        catch (Exception e) {results = 'pass';}
        system.assertequals(results, 'pass');
        // confirm method will uncheck box and go to confirmation page
        results = 'start';
        try { results = con.confirm().geturl(); results = 'pass';}
        catch (Exception e) {results = 'fail';}
        system.assertequals(results, 'pass');
        // modify method will send to a clone page and use future method to delete
        test.startTest();
        results = 'start';
        try { results = con.modifyJob().geturl(); results = 'pass';}
        catch (Exception e) {results = 'fail';}
        system.assertequals(results, 'pass');
        test.stopTest();
        // original job was not deleted in test code
        
        // test coming into code without preview checked - should redirect to confirmation
        j1 = [select id, name, recordtypeid, Job_role_title__c, candidate_requirements__c,
              Job_Description__c, Job_Preview_Pending__c, Job_Description_original__c
              from SFDC_Job__c where id = :j1.id];
		system.assert(!j1.Job_Preview_Pending__c, 'job should not be in preview pending now');        
		// reset controller and call action method
        con = new JobPreview_Controller();
        results = 'start';
        try { results = con.previewredirect().geturl(); results = 'pass';}
        catch (Exception e) {results = 'fail';}
        system.assertequals(results, 'pass');
		// and test delete
        results = 'start';
        try { results = con.deleteJob().geturl(); results = 'pass';}
        catch (Exception e) {results = 'fail';}
        system.assertequals(results, 'pass');
        system.assertequals(0, [select count() from sfdc_job__c where id = :j1.id]);
    }
}