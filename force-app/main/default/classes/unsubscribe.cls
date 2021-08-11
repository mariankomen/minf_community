/*
Email Unsubscribe Service (Part of Pardot Replacement, ER: 00169837)
This will capture email sent to the email unsubscribe service.
It will use the emaiul address in the email and then find all contacts / leads and set the opt out checkbox.
*/


Global class unsubscribe implements Messaging.inboundEmailHandler{

    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env ) {
    
        // Create an inboundEmailResult object for returning 
        // the result of the email service.
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
         
        // Create contact and lead lists to hold all the updated records.
        List<Contact> lc = new List <contact>();
        List<Lead> ll = new List <lead>();
        
        //result.success = true; //set initial success
         
        /*
           We could use this to only unsub if they have 'unsubscribe' in the subject line.
           EG: mailto:email_unsubscribe@2ogae6zcu0gvcnhx6i82r163a3phzkoid42d8kj67hq3537ntz.0t-sjbeam.cs77.apex.sandbox.salesforce.com?subject=unsubscribe 
           String mySubject = email.subject.toLowerCase();
           String s = 'unsubscribe'; //can do this if wanted??
           Boolean unsubMe = mySubject.contains(s); 
        */
        
        // Opt out for Contacts ----------------------------------------------------------------------    
        try {
            // Look up all contacts with a matching email address.
            for (Contact c : [SELECT Id, Name, Email, HasOptedOutOfEmail
                              FROM Contact
                              WHERE Email = :env.fromAddress
                              AND hasOptedOutOfEmail = false
                              LIMIT 100]
            ) {
                // Add all the matching contacts into the list.   
                c.hasOptedOutOfEmail = true;
                lc.add(c);
            }
            // Update all of the contact records.
            update lc;
        }
        catch (Exception e) {
            SendErrorEmail(e, env.fromAddress);
        }   
        
        // Opt out for leads ----------------------------------------------------------------------------
        try {
            // Look up all leads matching the email address.
            for (Lead l : [SELECT Id, Name, Email, HasOptedOutOfEmail
                           FROM Lead
                           WHERE Email = :env.fromAddress
                           AND isConverted = false
                           AND hasOptedOutOfEmail = false
                           LIMIT 100]
             ) {
                // Add all the leads to the list.       
                l.hasOptedOutOfEmail = true;
                ll.add(l);
            } 
            // Update all lead records in the query.
            update ll;
        }
        catch (Exception e) {
            SendErrorEmail(e, env.fromAddress);
        }   
          
        return result;
    }   
    
    
    //send error if unsubscribe doesn't work
    public static void SendErrorEmail(Exception e, String unsubsEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'jeff.perron@mindfieldgroup.com', 'mfgsysadmin@mindfieldgroup.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Mindfield Group: Email Service Unsubscribe Error');
        mail.setPlainTextBody('There was an issue with the following person, ' + unsubsEmail + ', trying to unsubscribe using our email service. Please manually find this person as a contact and/or lead in Salesforce and opt them out from future emails. See the following for error details: ' + e);//.getStackTraceString());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    
}