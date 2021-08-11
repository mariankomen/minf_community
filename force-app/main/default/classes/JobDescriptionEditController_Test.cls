/******************
Class: Job Description Edit Controller, extension for VF Job Description Edit
Description:  Dynamically show/hide the relevant job Title field based on the selected record type.  To leverage job field dependencies and record types we are using a 
    shell Job record and then moving selected details into the Job Description record upon save.
    
Test methods

******************/
@istest
public class JobDescriptionEditController_Test{
    private static testmethod void testpg(){
     	// start page with new Job Description record showing
        ApexPages.StandardController con = new ApexPages.StandardController(new Job_Description__c());
        JobDescriptionEditController ext = new JobDescriptionEditController(con);
        // set job rec type to OFG
        ext.job.recordtypeid = '012U00000009QriIAE';
        ext.updateClient();
        // displayJobTitleOFG should be true and others false
        system.assert(ext.displayJobTitleOFG);
        system.assert(!ext.displayJobTitle);
        // use rec type that uses Job Banner field - COBS
        ext.job.recordtypeid = '012U00000009QqaIAE';
        ext.updateClient();
        // displayJobTitleOFG should be true and others false
        system.assert(ext.displayJobBanner);
        system.assert(!ext.displayJobTitle); 
        // set values for job banner, title and desc
        ext.job.Job_Title_for_Banner__c = 'Job Title';
        ext.job.banner_of_store__c = 'Job Banner';
        ext.jobDesc.job_description__c = 'sample default description';
        // now call save and new
        ext.saveNew();
        job_description__c jd = [select id, job_title__c, client__c, banner_of_store__c, job_description__c, record_type_id__c from job_description__c limit 1];
        system.debug('job desc: '+jd);
        system.assertequals(jd.Job_Title__c, 'Job Title');
        system.debug('client name: '+jd.Client__c);
        // now try cloning the one we just created
        con = new ApexPages.StandardController(jd);
        ApexPages.currentPage().getParameters().put('clone', '1');
        ext = new JobDescriptionEditController(con);
        ext.jobDesc.job_description__c = 'cloned';
        // save newly cloned desc
        ext.save();
        job_description__c jd2 = [select id, job_title__c, client__c, banner_of_store__c, job_description__c, record_type_id__c from job_description__c 
                                  	where id != :jd.id limit 1];
        system.debug('job desc2: '+jd2);
        system.assertequals(jd2.Job_Title__c, 'Job Title');
    }
}