public class TestDataFactory {

    public static SFDC_Job_Candidate__c createCandidatewithCandidateRecord(Id jobId, Id canRecordId, string status) {
        return new SFDC_Job_Candidate__c(sfdc_job__c = jobId, candidate__c = canRecordId, status__c=status);
    }

    public static User setupPortalUserWith3Levels(string country, decimal cadTax, string language) {
        Account grand = new Account(name = 'grandparent'+country, billingcountry = country);
        insert grand;
        Account parent = new Account(name = 'parent'+country, billingcountry = country, parentid = grand.id);
        insert parent;
        Account location = new Account(name = 'location'+country, billingcountry = country, parentid = parent.id, cad_tax__c = cadTax);
        insert location;
        Contact con = new Contact(lastname = 'test con', firstname = 'Sam', accountid = location.id, email = 'gotjunktest@mindfieldgroup.com');
        insert con;
        Profile p_GOTJUNK = [select id from Profile where name = '1800GotJunk HirePortal REG User'];
        string UserAlias = country.remove(' ');
        if (UserAlias.length() > 8) UserAlias = UserAlias.left(8);
        User u = new User(contactid = con.id, firstname='Sam', lastname = 'test con', email='gotjunktest@mindfieldgroup.com',
            username = UserAlias+'@mindfieldgroup.com', alias=UserAlias, communitynickname=UserAlias, 
            EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey=language, LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',
            profileid = p_GOTJUNK.id); 
        insert(u);
        u = [select id, contactid, contact.accountid, contact.account.parentid, contact.account.parent.parentid, contact.account.parent.parent.name, LanguageLocaleKey from User where id = :u.id];
        return u; 
    }
}