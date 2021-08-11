@isTest
public class NotificationsTriggerHandler_Test {
   Public static final String SCS_CR='[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Your custom notification is processed successfully."}},{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Your custom notification is processed successfully."}}]';
    
    @isTest
    public static void insertNotification(){ 
        
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        
        User userWithRole = (User)MFG_TestDataFactory.createsObject(new User(userroleid = r.id, profileid = UserInfo.getProfileId()),true);  
        System.runAs(userWithRole){
            Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(),true);
            
            
            List<Contact> contacts = (List<Contact>)MFG_TestDataFactory.createsObjectList(new Contact(AccountId=acc.id),10,null,true);
            List<User> portalUsers=new List<User>();
            for(Contact con:contacts){
                User user_en = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='fr',IsActive = true),false); 
                User user_fr = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false); 
                //portalUsers.add(user_en);
                portalUsers.add(user_fr);
            }
            
            insert portalUsers;
            
            SalesforceEndpointMock sem = new SalesforceEndpointMock(SCS_CR,200);
            System.Test.setMock(HttpCalloutMock.class, sem);
            System.Test.StartTest();
            List<Notification__c> notifications = (List<Notification__c>)MFG_TestDataFactory.createsObjectList(new Notification__c(),10,null,true);
           

            System.Test.StopTest();
        }
        
    }
    @isTest
    public static void updateNotification(){ 
        
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        
        User userWithRole = (User)MFG_TestDataFactory.createsObject(new User(userroleid = r.id, profileid = UserInfo.getProfileId()),true);  
        System.runAs(userWithRole){
            Account acc = (Account)MFG_TestDataFactory.createsObject(new Account(),true);
            
            
            List<Contact> contacts = (List<Contact>)MFG_TestDataFactory.createsObjectList(new Contact(AccountId=acc.id),10,null,true);
            List<User> portalUsers=new List<User>();
            for(Contact con:contacts){
                User user_en = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='fr',IsActive = true),false); 
                User user_fr = (User)MFG_TestDataFactory.createsObject(new User(ContactId=con.id,LanguageLocaleKey='en_US',IsActive = true),false); 
                //portalUsers.add(user_en);
                portalUsers.add(user_fr);
            }
            
            insert portalUsers;
             List<Notification__c> notifications = (List<Notification__c>)MFG_TestDataFactory.createsObjectList(new Notification__c(),10,null,true);
            
            SalesforceEndpointMock sem = new SalesforceEndpointMock(SCS_CR,200);
            System.Test.setMock(HttpCalloutMock.class, sem);
            System.Test.StartTest();
           
            for(Notification__c n:notifications){
                n.Display_End_Date__c=system.today().addDays(90);
            }
            update notifications;
            System.Test.StopTest();
        }
        
    }
    
    
    
    
    @TestVisible
    private class SalesforceEndpointMock implements HttpCalloutMock {

        private final String body;
        private final Map<String,String> headers = new Map<String,String>{'Content-Type' => 'application/json'};
            private final Integer statusCode;

        public HTTPResponse respond(HTTPRequest req) {
           
            HttpResponse res = new HttpResponse();
            for(String hdr :this.headers.keySet()){
                res.setHeader(hdr, headers.get(hdr));
            }
            if(this.body != null){
                res.setBody(this.body);
            }
            res.setStatusCode(this.statusCode);
            res.setStatus('status');
            return res;
        }

        public SalesforceEndpointMock(String body, Integer statusCode){
            this.body = body;
            this.statusCode = statusCode;
        }

    }
}