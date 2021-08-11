/******************
Class: Job Point Edit Controller tests
   
Test methods

******************/
@istest
public class JobPointNewEdit_Test{
    private static testmethod void testpg(){
     	// start page with new Job Description record showing
        ApexPages.StandardController con = new ApexPages.StandardController(new Job_Point__c());
        JobPointNewEditController ext = new JobPointNewEditController(con);
        // set job rec type to OFG
        ext.job.recordtypeid = '012U00000009QriIAE';
        ext.updateClient();
        // displayJobTitleOFG should be true
        system.assert(ext.displayJobTitleOFG);
        // set values for OFG job banner, title and points
        ext.job.OWF_Job_Title__c  = 'Job Title';
        ext.job.OWF_Banner_of_Store__c  = 'Job Banner';
        ext.jobPt.point_allocation__c = 10;
        // now call save and new
        ext.saveNew();
        job_point__c jp = [select id, job_title__c, client__c, banner_of_store__c, point_allocation__c, record_type_id__c from job_point__c limit 1];
        system.debug('job point: '+jp);
        system.assertequals(jp.Job_Title__c, 'Job Title');
        system.debug('client name: '+jp.Client__c);
        // now try cloning the one we just created
        con = new ApexPages.StandardController(jp);
        ApexPages.currentPage().getParameters().put('clone', '1');
        ext = new JobPointNewEditController(con);
        ext.job.OWF_Job_Title__c = 'cloned';
        // save newly cloned desc
        ext.save();
        job_point__c jp2 = [select id, job_title__c, client__c, banner_of_store__c, point_allocation__c, record_type_id__c from job_point__c 
                                  	where id != :jp.id limit 1];
        system.debug('job desc2: '+jp2);
        system.assertequals(jp2.Job_Title__c, 'cloned');
        // add jp for a non ofg rec type
        // get some valid job recs
        map<Id, RecordType> RecTypeMapbyID = new Map<Id, RecordType>([select id, name from recordtype where SobjectType='SFDC_Job__c' and isactive = true
                                                                     and name != 'Overwaitea Food Group']);
        RecordType RecordTypeA  = RecTypeMapbyID.values()[1];  
        ApexPages.currentPage().getParameters().put('clone', '0');        
        con = new ApexPages.StandardController(new Job_Point__c());
        ext = new JobPointNewEditController(con);
        // set job rec type to rec a
        ext.job.recordtypeid = RecordTypeA.id;
        ext.updateClient();
        // set job banner_of_store__c and job title for banner
        ext.job.banner_of_store__c = 'banner';
        ext.job.job_title_for_banner__c ='title';
        ext.save();
        job_point__c jp3 = [select id, job_title__c, client__c, banner_of_store__c, point_allocation__c, record_type_id__c from job_point__c 
                                  	where name = :Recordtypea.name+ ' - banner - title'];        
        // banner and title set properly
        system.assertequals(jp3.Job_Title__c, 'title');
        system.assertequals(jp3.banner_of_store__c, 'banner');
        // open for edit
        con = new ApexPages.StandardController(jp3);
        ext = new JobPointNewEditController(con); 
        system.assertequals(ext.job.job_title_for_banner__c, 'title');
        system.assertequals(ext.job.banner_of_store__c, 'banner');
        // one more update with no banner
        ext.job.job_title_for_banner__c = null;
        ext.job.banner_of_store__c = null;
        ext.job.Job_Title_for_Role__c = 'title for role';
        ext.save();
        jp3 = [select id, job_title__c, client__c, banner_of_store__c, point_allocation__c, record_type_id__c from job_point__c 
                                  	where id = :jp3.id];
        system.debug('checking on points record: '+jp3);
        system.assertequals(jp3.Job_Title__c, 'title for role');
        con = new ApexPages.StandardController(jp3);
        ext = new JobPointNewEditController(con);
        system.assertequals(ext.jobpt.Job_Title__c, 'title for role');
        system.assertequals(ext.jobpt.banner_of_store__c, null);        
    }

}