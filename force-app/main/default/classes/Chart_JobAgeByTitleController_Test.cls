@isTest
public class Chart_JobAgeByTitleController_Test{
    private static testmethod void testJobAgeData(){
     	// add Open/Active job to our open job status custom setting 
        Open_Job_Statuses__c opens = new Open_Job_Statuses__c(name = '1', Status_Name__c = 'Open/Active Job');
        insert opens;
        // create jobs in Open status with mgr is me set and job age in various categories grouped by job title
        // mgr is me = Yes if I am the owner or 1/2/3/4/5 Level Mgr or HR User
        // job age = now - Date Job Added or Opened, < 8 goes to 0 - 7, < 15 goes to 8 - 14, else 15+
        list<SFDC_Job__c> jobs = new list<SFDC_Job__C>();
        // j1, job title1 and age 0-7
        SFDC_Job__c j1 = new SFDC_Job__c(job_name__c = 'Test1', Job_Title_for_Role__c = 'job title1', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
     //   j1.date_job_filled__c = datetime.newInstance(date.newinstance(date.today().addmonths(-1).year(), date.today().addmonths(-1).month(), 1), Time.newInstance(13,0,0,0));
        jobs.add(j1);
        // j2 job title1 and age 8-14
        SFDC_Job__c j2 = new SFDC_Job__c(job_name__c = 'Test2', Job_Title_for_Role__c = 'job title1', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j2);        
        // j3 job title2 and age 8-14
        SFDC_Job__c j3 = new SFDC_Job__c(job_name__c = 'Test3', Job_Title_for_Role__c = 'job title2', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j3); 
        // j4 job title2 and age 15+
        SFDC_Job__c j4 = new SFDC_Job__c(job_name__c = 'Test4', Job_Title_for_Role__c = 'job title2', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j4); 
        // j5 job title3 and age 8-14
        SFDC_Job__c j5 = new SFDC_Job__c(job_name__c = 'Test5', Job_Title_for_Role__c = 'job title3', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j5); 
        // j6 job title4 and age 0-7
        SFDC_Job__c j6 = new SFDC_Job__c(job_name__c = 'Test6', Job_Title_for_Role__c = 'job title4', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j6); 
        // j7 job title5 and age 15+
        SFDC_Job__c j7 = new SFDC_Job__c(job_name__c = 'Test7', Job_Title_for_Role__c = 'job title5', Num_of_Days_for_Delivery_Agreement__c = 1, Num_of_Candidates_for_Delivery_Agreement__c = 1, 
            job_status__c = 'Open/Active Job', Specific_Candidate_Preference__c = 'No' ,MindField_Job_Type__c = 'TalentRecruit');
        jobs.add(j7);         
        insert jobs;
		// update date job added to force job age categories
        j1.Date_Job_Added_or_Opened__c = datetime.now().adddays(-3);
        j2.Date_Job_Added_or_Opened__c = datetime.now().adddays(-10);
        j3.Date_Job_Added_or_Opened__c = datetime.now().adddays(-10);
        j4.Date_Job_Added_or_Opened__c = datetime.now().adddays(-20);
        j5.Date_Job_Added_or_Opened__c = datetime.now().adddays(-10);
        j6.Date_Job_Added_or_Opened__c = datetime.now().adddays(-3);
        j7.Date_Job_Added_or_Opened__c = datetime.now().adddays(-19);
        update jobs;
        jobs = [select id, chart_job_Title__c, job_age_days__c, Date_Job_Added_or_Opened__c, name from SFDC_Job__c where id in :jobs];
        system.debug('jobs after update; '+jobs);
        // start controller and pass in job titles plus an extra
        Chart_JobAgeByTitleController con = new Chart_JobAgeByTitleController ();
        con.jobTitlesFromPage = 'job title1,job title2,job title3,job title4,job title5,job title6';
        // should have set the jobTitles array with each item
        system.assertequals(con.jobTitles.size(), 6);
        system.assertequals(con.jobTitles[0], 'job title1');
        // call data method to run through aggregation
        List<Chart_JobAgeByTitleController.JobAgeForTitle> res = con.getJobAgeByTitleData();
        // should have 3 rows, one for each bracket
        system.assertequals(res.size(), 3);
        system.assertequals(con.getJobAgeByTitleData_Size(), 3);
		// cycle through counts per bracket        
        for (Chart_JobAgeByTitleController.JobAgeForTitle r : res) {
            if (r.bracketname == '0 - 7') {
            	system.assertequals(r.jobtitle1, 1);
                system.assertequals(r.jobtitle2, 0);
                system.assertequals(r.jobtitle3, 0);
                system.assertequals(r.jobtitle4, 1);
                system.assertequals(r.jobtitle5, 0);
                system.assertequals(r.jobtitle6, 0);
                system.assertequals(r.jobtitle7, 0);
            }
            else if (r.bracketname == '8 - 14') {
            	system.assertequals(r.jobtitle1, 1);
                system.assertequals(r.jobtitle2, 1);
                system.assertequals(r.jobtitle3, 1);
                system.assertequals(r.jobtitle4, 0);
                system.assertequals(r.jobtitle5, 0);
                system.assertequals(r.jobtitle6, 0);
                system.assertequals(r.jobtitle7, 0);
            }
            else if (r.bracketname == '15+') {
            	system.assertequals(r.jobtitle1, 0);
                system.assertequals(r.jobtitle2, 1);
                system.assertequals(r.jobtitle3, 0);
                system.assertequals(r.jobtitle4, 0);
                system.assertequals(r.jobtitle5, 1);
                system.assertequals(r.jobtitle6, 0);
                system.assertequals(r.jobtitle7, 0);
            }            
    	}
        // get legend returns string with all job titles listed, same as passed in
        system.assertequals(con.getJobTitleLegend(), 'job title1,job title2,job title3,job title4,job title5,job title6');
        // get fields reutns string with jobTitlex up to number of titles passed in
        system.assertequals(con.getJobTitleFields(), 'jobTitle1,jobTitle2,jobTitle3,jobTitle4,jobTitle5,jobTitle6');

    }
}