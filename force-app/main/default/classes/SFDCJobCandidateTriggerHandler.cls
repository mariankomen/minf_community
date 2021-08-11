/*==============================================================================
 * Author 		: Henry Caballero | floatintotheclouds
 * Date			: 5/7/2020
 * Description	: Jira Issue => MFG-129
 * Changes		: HC | 6/30/2020 | MFG-210
 * ===========================================================================*/

public class SFDCJobCandidateTriggerHandler 
{
    private static final map<string,string>	CANDIDATE_STATUS_TO_JobAPP = new map<string,string> {	'Qualified Candidates'=>'Presented',
        																							'Interviewing'=>'Presented',
        																							'Interviewing/Background Check'=>'Presented',
        																							'Background Check'=>'Presented',
        																							'Would Like to Hire for Other Job'=>'Presented',
        																							'Hired'=>'Accepted',
        																							'Rejected'=>'RejectedbyHM'
        																						};
   	public static void run(List<SFDC_Job_Candidate__c  > candidates,  map<id, SFDC_Job_Candidate__c> candidatesOld,  System.TriggerOperation triggerEvent ) 
    {                          
        switch on triggerEvent 
        {         
           when AFTER_INSERT
           {
                 
           }            
           when AFTER_UPDATE 
           {
               sync_Candidate_To_JobApp(candidates,candidatesOld);
	       }            
        }
    }
    
    
    private static void sync_Candidate_To_JobApp(List<SFDC_Job_Candidate__c  > candidates,  map<id, SFDC_Job_Candidate__c> candidatesOld)
    {            	            	
        // Since this trigger runs methods related to candidate object, we prevent that both run in the same transaction.
        if (ApplicantJobAppTriggerHandler.isCreatingCandidateRecord || ApplicantJobAppTriggerHandler.isSyncCandidateToJobApp || ApplicantJobAppTriggerHandler.isSyncJobAppToCandidate)
        	return;
		map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
        map<String, Schema.SObjectField> sourceFieldsDescribe = schemaMap.get('SFDC_Job_Candidate__c').getDescribe().fields.getMap();
    	map<String, Schema.SObjectField> targetFieldsDescribe = schemaMap.get('Applicant_Job_Apps__c').getDescribe().fields.getMap();
        
       	map<string,string> APPLICANTAPP_TO_JOBCANDIDATE = ApplicantJobAppTriggerHandler.getFieldsMapping('ApplicantJobApp->Job Candidate');
        
        map<id, SFDC_Job_Candidate__c> cantidates_JobAppMAP = new map<id, SFDC_Job_Candidate__c>([select id,  (select Id,Name from Applicant_Job_Apps__r) from SFDC_Job_Candidate__c where id in : candidates]);
        list<Applicant_Job_Apps__c> updateThesejobApps = new list<Applicant_Job_Apps__c>();
        
        for ( SFDC_Job_Candidate__c jc : candidates )
        {
            //check if the candidate has a jobApp related
            if ( !cantidates_JobAppMAP.containsKey(jc.id) || (cantidates_JobAppMAP.containsKey(jc.id) && cantidates_JobAppMAP.get(jc.id).Applicant_Job_Apps__r.isEmpty() ) )
                continue;
            
            Applicant_Job_Apps__c jobApps =  cantidates_JobAppMAP.get( jc.id ).Applicant_Job_Apps__r[0];
	      
            boolean foundChanges=false;
            // check if any field get changed 
       		for ( string target_field : APPLICANTAPP_TO_JOBCANDIDATE.keyset() )
         	{   
                string source_field = APPLICANTAPP_TO_JOBCANDIDATE.get(target_field);
                object value = jc.get(source_field);
                if ( value !=null &&  value != candidatesOld.get(jc.id).get(source_field)  )      
                {
                    if ( target_field.equalsIgnoreCase('status__c') && CANDIDATE_STATUS_TO_JobAPP.containsKey((string)value) )
                    	jobApps.put( target_field , CANDIDATE_STATUS_TO_JobAPP.get((string)value) );	    
                    else                        
                    {
                        // if the target field is date, we check if the source field is date time
                        if (Schema.DisplayType.DATE == targetFieldsDescribe.get(target_field).getDescribe().getType() && Schema.DisplayType.DATETIME==sourceFieldsDescribe.get(source_field).getDescribe().getType() && value!=null ) 
                            value = date.newinstance( ((datetime)value).year(), ((datetime)value).month(), ((datetime)value).day()  );   
                        
                		jobApps.put( target_field , value);				                
                    }
                    foundChanges=true;
                }
            }
            
            if (foundChanges)
            {
            	updateThesejobApps.add(jobApps);    
                ApplicantJobAppTriggerHandler.isSyncCandidateToJobApp=true;
            }
        }
        
        update updateThesejobApps;
        
    }
    
}