@istest
private class ResetPortalPwdTest{
@istest
static void testReset(){
// create a user for this test
Profile p = [select id from profile where name = 'Mindfield.1 - Implementations Team' limit 1];
User u = new user(firstname = 'first', lastname = 'test', username = 'testpasswordreset@mfg.com', email = 'bademail@bademail.com',alias='testabc', communitynickname='testabc', managerid = Userinfo.getuserid(),EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey= 'en_CA', TimeZoneSidKey = 'America/Los_Angeles',profileid = p.id, user_classification__c = 'Demo Related');
insert u;
system.runas(u)
{
string results = 'start';
ResetPortalPwd con = new ResetPortalPwd();
results = con.ResetPwd().getURL();
system.debug(' results are: '+results);
}
}
}