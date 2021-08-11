public without sharing class MFG_UserProfileController {
    @AuraEnabled
    public static sObject getUserDetails(){
        return [SELECT FullPhotoUrl, SmallPhotoUrl, MediumPhotoUrl, BannerPhotoUrl, SmallBannerPhotoUrl, MediumBannerPhotoUrl, Street, Signature, StayInTouchSignature, AboutMe, Special_Configuration_Comments__c, Username, LastName, FirstName, Name, CompanyName, Division, Department, Title, City, State, PostalCode, Country, SenderName, StayInTouchSubject, StayInTouchNote, Alias,
                CommunityNickname, BadgeText, EmployeeNumber, FederationIdentifier, OutOfOfficeMessage, User_Profile_Name__c, Billing_Type__c, Division_Name__c, Region_Name__c, Reports_To__c, SSO_Store_Name__c, Store_Manager_Name__c, Store_Number__c, OLDSFID__c, Store_ID__c, Five9_Station_ID__c, Extension__c, Multi_Service_User__c, Client_Display_Name__c, User_License_reporting__c, dsfs__DSProSFMembershipStatus__c, Active_Client_Profile__c, Client_Profile_CAND_FCR_Value__c, Client_Profile_Int_Sch_Value__c, Client_Profile_JOB_FCR_Value__c, Client_Profile_References_Value__c, Client_Profile_CAND_CSS_Value__c, Client_Profile_JOB_CSS_Value__c, dsfs__DSProSFPassword__c, dsfs__DSProSFUsername__c, UserRoleId, ProfileId, DelegatedApproverId, ManagerId, CreatedById, LastModifiedById, ContactId, AccountId, CallCenterId, IndividualId, Job_Approver_4__c, Job_Approver_1__c, Job_Approver_2__c, Job_Approver_3__c, manager__c, HR_User_Approver__c, HR_User__c, X1st_Level_Manager__c, X2nd_Level_Manager__c, X3rd_Level_Manager__c, StateCode, CountryCode, GeocodeAccuracy, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, UserType, LanguageLocaleKey, PortalRole, DigestFrequency, DefaultGroupNotificationFrequency, Added_to_Security_Group__c, Alias_Added_to_HD__c, Created_Sharing_Rule_on_Parent_Acct__c, Job_Approval_Type__c, Job_Owner_Reference_Created__c, Location_Posted_on_Telemetry__c, SSO_Client_Name__c, User_Classification__c, HM_Portal_Language__c, Team__c, Career_Site_Language__c, Phone, Fax, MobilePhone, Extension, NumberOfFailedLogins, Id, Email, SenderEmail, Latitude, Longitude, LastLoginDate, LastPasswordChangeDate, CreatedDate, LastModifiedDate, SystemModstamp, OfflineTrialExpirationDate, OfflinePdaTrialExpirationDate, LastViewedDate, LastReferencedDate 
                FROM User WHERE id=:UserInfo.getUserId() LIMIT 1].get(0);
    }
    
    @AuraEnabled
    public static UserPicklist getPiclistOptions(){
        return new UserPicklist();
    }    
    public class UserPicklist{
        @AuraEnabled  public list<SelectOpt> locale;
        @AuraEnabled public list<SelectOpt> timeZone;
        public UserPicklist(){
            this.locale=getPicklistValues('User', 'LocaleSidKey');
            this.timeZone=getPicklistValues('User', 'TimeZoneSidKey');
        }
        public  list<SelectOpt> getPicklistValues(String ObjectApi_name, String fld){
            list<SelectOpt> options = new list<SelectOpt>();
            
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType objType = Object_name.getSObjectType();
            
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
            list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : values){ 
                options.add(new SelectOpt(a.getLabel(), a.getValue())); 
            }
            return options;
        }
    }
    
    @AuraEnabled
    public static void saveUserDetails(String user){
        system.debug(user);
        if(!string.isEmpty(user)){
            User u=(User)system.JSON.deserialize(user, User.class);
            update u;
       }  
    }
    


    public class SelectOpt{
        @AuraEnabled  public String label;
       @AuraEnabled   public String value;
        public SelectOpt(String label,String value){
            this.label=label;
            this.value=value;
        }
    }
}