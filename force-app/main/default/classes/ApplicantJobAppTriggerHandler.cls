/*==============================================================================
 * Author 		: Henry Caballero | floatintotheclouds
 * Date			: 5/6/2020
 * Description	: Jira Issue => MFG-128, MFG-129, MFG-149
 * Changes		: HC | 6/30/2020 | MFG-210
 * ===========================================================================*/
public class ApplicantJobAppTriggerHandler 
{
    private List<Applicant_Job_Apps__c  > QualifiedJobApps;
    
    public static boolean isCreatingCandidateRecord = false;
    public static boolean isSyncCandidateToJobApp=false;
    public static boolean isSyncJobAppToCandidate=false;
    
	private static final string JOB_APP_STATUS = 'Presented';
    private static final string CANDIDATE_STATUS = 'Qualified Candidates';
    public  map<string, string> APPLICANT_TO_CANDIDATERECORD; 
	public  map<string, string> APPLICANTAPP_TO_JOBCANDIDATE; 
	private map <id, SFDC_Candidate__c> applicantMAP;
    private map <id, SFDC_Job_Candidate__c> applicantApp_JobCandidateMAP;
    private map<String, Schema.SObjectField> sourceFieldsDescribe;
    private map<String, Schema.SObjectField> targetFieldsDescribe;
    private static final map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
    private static final map<string,string>	JobAPP_STATUS_TO_CANDIDATE = new map<string,string> {
        																							'Accepted'=>'Hired',
        																							'Rejected by HM'=>'Rejected'
        																						};
        
   	public void run(List<Applicant_Job_Apps__c  > JobApps,  map<id, Applicant_Job_Apps__c> JobAppsOld,  System.TriggerOperation triggerEvent ) 
    {                                  
        switch on triggerEvent 
        {         
            when AFTER_INSERT
            {
             	createCandidateRecord(JobApps,null) ;  
            }            
            when AFTER_UPDATE 
            {
				createCandidateRecord(JobApps,JobAppsOld) ;  
                sync_JobApp_To_Candidate(JobApps,JobAppsOld);
            }            
        }
    }
     
    
    private void sync_JobApp_To_Candidate(List<Applicant_Job_Apps__c  > JobApps,  map<id, Applicant_Job_Apps__c> JobAppsOld)
    {
        // Since this trigger runs methods related to candidate object, we prevent that both run in the same transaction.
        if (isCreatingCandidateRecord || isSyncCandidateToJobApp || isSyncJobAppToCandidate)
        	return;
                
        set<id> setOfCandidates = new set<id>();
		for ( Applicant_Job_Apps__c ja : JobApps )	        
        {
            if (ja.Candidate_Link_to_HirePortal_Record__c==null)
                continue;
            
            setOfCandidates.add(ja.Candidate_Link_to_HirePortal_Record__c);
        }
                
        if ( setOfCandidates.isempty() ) 
            return;

        fieldsMapping();
		this.sourceFieldsDescribe = schemaMap.get('Applicant_Job_Apps__c').getDescribe().fields.getMap();
        this.targetFieldsDescribe = schemaMap.get('SFDC_Job_Candidate__c').getDescribe().fields.getMap();
        
        map<id, SFDC_Job_Candidate__c > candidateMAP = new map<id, SFDC_Job_Candidate__c >( [select id from SFDC_Job_Candidate__c where id in : setOfCandidates ]);
        list<SFDC_Job_Candidate__c> updateTheseCandidates = new list<SFDC_Job_Candidate__c> ();
                
        for ( Applicant_Job_Apps__c ja : JobApps )	        
        {
           
            if (!candidateMAP.containsKey( ja.Candidate_Link_to_HirePortal_Record__c )  )
            	continue;
            
           	SFDC_Job_Candidate__c candidate =  candidateMAP.get( ja.Candidate_Link_to_HirePortal_Record__c );
            boolean foundChanges=false;
            // check if any field get changed 
       		for ( string source_field : APPLICANTAPP_TO_JOBCANDIDATE.keyset() )
         	{   
                object value = ja.get(source_field);
                string targetField = APPLICANTAPP_TO_JOBCANDIDATE.get(source_field);
                
                if ( value!=null &&  value != JobAppsOld.get(ja.id).get(source_field)  )      
                {
                    if ( source_field.equalsIgnoreCase('status__c') && JobAPP_STATUS_TO_CANDIDATE.containsKey((string)value) )
						candidate.put( targetField , JobAPP_STATUS_TO_CANDIDATE.get((string)ja.get(source_field))  );				                                        
                    else
                    {						
                        // if the target field is date, we check if the source field is date time
                        if (Schema.DisplayType.DATE == targetFieldsDescribe.get(targetField).getDescribe().getType() && Schema.DisplayType.DATETIME==sourceFieldsDescribe.get(source_field).getDescribe().getType() && value!=null ) 
                            value = date.newinstance( ((datetime)value).year(), ((datetime)value).month(), ((datetime)value).day()  );                         
                		
                        candidate.put( targetField , value );				                
                    }
                    foundChanges=true;
                }
            }
            
            if (foundChanges)
            {
            	updateTheseCandidates.add(candidate);   
                isSyncJobAppToCandidate=true;
            }
        }
        
        update updateTheseCandidates;
    }
    
