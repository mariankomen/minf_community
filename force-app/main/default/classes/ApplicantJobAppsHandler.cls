/**
* Class ApplicantJobAppsHandler
*
* Trigger Handler for the Applicant_Job_Apps__c sObject. This class implements the TriggerInterface
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public without sharing class ApplicantJobAppsHandler implements TriggerInterface {
    public map<string, string> mapping = new map<string, string>();
    public map<string, string> APPLICANT_TO_CANDIDATERECORD; 
    public map<string, string> APPLICANTAPP_TO_JOBCANDIDATE; 
    public Map<Id,Applicant__c> applicantMap;
    public Map<Id,SFDC_Candidate__c> candidateTobeInsert;
    private static final string JOB_APP_STATUS = 'Presented';
    private static final string CANDIDATE_STATUS = 'Qualified Candidates';
    public list<SFDC_Job_Candidate__c> updateTheseCandidates = new list<SFDC_Job_Candidate__c> ();
    public List<Talemetry_Logger__c> loggerList = new List<Talemetry_Logger__c>();
    
    public Map<Id,Applicant_Job_Apps__c> QualifiedJobApps;
    public map<id, SFDC_Job_Candidate__c > candidateMAP;
    private static final map<string,string> JobAPP_STATUS_TO_CANDIDATE = new map<string,string> {
                                                                                                    'Accepted'=>'Hired',
                                                                                                    'Rejected by HM'=>'Rejected'
                                                                                                };
    Public Id RecruitmentRecId = Schema.SObjectType.SFDC_Job_Candidate__c.getRecordTypeInfosByName().get('Recruitment').getRecordTypeId();  
    // Constructor
    public ApplicantJobAppsHandler(){  
        APPLICANT_TO_CANDIDATERECORD = new map<string, string>();
        APPLICANTAPP_TO_JOBCANDIDATE = new map<string, string>();
        applicantMap = new Map<Id,Applicant__c>();
        candidateTobeInsert = new Map<Id,SFDC_Candidate__c>();
        QualifiedJobApps = new Map<Id,Applicant_Job_Apps__c>();
        candidateMAP = new Map<id,SFDC_Job_Candidate__c>();
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){ }
    
    public void bulkAfter() { 

        for (Candidate_field_mapping__mdt fm : [select source_field__c, target_field__c,direction__c from Candidate_field_mapping__mdt])
        {   
            if(fm.direction__c == 'Applicant->Candidate'){
                APPLICANT_TO_CANDIDATERECORD.put(fm.source_field__c, fm.target_field__c);
            }else if(fm.direction__c == 'ApplicantJobApp->Job Candidate'){
                APPLICANTAPP_TO_JOBCANDIDATE.put(fm.source_field__c, fm.target_field__c);
            }         
        }
        
        Set<Id> setOfApplicants = new Set<Id>();
        set<id> setOfCandidates = new set<id>();
        for(Applicant_Job_Apps__c ja : (List<Applicant_Job_Apps__c>) Trigger.new){
            setOfApplicants.add(ja.Applicant__c);
            if(ja.Candidate_Link_to_HirePortal_Record__c <> null){
                setOfCandidates.add(ja.Candidate_Link_to_HirePortal_Record__c);
            }
        }
        
        string query = 'select ' + buildQuery(APPLICANT_TO_CANDIDATERECORD.keySet() , null ) + ' from Applicant__c where id in : setOfApplicants' ;                
        
        
        for ( Applicant__c a :  database.query(query) )
        {
            applicantMap.put(a.Id,a); 
        }
        
        if(Trigger.isUpdate){
            candidateMAP = new map<id, SFDC_Job_Candidate__c >( [select id from SFDC_Job_Candidate__c where id in : setOfCandidates ]);
        }

    }
    
    private static string buildQuery(set<string> fields , list<string> fixedFields)
    {        
        list<string> allfields = new list<string>();
            allfields.addall(fields);
        
        if (fixedFields!=null )
            allfields.addAll(fixedFields) ;
        
        return string.join( allfields , ',' );         
       
    }
    
    public void beforeInsert(SObject so){ }
    
    public void beforeUpdate(SObject oldSo, SObject so){ }
    
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){ }
    Map<id, SFDC_Job_Candidate__c> applicantApp_JobCandidateMAP = new Map<id, SFDC_Job_Candidate__c>();
    public void afterInsert(SObject so) { 
        Applicant_Job_Apps__c jobApps = (Applicant_Job_Apps__c)so;
        
        if(jobApps.Status__c ==JOB_APP_STATUS && jobApps.Candidate_Link_to_HirePortal_Record__c==null && applicantMAP.containsKey(jobApps.Applicant__c)){
            Applicant__c app = applicantMAP.get(jobApps.Applicant__c);
            SFDC_Candidate__c c = new SFDC_Candidate__c();
                
            for ( string source_field :  APPLICANT_TO_CANDIDATERECORD.keySet())
            {
                c.put( APPLICANT_TO_CANDIDATERECORD.get(source_field) , app.get(source_field) );
            }
            c.Recruiter_Summary_on_Candidate__c = jobApps.Recruiter_Submission_Comments__c;
            candidateTobeInsert.put(app.Id,c);
            
            //--------------------------------//
            QualifiedJobApps.put(jobApps.id,jobApps);
            
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        Applicant_Job_Apps__c jobApps = (Applicant_Job_Apps__c)so;
        Applicant_Job_Apps__c oldJobApps = (Applicant_Job_Apps__c) oldSo;
        
        if (jobApps.Status__c != oldJobApps.Status__c){
            System.debug('jobApps.Applicant__c..>>>>  '+jobApps.Applicant__c);
            //TalemetryCandidateAsync.asyncUpsertCandidate(jobApps.Applicant__c);
            Talemetry_Logger__c tl = new Talemetry_Logger__c();
            tl = TalemetryParseResponseUtil.getLogging('Trigger ApplicantJobAppsHandler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Applicant_Id__c = jobApps.Applicant__c;
            tl.Source_Id__c = jobApps.Id;
            loggerList.add(tl);
            TriggerFactory.isTriggerExecuted = true;
        }
        System.debug('applicantMAP.containsKey(jobApps.Applicant__c) : '+applicantMAP.containsKey(jobApps.Applicant__c));
        if(jobApps.Status__c ==JOB_APP_STATUS && jobApps.Status__c <> oldJobApps.Status__c  && jobApps.Candidate_Link_to_HirePortal_Record__c==null && applicantMAP.containsKey(jobApps.Applicant__c)){
            Applicant__c app = applicantMAP.get(jobApps.Applicant__c);
            SFDC_Candidate__c c = new SFDC_Candidate__c();
                
            
            for ( string source_field :  APPLICANT_TO_CANDIDATERECORD.keySet())
            {
                System.debug('candidate mapping  : '+APPLICANT_TO_CANDIDATERECORD.get(source_field)+' value   : '+app.get(source_field));
                c.put( APPLICANT_TO_CANDIDATERECORD.get(source_field) , app.get(source_field) );
            }
            c.Recruiter_Summary_on_Candidate__c = jobApps.Recruiter_Submission_Comments__c;
            candidateTobeInsert.put(app.Id,c);
            
            //--------------------------------//
            QualifiedJobApps.put(jobApps.id,jobApps);
            
        }
        
        if(candidateMAP.containsKey( jobApps.Candidate_Link_to_HirePortal_Record__c )){
            SFDC_Job_Candidate__c candidate =  candidateMAP.get( jobApps.Candidate_Link_to_HirePortal_Record__c );
            boolean foundChanges=false;
            // check if any field get changed 
            for ( string source_field : APPLICANTAPP_TO_JOBCANDIDATE.keyset() )
            {           
                if ( jobApps.get(source_field)!=null &&  jobApps.get(source_field) != oldJobApps.get(source_field)  )      
                {
                    System.debug('source_field : '+source_field +' jobApps.get(source_field) : '+jobApps.get(source_field));
                    if ( source_field.equalsIgnoreCase('status__c') && JobAPP_STATUS_TO_CANDIDATE.containsKey((string)jobApps.get(source_field)) )
                        candidate.put( APPLICANTAPP_TO_JOBCANDIDATE.get(source_field) , JobAPP_STATUS_TO_CANDIDATE.get((string)jobApps.get(source_field))  );                                                       
                    else if(source_field.equalsIgnoreCase('Accepted_Date_Time__c') || source_field.equalsIgnoreCase('Rejected_Date_Time__c') || source_field.equalsIgnoreCase('Date_Candidate_Sent__c')){ 
                        candidate.put( APPLICANTAPP_TO_JOBCANDIDATE.get(source_field) , Date.valueOf(jobApps.get(source_field)) );  
                    }else{
                        candidate.put( APPLICANTAPP_TO_JOBCANDIDATE.get(source_field) , jobApps.get(source_field) );
                    }                               
                    foundChanges=true;
                }
            }
            
            if (foundChanges)
            {
                updateTheseCandidates.add(candidate);
            }
        }
        
         
    }
    
    public void afterDelete(SObject so){ }
    
    public void afterUndelete(SObject so){ }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        if(!candidateTobeInsert.isEmpty()){
            insert candidateTobeInsert.values();
        }
        
        if(!QualifiedJobApps.isEmpty()){
            for(Applicant_Job_Apps__c ja : QualifiedJobApps.values()){
                SFDC_Job_Candidate__c jc = new SFDC_Job_Candidate__c();
                jc.Candidate__c = candidateTobeInsert.get(ja.Applicant__c).id;
                jc.SFDC_Job__c = ja.Job__c;
                for (String source_field :  APPLICANTAPP_TO_JOBCANDIDATE.keySet()) {
                    System.debug('mapping  : '+APPLICANTAPP_TO_JOBCANDIDATE.get(source_field)+' value   : '+ja.get(source_field));
                    if(source_field.equalsIgnoreCase('Rejected_Date_Time__c') || source_field.equalsIgnoreCase('Accepted_Date_Time__c') || source_field.equalsIgnoreCase('Presented_Date_Time__c')){
                        jc.put( APPLICANTAPP_TO_JOBCANDIDATE.get(source_field) , Date.valueOf(ja.get(source_field)) );
                    } else {
                        jc.put( APPLICANTAPP_TO_JOBCANDIDATE.get(source_field) , ja.get(source_field) );
                    }
                }
                
                jc.Status__c = CANDIDATE_STATUS;
                if(RecruitmentRecId <> null)jc.RecordTypeId = RecruitmentRecId;
                applicantApp_JobCandidateMAP.put(ja.id, jc);
                System.debug('jc : '+jc);
            }
        }
        
        if(!applicantApp_JobCandidateMAP.isEmpty()){
            insert applicantApp_JobCandidateMAP.values();
            System.debug('applicantApp_JobCandidateMAP : '+applicantApp_JobCandidateMAP.values());
            
            List<Applicant_Job_Apps__c> updateTheseJobApps = new List<Applicant_Job_Apps__c>();
            Map<Id, Id> ApplicantCandidateMAP = new Map<Id,Id>();
            for ( Applicant_Job_Apps__c ja : QualifiedJobApps.values()){            
                updateTheseJobApps.add(  new Applicant_Job_Apps__c ( id = ja.id, Candidate_Link_to_HirePortal_Record__c = applicantApp_JobCandidateMAP.get(ja.id).id )  ) ;
                ApplicantCandidateMAP.put(ja.Applicant__c, applicantApp_JobCandidateMAP.get(ja.id).Candidate__c);
            }
    
            update updateTheseJobApps;
            
            
            //used for tracking file upload
            Map<Id,Id> candidateJobCandidateMap = new Map<Id,Id>();
            for(SFDC_Job_Candidate__c jc:applicantApp_JobCandidateMAP.values()){
                candidateJobCandidateMap.put(jc.Candidate__c, jc.Id);
            }
            
            //Content Document Link Start
            Set<Id> contentDocumentIds = new Set<Id>();
            List<ContentDocumentLink> documentLinkList = new List<ContentDocumentLink>();
            String objectName;
            
            for(ContentDocumentLink cdl: [SELECT Id, LinkedEntityId, ShareType, ContentDocumentId, Visibility, ContentDocument.Title FROM ContentDocumentLink where LinkedEntityId in : applicantApp_JobCandidateMAP.keySet() OR LinkedEntityId IN: ApplicantCandidateMAP.keyset()]){
                objectName =  cdl.LinkedEntityId.getSObjectType().getDescribe().getName().toLowerCase();
                if (objectName == 'applicant_job_apps__c' && cdl.ContentDocument.Title.containsIgnoreCase('Phone Screen')){
                    contentDocumentIds.add(cdl.ContentDocumentId);
                    documentLinkList.add(cdl);
                } else if(objectName == 'applicant__c') {
                    contentDocumentIds.add(cdl.ContentDocumentId);
                    documentLinkList.add(cdl);
                }
            }
            
            if(!contentDocumentIds.isEmpty()){
                // get the existing document links
                Map<Id, Set<Id> > filesShares = new Map<Id, Set<Id>> ();
                Set<Id> tempCdlIdsSet = new Set<Id>();
                for(ContentDocumentLink cdl : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN: contentDocumentIds ]  )
                {
                    tempCdlIdsSet = new Set<Id>();
                    if (filesShares.containskey(cdl.ContentDocumentId))            
                        tempCdlIdsSet = filesShares.get(cdl.ContentDocumentId);
                    tempCdlIdsSet.add(cdl.LinkedEntityId);
                    filesShares.put(cdl.ContentDocumentId,tempCdlIdsSet);
                }
                
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                Id targetId;
                for (ContentDocumentLink cdl : documentLinkList) {
                    if(applicantApp_JobCandidateMAP.containsKey(cdl.LinkedEntityId)){
                        targetId = (applicantApp_JobCandidateMAP.get(cdl.LinkedEntityId)).Candidate__c;
                    } else if (ApplicantCandidateMAP.containsKey(cdl.LinkedEntityId)){
                        targetId = (ApplicantCandidateMAP.get(cdl.LinkedEntityId));
                    }
                    
                    if(targetId!=null){
                        
                        if (filesShares.containskey(cdl.ContentDocumentId) && filesShares.get(cdl.ContentDocumentId).contains(targetId))    
                            continue;
                        
                        // share the file with SFDC_Candidate__c related record
                        ContentDocumentLink new_cdl = new ContentDocumentLink();
                        new_cdl.ContentDocumentId   = cdl.ContentDocumentId;
                        new_cdl.LinkedEntityId      = targetId;
                        new_cdl.ShareType           = 'V';
                        new_cdl.Visibility          = 'AllUsers';
                        cdlList.add(new_cdl);
                        candidateJobCandidateMap.remove(targetId);
                    }
                }
                
                if(!cdlList.isEmpty()){
                    insert cdlList;
                }
            }
            
            if(!candidateJobCandidateMap.isEmpty()){
                //update all candidates without file (resume or phone_screen)
                List<SFDC_Job_Candidate__c> candidateWithoutFiles = new List<SFDC_Job_Candidate__c>();
                SFDC_Job_Candidate__c can;
                for(Id canId:candidateJobCandidateMap.values()){
                    if(canId!=null){
                        can = new SFDC_Job_Candidate__c(Id=canId);
                        can.No_File_Found__c = true;
                        candidateWithoutFiles.add(can);
                    }
                }
                
                if(!candidateWithoutFiles.isEmpty()){
                    update candidateWithoutFiles;
                }
            }
            //Content Document Link End
            /*
            System.debug('applicantApp_JobCandidateMAP.keySet() : '+applicantApp_JobCandidateMAP.keySet());
            List<ContentDocumentLink> cList = [select id,LinkedEntityId, ShareType, ContentDocumentId, Visibility from ContentDocumentLink where LinkedEntityId in : applicantApp_JobCandidateMAP.keySet()];
            System.debug('cList : '+cList.size());
            if(!cList.isEmpty())
            ContentDocumentLinkTriggerHandler.shareFileAppJobApps( cList);
            
             cList = [select id,LinkedEntityId, ShareType, ContentDocumentId, Visibility from ContentDocumentLink where LinkedEntityId in :  ApplicantCandidateMAP.keyset() ];
            System.debug('shareFileApplicants cList : '+cList);
            if(!cList.isEmpty())
            ContentDocumentLinkTriggerHandler.shareFileApplicants(cList, new set<id>( ApplicantCandidateMAP.values())  ); 
            */
            
        }
        
        
        
        if(!updateTheseCandidates.isEmpty()){
            update updateTheseCandidates;
        }
        if(!loggerList.isEmpty()){
            insert loggerList;
        }
    }
}