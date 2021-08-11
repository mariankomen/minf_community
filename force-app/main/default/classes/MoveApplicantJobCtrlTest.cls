@isTest
public class MoveApplicantJobCtrlTest {
    
    @isTest
    static void moveApplicantJobTest() {
        Applicant__c app = new  Applicant__c(
            First_Name__c ='Test', 
            Last_Name__c ='Test', Name  = 'Test');
        insert app;
        MoveApplicantJobCtrl.moveApplicantJob(app.Id,null);
        
        SFDC_Job__c job= new SFDC_Job__c(
            Banner_of_Store__c = 'Betonel', 
            Additional_Information__c= 'test');
        insert job;
        MoveApplicantJobCtrl.moveApplicantJob(app.Id,job.Id);
        
        Applicant_Job_Apps__c aja= new Applicant_Job_Apps__c(
            Job__c =job.Id, 
            Applicant__c = app.Id);
        insert aja;
        MoveApplicantJobCtrl.moveApplicantJob(app.Id,job.Id);
       	
        SFDC_Job__c job2 = new SFDC_Job__c(
            Banner_of_Store__c = 'Betonel', 
            Additional_Information__c= 'test',
        	Career_Site_Alternate_Job_Title__c='test');
        insert job2;
        job2 = [SELECT Id, Name, Job_Title__c, Store__c FROM SFDC_Job__c WHERE Id =: job2.Id];
        
        MoveApplicantJobCtrl.moveApplicantJob(aja.Id,job2.Id);
        MoveApplicantJobCtrl.getApplicantJobApps(app.Id);
        MoveApplicantJobCtrl.getJobs(job2.Name, job.Id, job2.Job_Title__c, null);
    }
}