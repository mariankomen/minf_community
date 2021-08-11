public class MFG_JobDetailsController {
    
    @AuraEnabled
    public static Job initJobDeails(Id jobId){
        system.debug(jobId);
        return new Job(jobId);
    }
    
    public class Job{
        @AuraEnabled public SFDC_Job__c jobDetails;
        @AuraEnabled public List<SFDC_Job_Candidate__c> outstanding;
        @AuraEnabled public List<SFDC_Job_Candidate__c> accepted;
        @AuraEnabled public List<SFDC_Job_Candidate__c> rejected;
        public Job(Id jobId){
            try{
                this.jobDetails=new MFG_JobsSelector().selectForCurrentUser('WHERE id=\''+jobId+'\'').get(0);
                this.outstanding=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c!=\'Hired\' AND Status__c!=\'Rejected\' AND Status__c!=\'Offer Accepted\' AND SFDC_Job__c=\''+jobId+'\'');
                this.accepted=new MFG_JobCandidateSelector().selectByStatus('WHERE (Status__c=\'Hired\' OR Status__c=\'Offer Accepted\') AND SFDC_Job__c=\''+jobId+'\'');
                this.rejected=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c=\'Rejected\' AND SFDC_Job__c=\''+jobId+'\'');   
            }Catch(Exception e){
               system.debug(e.getMessage()); 
                throw new AuraHandledException(e.getMessage());
            }
            
        }
        
    }
}