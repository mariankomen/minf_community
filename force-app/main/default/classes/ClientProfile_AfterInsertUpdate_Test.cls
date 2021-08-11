@isTest
public class ClientProfile_AfterInsertUpdate_Test {
    
    static testmethod void testClientProfileAfterInsertUpdate(){
    
        //create new profile
        Client_Profile__c cp = new Client_Profile__c(name='Test Client Profile', Using_New_Service_Model__c=true);
        insert cp;
        
        //update field....trigger detects this and tries to update users....DONE
        cp.Using_New_Service_Model__c=false;
        update cp;
    
    }
    
}