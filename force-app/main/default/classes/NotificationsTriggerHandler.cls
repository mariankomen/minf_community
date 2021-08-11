public class NotificationsTriggerHandler extends fflib_SObjectDomain{
    public NotificationsTriggerHandler(List<SObject> records){
        super(records); 
    }
    public static String customNotifTypeId=[SELECT Id, CustomNotifTypeName, DeveloperName, MasterLabel, Language, Desktop, Mobile, Description FROM CustomNotificationType WHERE DeveloperName='MFG_Notification' LIMIT 1].id;
    
    public static Map<id,User> recipientIds=new Map<id,User>([SELECT id, UserType, isPortalEnabled, LanguageLocaleKey  FROM User WHERE isActive=true and isportalenabled = true LIMIT 10000]);
    
    
    public override void onAfterInsert(){
        List<CustomNotificationActionInput> inputs=new List<CustomNotificationActionInput>();
        
        List<id> enUsersId=new list<id>();
        List<id> frUsersId=new list<id>();
        for(User user:recipientIds.values()){
            if(user.LanguageLocaleKey.containsIgnoreCase('fr')){
                frUsersId.add(user.Id);
            }else{
                enUsersId.add(user.Id);
            }
        }
        
        
        
        
        
        for(Notification__c notification :(List<Notification__c>)records) {
            
            if(notification.Displays__c!=null && notification.Displays__c=='Yes'){
                
                if(!enUsersId.isEmpty()){
                    for(Id uId:enUsersId){
                        CustomNotificationActionInput input = new CustomNotificationActionInput(customNotifTypeId,
                                                                                                new List<Id>{uId}, 
                                                                                                notification.Title__c,
                                                                                                notification.Body__c,
                                                                                                notification.Id);
                        inputs.add(input);  
                    }
                }
                
                if(!frUsersId.isEmpty()){
                    for(Id uId:frUsersId){
                        CustomNotificationActionInput input = new CustomNotificationActionInput(customNotifTypeId,
                                                                                                new List<Id>{uId}, 
                                                                                                (notification.Title_FR__c!=null?notification.Title_FR__c:notification.Title__c),
                                                                                                (notification.Body_FR__c!=null?notification.Body_FR__c:notification.Body__c),
                                                                                                notification.Id);
                        inputs.add(input);   
                    }
                }
            }
            
        }
        if(!inputs.isEmpty()){
            CustomNotificationAction action = new CustomNotificationAction(inputs);
            doCalloutFromFuture(JSON.serialize(action));
        }
    }
    
    
    
    
    
    public override void onAfterUpdate(Map<Id,SObject> oldRecords){
        List<CustomNotificationActionInput> inputs=new List<CustomNotificationActionInput>();
        
        List<id> enUsersId=new list<id>();
        List<id> frUsersId=new list<id>();
        for(User user:recipientIds.values()){
            if(user.LanguageLocaleKey.containsIgnoreCase('fr')){
                frUsersId.add(user.Id);
            }else{
                enUsersId.add(user.Id);
            }
        }
        
        for(Notification__c notification :(List<Notification__c>)records) {
            Notification__c oldnotification = (Notification__c)oldRecords.get(notification.Id);
            
            if( (notification.Display_Start_Date__c!=oldnotification.Display_Start_Date__c && notification.Displays__c=='Yes') ||
               (notification.Display_End_Date__c!=oldnotification.Display_End_Date__c && notification.Displays__c=='Yes')
              ){
                  
                  
                  if(!enUsersId.isEmpty()){
                      for(Id uId:enUsersId){
                          CustomNotificationActionInput input = new CustomNotificationActionInput(customNotifTypeId,
                                                                                                  new List<Id>{uId}, 
                                                                                                  notification.Title__c,
                                                                                                  notification.Body__c,
                                                                                                  notification.Id);
                          inputs.add(input);     
                      }
                      
                  }
                  
                  if(!frUsersId.isEmpty()){
                      for(Id uId:frUsersId){
                          CustomNotificationActionInput input = new CustomNotificationActionInput(customNotifTypeId,
                                                                                                  new List<Id>{uId}, 
                                                                                                  (notification.Title_FR__c!=null?notification.Title_FR__c:notification.Title__c),
                                                                                                  (notification.Body_FR__c!=null?notification.Body_FR__c:notification.Body__c),
                                                                                                  notification.Id);
                          inputs.add(input);  
                      }
                  }
                  
                  
              }
            
            
        }
        if(!inputs.isEmpty()){
            CustomNotificationAction action = new CustomNotificationAction(inputs);
            doCalloutFromFuture(JSON.serialize(action));
        }
    }
    
    
    @future (callout=true)
    public static void doCalloutFromFuture( String action) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('callout:MFG_UI_API' + '/services/data/v46.0/actions/standard/customNotificationAction');
        req.setMethod('POST');
        
        req.setHeader('Content-Type', 'application/json');
        req.setBody(action);
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
        
    }
    
    
    public class CustomNotificationAction {
        public List<CustomNotificationActionInput> inputs;
        public CustomNotificationAction(List<CustomNotificationActionInput> inputs){
            this.inputs=inputs;
        }
    }
    
    public class CustomNotificationActionInput{
        public String customNotifTypeId ;
        public List<String> recipientIds ;
        public String title ;
        public String body ;
        public String targetId ;
        public CustomNotificationActionInput(String customNotifTypeId, List<String> recipientIds,String title,String body,String targetId){
            this.customNotifTypeId=customNotifTypeId;
            this.recipientIds= recipientIds;
            
            this.title=title;
            this.body=body;
            this.targetId=targetId;
            
        }
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new NotificationsTriggerHandler(sObjectList);
        }
    }
}