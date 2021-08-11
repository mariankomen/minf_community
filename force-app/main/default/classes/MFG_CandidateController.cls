public class MFG_CandidateController {
    
    @AuraEnabled
    public static Candidates getCandidates(){
        return new Candidates();
    }
    
    
    public class Candidates{
        @AuraEnabled public List<SFDC_Job_Candidate__c> outstanding;
        @AuraEnabled public List<SFDC_Job_Candidate__c> accepted;
        @AuraEnabled public List<SFDC_Job_Candidate__c> rejected;
        public Candidates(){
          
        //Interviewing Candidates (called “Outstanding Candidates in Mockup”) - this will be coming from the SFDC_Job_Candidate__c table 
        //and showing all records that are associated with the SFDC_Job__C record 
        //and the Status__c not equal “Hired” or “Rejected” or “Offer Accepted” 
        //then show “Outstanding Candidate”.
        
        //Accepted Candidates  - this will be coming from the SFDC_Job_Candidate__c table 
        //and showing all records that are associated with the SFDC_Job__C record 
        //and the Status__c not equal “Hired” “Offer Accepted”
        
        //Rejected Candidates - this will be coming from the SFDC_Job_Candidate__c table 
        //and showing all records that are associated with the SFDC_Job__C record 
        //and the Status__c not equal “Rejected”
                       
            this.outstanding=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c!=\'Hired\' AND Status__c!=\'Rejected\' AND Status__c!=\'Offer Accepted\' ');
            this.accepted=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c=\'Hired\' OR Status__c=\'Offer Accepted\' ');
            this.rejected=new MFG_JobCandidateSelector().selectByStatus('WHERE Status__c=\'Rejected\'');
        }
    }
}