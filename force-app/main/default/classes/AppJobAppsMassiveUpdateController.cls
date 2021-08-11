/*==============================================================================
 * Author 		: Henry Caballero | floatintotheclouds
 * Date			: 5/6/2020
 * Description	: Jira Issue => MFG-109
 * Changes		: 
 * ===========================================================================*/
public class AppJobAppsMassiveUpdateController 
{
    private list<Applicant_Job_Apps__c> jobApps;
    public Applicant_Job_Apps__c tmpJobApp  {get;set;}
    private string JobId;
	public AppJobAppsMassiveUpdateController(ApexPages.StandardSetController controller)
    {        
        if (!test.isRunningTest()) controller.addFields(new List<String>{'Job__c'} );
        tmpJobApp = new Applicant_Job_Apps__c();
        this.jobApps =  controller.getSelected();
        this.JobId = (string)controller.getRecords()[0].get('Job__c');                
    }
    
    public PageReference UpdateStatus()
    {
        
        for ( Applicant_Job_Apps__c a : jobApps)
        {
            a.status__c = tmpJobApp.status__c;
            if ( (tmpJobApp.status__c=='DeclinedbyMFG' && tmpJobApp.Declined_Reason_by_MFG__c==null) || (tmpJobApp.status__c=='RejectedbyHM' && tmpJobApp.Rejected_Reason_by_HM__c==null)  )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You must select a reason'));
                return null;
            }
            
            if (tmpJobApp.status__c=='DeclinedbyMFG')
            {
            	a.Declined_Reason_by_MFG__c =  tmpJobApp.Declined_Reason_by_MFG__c;   
            } else if (tmpJobApp.status__c=='RejectedbyHM')
            {
                a.Rejected_Reason_by_HM__c =  tmpJobApp.Rejected_Reason_by_HM__c;   
            }            
        }
        
		 try{
            update jobApps;
        }catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;

        }        
        return Cancel();                
    }
    
    public PageReference Cancel()
    {
          
        return new system.PageReference('/lightning/r/SFDC_Job__c/' + this.JobId + '/view') ;                
    }
}