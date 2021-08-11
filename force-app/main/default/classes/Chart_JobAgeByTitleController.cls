/******************
Class: Chart - Job Age by Title Controller for VF Component
Description:  For a certain set of Job Titles, find all open Jobs the user can see and group them by Age Bracket and Job Title
    We are using a dynamic set of job titles and also creating legend and data series field names dynamically.  Currently
    can take up to 10 job titles.
    
    To Do: - remove a job title if no Jobs are returned in any age bracket
           
Created: Oct 25 2013, Vankerk Solutions
Modification Log

******************/
public with sharing class Chart_JobAgeByTitleController {

    private integer MAX_NUM_JOB_TITLES = 10;
    private integer titleCount {
        get {
            if (titleCount != null) return titleCount;
            else titleCount = (jobTitles.size() > MAX_NUM_JOB_TITLES ? MAX_NUM_JOB_TITLES : jobtitles.size());
            return titleCount;
        } set; }
            
    // jobTitles list is built from passing attribute details into component with comma separated list of titles, and getter for attribute field sets this array
    public List<string> jobTitles {get; set;}
    
    // attribute sets this field which then splits the list of job titles by comma and drops list into jobTitles.
    public string jobTitlesFromPage {get; 
        set {
            jobtitles = new list<string>();
            jobtitles = value.split(',');
        }
    }
    
    // pull all jobs that are currently 'open' based on custom setting list of status values.
    public List<JobAgeForTitle> getJobAgeByTitleData() {
        
        Set<String> OpenStatus = new Set<String>();
        for (Open_Job_Statuses__c s : Open_Job_Statuses__c.getall().values())
            OpenStatus.add(s.status_name__c);
        
        List<JobAgeForTitle> results = new List<JobAgeForTitle>();
        try {
            Map<string, list<SFDC_Job__c>> jobMap = new Map<string, list<SFDC_Job__c>>();
            
            // cycle through open jobs this user can see and build map of bucket to jobs
            for (SFDC_job__c j : [select id, chart_job_Title__c, job_age_days__c 
                                  from SFDC_Job__c 
                                  where job_status__c in :OpenStatus and chart_job_Title__c != null and (manager_is_me__c = 'Yes' or my_stores_job__c = 'Yes') and 
                                  chart_job_title__c in :jobTitles ]) {
                // add job to the list based on which job age it comes back with - check if that job age list has already been created
                List<SFDC_Job__c> tempList = new List<SFDC_Job__c>();
                if (JobMap.containskey(j.job_age_days__c )) {
                    tempList = JobMap.get(j.job_age_days__c );
                }
                tempList.add(j);
                JobMap.put(j.job_age_days__c, tempList);
            }
            
            // system.debug('job map is: '+jobmap);
            // force order of displaying bucket rows since default is alphabetical and 15+ comes before 8-14
            list<string> keys = new list<string>{'0 - 7', '8 - 14', '15+'};
            // cycle through map and add to results list
            for (string key : keys){
                // count each job title we are tracking for this client
                Map<string, integer> JobCounts = new Map<string, integer>();
                // load map with job titles
                for (string s : jobtitles)
                    JobCounts.put(s, 0);
                
                // if we have jobs with this age bracket in our map, count them
                if (jobMap.containskey(key)) {
                    // cycle through jobs for this bracket and count
                    for (Sfdc_Job__c j : jobMap.get(key)) {
                        // add +1 to the JobCounts map for this job's title
                        integer tempCount = 0;
                        if (JobCounts.containskey(j.chart_job_title__c))
                            tempCount = JobCounts.get(j.chart_job_title__c);
                        tempCount ++;
                        JobCounts.put(j.chart_job_title__c, tempCount);
                    }            
                }
                // system.debug('job titles list size: '+jobTitles.size()+' :: and list: '+jobTitles);
                JobAgeForTitle newline  = new JobAgeForTitle(key);
                // go through each title and send count into jobAge class
                for (integer i=1; i<=titleCount; i++)
                    if (jobCounts.containskey(jobTitles[i-1]))
                        newline.setJobTitleCount(i, jobCounts.get(jobTitles[i-1]));
                results.add(newline);
            }
        } catch (Exception e) {}
        return results;
    }
    
    public string getJobTitleLegend(){
        // buid string from jobTitles array
        string JobTitleString = '';
        // build legend based on titles passed in up to max number of titles allowed
        for (integer i=0; i<titleCount; i++)        
            JobTitleString += jobTitles[i] + ',';
        // take off last comma
        if (JobTitleString.length() > 1) JobTitleString = JobTitleString.removeEnd(',');
        return JobTitleString; 
    }

    public string getJobTitleFields(){
        string fieldnames = '';
        // build list of jobTitlex based on number of titles passing in
        for (integer i=1; i<=titleCount; i++){
            fieldnames += 'jobTitle'+i+',';
        }
        return fieldnames.removeend(',');
    }
    
    public integer getJobAgeByTitleData_Size() {
        return getJobAgeByTitleData().size();
    } 
    
    // need wrapper class since aggregate can't group by formula field of Job Age Days
    public class JobAgeforTitle{
        public string BracketName {get; set;}
        public integer jobTitle1 {get; set;}
        public integer jobTitle2 {get; set;}
        public integer jobTitle3 {get; set;}
        public integer jobTitle4 {get; set;}
        public integer jobTitle5 {get; set;}
        public integer jobTitle6 {get; set;}
        public integer jobTitle7 {get; set;}
        public integer jobTitle8 {get; set;}
        public integer jobTitle9 {get; set;}
        public integer jobTitle10 {get; set;}
                
        public JobAgeforTitle(string bracket){
            BracketName = bracket;
            jobTitle1 = 0;
            jobTitle2 = 0;
            jobTitle3 = 0;
            jobTitle4 = 0;
            jobTitle5 = 0;
            jobTitle6 = 0;
            jobTitle7 = 0;
            jobTitle8 = 0;
            jobTitle9 = 0;
            jobTitle10 = 0;
        }
        
        public void setJobTitleCount(integer TitleNum, integer TitleCount) {
            titleCount = (TitleCount == null ? 0 : titleCount);
            if (titleNum == 1)
                jobTitle1 = TitleCount;
            else if (titleNum == 2)
                jobTitle2 = TitleCount;
            else if (titleNum == 3)
                jobTitle3 = TitleCount;
            else if (titleNum == 4)
                jobTitle4 = TitleCount;
            else if (titleNum == 5)
                jobTitle5 = TitleCount;
            else if (titleNum == 6)
                jobTitle6 = TitleCount;
            else if (titleNum == 7)
                jobTitle7 = TitleCount;
            else if (titleNum == 8)
                jobTitle8 = TitleCount;
            else if (titleNum == 9)
                jobTitle9 = TitleCount;
            else if (titleNum == 10)
                jobTitle10 = TitleCount;
        }
    }


}