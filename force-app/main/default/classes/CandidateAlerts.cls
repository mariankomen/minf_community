/*******************
Class: Candidate Alerts: extension to VF page of same name
Description: manages taking in a list of comma separated email addresses, sending a template email to each and cleaning them up.  Leaves
    one Task against the Candidate
    
Created: Mar 25/12, Niki Vankerk
Modification Log: 
    Jan 17/13: updates to test method for new system deploy
    Mar 19/13: added job posting only parameters so we can have different email templates for that type of job
    Mar 29/13: hard code Task to Jeff's user
    
*******************/
public class CandidateAlerts {

    private SFDC_Job_Candidate__c Candidate {get; set;}
    private Id TemplateId {get; set;}
    public boolean TempMissing {get; set;}
    public string emailAddresses {get; set;}
    public string Comments {get; set;}
    private List<Contact> cons {get; set;}
    public boolean emailComplete {get; set;}
    private string lang {get; set;}
    
    // initialize variables and check that we have the correct template Id passed in
    public CandidateAlerts(ApexPages.StandardController controller) {
        Candidate = (SFDC_Job_Candidate__c) controller.getRecord();
        emailAddresses = null;
        comments = null;
        cons = new List<Contact>();
        TemplateId = null;  
        emailComplete = false;
        // look for the template based on parameters in page and SLA level
        lang = UserInfo.getLanguage();
        string IdParm;
        // if sla is job posting only find specific templates based on language
        if (Candidate.sla_level__c == 'Job Posting Only')
            IdParm = ApexPages.currentpage().getparameters().get((lang == 'fr' ? 'FR_template_postonly' : 'template_postonly')); 
        // if we don't have the Id parameter set yet, try with the basic template (in case we didn't specify the Job Post only template correctly it won't fail
        if (IdParm == null)
            IdParm = ApexPages.currentpage().getparameters().get((lang == 'fr' ? 'FR_template' : 'template'));
        List<EmailTemplate> temp = new List<EmailTemplate>();
        temp = [select id, name from EmailTemplate where id= :IdParm limit 1];
        tempMissing = false;
        if (temp.size() != 1)  {
            tempMissing = true;
        }   
        else TemplateId = temp[0].id;          
    }

    // fired from Send Email button on the VF page, we check for at least some email address.  then create a temp Contact for each address,
    //    send the emails, create a single task and then delete contacts
    public PageReference sendAlert() {

        try {
            // test that we have email addresses
            if (emailAddresses == null || emailAddresses == '' ) {
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, (lang == 'fr' ? 'Veuillez entrer au moins une adresse de courriel' : 'Please enter at least one email address')));
                return null;
            } // if no addresses entered
            // break out each address by the comma and create new basic Contacts
            string[] recip = emailAddresses.split(',', -1);
            // system.debug('recipients: '+recip);
            cons = new List<Contact>();
            for (string r : recip) {
                Cons.add(new Contact(email = r, lastname = r, description = comments));
            }
            insert Cons;
            // now cycle through each Contact to create a set of emails
            Messaging.SingleEmailMessage[] mails = new Messaging.SingleEmailMessage[]{};
            for (Contact c : Cons) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(templateId);
                mail.settargetobjectid(c.id);
                mail.setWhatId(Candidate.id);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }

            //system.debug('mails being sent: '+mails);
            List<Messaging.SendEmailResult> res = Messaging.sendEmail( mails, false);
            if (!res[0].issuccess()) {
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, (lang == 'fr' ? 'Erreur survenue durant l’envoi du courriel de profil du candidat' : 'Error sending Candidate Profile email: ') 
                                                                                      +res[0].geterrors()[0].getmessage()));
                cleanupContacts();
                return null;
            }
            // create Task to record email
            // find Jeff's user by email, else grab current user
            User u;
            try { u = [select id, username from User where username = 'jeff.summers@mindfieldgroup.ca']; }
            catch (Exception e) { u = [select id, username, contact.ownerid from User where id = :UserInfo.getUserId()]; }
            Task t = new Task(whatid = Candidate.id, subject = 'Email: '+mails[0].getSubject(), type = 'Outbound Email', 
                description = 'Email sent to the following address(es): '+emailAddresses+'\n\n'+ mails[0].getplaintextbody(), 
                status = 'Completed', activitydate = date.today());
            // if we found jeff, use him as owner
            if (u.username == 'jeff.summers@mindfieldgroup.ca')
                t.ownerid = u.id;
            // if user is not a SF user, set owner to the contact's owner   
            else if (UserInfo.getUserType() != 'Standard')
                t.ownerid = u.contact.ownerid;
            insert t;
            //system.debug('new task: '+t);
            // delete the contacts now
            cleanupContacts();
            emailComplete = true;
            return null;
        } catch (Exception e) {
            cleanupContacts();
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.FATAL, 'Error sending Candidate Alert email: '+e));
            return null;
        }
    
    }
    
    // helper method to delete any temporary Contact that was inserted for the email send
    private void cleanupContacts() {
        Cons = [select id from Contact where id in :cons];
        if (Cons.size() > 0) delete cons;
    }

}