public with sharing class TargetVolumeController {

    public Contract contr {get; set;}

    public TargetVolumeController(ApexPages.StandardController controller) {
        controller.addFields(new String[] { 'StartDate', 'EndDate', 'Frontline__c', 'Frontline_Price__c','Frontline_1__c', 'Frontline_1_Price__c', 'Frontline_2__c', 'Frontline_2_Price__c',  'Management_1__c', 'Management_1_Price__c', 'Management_2__c', 'Management_2_Price__c', 'Specialty_1__c', 'Specialty_1_Price__c', 'Specialty_2__c', 'Specialty_2_Price__c', 'Admin_Fee__c' });
        contr = (Contract) controller.getRecord();
    }    
    
    public PageReference ProcessTargetVolmes() {
        
        //call util class to create target volumes
        string result = NewServiceModel_Util.CreateTargetVolumes(contr);
    
        if(result=='true') { //successfully created target volumes
            return ReturnToContract();
        }
        else { //error or exception
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, result));
            return null;
        }             
    }

    public PageReference ReturnToContract() {
        PageReference ContractPage = new PageReference('/' + contr.id);
        ContractPage.setRedirect(true);
        return ContractPage;
    }


}