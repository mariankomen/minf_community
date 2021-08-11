public class HirePortal_FAQ_QCP_NSM_Controller {

    public Boolean IsNSM {get; set;}
    public List<Attachment> lQCP {get; set;}
    public List<NewServiceModel_Util.QCPSectionWrapper> lQCPSectionWrapper {get; set;}

    //ctor
    public HirePortal_FAQ_QCP_NSM_Controller() {
        Client_Profile__c cp = NewServiceModel_Util.FindCurrentUserClientProfile(UserInfo.getUserId());
        
        System.debug(cp);
        //List<NewServiceModel_Util.QCPSectionWrapper> lQCPSectionWrapper = new List<NewServiceModel_Util.QCPSectionWrapper>();
        if(cp != null) { //found a client profile for user, get qcp list
            lQCP = [SELECT a.ParentId, a.Name, a.Id From Attachment a WHERE a.ParentId =:cp.Id ORDER BY a.Name];
            lQCPSectionWrapper = NewServiceModel_Util.BuildQCPList(lQCP);
            IsNSM = cp.Using_New_Service_Model__c;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static QCPResourceWrapper getResouces() {
        QCPResourceWrapper resourceWrapper = new QCPResourceWrapper();
        
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        Client_Profile__c cp = NewServiceModel_Util.FindCurrentUserClientProfile(UserInfo.getUserId());

        if(cp != null) { //found a client profile for user, get qcp list
        	resourceWrapper.isNSMEnabled = cp.Using_New_Service_Model__c;
            resourceWrapper.attachments = [SELECT a.ParentId, a.Name, a.Id From Attachment a WHERE a.ParentId =:cp.Id ORDER BY a.Name];
        }
       
        return resourceWrapper;
    }
    
    public class QCPResourceWrapper {
        @AuraEnabled public Boolean isNSMEnabled;
        @AuraEnabled public List<Attachment> attachments;
        
        public QCPResourceWrapper() {
            this.isNSMEnabled = false;
            this.attachments = new List<Attachment>();
        }
    }

}