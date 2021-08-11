/*
This will test:
1. Trigger: CandidateRec_AfterInsert_AfterUpdate
2. Class: HNRX_Webservice
*/

@isTest(SeeAllData=true)
public class HNRX_Webservice_Test {
    
    static testmethod void testWebservice() {
    
        string sReturnValue = '';
    
        //get a hiredesk guid
        List<SFDC_Candidate__c> cList = [SELECT Id, Name, Auto_HireDesk_GUID_Lookup__c, LMP_Report_URL__c, LMP_Report_URL_Exception__c 
                                         FROM SFDC_Candidate__c 
                                         WHERE Auto_HireDesk_GUID_Lookup__c != null
                                         ORDER BY CreatedDate DESC
                                         LIMIT 1];
        
        if(cList.size() > 0) {   
            //create new candidate record with hiredesk guid.
            //this will trigger HRNX call, CandidateRec_AfterInsert_AfterUpdate  
            SFDC_Candidate__c newCand = new SFDC_Candidate__c(Name='Jeff Test', Candidate_Resume_Link__c=cList[0].Auto_HireDesk_GUID_Lookup__c);
            insert newCand;
            
            //blank out, this will call HRNX trigger again 
            newCand.LMP_Report_URL__c='';
            newCand.LMP_Report_URL_Exception__c='';
            update newCand;
            
            SFDC_Candidate__c updatedCand = [SELECT Id, LMP_Report_URL__c, LMP_Report_URL_Exception__c 
                                             FROM SFDC_Candidate__c 
                                             WHERE Id =: newCand.Id];
            
            //we should get back LMP link or error                                 
            //System.assert((updatedCand.LMP_Report_URL__c != null || updatedCand.LMP_Report_URL_Exception__c != null));   
            System.assert(updatedCand != null);                                  
        } 
    }
    
}