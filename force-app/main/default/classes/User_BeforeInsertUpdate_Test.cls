@isTest
public class User_BeforeInsertUpdate_Test {
    
    static testmethod void testUserBeforeInsertUpdate(){
    
         //setup
       Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true);
       insert cp;
       Account a = new Account(name='Test Account', Client_Profile__c=cp.Id);
       insert a;
       Contact c = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
       insert c;
       User u = new User(firstname='Jeff', lastname='Perron', Username='jp@perron.com', Email='jp@perron.com', Alias='jp', CommunityNickname='jp', TimeZoneSidKey='Pacific/Chatham', 
                         LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId='00eU0000000JM7h',LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=false, contactid=c.id);
       insert u; //simulates new user setup and NSM check
    
    }
    
}