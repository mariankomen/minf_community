/*******************
Trigger: Case Email Message after insert
Description:  if a case email is sent in from the MFG group based on fromaddress, we want to move the contents into a Case Comment and
	delete the email and associated task.

Created: Aug 9/2013, Vankerk Solutions
Modification Log:
					Henry Caballero | floatintotheclouds | 6/4/2020 | Jira Issue => MFG-142
*******************/
trigger CaseEmail_AfterInsert on EmailMessage (after insert) {
    // list of emails from MFG domain to convert and delete
    List<EmailMessage> emailsToProcess = new List<EmailMessage>();
    
    for (EmailMessage e : trigger.new) {
        // if the from address is MFG then we want to process the email and delete
        if (e.parentid!=null && e.fromaddress.contains('mindfieldgroup.c')) {
            emailsToProcess.add(e);
        }
    }
    
    // if we have messages to process, call utility method to create case comments and delete new email/task in a future call
    if (emailsToProcess.size() > 0)
        Case_Util.MoveMFGEmailtoCaseComment(emailsToProcess);

}