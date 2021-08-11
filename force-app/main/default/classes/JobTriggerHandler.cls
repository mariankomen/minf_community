/*==============================================================================
 * Author 		: Henry Caballero | floatintotheclouds
 * Date			: 8/22/2020
 * Description	: Jira Issue => MFG-237
 * Changes		: 
 * ===========================================================================*/
public class JobTriggerHandler 
{    
    
    private static final set<string> JobclosedStatus = new set<string>{'Filled Closed Job','Filled Internally Closed Job','Not Filled/Closed by Mgr','Not Filled/Job Re-Opened'};
    private static final set<string> ApplicantJobAppsclosedStatus = new set<string>{'New','Short List','Phone Screen'};
    
    public static void run(List<SFDC_Job__c  > Jobs,  map<id, SFDC_Job__c> JobsOld,  System.TriggerOperation triggerEvent ) 
    {
        switch on triggerEvent 
        {                     
            when AFTER_UPDATE 
            {		
                rejectAllCandidatesNotUsed(Jobs,JobsOld );
            }            
        }        
    }   
    
    public static void rejectAllCandidatesNotUsed( List<SFDC_Job__c  > Jobs,  map<id, SFDC_Job__c> JobsOld )
    {        
        //get the Jobs were closed        
        set<id> setOfJobs = new set<id>();
        for ( SFDC_Job__c  job : jobs) 
        {
     		if (  job.Job_Status__c != JobsOld.get(job.id).Job_Status__c &&   JobclosedStatus.contains(job.Job_Status__c)  )       
            {
				setOfJobs.add(job.id);
            }
        }
        
        if ( setOfJobs.isEmpty() )
            return;
		
        rejectAllCandidatesNotUsed(setOfJobs);        
    }
    
    
    public static void rejectAllCandidatesNotUsed(set<id> setOfJobs)
    {
     	list<Applicant_Job_Apps__c> jobAppsToUpdate = new list<Applicant_Job_Apps__c>();
        for ( SFDC_Job__c job : [ select Id , (select Id from Applications__r where Status__c in : ApplicantJobAppsclosedStatus ) from SFDC_Job__c where id in : setOfJobs ]  )
        {
            for (Applicant_Job_Apps__c jobApp : job.Applications__r)
            {
                jobApp.Status__c = 'Declined by MFG';
                jobApp.Declined_Reason_by_MFG__c = 'Job Filled';
                jobAppsToUpdate.add(jobApp);
            }
        }
        
        update jobAppsToUpdate;
    }        
}