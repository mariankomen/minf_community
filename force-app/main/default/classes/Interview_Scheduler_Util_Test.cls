//This will handle tests for class, 'Interview_Scheduler_Util'
//Also delete methods handle tests for 'Job_Candidate_BeforeDelete'
//Also insert, update, delete handle tests for 'Candidate_Interview_BeforeInsertDeleteAfterUpdate'


@isTest
public class Interview_Scheduler_Util_Test {
    
    static testmethod void testIStil(){
       
       //setup tests ---------------------------------------------------------------
       //Id jId = '01p1g0000009OjA';
       string sEmail = 'jeff.e.perron@gmail.com';
       
       Datetime sd = DateTime.newInstance(2018, 1, 31, 7, 8, 16);
       Datetime ed = sd.AddDays(30);
       
       Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
       Id RecType = JobRecTypes.get('PPG USA').getrecordtypeid();
       
       Map<string,Schema.RecordTypeInfo> AccRecTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
       Id RecTypeAcc = AccRecTypes.get('Franchise Location').getrecordtypeid();
       
       Account a = new Account(name='Test', recordtypeid=RecTypeAcc);
       insert a;
       
       SFDC_Job__c j = new SFDC_Job__c(job_status__c = 'test', Store__c=a.id, Specific_Candidate_Preference__c = 'No', recordtypeid=RecType, Job_Title_for_Banner__c = 'Store Sales Associate',  Banner_of_Store__c = 'PPG');
       insert j;
       
       SFDC_Candidate__c c = new SFDC_Candidate__c(name='Jeff Perron', First_Name__c='Jeff', Last_Name__c='Perron', SFDC_Candidate_Email__c=sEmail);
       insert c;
       
       SFDC_Job_Candidate__c jc = new SFDC_Job_Candidate__c(Status__c='Qualified Candidates', SFDC_Job__c=j.id, Candidate__c=c.id);
       insert jc;
       
       
       Hiring_Manager_Availability__c hm = new Hiring_Manager_Availability__c(Hiring_Managers_Store__c=a.id, Start_Date__c=sd, End_Date__c=ed, Interview_Duration__c='30');
       insert hm;
       
       Candidate_Interview__c ci = new Candidate_Interview__c(name=sEmail, Hiring_Manager_Availability__c=hm.id, Job__c=j.id, Job_Candidate__c=jc.id, Start_Date__c=sd);
       insert ci;
       
       //assert found 
       List<Candidate_Interview__c> ciL = Interview_Scheduler_Util.FindCandidateInterviewByEmailAndJobId(sEmail, j.id);
       system.assertequals(ciL.size(), 1);
       
       List<SFDC_Job_Candidate__c> jcL = Interview_Scheduler_Util.FindJobCandidateByEmailAndJobId(sEmail, j.id);
       system.assertequals(jcl.size(), 1);
       
       DateTime dtR = Interview_Scheduler_Util.FindCandidateInterviewByEmailAndJobIdAndReturnStartDate(sEmail, j.id);
       system.assertequals(dtR, sd);
       
       Id jcId = Interview_Scheduler_Util.FindJobCandidateByEmailAndJobIdAndReturnId(sEmail, j.id);
       system.assertequals(jcId, jc.Id);
       
       Interview_Scheduler_Util.SetCandidateInterviewToJobCandidate(sEmail, j.id, jc.id);
       Interview_Scheduler_Util.SendErrorEmail('Test');
       
       ci.Start_Date__c = ci.Start_Date__c.AddDays(1);
       update ci;
       
       try { //cannot  delete if job candidate associcated
           delete ci;
       }
       catch(Exception ex) { System.Assert(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));}    
     
       delete jc; //will remove candidate interview
            
    }
}