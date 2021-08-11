/*
Test class for apex class: unsubscribe
*/

@isTest
private class unsubscribeTest {
           
    static testMethod void testUnsubscribe() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
    
       // Create a new test lead and insert it in the test method.
       Lead l = new lead(firstName='John', 
                lastName='Smith',
                Company='Salesforce', 
                Email='user@acme.com', 
                State='British Columbia',
                HasOptedOutOfEmail=false);
       insert l;
    
       // Create a new test contact and insert it in the test method.
       Contact c = new Contact(firstName='john', 
                    lastName='smith', 
                    Email='user@acme.com', 
                    HasOptedOutOfEmail=false);
       insert c;
       
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'unsubscribe';
       env.fromAddress = 'user@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       unsubscribe unsubscribeObj = new unsubscribe();
       unsubscribeObj.handleInboundEmail(email, env );
                            
    }
   
}