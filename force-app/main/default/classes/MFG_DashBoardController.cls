public without sharing class MFG_DashBoardController {
    
    @AuraEnabled
    public static List<ScheduledInterview> getScheduledInterviews(){
        try{
            User portalUser=[SELECT id, AccountId FROM User WHERE Id=:UserInfo.getUserId()];
            List<Candidate_Interview__c> candInt=new List<Candidate_Interview__c>([SELECT 
                                                                                   Job_Candidate__c,
                                                                                   Job_Candidate__r.Name,
                                                                                   Job_Candidate__r.Candidate__r.Name,
                                                                                   Job_Candidate__r.SFDC_Job__r.Name,
                                                                                   Job_Candidate__r.SFDC_Job__r.New_Job_Title__c,
                                                                                   Job_Candidate__r.SFDC_Job__r.RecordType.DeveloperName,
                                                                                   toLabel(Job_Candidate__r.SFDC_Job__r.Job_Title_for_Banner__c),
                                                                                   toLabel(Job_Candidate__r.SFDC_Job__r.Job_Title_for_Role__c),
                                                                                   Job_Candidate__r.Status__c,
                                                                                   Job_Candidate__r.Status_Details__c,
                                                                                   Job_Candidate__r.Job_Title__c,
                                                                                   
                                                                                   Hiring_Manager_Availability__c, End_Date__c, Job__c, Start_Date__c, Name, Id 
                                                                                   FROM Candidate_Interview__c 
                                                                                   
                                                                                   Where Hiring_Manager_Availability__c IN 
                                                                                   (select id FROM Hiring_Manager_Availability__c 
                                                                                    WHERE Hiring_Managers_Store__c=:portalUser.AccountId)
                                                                                   AND
                                                                                   (Start_Date__c = NEXT_N_DAYS:5 OR Start_Date__c = TODAY)
                                                                                   
                                                                                   ORDER BY Start_Date__c ASC
                                                                                  ]); //
            
            
            Map<Date, List<Candidate_Interview__c>> groupbydate=new Map<Date, List<Candidate_Interview__c>>();
            
            for(Candidate_Interview__c cint:candInt){
                if(groupbydate.containsKey(cint.Start_Date__c.date())){
                    List<Candidate_Interview__c> cand=groupbydate.get(cint.Start_Date__c.date());
                    cand.add(cint);
                    groupbydate.put(cint.Start_Date__c.date(),cand);
                }else{
                    groupbydate.put(cint.Start_Date__c.date(),new  List<Candidate_Interview__c>{cint});
                }
            }
            List<ScheduledInterview> scheduledInterviews=new List<ScheduledInterview>();
            for(Date d:groupbydate.keySet()){
                scheduledInterviews.add(new ScheduledInterview(d ,groupbydate.get(d)));
            }
            
            
            return scheduledInterviews;   
            
        }Catch(Exception e){
            return new List<ScheduledInterview>();
        }
        
    }
    public class ScheduledInterview{
        @AuraEnabled public DateTime seduledDate;
        @AuraEnabled public List<Candidate_Interview__c> candidateInterview;
        public ScheduledInterview(DateTime seduledDate,List<Candidate_Interview__c> candidateInterview){
            this.seduledDate=seduledDate;
            this.candidateInterview=candidateInterview;
        }
    }
    @AuraEnabled
    public static List<Notification__c> getLastNotification(){
        return new List<Notification__c>([SELECT Id, 
                                          CreatedDate,
                                          Title__c,
                                          Title_FR__c,
                                          Body__c, 
                                          Body_FR__c, 
                                          Display_Start_Date__c, 
                                          Display_End_Date__c, 
                                          Show_as_Pop_Up_Alert__c, 
                                          Displays__c 
                                          FROM Notification__c 
                                          WHERE Displays__c='Yes' ORDER BY CreatedDate DESC LIMIT 1]);
    }
    
    @AuraEnabled
    public static JobSummury getJobSummury(){
        return new JobSummury();
    }
    
    public class JobSummury{
        @AuraEnabled public Integer openJobs;
        @AuraEnabled public Integer outstandingCandidates;
        @AuraEnabled public Chart jobsOpen;
        
    public JobSummury(){
            this.openJobs=new MFG_JobsSelector().selectForCurrentUser('WHERE (Job_Status__c =\'Open/Active Job\' OR Job_Status__c =\'Candidates Sent/Awaiting Hire\' OR Job_Status__c =\'Additional Candidate(s) Required\' OR Job_Status__c =\'Job On Hold\') AND Credits_Used_for_Job__c != 0  AND OwnerId=\''+UserInfo.getUserId()+ '\'').size();
            this.outstandingCandidates=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c!=\'Hired\' AND Status__c!=\'Rejected\' AND Status__c!=\'Offer Accepted\' ').size();
            this.jobsOpen=new Chart();
        }
    }
    
    @AuraEnabled
    public static Chart getChart(){
        return new Chart();
    }
    
    public class Chart{
        @AuraEnabled public list<Integer> data;
        @AuraEnabled public list<String> labels;
        public Chart(){
            DateTime d=system.today();
            date myDate = date.newInstance(d.year(),d.month(),d.day());
            Integer month = myDate.month();
            
            this.labels=new list<String>();
            for(Integer i=0;i<6;i++){
                if(UserInfo.getLanguage()=='fr'){
                    if(month==1){
                        this.labels.add(monthNameMapfr.get(month));
                        month=12;
                    }else{
                        this.labels.add(monthNameMapfr.get(month));
                        month=month-1;
                    } 
                }else{
                    if(month==1){
                        this.labels.add(monthNameMap.get(month));
                        month=12;
                    }else{
                        this.labels.add(monthNameMap.get(month));
                        month=month-1;
                    }
                }
                
            }
            
            List<SFDC_Job__c>   jobs0=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = THIS_MONTH AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            
            List<SFDC_Job__c>   jobs1=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = LAST_N_MONTHS:1 AND CreatedDate < THIS_MONTH  AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            
            List<SFDC_Job__c>   jobs2=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = LAST_N_MONTHS:2 AND CreatedDate < LAST_N_MONTHS:1 AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            
            List<SFDC_Job__c>   jobs3=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = LAST_N_MONTHS:3 AND CreatedDate < LAST_N_MONTHS:3 AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            
            List<SFDC_Job__c>   jobs4=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = LAST_N_MONTHS:4 AND CreatedDate < LAST_N_MONTHS:3 AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            
            List<SFDC_Job__c>   jobs5=new MFG_JobsSelector().selectForCurrentUser(
                'WHERE CreatedDate = LAST_N_MONTHS:5 AND CreatedDate < LAST_N_MONTHS:4 AND OwnerId=\''+UserInfo.getUserId()+ '\' AND Credits_Used_for_Job__c != 0');
            this.data=new list<Integer>{jobs0.size(), jobs1.size(), jobs2.size(), jobs3.size(), jobs4.size(), jobs5.size()};
                
                }
    }
    
    public static  Map<Integer,String> monthNameMapfr=new Map<Integer, String>{ 
        1=> 'JAN',
            2=> 'FÉV',
            3=>  'MAR',
            4=> 'AVR',
            5=>  'MAI',
            6=> 'JUIN',
            7=>  'JUIL',
            8=>  'AOÛT',
            9=>  'SEPT',
            10=>  'OCT',
            11=> 'NOV',
            12=>  'DÉC'
            };
                
                
                public static  Map<Integer,String> monthNameMap=new Map<Integer, String>{
                    1=> 'JAN',
                        2=> 'FEB',
                        3=>  'MAR',
                        4=> 'APR',
                        5=>  'MAY',
                        6=> 'JUNE',
                        7=>  'JULY',
                        8=>  'AUG',
                        9=>  'SEPT',
                        10=>  'OCT',
                        11=> 'NOV',
                        12=>  'DEC'};
                            
                           
                @AuraEnabled
                public static void sendEmailMethod(String createdJobId){
                    InterviewsAvailabilityController.sentEmail(createdJobId);
                }        
                @AuraEnabled
                public static string getStaticUrl(){
                    return CustomSettingsDataForChecking.getCustomSett();
                }
                @AuraEnabled
                public static void setStaticUrl(String url){
                    CustomSettingsDataForChecking.setCustomSett(url);
                }


                /* Methods for MFG_NotificationAlert */

                @AuraEnabled
                public static string getNotificationState(){
                    notificationState__c state = notificationState__c.getInstance();
                    if(state.needShow__c == null){
                        return 'null';
                    } else {
                        return JSON.serialize(state);
                    }

                    
                }
                @AuraEnabled
                public static void setNotificationState(String data){
                    notificationState__c state = notificationState__c.getInstance();
                    state.needShow__c = data;
                    upsert state;
                }
                @AuraEnabled
                public static string getLastNot(){
                    if(getLastNotification().isempty()){
                        return null;
                    } else {
                        return JSON.serialize(getLastNotification());
                    }
                   
                }

                @AuraEnabled
                public static string getUserProfile(){
                    return getUserInfo.getUserProfile();
                }
                            }