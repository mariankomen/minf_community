/*****************************
  Class: Employee_Util
  Purpose: This class contains utility methods for Employee triggers.  Test methods in Employee_UtilTest class

  Created: Nov 23/11 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:

*****************************/
public class Employee_Util {
    
    // Submit PTO Requests for approvals processing.

    public static void SubmitForApproval(Set<Id> ptos) {
        // if we have PTOs to submit, do so now
        if (!ptos.isempty()) {  
           //system.debug('about to submit these ptos for approval: '+[select id, name  from SFDC_PTO_Request__c where id in :ptos]);
           List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
           for (Id pid :  ptos) {
               Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
               req1.setComments('Submitting automated requests for approval.');
               req1.setObjectId(pid);
               reqs.add(req1);
           } // end build list of approvals to submit
           try {
               // submit all ptos with AllorNothing set to false so some can fail and others still submit
               Approval.ProcessResult[] results = Approval.process(reqs, false); 
               //System.debug('approval submission process results: '+results);
           } catch (Exception e) {system.debug('approval submit failed: '+e); } 
        } // end if ptos to submit
    }
    
}