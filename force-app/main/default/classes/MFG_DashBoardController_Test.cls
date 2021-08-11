@isTest
public class MFG_DashBoardController_Test {
      Public static final String SCS_CR='[{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Your custom notification is processed successfully."}},{"actionName":"customNotificationAction","errors":null,"isSuccess":true,"outputValues":{"SuccessMessage":"Your custom notification is processed successfully."}}]';
    @isTest
    public static void getLastNotificationTest(){ 
         List<Notification__c> notifications = (List<Notification__c>)MFG_TestDataFactory.createsObjectList(new Notification__c(),10,null,true);
                    SalesforceEndpointMock sem = new SalesforceEndpointMock(SCS_CR,200);
            System.Test.setMock(HttpCalloutMock.class, sem);
        system.test.startTest();
        List<Notification__c> notification=    MFG_DashBoardController.getLastNotification();
        system.assertEquals(1, notification.size());
        system.Test.stopTest();
    }
   
    @isTest
    public static void getJobSummuryTest(){ 

        system.test.startTest();
      MFG_DashBoardController.JobSummury  jobSummury= MFG_DashBoardController.getJobSummury();
       system.assertNotEquals(null, jobSummury);
        system.Test.stopTest();
    } 
        
      @isTest
    public static void getScheduledInterviewsTest(){ 

        system.test.startTest();
      List<MFG_DashBoardController.ScheduledInterview> scheduledInterviews= MFG_DashBoardController.getScheduledInterviews() ;  
       
        system.Test.stopTest();
    } 
    @isTest
    public static void getsetNotificationStateTest(){
        MFG_DashBoardController.setNotificationState('test');
        String str = MFG_DashBoardController.getNotificationState();
        notificationState__c testData = (notificationState__c)JSON.deserialize(str, notificationState__c.class);
        System.assertEquals(testData.needShow__c, 'test');
    }
    @isTest
    public static void CustomSettingsDataForCheckingTest(){
        MFG_DashBoardController.setStaticUrl('test');
        String str = MFG_DashBoardController.getStaticUrl();
        url_data_check__c testData = (url_data_check__c)JSON.deserialize(str, url_data_check__c.class);
        System.assertEquals(testData.front_url__c, 'test');
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
    @isTest
    public static void getUserProfileTest(){
        MFG_DashBoardController.getUserProfile();
    }
}