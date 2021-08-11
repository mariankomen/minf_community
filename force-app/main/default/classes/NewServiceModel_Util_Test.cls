@isTest
public class NewServiceModel_Util_Test {
    
    static testmethod void testNSMUtil(){
       
       List<SelectOption> rej = NewServiceModel_Util.BuildRejectionReasonsNewServiceModel();
       system.assertequals(rej.size() , 16); //should be 16 reasons including the '--None--'
                                             //Feb 6, 2018...removed one reason
       
       //run through validations.. will fail becasue we dont have client profile which gives us time to dispostion variable
       CandidateUpdate.CandidateWrapper c1 = new CandidateUpdate.CandidateWrapper(new SFDC_Job_Candidate__c(Status__c='Rejected',Rejection_Reason_for__c='An internal hire made'), true);
       system.assertequals(NewServiceModel_Util.IsValidRejectionReason(c1) , false);
       
       //setup
       Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true, Time_to_Disposition_Job_Close_hrs__c=24, Time_to_Disposition_hrs__c=24, Time_to_Disposition_Reminder__c=23);
       insert cp;
       Account a = new Account(name='Test Account', Client_Profile__c=cp.Id);
       insert a;
       Contact c = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
       insert c;
       User u = new User(firstname='Jeff', lastname='Perron', Username='jp@perron.com', Email='jp@perron.com', Alias='jp', CommunityNickname='jp', TimeZoneSidKey='Pacific/Chatham', 
                         LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId='00eU0000000JM7h',LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=false, contactid=c.id);
       insert u;
       
       String myString = 'StringToBlob';
       Blob myBlob = Blob.valueof(myString);
       Attachment att = new Attachment(name='Section - File 1', ParentId=cp.Id, Body=myBlob);
       insert att;
       Attachment att2 = new Attachment(name='Section 2 - File 1', ParentId=cp.Id, Body=myBlob);
       insert att2;
       
       List<Attachment> lQCP = new List<Attachment>();
       lQCP.add(att);
       lQCP.add(att2);
       
       //system.assert(NewServiceModel_Util.IsUserOnNSMByContact(c)); //contact assocaited with NSM
       NewServiceModel_Util.IsUserOnNSMByContact(c);
       
       NewServiceModel_Util.UpdateUsersToNSMByClientProfile(cp); //just hit method
       
       Client_Profile__c cpFound = NewServiceModel_Util.FindCurrentUserClientProfile(u.Id);
       //system.assertequals(cpFound != null, true); //finds client profile assocaited with user
       
       NewServiceModel_Util.BuildQCPList(lQCP); //just hit method
       
       
       //NSM Release 3-------------------------------------------------------------------------------------------------------------------------------------------------------------
       //test target volume
       Date myDateTime = date.today(); //Date.newInstance(2017, 2, 17);
       Contract contr = new Contract(name='testtargetvolume', AccountId=a.Id, StartDate=myDateTime, ContractTerm=12,
       Frontline__c=12, Frontline_Price__c=100,
       Frontline_1__c=12, Frontline_1_Price__c=100,
       Frontline_2__c=12, Frontline_2_Price__c=100,
       Specialty_1__c=12, Specialty_1_Price__c=100,
       Specialty_2__c=12, Specialty_2_Price__c=100,
       Management_1__c=12, Management_1_Price__c=100,
       Management_2__c=12, Management_2_Price__c=100,
       Admin_Fee__c=100
       );
       insert contr;
       
       contr = [SELECT id,StartDate, EndDate, Frontline__c, Frontline_Price__c, Frontline_1__c, Frontline_1_Price__c,Frontline_2__c, Frontline_2_Price__c,
                Specialty_1__c, Specialty_1_Price__c, Specialty_2__c, Specialty_2_Price__c,
                Management_1__c, Management_1_Price__c, Management_2__c, Management_2_Price__c,Admin_Fee__c
                 FROM Contract WHERE Name='testtargetvolume'];
       
       NewServiceModel_Util.CreateTargetVolumes(contr); 
       List<Target_Volume__c> tvl = [SELECT id FROM Target_Volume__c WHERE Contract__r.Id =: contr.Id];
       //system.assert(tvl.size() == 12); //should create 12 target volume entries
       
       
       
       //test two can rule
       // Create test records now
        List<SFDC_Candidate__c> cans = new List<SFDC_Candidate__c>();
        SFDC_Candidate__c can1 = new SFDC_Candidate__c( first_name__c='Test1', Last_name__c='Test1');
        cans.add(can1);    
        SFDC_Candidate__c can2 = new SFDC_Candidate__c( first_name__c='Test2', Last_name__c='Test2');
        cans.add(can2);
        SFDC_Candidate__c can3 = new SFDC_Candidate__c( first_name__c='Test3', Last_name__c='Test3');
        cans.add(can3);
        insert cans;
        
        // get MFG Demo rec type
        id MFGDemo = [select id, name from recordtype where developername = 'MFG_Demo' and sobjecttype = 'SFDC_Job__C' limit 1].id;
        SFDC_Job__c j1 = new SFDC_Job__c(Contract__c=contr.Id,job_status__c = 'Candidates Sent/Awaiting Hire', Specific_Candidate_Preference__c = 'No', Job_Role_Title__c = 'test',
                                            recordtypeid = MFGDemo, Role_type__c='Frontline 1');
        insert j1;
        
        // add 3 Candidates to set each picklist, one set to Interviewing, others as Qualified
        List<SFDC_Job_Candidate__c> jcs = new List<SFDC_Job_Candidate__c>();
        SFDC_Job_Candidate__c jc1 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can1.id, status__c='Hired', interview_date__c = date.today().adddays(7),
                                                                Date_Candidate_Sent__c = date.today());
        jcs.add(jc1);
        SFDC_Job_Candidate__c jc2 = new SFDC_Job_Candidate__c( SFDC_job__c = j1.id, Candidate__c = can2.id, status__c='Rejected', Date_Candidate_Sent__c = date.today());
        jcs.add(jc2);
            
        insert jcs;
        
        NewServiceModel_Util.ProcessUptoTwoCandidateRule(j1, false);
        
        //process 2 hires
        NewServiceModel_Util.ProcessTransferToHireRule(j1, null, jc1, jc2);
        
        NewServiceModel_Util.FindMatchingJobs(j1);
        
              
        
    }
}