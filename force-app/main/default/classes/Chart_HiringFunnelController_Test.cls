@istest
public class Chart_HiringFunnelController_Test{
    private static testmethod void testHiringFunnelData(){
        // create jobs with mgr is me set and then candidates against the job with Hire_Date__c = last_month or Date_Candidate_Rejected__c = last month
        // mgr is me = Yes if I am the owner or 1/2/3/4/5 Level Mgr or HR User
        list<SFDC_Job__c> jobs = new list<SFDC_Job__C>();
        SFDC_Job__c j1 = new SFDC_Job__c(job_name__c = 'Test1', Job_Title_for_Role__c = 'job title', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j1);
        insert jobs;
        // add 3 candidates to job 
        List<SFDC_Candidate__c> cans = new list<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c(first_name__c = 'test', last_name__c = 'testlast', SFDC_candidate_email__c = 'testlast@test.com');
        cans.add(can1);
        SFDC_Candidate__c can2 = new SFDC_Candidate__c(first_name__c = 'test2', last_name__c = 'testlast', SFDC_candidate_email__c = 'testlast@test.com');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c(first_name__c = 'test3', last_name__c = 'testlast', SFDC_candidate_email__c = 'testlast@test.com');
        cans.add(can3); 
        insert cans;
        // add candidates to job: 1 only sent then rejected, 1 with interviewed date then rejected, 1 with interviewed and hired dates
        list<SFDC_Job_Candidate__c> jcs = new list<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c(status__c = 'Rejected', sfdc_job__c = j1.id, candidate__c = can1.id);
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c(status__c = 'Rejected', sfdc_job__c = j1.id, candidate__c = can2.id, Date_Candidate_Sent__c = date.today().adddays(-15),
                                         interview_date__c = date.today().adddays(-10));
        jcs.add(jc2);
        SFDC_Job_Candidate__c jc3 = new SFDC_Job_Candidate__c(status__c = 'Hired', sfdc_job__c = j1.id, candidate__c = can3.id, Date_Candidate_Sent__c = date.today().adddays(-15),
                                         interview_date__c = date.today().adddays(-10) );
        jcs.add(jc3);
        insert jcs;
        jcs = [select id, date_candidate_sent__c, status__c, Hire_Date__c, Date_Candidate_Rejected__c, interview_date__c , Candidate_Sent__c, Candidate_Interviewed__c, Hired__c from SFDC_Job_Candidate__c 
            where id in :jcs];
        // need to push hire/reject dates back by a month
        // set all to be Sent at the beginning of last month
        jc1.Date_Candidate_Sent__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1);
        jc2.Date_Candidate_Sent__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1);
        jc3.Date_Candidate_Sent__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1);
        // set rejected for both 1/2 to 25th of last month
        jc1.Date_Candidate_Rejected__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 25);
        jc2.Date_Candidate_Rejected__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 25);
        // set hired date for 3 to 26th of last month
        jc3.Hire_Date__c = date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 26);
        jcs.clear();
        jcs.add(jc1);jcs.add(jc2);jcs.add(jc3);
        update jcs;
        jcs = [select id, date_candidate_sent__c, status__c, Hire_Date__c, Date_Candidate_Rejected__c, interview_date__c , Candidate_Sent__c, Candidate_Interviewed__c, Hired__c from SFDC_Job_Candidate__c 
            where id in :jcs];        
        system.debug('candidates data: '+jcs);
        // call controller
        Chart_HiringFunnelController con = new Chart_HiringFunnelController();
        for (Chart_HiringFunnelController.HiringFunnel f : con.getHiringFunnelData()) {
            // 3 sent, 2 interviewed, 1 hired
            if (f.name == 'Sent') system.assertequals(f.recCount, 3);
            else if (f.name == 'Interviewed') system.assertequals(f.recCount, 2);
            else if (f.name == 'Hired') system.assertequals(f.recCount, 1);
        }
        // only 3 rows
        system.assertequals(con.getHiringFunnelData_Size(), 3);
        
    }

}