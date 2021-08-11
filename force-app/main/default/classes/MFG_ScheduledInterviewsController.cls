public without sharing class MFG_ScheduledInterviewsController {
    @AuraEnabled
    public static List<ScheduledInterview> getSchInterviews(Boolean upcoming){
        try{

            User portalUser=[SELECT id, AccountId FROM User WHERE Id=:UserInfo.getUserId()];
            List<Candidate_Interview__c> candInt;
            if(upcoming){
                candInt=new List<Candidate_Interview__c>([SELECT 
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
                                                          
                                                          (Start_Date__c = NEXT_N_DAYS:90 OR Start_Date__c = TODAY)
                                                          
                                                          
                                                          ORDER BY Start_Date__c ASC
                                                         ]);  //NEXT_N_DAYS:90
            }else{
                candInt=new List<Candidate_Interview__c>([SELECT 
                                                          Job_Candidate__c,
                                                          Job_Candidate__r.Candidate__r.Name,
                                                          Job_Candidate__r.SFDC_Job__r.Name,
                                                          Job_Candidate__r.SFDC_Job__r.New_Job_Title__c,
                                                          Job_Candidate__r.Status__c,
                                                          Job_Candidate__r.Status_Details__c,
                                                          Job_Candidate__r.Job_Title__c,
                                                          Job_Candidate__r.SFDC_Job__r.RecordType.DeveloperName,
                                                          toLabel(Job_Candidate__r.SFDC_Job__r.Job_Title_for_Banner__c),
                                                          toLabel(Job_Candidate__r.SFDC_Job__r.Job_Title_for_Role__c),
                                                          Hiring_Manager_Availability__c, End_Date__c, Job__c, Start_Date__c, Name, Id 
                                                          FROM Candidate_Interview__c 
                                                          
                                                          Where Hiring_Manager_Availability__c IN 
                                                          (select id FROM Hiring_Manager_Availability__c 
                                                           WHERE Hiring_Managers_Store__c=:portalUser.AccountId)
                                                          AND
                                                          
                                                          Start_Date__c = LAST_N_DAYS:30 AND Start_Date__c != TODAY
 
                                                          
                                                          
                                                          ORDER BY Start_Date__c ASC
                                                         ]);    //LAST_N_DAYS:30 
            }
            
            
            

            
            
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
}