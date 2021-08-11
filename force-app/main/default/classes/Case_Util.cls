/*****************************
  Class: Case_Util
  Purpose: This class contains utility methods for Case logic

  Created: Aug 10/13 by Niki Vankerk, Vankerk Solutions, Inc
  Modification Log:
        Sept 9/13: added method to update Recruiter job Id list field on cases
        July 26/14: updated Email to Case Comment method to keep email/task if there is an attachment
        Aug 1/14: Updated skip method to include Nick Onusko
*****************************/
public class Case_Util{

    public static void MoveMFGEmailtoCaseComment(list<EmailMessage> msgs) {
        // set of email Ids to delete in future method
        Set<Id> emailIdsToDelete = new Set<Id>();
        // set of email related tasks to delete as well
        Set<Id> emailTaskIdsToDelete = new Set<Id>();
        // list of Case Comments to create
        List<CaseComment> newComments = new List<CaseComment>();
        // cycle through passed in email messages to record ID and Task ID then build Case Comment
        for (EmailMessage e : msgs) {
           // if the email has an attachment, keep Email and related Task
           if (!e.hasattachment) {
               emailIdsToDelete.add(e.id);
               emailTaskIdsToDelete.add(e.activityid);
           }
           // build new case comment
           CaseComment c = new CaseComment( CommentBody  = 'Email Received from: '+ e.fromname+ '<' + e.fromaddress+'>\nEmail Body:\n',
                                            ParentId = e.parentid,
                                            IsPublished = true);
            // try to remove original email thread based on looking for "From: SalesForce Case Updates"
            string emailBody;
            // look for first occasion of [cid from MFG footer images
            if (e.textbody.containsIgnoreCase('[cid')) 
                 emailBody = e.textbody.left(e.textbody.indexof('[cid'));
            // otherwise look for the start of the forwarded case comment email that MFG recruiter is responding to
            else if (e.textbody.containsIgnoreCase('From: SalesForce Case Updates')) 
                 emailBody = e.textbody.left(e.textbody.indexof('From: SalesForce Case Updates'));
            // in testing we aren't getting the org wide address so looking for noreply 
            else if (e.textbody.containsIgnoreCase('From: noreply@salesforce.com')) 
                 emailBody = e.textbody.left(e.textbody.indexof('From: noreply@salesforce.com'));
            else
                 emailBody = e.textbody;    
             // add response text from email into Case comment body    
             
             //June 2019, update to catch if body limit gets over 4000 chars
             string tempComments = c.commentbody + emailBody;
             if(tempComments.length() < 4000) {
                 c.commentbody += emailBody;
             }
             newComments.add(c);  
        }
        // if we have new comments, add them
        if (newComments.size() > 0) insert newcomments;
        // now call delete method for email and task
        if (msgs.size() > 0) case_util.deleteCaseEmails(emailIdsToDelete, emailTaskIdsToDelete);        
    }
    
    @future
    public static void DeleteCaseEmails(Set<Id> emails, Set<Id> tasks) {
        // if we have emails to delete, do so now
        if (!emails.isempty()) { delete [select id from EmailMessage where id in :emails]; }
        if (!tasks.isempty()) { delete [select id from Task where id in :tasks]; }
    }
    
    // method called by Job Case Link after insert/delete will rebuild the Case field: Case is related to job (Recruiter)
    public static void RecalcCaseIsForJobRecruiter(Set<Id> CaseIds){
        List<Case> CaseUpd = new List<Case>();
        for (Case c : [select id, Case_is_Related_to_Job_from_Recruiters__c, (select id, job__c, job__r.name from case_job_links__r order by job__r.name) from Case where id in :CaseIds]) {
            // build list of jobIds separated by comma
            string JobList = '';
            for (case_job_link__c cj : c.case_job_links__r) {
                JobList += cj.job__r.name + ',';
            } // end loop through link recs
            // if we have a comma at the end, remove it
            JobList = JobList.removeEnd(',');
            // if it is an empty string, replace with null so it sets the case field to null
            if (JobList == '') JobList = null;
            // if this is different than current value on case, add to update list
            if (c.Case_is_Related_to_Job_from_Recruiters__c != JobList) {
                c.Case_is_Related_to_Job_from_Recruiters__c = JobList;
                CaseUpd.add(c);
            }// end if case field different
        } // end loop through cases
        // if we have cases to update, do so now
        if (CaseUpd.size() > 0) update CaseUpd;
    }
    
    // from before insert case trigger, cases that are MFG Helpdesk with the Recruiter/MFG Employee link null are passed
    //   here.  We set the value based on whether the case came from Email-to-case or ws manually created by a non-admin
    // 1. If webname is NOT blank (email to case) match the web name/email to User
    // 2. If webname is blank (manually created) and running user is NOT MFG Admin, Andy, Gary, or Nick, we use the running user
    // 3. If webname is blank and running user is one of those admins we don't know who the case was created for so leave it
    //     blank.

    public static void MFGHelpdeskCaseLinktoRecruiter(list<Case> cases) {
        // set of web names to use for finding users
        set<string> WebNames = new set<string>();
        map<string, User> WebNameUserMap = new map<string, User>();
        
        // set of running users that we will skip matching if case created directly (MFG, Andy, Gary, Nick)
        set<Id> SkipUsers = new set<Id>{'005U0000001dhAZIAY','005U0000001fxqTIAQ','005U0000002htDUIAY','005U0000003ILFk'};
        boolean isaSkipUser = SkipUsers.contains(userinfo.getuserid());
        // list of cases that need matching based on Web email/name
        list<Case> UserLookupCases = new list<Case>();
        
        // cycle through incoming cases to see if they need matching/updating
        for (Case c : cases) {
            // if webemail is not blank we need to match so add email to set and case to Lookup list for further processing
            if (c.suppliedname != null) {
                WebNames.add(c.suppliedname);
                UserLookupCases.add(c);
            }
            // else web email is blank so check running user not in the skip list, populate with running user info
            else if (!isaSkipUser) {
                c.recruiter_mfg_employee__c = userinfo.getuserid();
                c.Recruiter_MFG_Employee_Email__c = userinfo.getuseremail();
            }
        } // end first loop through cases
        
        // if we have lookup cases, populate map with matching user records
        if (UserLookupCases.size() > 0) {
            // build map of username to User for any web emails encountered
            for (User u : [select id, username, email, name, firstname, lastname from user where name in :WebNames and isactive = true
                            and usertype = 'Standard'])
                WebNameUserMap.put(u.name, u);
            for (case c : userlookupcases)
                if (WebNameUserMap.containskey(c.suppliedname)) {
                    c.recruiter_mfg_employee__c = WebNameUserMap.get(c.suppliedname).id;
                    c.Recruiter_MFG_Employee_Email__c = WebNameUserMap.get(c.suppliedname).email;
                }
        } // end if lookup cases
    } 
}