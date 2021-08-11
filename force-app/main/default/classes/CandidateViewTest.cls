@istest
private class CandidateViewTest{
    @istest
    private static void testPg(){
        // create test Candidate and 2 References
        SFDC_Candidate__c can = new SFDC_Candidate__c(name = 'test');
        insert can;
        List<References__c> rs = new List<References__c>();
        References__c r1 = new References__c(Candidate_Record__c = can.id);
        rs.add(r1);
        References__c r2 = new References__c(Candidate_Record__c = can.id, Reference_Completed_Successfully__c = 'Completed');
        rs.add(r2);
        insert rs;
        
        Test.setCurrentPage(page.CandidateView);
        ApexPages.currentPage().getParameters().put('id', string.valueof(can.id)); 
        ApexPages.currentPage().getParameters().put('retURL', '\\apex\\CandidateListViews'); 
        ApexPages.StandardController con = new ApexPages.StandardController(can);
        CandidateView ext = new CandidateView(con);
        // breadcrumb on
        system.assertequals(ext.showBreadcrumb, true, 'breadcrumb on: '+ApexPages.currentPage().getParameters().get('retURL'));        
        // test that refs size is still 2
        system.assertequals(ext.refs.size(), 1);
        
        // test breadcrumb off
        ApexPages.currentPage().getParameters().remove('retURL'); 
        con = new ApexPages.StandardController(can);
        ext = new CandidateView(con);
        system.assertequals(ext.showBreadcrumb, false, 'breadcrumb off: '+ApexPages.currentPage().getParameters().get('retURL'));        
        
    }
    }