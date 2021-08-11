global class TalemetryProcessLoggerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable,Database.stateful {
    public static String CRON_EXPR =  '0 15 * * * ?' ;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id, Applicant_Id__c,Status__c,Job_Id__c,WebService__c FROM Talemetry_Logger__c where (Applicant_Id__c <> null Or Job_Id__c <> null) and WebService__c like \'Trigger%\'and Status__c <> \'Processed\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Object> scope) {
        List<Talemetry_Logger__c> LoggerList = new List<Talemetry_Logger__c>();
        Set<String> JobIds = new Set<String>();
        try {
            for(Object s : scope) {  
                Talemetry_Logger__c tl =  (Talemetry_Logger__c) s;  
                tl.Status__c = 'Processed'; 
                tl.Processed__c = true;
                LoggerList.add(tl);
                if(tl.Applicant_Id__c <> null){
                    // Update the Logger Status 
                    //System.debug('tl.Status__c..>> '+tl.Status__c);
                    
                    //Call UpsertCandidate
                    String upsertCandidatePayload = TalemetryParseResponseUtil.upsertCandidatePayload(tl.Applicant_Id__c);
                    //System.debug('upsertCandidatePayload..>>> '+upsertCandidatePayload);
                    TalemetryCandidateAsync.asyncUpsertCandidate(upsertCandidatePayload, tl.Applicant_Id__c);
                }
                else if (tl.Job_Id__c <> null){
                    JobIds.add(tl.Job_Id__c);
                }
                
            }
            //System.debug('LoggerList ..>> '+LoggerList.size());
            // Update the Logger Record
            System.debug('JobIds >>'+JobIds);
            for( Sfdc_Job__c job : [Select Id,Job_Status__c,Job_Title__c,Recruiter_Assigned__c, Name,Link_to_Career_Site_Posting__c,Career_Site_Language__c,Job_Owner_Alias__c,Location_Store_Country__c,Location_Store_Postal_Code_Zip_Code__c,Location_Store_Province_State__c,Location_Store_City__c,Location_Store_Address__c,FT_or_PT__c,Job_Description__c,Hot_Job__c,Job_Role__c,Job_Category__c,Client_Career_Site__c,Online_Posting__c from Sfdc_Job__c where Id IN : JobIds ]){
                System.debug('job >'+ job);
                if(
                    job.Job_Status__c == 'Open/Active Job' ||
                    job.Job_Status__c == 'Open/Active Job - Talent Connect' ||
                    job.Job_Status__c == 'Open/Active Job for New Store' ||
                    job.job_status__c == 'Additional Candidate(s) Required'
                ) {
                    System.debug('inside if');
                    TalemetryGateway.apiCallout(Json.serialize(job), false);
                }
                else if(
                    job.Job_Status__c == 'Filled Closed Job' ||
                    job.Job_Status__c == 'Filled Internally Closed Job' ||
                    job.Job_Status__c == 'Not Filled/Closed by Mgr' ||
                    job.Job_Status__c == 'Filled Closed Job for New Store' ||
                    job.Job_Status__c == 'Filled Internally Closed Job for New Store' ||
                    job.Job_Status__c == 'Not Filled/Closed by Mgr for New Store' ||
                    job.Job_Status__c == 'Implementation/Job Discovery' ||
                    job.Job_Status__c == 'Job Awaiting Approval' ||
                    job.Job_Status__c == 'Job On Hold' ||
                    job.Job_Status__c == 'Pending Order' ||
                    job.Job_Status__c == 'Not Filled/Job Re-opened'
                    
                ) {
                    TalemetryGateway.apiCallout(Json.serialize(job), true);
                    
                }
                
            }
            if(!LoggerList.isEmpty()) {
                update LoggerList;
            }
            
        } catch(Exception e) {
            System.debug('exception occured : '+e.getMessage() + ' @line..>> '+e.getLineNumber());
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    global void execute(SchedulableContext ctx){
        Integer count = [select count() from asyncapexjob where status = 'Processing' and apexclass.name = 'TalemetryProcessLoggerBatch'];
        if(count == 0) {
            TalemetryProcessLoggerBatch plb  = new TalemetryProcessLoggerBatch();
            Database.executeBatch(plb,1);            
        }
    }
    
    global static string scheduleJob(){
        List<CronTrigger> jobList = [SELECT Id,
                                     CronJobDetail.Name,
                                     CronJobDetail.Id,
                                     State
                                     FROM CronTrigger 
                                     where CronJobDetail.Name Like '%TalemetryProcessLoggerBatch%'
                                     AND State !='COMPLETE'];
        TalemetryProcessLoggerBatch job  = new TalemetryProcessLoggerBatch();
        if(jobList.isEmpty()){
            for(Integer i=1; i < 11 ; i++){
                CRON_EXPR =  '0 '+5*i+' * * * ?' ;
                System.Schedule('TalemetryProcessLoggerBatch Job '+i,CRON_EXPR,job);
            }
        }
        return null;
    }
    
    
}