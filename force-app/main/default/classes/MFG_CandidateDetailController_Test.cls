@isTest
public class MFG_CandidateDetailController_Test {
    @isTest
    public static void getjobDetTest(){ 
        SFDC_Job__c job=(SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        SFDC_Job_Candidate__c jcandidate=(SFDC_Job_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id),true);  
        
        system.Test.startTest();
        SFDC_Job_Candidate__c jobcandidate = (SFDC_Job_Candidate__c)MFG_CandidateDetailController.getjobDet(jcandidate.id);
        system.assertEquals('test job', jobcandidate.SFDC_Job__r.New_Job_Title__c);
        system.Test.stopTest();
        
    }
    
    @isTest
    public static void updateCandidateStatusRatingTest(){ 
        SFDC_Job__c job=(SFDC_Job__c)MFG_TestDataFactory.createsObject(new SFDC_Job__c(),true);  
        SFDC_Candidate__c candidate=(SFDC_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Candidate__c(),true);  
        SFDC_Job_Candidate__c jcandidate=(SFDC_Job_Candidate__c)MFG_TestDataFactory.createsObject(new SFDC_Job_Candidate__c(SFDC_Job__c=job.id, Candidate__c=candidate.id),true);  
        
        system.Test.startTest();
        MFG_CandidateDetailController.updateCandidateStatusRating( 'Interviewing',  '4',  null,  null,  jcandidate.Id);
        SFDC_Job_Candidate__c jobcand=[select id ,Status__c from SFDC_Job_Candidate__c WHERE id=:jcandidate.Id LIMIT 1];
        system.assertEquals('Interviewing', jobcand.Status__c);
        system.Test.stopTest();
        
    }
    @isTest
    public static void  getStatusRatingOptionsTest(){ 
        SalesforceEndpointMock sem = new SalesforceEndpointMock(SCS_CR,200);
        System.Test.setMock(HttpCalloutMock.class, sem);
        system.Test.startTest();
        MFG_CandidateDetailController.FieldOptions options=MFG_CandidateDetailController.getStatusRatingOptions( 
            Schema.SObjectType.SFDC_Job_Candidate__c.getRecordTypeInfosByDeveloperName().get('Recruitment').getRecordTypeId());
        system.Test.stopTest();
        
    }
    Public static final String SCS_CR='{"controllerValues":{},"defaultValue":null,"eTag":"19a3bd353ee57bc3ada96fb316a59881","url":"/services/data/v43.0/ui-api/object-info/SFDC_Job_Candidate__c/picklist-values/012U0000000A2tSIAS/Status__c","values":[{"attributes":null,"label":"Initial Applicant","validFor":[],"value":"Initial Applicant"},{"attributes":null,"label":"Qualified Candidates","validFor":[],"value":"Qualified Candidates"},{"attributes":null,"label":"Sent to Store/Manager","validFor":[],"value":"Sent to Store/Manager"},{"attributes":null,"label":"Interviewing/Background Check","validFor":[],"value":"Interviewing/Background Check"},{"attributes":null,"label":"Hired","validFor":[],"value":"Hired"},{"attributes":null,"label":"Rejected","validFor":[],"value":"Rejected"},{"attributes":null,"label":"Would Like To Hire For Other Job","validFor":[],"value":"Would Like To Hire For Other Job"},{"attributes":null,"label":"Interviewing","validFor":[],"value":"Interviewing"},{"attributes":null,"label":"Interviewing Round 1","validFor":[],"value":"Interviewing Round 1"},{"attributes":null,"label":"Interviewing Round 2","validFor":[],"value":"Interviewing Round 2"},{"attributes":null,"label":"Background Check","validFor":[],"value":"Background Check"},{"attributes":null,"label":"Awaiting MindField Group Contact","validFor":[],"value":"Awaiting MindField Group Contact"},{"attributes":null,"label":"No Show for Interview","validFor":[],"value":"No Show for Interview"}]}';
    @TestVisible
    private class SalesforceEndpointMock implements HttpCalloutMock {
        
        private final String body;
        private final Map<String,String> headers = new Map<String,String>{'Content-Type' => 'application/json'};
            private final Integer statusCode;
        
        public HTTPResponse respond(HTTPRequest req) {
            
            HttpResponse res = new HttpResponse();
            for(String hdr :this.headers.keySet()){
                res.setHeader(hdr, headers.get(hdr));
            }
            if(this.body != null){
                res.setBody(this.body);
            }
            res.setStatusCode(this.statusCode);
            res.setStatus('status');
            return res;
        }
        
        public SalesforceEndpointMock(String body, Integer statusCode){
            this.body = body;
            this.statusCode = statusCode;
        }
        
    }
    
}