    private static string buildQuery(set<string> fields , list<string> fixedFields)
    {        
        list<string> allfields = new list<string>();
            allfields.addall(fields);
        
        if (fixedFields!=null )
        	allfields.addAll(fixedFields) ;
        
        return string.join( allfields , ',' );         
       
    }
    
    private void files()
    {
        if (this.QualifiedJobApps.isEmpty())
            return;
        
        set<id> setOfJobApps = new set<id>();
        for (Applicant_Job_Apps__c ja : this.QualifiedJobApps )
        {
            setOfJobApps.add(ja.id);
        }
        ContentDocumentLinkTriggerHandler.shareFileAppJobApps([select id,LinkedEntityId, ShareType, ContentDocumentId, Visibility from ContentDocumentLink where LinkedEntityId in : setOfJobApps ] );
    }
    private void ApplicantJobApps()
    {
        this.sourceFieldsDescribe = schemaMap.get('Applicant_Job_Apps__c').getDescribe().fields.getMap();
        this.targetFieldsDescribe = schemaMap.get('SFDC_Job_Candidate__c').getDescribe().fields.getMap();
		this.applicantApp_JobCandidateMAP = new map <id, SFDC_Job_Candidate__c>();
        
        for ( Applicant_Job_Apps__c ja : this.QualifiedJobApps )
        {
            SFDC_Job_Candidate__c c = new SFDC_Job_Candidate__c();
            c.Candidate__c = applicantMAP.get(ja.Applicant__c).id;
            c.SFDC_Job__c = ja.Job__c;
            for ( string source_field :  APPLICANTAPP_TO_JOBCANDIDATE.keySet())
            {                
                object value = ja.get(source_field);
           		string targetField = APPLICANTAPP_TO_JOBCANDIDATE.get(source_field);
           		// if the target field is date, we check if the source field is date time
           		if (Schema.DisplayType.DATE == targetFieldsDescribe.get(targetField).getDescribe().getType() && Schema.DisplayType.DATETIME==sourceFieldsDescribe.get(source_field).getDescribe().getType() && value!=null ) 
        			value = date.newinstance( ((datetime)value).year(), ((datetime)value).month(), ((datetime)value).day()  );                              
                c.put( targetField , value );
            }
            
            c.Status__c = CANDIDATE_STATUS;
            this.applicantApp_JobCandidateMAP.put(ja.id, c);
        }
        
        insert applicantApp_JobCandidateMAP.values();
        
        list<Applicant_Job_Apps__c> updateTheseJobApps = new list<Applicant_Job_Apps__c>();
        map<id, id> ApplicantCandidateMAP = new map<id, id>();
        for ( Applicant_Job_Apps__c ja : this.QualifiedJobApps)
        {           	
          updateTheseJobApps.add(  new Applicant_Job_Apps__c ( id = ja.id, Candidate_Link_to_HirePortal_Record__c = applicantApp_JobCandidateMAP.get(ja.id).id )  ) ;
          ApplicantCandidateMAP.put(ja.Applicant__c, ja.id);
        }

        update updateTheseJobApps;
		
        ContentDocumentLinkTriggerHandler.shareFileApplicants([select id,LinkedEntityId, ShareType, ContentDocumentId, Visibility from ContentDocumentLink where LinkedEntityId in :  ApplicantCandidateMAP.keyset() ], new set<id>( ApplicantCandidateMAP.values())  );        
    }
    private void applicants()
    {   
        this.applicantMAP = new map <id, SFDC_Candidate__c>();      
        this.sourceFieldsDescribe = schemaMap.get('Applicant__c').getDescribe().fields.getMap();
        this.targetFieldsDescribe = schemaMap.get('SFDC_Candidate__c').getDescribe().fields.getMap();
        
        set<id> setOfApplicants = new set<id>();
        for ( Applicant_Job_Apps__c ja : QualifiedJobApps )
        {
			setOfApplicants.add(ja.Applicant__c);            	
        }
        
		string query = 'select ' + buildQuery(APPLICANT_TO_CANDIDATERECORD.keySet() , null ) + ' from Applicant__c where id in : setOfApplicants' ;                
        for ( Applicant__c a :  database.query(query) )
        {
            SFDC_Candidate__c c = new SFDC_Candidate__c();
            
            for ( string source_field :  APPLICANT_TO_CANDIDATERECORD.keySet())
            {
                object value = a.get(source_field);
                string targetField = APPLICANT_TO_CANDIDATERECORD.get(source_field);
                // if the target field is date, we check if the source field is date time
                if (Schema.DisplayType.DATE == targetFieldsDescribe.get(targetField).getDescribe().getType() && Schema.DisplayType.DATETIME==sourceFieldsDescribe.get(source_field).getDescribe().getType() && value!=null ) 
                	value = date.newinstance( ((datetime)value).year(), ((datetime)value).month(), ((datetime)value).day()  );
                c.put( targetField , value );
            }
            
            applicantMAP.put(a.id, c);
        }
         
        insert applicantMAP.values();
    }


