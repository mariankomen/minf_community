/**********************************************************************************
    Author: Jeff Perron
    Date: May 2018
    Class: Interview_Scheduler_Util 
    Purpose: This class contains methods to handle Interview_Scheduler functionallity.
***********************************************************************************/   
global without sharing class Interview_Scheduler_Util {

    
    //find candidate interview from email and job id
    public static List<Candidate_Interview__c> FindCandidateInterviewByEmailAndJobId(string sEmail, Id jId) {
        string qEmail = sEmail != null && sEmail.length() > 0 ? sEmail.trim() : '';
    
        List<Candidate_Interview__c> cil = [SELECT id, name, Start_Date__c, End_Date__c FROM Candidate_Interview__c WHERE name=:qEmail AND Job__c=:jId];
        return cil;
    }
    //find candidate interview from email and job id
    public static List<SFDC_Job_Candidate__c> FindJobCandidateByEmailAndJobId(string sEmail, Id jId) {
        string qEmail = sEmail != null && sEmail.length() > 0 ? sEmail.trim() : '';
    
        List<SFDC_Job_Candidate__c> jcl = [SELECT id, name, Scheduled_Interview_Date_Time__c  FROM SFDC_Job_Candidate__c WHERE Email__c=:qEmail AND SFDC_Job__c=:jId];
        return jcl;
    }
    
    //find candidate interview from email and job id and return start date
    public static DateTime FindCandidateInterviewByEmailAndJobIdAndReturnStartDate(string sEmail, Id jId) {
        List<Candidate_Interview__c> cil = FindCandidateInterviewByEmailAndJobId(sEmail, jId);
        if(cil.size() > 0 && cil[0].Start_Date__c != null) {
            return cil[0].Start_Date__c;
        }
        return null;
    }
    //find job candidate from email and job id and return id
    public static Id FindJobCandidateByEmailAndJobIdAndReturnId(string sEmail, Id jId) {
        List<SFDC_Job_Candidate__c> jcl = FindJobCandidateByEmailAndJobId(sEmail, jId);
        if(jcl.size() > 0) {
            return jcl[0].Id;
        }
        return null;
    }
    
    //find candidate interview from email and job id
    //set the job candidate/candidate interview association 
    public static void SetCandidateInterviewToJobCandidate(string sEmail, Id jId, Id jcId) {
        List<Candidate_Interview__c> cil = FindCandidateInterviewByEmailAndJobId(sEmail, jId);
        if(cil.size() > 0) {
            cil[0].Job_Candidate__c = jcId;
            update cil;
        }
    }
    
    //webservice to send emails if amy scheduling errors occur
    webservice static void SendErrorEmail(String err) {
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'jeff.perron@mindfieldgroup.com', 'mfgsysadmin@mindfieldgroup.com'}; 
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('jeff.perron@mindfieldgroup.com');
            mail.setSenderDisplayName('Mindfield Group: Apex error message');
            mail.setSubject('Scheduler Error from ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(err + '\n\nUser: ' + userinfo.getUserName());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }    
        catch(Exception ex) {  }
    }
}