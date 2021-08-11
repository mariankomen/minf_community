//March 2018, build for the agency model but could be used in other scenerios.
//-----------------------------------------------------------------------------
trigger Task_AfterInsertUpdate on Task (after insert, after update) { 
    //Update Sept 2018, uodate so trigger will work for account managers as well.
    //Agency Usage
    //When a new task is created by an agency user, of Task Type 'Hiring Manager Interview Rescheduling' we want to create
    //a case to CE of type 'Interview Rescheduling - Hiring Manager Request' so it can be tracked as a billable item
    // (Agennts dont have full SF lincense so they dont have acccess to create the case themselves.)
    if (trigger.isAfter && trigger.isInsert) {
    
        Id pId = userinfo.getProfileId(); //Mindfield.2 - Recruitment Agency OR Mindfield.2 - Account Managers
        RecordType rt = [Select Id,SobjectType,Name From RecordType WHERE Name ='MFG Clients' AND SobjectType='Case' limit 1]; //CE record type
        Profile pRC = [Select Id, Name From Profile WHERE Name='Mindfield.2 - Recruitment Agency' limit 1]; //agency profile
        Profile pRM = [Select Id, Name From Profile WHERE Name='Mindfield.2 - Account Managers' limit 1]; //account manager
        Group g = [SELECT Id FROM Group WHERE Type = 'Queue' AND NAME = 'MindField Support' limit 1]; //CE queue

        
        for (Task t : trigger.new) {
            
            if(rt != null &&
               g != null &&
               (
                 (pRC != null && pRC.Id==pId) 
                 ||
                 (pRM != null && pRM.Id==pId)
               )  
               &&
               t.WhatId != null &&
               t.WhatId.getSObjectType() == SFDC_Job__c.sObjectType && //related to job
               t.Task_Type__c=='Hiring Manager Interview Rescheduling' //HM rescheduling interview
               )
            {
            
                SFDC_Job__c j = [SELECT id, Using_New_Service_Model__c FROM SFDC_Job__c WHERE id =: t.whatid]; //grab job
                
                if(j != null && j.Using_New_Service_Model__c) { //if NSM, create the case so we can track billing
            
                    //create CE case
                    Case caseObj = new Case(
                        RecordTypeId=rt.Id, //MFG Clients (CE)
                        Case_Is_Related_to_Specific_Job__c=t.whatid, //related job
                        Type='Interview Rescheduling - Hiring Manager Request',
                        OwnerId=g.Id,
                        Subject=t.Subject,
                        Description='Automatic case created from agency task for NSM billing.' + (t.Description != null ? t.Description : ''),
                        Status = 'Close',
                        Origin = 'Recruiter');
                
                    insert caseObj;
                }
            }
        }
    
    }

}