@isTest
private class ClientProfileTrigger_Test {
	
    private static RecordType rt_FCR  =  [select id, name from recordtype where name = '1800GotJunk-FCR' and sobjecttype = 'SFDC_Job__c']; 
    private static RecordType rt_CSS = [select id, name from recordtype where name = '1800GotJunk-CSS' and sobjecttype = 'SFDC_Job__c']; 
	private static RecordType rt_PO = [select id, name from recordtype where name = '1800GotJunk-PO' and sobjecttype = 'SFDC_Job__c']; 

    private static testmethod void testClientProfileTriggerFail() {
        // test clientprofile error if name doesn't match
        list<client_profile__c> cptrigger = new list<client_profile__c>(); 
        Client_Profile__c cpfcr = new Client_Profile__c(name = 'fcr test', fcr_record_type_name__c = 'no match');
        cptrigger.add(cpfcr);
        Client_Profile__c cpcss = new Client_Profile__c(name = 'css test', css_record_type_name__c = 'no match');
        cptrigger.add(cpcss);
        Client_Profile__c cp_po = new Client_Profile__c(name = 'PO test', po_record_type_name__c = 'no match');
        cptrigger.add(cp_po);   
        test.starttest();     
        try { insert cptrigger; system.assert(false, 'should have errored');}
        catch (Exception e) {}
        test.stoptest();
        // no CPs created
        system.assertEquals(0, [select count() from Client_Profile__c], 'no records created');

    }

    private static testmethod void testClientProfileTriggerSuccess() {
        // test clientprofile error if name doesn't match
        list<client_profile__c> cptrigger = new list<client_profile__c>(); 
        Client_Profile__c cpfcr = new Client_Profile__c(name = 'fcr test', fcr_record_type_name__c = rt_FCR.name);
        cptrigger.add(cpfcr);
        Client_Profile__c cpcss = new Client_Profile__c(name = 'css test', css_record_type_name__c = rt_CSS.name );
        cptrigger.add(cpcss);
        Client_Profile__c cp_po = new Client_Profile__c(name = 'PO test', po_record_type_name__c = rt_PO.name);
        cptrigger.add(cp_po);   
        test.starttest();     
        insert cptrigger; 
        test.stoptest();
        cptrigger = [select id, name, fcr_record_type_name__c, fcr_record_type_id__c, css_record_type_name__c, css_record_type_id__c, po_record_type_name__c, po_record_type_id__c
            from Client_Profile__c where id in :cptrigger];
        system.assertequals(cptrigger[0].name, 'fcr test', 'looking at fcr profile');
        system.assertequals(cptrigger[0].fcr_record_type_id__c, rt_FCR.id, 'FCR rec type match');
        system.assertequals(cptrigger[1].name, 'css test', 'looking at css profile');
        system.assertequals(cptrigger[1].css_record_type_id__c, rt_CSS.id, 'CSS rec type match');
        system.assertequals(cptrigger[2].name, 'PO test', 'looking at PO profile');
        system.assertequals(cptrigger[2].po_record_type_id__c, rt_PO.id, 'PO rec type match');        

    }	
}