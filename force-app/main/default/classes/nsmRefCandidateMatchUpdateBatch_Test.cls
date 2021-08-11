@isTest
private class nsmRefCandidateMatchUpdateBatch_Test {

    static testmethod void test() {
    
          //setup
       Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true);
       insert cp;
       Account a = new Account(name='Test Account', Client_Profile__c=cp.Id);
       insert a;
       Contact con = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
       insert con;
       User u = new User(firstname='Jeff', lastname='Perron', Username='jp@perron.com', Email='jp@perron.com', Alias='jp', CommunityNickname='jp', TimeZoneSidKey='Pacific/Chatham', 
                         LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId='00eU0000000JM7h',LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=true, contactid=con.id);
       insert u;
       
    
     System.runAs(u) { //run as user setup above
     
        //create test job
        SFDC_Job__c j = new SFDC_Job__c (
            recordtypeid='012U00000009Qqf', //Direct Tap
            //Banner_of_Store__c='Atmosphere',0120P0000005nhC
            Job_Status__c='Open/Active Job',
            Name_of_Person_Submitting_Request__c='Jeff',
            Confidential__c='No',
            Number_Of_Hours_Per_Week__c='0 to 8 hours',
            Hours_of_Availability__c='Weekdays - 8am to 4pm',
            Specific_Candidate_Preference__c='No',
            MindField_Job_Type__c='Client Demo & Testing',
            Date_Job_Added_or_Opened__c=system.now().addDays(-2),
            Date_Job_Filled__c=system.now().addDays(-1),
            Parent_Account__c=a.Id,
            NSM_Specific_Candidate_Requested__c='Yes_Requested_Candidate',
            Specific_Candidate_Name__c='Jeff Perron',
            Specific_Candidate_Email__c='jeff2.perron@gmail.com',
            Specific_Candidate_Phone_Number__c='604-588-8925',
            Specific_Candidate_Phone_Number_2nd__c='604-588-8925',
            QCP_Acknowledgement__c=true
        );
        insert j;
        

        SFDC_Candidate__c c = new SFDC_Candidate__c(name='Jeff Perron', First_Name__c='Jeff', Last_Name__c='Perron', 
                                                    SFDC_Candidate_Email__c='jeff.perron@gmail.com', Primary_Phone__c='604-588-8924',Secondary_Phone__c='604-588-8924');
        
        insert c;
        
        SFDC_Job_Candidate__c jc = new SFDC_Job_Candidate__c(Name='Test', Status__c='Interviewing', SFDC_Job__c=j.Id, Candidate__c=c.Id);
        insert jc;
        }
        
        
        Test.startTest();
        //the setup fail all but last match, name, so we get most code coverage
        Id batchinstanceid = database.executeBatch(new nsmReferredCandidateMatchUpdateBatch(),200);
        Test.stopTest();
       
    }
}