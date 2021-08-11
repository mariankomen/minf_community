public class MoveApplicantJobCtrl {
    
    @AuraEnabled
    public static String moveApplicantJob(Id appId, String job_Id){
        System.debug('appId : '+ appId);
        System.debug('jobId : '+ job_Id);
        try{
            if(String.isNotBlank(job_Id) && String.isNotBlank(appId) ){
                //List<Applicant_Job_Apps__c> applicantJobList = [SELECT Id, Job__c, Applicant__c FROM Applicant_Job_Apps__c WHERE (Applicant__c =: appId OR Job__c =: appId) AND Job__c !=: job_Id];
                List<Applicant_Job_Apps__c> applicantJobList = [SELECT Id, Job__c, Applicant__c FROM Applicant_Job_Apps__c WHERE Id =: appId AND Job__c !=: job_Id];
                if(applicantJobList.isEmpty()){
                    return 'There is no Applicant Job App record to move'; 
                }else{
                    Talemetry_Logger__c tl = new Talemetry_Logger__c();
                    tl = TalemetryParseResponseUtil.getLogging('Trigger MoveApplicantJobCtrl', 'MoveApplicantJobCtrl trigger', null);
                    tl.Status__c = 'Pending';
                    //tl.Applicant_Id__c = tsk.WhatId;
                    //tl.Source_Id__c = tsk.Id;
                    for(Applicant_Job_Apps__c aja : applicantJobList){
                        aja.Job__c = job_Id;
                        tl.Applicant_Id__c = aja.Applicant__c;
                    }
                    if(!applicantJobList.isEmpty() && tl.Applicant_Id__c <> null){
                        update applicantJobList;
                        insert tl;
                    }  
                }
                
                return 'SUCCESS';
            }
        } catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            return 'Exception : '+ e.getMessage();    
        }
        return 'Error Occoured';
    }
    
    @AuraEnabled
    public static List<Applicant_Job_Apps__c> getApplicantJobApps(String parentId){
        return [SELECT Id, Name, Job__r.Job_Status__c, Status__c, Applicant_Name__c, Job_Name__c, Job__c, Job__r.Job_Title__c, Job__r.Store__c FROM Applicant_Job_Apps__c WHERE Applicant__c =: parentId OR Job__c =: parentId OR Id =: parentId];
    }
    
    @AuraEnabled
    public static List<JobWrapper> getJobs(String jobName, String currentJobId, String currentJobTitle, String currentJobStore){
        List<JobWrapper> jobWraps = new List<JobWrapper>();
        
        jobName = '\'%' +String.escapeSingleQuotes(jobName) + '%\'';
        String Open = 'Open';
        String Addit = 'Additional'; 
        
        String query = 'SELECT Id, Name, Job_Title__c, New_Job_Title__c, Banner_of_Store__c, Full_Time_Part_Time__c, Days_Job_Open__c, Department__c, Store__c, Job_Status__c FROM SFDC_Job__c WHERE Id !=: currentJobId AND Job_Title__c =: currentJobTitle AND Store__c =:currentJobStore AND (Job_Status__c LIKE \'%' + Open + '%\' OR Job_Status__c LIKE \'%' + Addit + '%\')';
        if(String.isNotBlank(jobName)) {
            query += ' AND Name LIKE '+ jobName;
          //  query += ' AND Job_Status__c LIKE \'%' + Open + '%\'' + OR Job_Status__c LIKE \'%' + Addit + '%\'';
            
        } 
        query += ' Order By LastModifiedDate DESC Limit 10';
        System.debug('query @>'+query);
        List<SFDC_Job__c> jobList = Database.query(query);
        System.debug('jobList @>'+jobList);
        if(!jobList.isEmpty()){
            JobWrapper job;
            for(SFDC_Job__c j:jobList){
                job = new JobWrapper();
                job.jobId = j.Id;
                job.jobName = j.Name;
                job.jobTitle = j.New_Job_Title__c;
                job.department = j.Department__c;
                job.fullTimePartTime = j.Full_Time_Part_Time__c;
                job.daysOpen = j.Days_Job_Open__c;
                job.banner = j.Banner_of_store__c;
                jobWraps.add(job);
            }
        }
        
        return jobWraps; 
    }
    
    public class JobWrapper {
        @AuraEnabled public String jobId;
        @AuraEnabled public String jobName;
        @AuraEnabled public String jobTitle; //New_Job_Title_c + Department_c 
        @AuraEnabled public String department;
        @AuraEnabled public String fullTimePartTime;
        @AuraEnabled public Decimal daysOpen;
        @AuraEnabled public String banner;
    }
}