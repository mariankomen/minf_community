@isTest
public class HirePortal_FAQ_QCP_NSM_Controller_Test {
    
    static final String PORTAL_PROFILE_NAME = 'Canadian Tire hireportal Store User EN';
    
    @testSetup static void setup() {
        //setup
        Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true);
        insert cp;
        Account a = new Account(name='Test Account', Client_Profile__c=cp.Id);
        insert a;
        Contact c = new Contact(firstname='Jeff', lastname='Perron', accountid=a.id);
        insert c;
        
        Profile prof = [SELECT Id FROM Profile WHERE Name =: PORTAL_PROFILE_NAME LIMIT 1];
        User u = new User(firstname='Jeff', lastname='Perron', Username='jp_apextest@perron.com', Email='jp@perron.com', Alias='jp', CommunityNickname='jp', TimeZoneSidKey='Pacific/Chatham', 
                          LocaleSidKey='en_US', EmailEncodingKey='UTF-8',  ProfileId=prof.Id, LanguageLocaleKey='en_US', Client_Profile_Using_New_Service_Model__c=false, contactid=c.id);
        insert u;

        Attachment att = new Attachment(name='Section - File 1', ParentId=cp.Id, Body=Blob.valueof('myString'));
        insert att;
    }
    
    public static testmethod void doTest () {
        List<User> user = [SELECT Id FROM User WHERE Profile.Name =: PORTAL_PROFILE_NAME AND Username = 'jp_apextest@perron.com' LIMIT 1];
        List<Attachment> lQCP = [SELECT Id, Name FROM Attachment];
        
        Test.setCurrentPage(Page.HirePortal_FAQ);  // not really needed to test the component itself
        System.runAs(user[0]) { //run as user setup above
            HirePortal_FAQ_QCP_NSM_Controller cont = new HirePortal_FAQ_QCP_NSM_Controller();
        }
    }
    
    public static testmethod void getResourcesTest () {
        List<User> user = [SELECT Id FROM User WHERE Profile.Name =: PORTAL_PROFILE_NAME AND Username = 'jp_apextest@perron.com' LIMIT 1];
        
        System.runAs(user[0]) { //run as user setup above
        	HirePortal_FAQ_QCP_NSM_Controller.QCPResourceWrapper QCPWrapper = HirePortal_FAQ_QCP_NSM_Controller.getResouces();
            
            System.assertEquals(true, QCPWrapper.isNSMEnabled);
            System.assertEquals(1, QCPWrapper.attachments.size());
        }
    }
    
}