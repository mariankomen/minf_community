/************************
Trigger: Job Broadcast Link AFter insert
Description:
    replaces workflow rule on since Job Braodcast that set the Job's Date Job Last Posted/Refreshed to today when a JB not linked to
        the Job Board of 'Job Shop' was created.
        
Created: Niki Vankerk, Sept 9/12
Modification Log:

Oct 5, 2016
We no longer need the object, Job_Broadcasting_Link.
Deactivate this trigger as part of data cleanup initiative.
SF Data Limitation

************************/
trigger JBLink_AfterInsert on Job_Broadcasting_Link__c (after insert) {
    // list of Jobs to update
    Map<Id, SFDC_Job__c> jobs = new Map<Id, SFDC_Job__c>();
    // grab map of JB Link Id to JB so we can access the JB's Job Board setting in our if statement
    Map<Id, Job_Broadcasting_Link__c> JBLs = new Map<Id, Job_Broadcasting_Link__c>([select id, job_broadcasting__r.job_board__c 
            from Job_Broadcasting_Link__c where id in :trigger.new]);
    
    // cycle through JB Links and set Job date if Job Board <> 'Job Shop'
    for (Job_Broadcasting_Link__c jb : trigger.new) {
        //system.debug('jbs job board value: '+JBLs.get(jb.id).job_broadcasting__r.job_board__c);
        if (JBLs.containskey(jb.id) && JBLs.get(jb.id).job_broadcasting__r.job_board__c != 'Job Shop')
            jobs.put(jb.job__c, new SFDC_Job__c(id = jb.job__c, Date_Job_Last_Posted_Refreshed__c = date.today()));
    }
    // if there are jobs to update, do so now
    if (jobs.size() > 0)
        update jobs.values();
}