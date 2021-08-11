/**
Tests for the Sharing recalculation jobs for Job and Candidate records
 */
@istest
private class SharingRecalcTests { 

   // Test for the Job/Candidate SharingRecalc class. 
    static testMethod void testApexSharing(){
  /*     // Instantiate the class implementing Database.Batchable interface. 
        JobSharingRecalc recalcJOB = new JobSharingRecalc();
        CandidateSharingRecalc recalcCAN = new CandidateSharingRecalc();
    
        // create 2 portal accounts with users
        Account a = new Account(name = 'test portal1', store_number__c = '1500');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'test contact', email='niki@vankerksolutions.com');
        insert c;
        Profile p = [select id from Profile where name = 'MindField OnDemand HirePortal Store User EN'];
        User u = new User(contactid = c.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample@mfg.com', alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, User_Classification__c = 'Demo Related');
        insert u;
        // second portal user
        Account a2 = new Account(name = 'test portal2', store_number__c = '1501', x1st_level_manager__c = u.id);
        insert a2;
        Contact c2 = new Contact(accountid = a2.id, lastname = 'test contact2', email='niki@vankerksolutions.com');
        insert c2;
        User u2 = new User(contactid = c2.id, firstname='test', lastname = 'portal user', email='niki@vankerksolutions.com',
            username = 'sample2@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, User_Classification__c = 'Demo Related');
        insert u2;
        // set of portal accounts for finding the user roles
        Set<Id> AccIds = new Set<Id>{a.id, a2.id};
        
        // Create a new Job for use in test.  
        // At least one Job must exist. 
        SFDC_Job__c j = new SFDC_Job__c(job_status__c = 'test', Job_Title_for_Role__c = 'job title', Specific_Candidate_Preference__c = 'No');
        // if owner is u2, job should get first level mgr of u1
        j.ownerid = u2.id;
        insert j;       
        
        // now insert a Candidate and assign to this job
        SFDC_Candidate__c can = new SFDC_Candidate__c(first_name__c = 'test', last_name__c = 'test');
        insert can;
        SFDC_Job_Candidate__c jc = new SFDC_Job_Candidate__c(sfdc_job__c = j.id, candidate__c = can.id);
        insert jc;
        Test.startTest();
        String jobId = Database.executeBatch(recalcJOB);
        String jobId2 = Database.executeBatch(recalcCAN);
        test.stoptest();
        
        // find the group IDs for verifying sharing is correct
        Id urA;  // account a's Executive role
        Id urA2; // accout a2's Executive role
        // find the Acc 1 and 2 portal role & subordinates for Executive for testing
        for (UserRole ur : [select id, PortalAccountId from userrole where PortalAccountId in :AccIds and PortalRole = 'Executive']) 
            if (ur.portalaccountid == a.id)
                urA = ur.id;
            else urA2 = ur.id;
        
        Id gA; // account a's group for exec role and sub
        Id gA2; // account a2's group   
        // find the group representing each Executive Role and Subordinate
        for(Group g : [Select g.Type, g.Id, g.relatedid From Group g where (g.relatedid = :ura or g.relatedid = :ura2) and g.type = 'roleandsubordinates']) 
            if (g.relatedId == urA) gA = g.id;
            else gA2 = g.id;
        
        // test JOB SHARING
        // find the sharing for the job we created above
        j = [SELECT Id, job_owner_link__r.contact.accountid, x1st_level_manager__c, x5th_level_manager__c,
            (SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Shares 
            WHERE (RowCause = :Schema.SFDC_Job__Share.rowCause.Store_Contact__c OR 
            RowCause = :Schema.SFDC_Job__Share.rowCause.Manager__c))
            FROM SFDC_Job__c WHERE Id = :j.id];
        // A maximum of two Apex managed sharing records should exist for each job. 
        System.assert(j.Shares.size() <= 2);
        system.assert(j.x5th_level_manager__c == null);
        for(SFDC_Job__Share jobShr : j.Shares){
           system.debug('job share record: '+jobshr);
           // Test the sharing record for owner on job.   - Store Contact is for the account profile of the owner  (u2)         
            if(jobShr.RowCause == Schema.SFDC_Job__Share.RowCause.Store_Contact__c){
                System.assertEquals(jobShr.UserOrGroupId,gA2);
                System.assertEquals(jobShr.AccessLevel,'Edit');
            }
            // Test the sharing record for HR Manager on job. - Manager is for the account profile of the 1st level mgr (u)
            else if(jobShr.RowCause == Schema.SFDC_Job__Share.RowCause.Manager__c){
                System.assertEquals(jobShr.UserOrGroupId,gA);
                System.assertEquals(jobShr.AccessLevel,'Edit');
            } 
        }

        // test CANDIDATE SHARING
        // find the sharing for the candidate we created above
        can = [SELECT Id, candidate_owner_link__r.contact.accountid, x1st_level_manager__r.contact.accountid, x5th_level_manager__c,
            (SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Shares 
            WHERE (RowCause = :Schema.SFDC_Candidate__Share.rowCause.Store_Contact__c OR 
            RowCause = :Schema.SFDC_Candidate__Share.rowCause.Manager__c))
            FROM SFDC_Candidate__c WHERE Id = :can.id];
        // A maximum of two Apex managed sharing records should exist for each candidate. 
        System.assert(can.Shares.size() <= 2);
        system.assert(can.x5th_level_manager__c == null);        
        for(SFDC_Candidate__Share cShr : can.Shares){
           system.debug('can share record: '+cshr);
           // Test the sharing record for owner on can.   - Store Contact is for the account profile of the owner  (u2)         
            if(cShr.RowCause == Schema.SFDC_Candidate__Share.RowCause.Store_Contact__c){
                System.assertEquals(cShr.UserOrGroupId,gA2);
                System.assertEquals(cShr.AccessLevel,'Edit');
            }
            // Test the sharing record for HR Manager on can. - Manager is for the account profile of the 1st level mgr (u)
            else if(cShr.RowCause == Schema.SFDC_Candidate__Share.RowCause.Manager__c){
                System.assertEquals(cShr.UserOrGroupId,gA);
                System.assertEquals(cShr.AccessLevel,'Edit');
            } 
        }
        
                CandidateSharingRecalclasthour recalcCANhr = new CandidateSharingRecalclasthour();
                String jobId3 = Database.executeBatch(recalcCANhr);
*/
}

}