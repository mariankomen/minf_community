//Controller for LMP Wrapper
//April 24, 2017
public class LMPWrapperController{

    private SFDC_Candidate__c cand;
              
    public boolean haveLMP {
        get { return cand.LMP_Report_URL__c != null; }
    }
    public boolean cannotFindLMP {
        //either exception OR 'HRNX Message: Not Found'
        get { return cand.LMP_Report_URL_Exception__c != null; }
    }
    public boolean tryToGetLMP {
        //try to get LMP if report URL is empty and no exceptions
        //also, only try once or we will get in infinate loop
        get { return !haveLMP && !cannotFindLMP; }
    }
    
    //ctor
    public LMPWrapperController() {
        this.cand = [SELECT Id, Name, LMP_Report_URL__c, LMP_Report_URL_Exception__c, Auto_HireDesk_GUID_Lookup__c FROM SFDC_Candidate__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }

    //redirect to LMP
    public PageReference redirectToLMP() {
    
        PageReference pageRef;
    
        //redirect to LMP
        if(cand.LMP_Report_URL__c != null) {
            pageRef = new PageReference(cand.LMP_Report_URL__c);
        }
        else { // didnt have LMP so getLMP function was called, so redirect back to page...wait for retieval of URL from web service
            pageRef = new PageReference('/apex/LMP_Wrapper?id=' + cand.id);
        }
        pageref.setRedirect(true);
        return pageRef;
    }

    //call webservice method to try to get LMP link from HRNX
    //called in page action
    public void getLMP() {
        if(tryToGetLMP) {
            HNRX_Webservice.retieveLMPURL(this.cand.Auto_HireDesk_GUID_Lookup__c, this.cand.id);
        }
    }
}