    public static map<string, string> getFieldsMapping(string direction)
    {
        map<string, string> mapping = new map<string, string>();
        for (Candidate_field_mapping__mdt fm : [select source_field__c, target_field__c from Candidate_field_mapping__mdt where direction__c =:direction])
        {
            mapping.put(fm.source_field__c, fm.target_field__c);            
        }

        return mapping;
    }

    private void fieldsMapping()
    {
        APPLICANT_TO_CANDIDATERECORD = getFieldsMapping('Applicant->Candidate');
        APPLICANTAPP_TO_JOBCANDIDATE = getFieldsMapping('ApplicantJobApp->Job Candidate');
    }
    
    private void createCandidateRecord(List<Applicant_Job_Apps__c  > JobApps,  map<id, Applicant_Job_Apps__c> JobAppsOld)
    {
        
        // Since this trigger runs methods related to candidate object, we prevent that both run in the same transaction.
        if (isCreatingCandidateRecord || isSyncCandidateToJobApp || isSyncJobAppToCandidate)
        	return;
        
        
        this.QualifiedJobApps = new List<Applicant_Job_Apps__c  >();
        for (Applicant_Job_Apps__c ja : JobApps )
        {
         if ( (( ja.Status__c ==JOB_APP_STATUS && JobAppsOld==null)  || ( JobAppsOld!=null && ja.Status__c ==JOB_APP_STATUS && ja.Status__c !=JobAppsOld.get(ja.id).Status__c  ) ) && ja.Candidate_Link_to_HirePortal_Record__c==null  )
                QualifiedJobApps.add(ja);
        }
        
        system.debug('QualifiedJobApps :: ' + QualifiedJobApps);
        
        if(QualifiedJobApps.isEmpty()) 
        	return;
        
        isCreatingCandidateRecord=true;
        fieldsMapping();
        applicants();        
        ApplicantJobApps();
        files();
    }
}