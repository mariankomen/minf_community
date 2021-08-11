public class TestClassUtil {
	
    public static Applicant__c getApplicant(){
        Applicant__c applicant = new Applicant__c();
        applicant.First_Name__c = 'TEST';
        applicant.Last_Name__c = 'TESTER';
        return applicant;
    }
    
    public static Applicant_Job_Apps__c getApplicantJobApps(Id applicantId, Id jobId){
        Applicant_Job_Apps__c appJobs  = new Applicant_Job_Apps__c();         
        appJobs.Applicant__c = applicantId;
        appJobs.Job__c = jobId;
        return appJobs;
    }
    
    public static List<TalemetrySettings__c> getTalemetrySettings(){
        List<TalemetrySettings__c> tSettingList = new List<TalemetrySettings__c>();
        TalemetrySettings__c tSetting = new TalemetrySettings__c(Name='IntegrationExternalID',Value__c ='1111');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='Username',Value__c ='1111');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='Password',Value__c ='1111');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='Endpoint',Value__c ='http://apiint.talemetry.com');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_attachmentsAPI',Value__c ='/api/v1/attachments');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_ProcessOrderAPI',Value__c ='/api/v1/createOrder');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_retrieveOrderAPI',Value__c ='/api/v1/retrieveHistoricResults');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='RP_Company',Value__c ='Mindfield');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='RP_Login',Value__c ='SFDevUser');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='RP_Password',Value__c ='wd3ABCD');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='RP_Account',Value__c ='wd3ABCD');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='ResumeProcessingEndpoint',Value__c ='wd3ABCD');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_ListResumes',Value__c ='/irexservice/resumeprocessing.asmx?op=ListResumes');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_RetrieveResume',Value__c ='/irexservice/resumeprocessing.asmx?op=RetrieveResume');
        tSettingList.add(tSetting);
        tSetting = new TalemetrySettings__c(Name='path_RemoveResume',Value__c ='/irexservice/resumeprocessing.asmx?op=RemoveResume');
        tSettingList.add(tSetting);
        return tSettingList;
    }
}