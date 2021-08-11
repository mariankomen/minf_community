@isTest
public class Job_Workflow_Test_Utility{

    // used by tests for creating portal user to own jobs (defaults to OFG profile)
    // and any OnDemand jobs that need an Opportunity created
    public static Opportunity o {get; set;}
    public static User u {get; set;}
    public static Opportunity o2 {get; set;}
    public static User u2 {get; set;}
    public static Opportunity o3 {get; set;}
    public static User u3 {get; set;}
    
    public static void setupUser(){
        // create Account
        Account a = new Account(name = 'ABC');
        insert a;
        o = new Opportunity(name = 'test', accountid = a.id, stagename = 'Initial', closedate = date.today(), Program_Duration__c=1);
        insert o;
        
        // create a portal user and Job Ref record for testing
        Profile p = [select id from Profile where name = 'OFG HirePortal Store User EN'];        
        Account a2 = new Account(name = 'test portal3', store_number__c = '1502', Store_Name__c = 'Test Store', BillingCountry='Canada');
        insert a2;
        system.debug('new account id: '+a2.id);
        Contact c = new Contact(accountid = a2.id, lastname = 'test contact2', email='niki2@vankerksolutions.com');
        insert c;
        u = new User(contactid = c.id, firstname='test', lastname = 'portal user3', email='niki2@vankerksolutions.com',
            username = 'sample99@mfg.com', alias='testabc2', communitynickname='testabc2', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p.id, HM_Portal_Language__c = 'English', user_classification__c = 'Demo Related');
        insert u;        
    }
    public static void setupUser2(){
        // create Account
        Account aUSA = new Account(name = 'ABCD');
        insert aUSA;
        o2 = new Opportunity(name = 'testUSA', accountid = aUSA.id, stagename = 'Initial', closedate = date.today(), Program_Duration__c=1);
        insert o2;
        
        // create a portal user and Job Ref record for testing
        Profile pUSA = [select id from Profile where name = '1800GotJunk HirePortal STORE User'];        
        Account a3 = new Account(name = 'test portal4', store_number__c = '1503', Store_Name__c = 'Test StoreUSA', BillingCountry='United States');
        insert a3;
        system.debug('new account id: '+a3.id);
        Contact cUSA = new Contact(accountid = a3.id, lastname = 'test contact4', email='niki2USA@vankerksolutions.com');
        insert cUSA;
        u2 = new User(contactid = cUSA.id, firstname='testUSA', lastname = 'portal user2USA', email='niki2USA@vankerksolutions.com',
            username = 'sample99USA@mfg.com', alias='test2USA', communitynickname='test2USA', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pUSA.id, user_classification__c = 'Demo Related');
        insert u2;        
    }
    public static void setupUser3(){
        // create Account
        Account aAUS = new Account(name = 'ABCDE');
        insert aAUS;
        o3 = new Opportunity(name = 'testAUS', accountid = aAUS.id, stagename = 'Initial', closedate = date.today(), Program_Duration__c=1);
        insert o3;
        
        // create a portal user and Job Ref record for testing
        Profile pAUS = [select id from Profile where name = 'Cactus Club Cafe HirePortal Store EN'];        
        Account a4 = new Account(name = 'test portal2AUS', store_number__c = '1504', Store_Name__c = 'Test StoreAUS', BillingCountry='Australia');
        insert a4;
        system.debug('new account id: '+a4.id);
        Contact cAUS = new Contact(accountid = a4.id, lastname = 'test contact2', email='niki2AUS@vankerksolutions.com');
        insert cAUS;
        u3 = new User(contactid = cAUS.id, firstname='testAUS', lastname = 'portal user2AUS', email='niki2AUS@vankerksolutions.com',
            username = 'sample99AUS@mfg.com', alias='test2AUS', communitynickname='test2AUS', managerid = Userinfo.getuserid(), 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = pAUS.id, user_classification__c = 'Demo Related');
        insert u3;        
    }
    
}