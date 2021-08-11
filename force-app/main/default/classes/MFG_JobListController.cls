public class MFG_JobListController {
    @AuraEnabled
    public static Jobs getCurrentUserJobs(){
        return new Jobs();
    }
    public class Jobs{
        @AuraEnabled public List<sObject> open;
        @AuraEnabled public List<sObject> completed;
        public Jobs(){
           
            this.open=new MFG_JobsSelector().selectForCurrentUser('WHERE (Job_Status__c =\'Open/Active Job\' OR Job_Status__c =\'Candidates Sent/Awaiting Hire\' OR Job_Status__c =\'Additional Candidate(s) Required\' OR Job_Status__c =\'Job On Hold\') AND Credits_Used_for_Job__c != 0 AND OwnerId=\''+UserInfo.getUserId()+ '\' ORDER BY CreatedDate DESC');
            this.completed=new MFG_JobsSelector().selectForCurrentUser('WHERE (Job_Status__c !=\'Open/Active Job\' AND Job_Status__c !=\'Candidates Sent/Awaiting Hire\' AND Job_Status__c !=\'Additional Candidate(s) Required\' AND OwnerId=\''+UserInfo.getUserId()+ '\') AND Credits_Used_for_Job__c != 0 ORDER BY CreatedDate DESC');
        }
    }

}