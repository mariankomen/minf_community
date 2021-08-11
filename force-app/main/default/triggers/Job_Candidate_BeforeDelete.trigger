//Jeff Perron
//May 2018
//Handles events for job candidate associated with candidate inerview
trigger Job_Candidate_BeforeDelete on SFDC_Job_Candidate__c (before delete) {
/*
    List<Candidate_Interview__c> ciListToDelete = new List<Candidate_Interview__c>();

    if(trigger.isDelete) {
        
        for (SFDC_Job_Candidate__c ci : Trigger.Old) {
            List<Candidate_Interview__c> ciL = [SELECT id FROM Candidate_Interview__c WHERE Job_Candidate__c =: ci.id];
            ciListToDelete.addall(ciL);
        }
        
        //delete candidates interviews
        if(ciListToDelete.size() > 0) {
        
            List<Candidate_Interview__c> ciListToDeleteFinal = new List<Candidate_Interview__c>();
            for(Candidate_Interview__c c : ciListToDelete) {
                //disassociate job candidate relationship before deletion.
                // Candidate_Interview_AfterInsertUpdate_BeforeDelete trigger will stop any deletion with association...which we want when trying to delete individually
                c.Job_Candidate__c = null; 
                ciListToDeleteFinal.add(c);
            }
            update ciListToDeleteFinal;
            delete ciListToDeleteFinal;
        }
     }
*/
}