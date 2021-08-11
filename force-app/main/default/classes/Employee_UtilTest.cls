@isTest
public class Employee_UtilTest {

    // create new user to run approvals with current user as the Manager for approvals processing
    @testSetup private static void testData() {
        User admin = new User(firstname = 'Joe', lastname = 'Admin', //User_Classification__c = 'HR User - Standard',
                username = 'admintest@testingMFG.com', email = 'test@vankerksolutions.com', alias = 'testadmi', 
                CommunityNickname = 'testadmin', EmailEncodingKey = 'ISO-8859-1', LocaleSidKey = 'en_CA',LanguageLocaleKey = 'en_US', 
                              TimeZoneSidKey='America/Los_Angeles', ManagerId = userinfo.getUserId());
        admin.ProfileId = [select id from profile where name = 'System Administrator' limit 1][0].id;
        insert admin;

    }
    // TEST METHODS //
    private static testmethod void testApprovals(){
        User admin = [select id from user where username = 'admintest@testingMFG.com' limit 1];
        system.runas(admin) {
            // create Employee and PTO request
            SFDC_Employee__c e = new SFDC_Employee__c(name = 'test');
            insert e;
            SFDC_PTO_Request__c p = new SFDC_PTO_Request__c(employee__c = e.id, Request_Type__c = 'Vacation', submit_to_manager__c = true);
            test.starttest();
            insert p;
            test.stoptest();
            p = [select id, Status_of_Request__c, submit_to_manager__c, Date_of_Request__c from SFDC_PTO_Request__c where id = :p.id];
            system.assertequals(p.submit_to_manager__c, false, 'new PTO has gone through approvals and submit to manager turned off: '+p);
            p.submit_to_manager__c = true;
            update p;
        }
    }
}