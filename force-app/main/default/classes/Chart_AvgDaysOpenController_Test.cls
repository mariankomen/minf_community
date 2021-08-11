@isTest
public class Chart_AvgDaysOpenController_Test{
    private static testmethod void testAvgDaysData(){
        // create jobs with title and date job filled from last month with mgr is me set and time to send/time to decide set
        // mgr is me = Yes if I am the owner or 1/2/3/4/5 Level Mgr or HR User
        // time to send: date candidates sent - date job added or opened (set to 1pm next business day)
        // time to decide: Date_Job_Filled__c - Date_Candidates_Sent__c
        list<SFDC_Job__c> jobs = new list<SFDC_Job__C>();
        SFDC_Job__c j1 = new SFDC_Job__c(job_name__c = 'Test1', Job_Title_for_Role__c = 'job title', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j1);
        SFDC_Job__c j2 = new SFDC_Job__c(job_name__c = 'Test2', Job_Title_for_Role__c = 'job title', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j2); 
        SFDC_Job__c j3 = new SFDC_Job__c(job_name__c = 'Test3', Job_Title_for_Role__c = 'job title', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j3);
        SFDC_Job__c j4 = new SFDC_Job__c(job_name__c = 'Test4', Job_Title_for_Role__c = 'job title2', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j4); 
        SFDC_Job__c j5 = new SFDC_Job__c(job_name__c = 'Test4', Job_Title_for_Role__c = 'job title2', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j5);
        insert jobs;
        // j1/2/3 are job title, all in previous month
        // update date job added to 1st of last month
        j1.Date_Job_Added_or_Opened__c = datetime.newInstance(date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1), Time.newInstance(13,0,0,0));
        // sent 5 days later
        j1.Date_Candidates_Sent__c = j1.Date_Job_Added_or_Opened__c.adddays(5);
        // filled 10 days after that
        j1.Date_Job_Filled__c = j1.Date_Candidates_Sent__c.adddays(10);
        j1.Job_Status__c = 'Filled Closed Job';
        // j2 will be 10/15
        j2.Date_Job_Added_or_Opened__c = datetime.newInstance(date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1), Time.newInstance(13,0,0,0));
        j2.Date_Candidates_Sent__c = j2.Date_Job_Added_or_Opened__c.adddays(10);
        j2.Date_Job_Filled__c = j2.Date_Candidates_Sent__c.adddays(15);
        j2.Job_Status__c = 'Filled Closed Job';
        // j3 will be 5/20
        j3.Date_Job_Added_or_Opened__c = datetime.newInstance(date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1), Time.newInstance(13,0,0,0));
        j3.Date_Candidates_Sent__c = j3.Date_Job_Added_or_Opened__c.adddays(5);
        j3.Date_Job_Filled__c = j3.Date_Candidates_Sent__c.adddays(20);
        j3.Job_Status__c = 'Filled Closed Job';
        // j4/5 are job title2, make j5 filled 2 months ago and not included
        // j4 is 5/20
        j4.Date_Job_Added_or_Opened__c = datetime.newInstance(date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1), Time.newInstance(13,0,0,0));
        j4.Date_Candidates_Sent__c = j4.Date_Job_Added_or_Opened__c.adddays(5);
        j4.Date_Job_Filled__c = j4.Date_Candidates_Sent__c.adddays(20);        
        j4.Job_Status__c = 'Filled Closed Job';
        // j5 is 2 months ago, not included
        j5.Date_Job_Added_or_Opened__c = datetime.newInstance(date.newinstance(date.today().addmonths(-2).year(), date.today().addmonths(-2).month(), 1), Time.newInstance(13,0,0,0));
        j5.Date_Candidates_Sent__c = j5.Date_Job_Added_or_Opened__c.adddays(10);
        j5.Date_Job_Filled__c = j5.Date_Candidates_Sent__c.adddays(15); 
        j5.Job_Status__c = 'Filled Closed Job';
        update jobs;
        jobs = [select id, chart_job_title__c, TTS_Time_to_Send_Numerical__c, TTS_Time_to_Decide_by_Store_Numerical__c, date_job_filled__c, Date_Candidates_Sent__c,
                Date_Job_Added_or_Opened__c, manager_is_me__c from SFDC_Job__c where id = :jobs];
        system.debug('job values: '+jobs);
        // call controller
        Chart_AvgDaysOpenController con = new Chart_AvgDaysOpenController();
        for (Chart_AvgDaysOpenController.AvgDaysData d : con.getAvgDaysData()) {
            // if job title 1, avg time to send = 5+10+5 / 3 =   6.66 and avg time to decide = 10 + 15 + 20 / 3=15
      /*      if (d.jobtitle == 'job title') {
                system.assertequals(d.timetosend.round(), 7);
                system.assertequals(d.sendtoclose.round(), 15);
            }
            else if (d.jobtitle == 'job title2') {
                system.assertequals(d.timetosend.round(), 5);
                system.assertequals(d.sendtoclose.round(), 20);
            }
      */  }
        system.assertequals(con.getAvgDaysData_Size(), 2);
    }
}