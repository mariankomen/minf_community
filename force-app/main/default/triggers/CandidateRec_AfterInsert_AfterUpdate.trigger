/*
Project: Chequed - LMP Report (Phase 1)
Date: Jan 2017
Description: When we get candidate record from Hiredesk, we want to make a webservice call 
to HRNX to retireve the URL to the LMP. 
*/

trigger CandidateRec_AfterInsert_AfterUpdate on SFDC_Candidate__c (after insert, after update) {

    if (trigger.isAfter) {
    
        /* Feb 13, 2018 - remove because it is not required anymore....alos seems like we're hitting API limits with OFG
        //try getting LMP on create-------------------------------------------------------------------
        if (trigger.isInsert) {
            // We bulkify the trigger so it works for n records being inserted
            for (SFDC_Candidate__c c : trigger.new) {
              //call HRNX webservice and get back LMP URL, this is an @future call
              HNRX_Webservice.retieveLMPURL(c.Auto_HireDesk_GUID_Lookup__c, c.id);
            }
        }*/
        //------------------------------------------------------------------------------------------
        
        //try getting LMP on update-------------------------------------------------------------------
        /* April 19, 2017 - Comment this section out.
           It looks like were running into issues where update is getting triggered multiple times.
           SHould be good triggering just on create. 
        if (trigger.isUpdate) {
            // We bulkify the trigger so it works for n records being inserted
            for (SFDC_Candidate__c c : trigger.new) {
                //Call to get LMP URL back haven't tried already
                //LMP call will always either fill one of the below two strings
                if(
                    String.isBlank(c.LMP_Report_URL__c) && 
                    String.isBlank(c.LMP_Report_URL_Exception__c)
                )
                {
                    //call HRNX webservice and get back LMP URL
                    HNRX_Webservice.retieveLMPURL(c.Auto_HireDesk_GUID_Lookup__c, c.id);
                }
            }
        }*/
        //------------------------------------------------------------------------------------------
    }

}