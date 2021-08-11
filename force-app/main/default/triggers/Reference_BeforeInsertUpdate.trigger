/*********************
Trigger: Reference Before Insert/Update
Description:  link the Reference to the Candidate that was most recently modified for an open job
              run autofill logic if the FGL fields start with a "Y;"
              
Created: Apr 14/2013, Vankerk Solutions
Modification Log:
    July 9/13: added new util method to find open candidates for each cand rec and changed to before insert and update to populate candidate link
    Mar 24/14: commented out email/HD email logic so we can rename fields in Prod, then back in
    
*********************/
trigger Reference_BeforeInsertUpdate on References__c (before insert, before update) {

    // map with Candidate Record to find open Candidates
    Map<Id, SFDC_Candidate__c> CandRecMap = new Map<Id, SFDC_Candidate__c>();

    // cycle through references to gather Candidate Rec ids if candidate link is blank
    // also check that email is valid as HireDesk sync sometimes sends 'N/A' or 'none' over as a string
    for (References__c r : trigger.new) {
        if (r.candidate__c == null) {
            CandRecMap.put(r.Candidate_Record__c, new SFDC_Candidate__c());
        }
        // if insert, test email for valid email formatting and then move into HD Email field
        //  NOTE that Hire desk syncs with email__c field which was type email. In order to avoid changing the sync, we have created a new text field
        //   called email__c and renamed the existing email type field to HireDesk_Email__c.  the labels are opposite so that the end user sees no change.
        if (trigger.isinsert && r.email__c != null) {
            Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
                
            //System.debug('Email address: ' + r.email__c);
            Matcher m = p.matcher(r.email__c);
            if (m.matches()) {
                r.hiredesk_email__c = r.email__c;
            } 
        }  // end if insert with email
        
    } // end loop
    // send CandMap into utility to pull in most recently modified open candidate
    CandRecMap = Job_Util.FindOpenCandidate(CandRecMap);

    // now cycle through References again and add candidate link if possible, also find/replace autotext in FGL fields
    for (References__c r : trigger.new) {
        if (r.candidate__c == null && CandRecMap.containskey(r.candidate_record__c) && CandRecMap.get(r.candidate_record__c).Candidates_Submitted_to_Job1__r.size() == 1) {
            r.candidate__c = CandRecMap.get(r.candidate_record__c).Candidates_Submitted_to_Job1__r[0].id;
        } // end if candidate link needs populating
        // Check FGL fields for Y; to replace with auto text statements
        // determine if past or present tense used based on Type
        boolean presentTense = true;
        if (r.type__c == 'Past Manager') presentTense = false;
        // FGL Applicant Attendance: There is/are no issues with <fname>'s attendance or punctuality
        if (r.FGL_Applicant_Attendance__c != null && r.FGL_Applicant_Attendance__c.startswithignorecase('Y;')) 
            r.FGL_Applicant_Attendance__c = 'There ' + (presentTense ? 'are ' : 'were ') + 'no issues with ' + r.candidate_first_name__c + '\'s attendance or punctuality.'
                + r.FGL_Applicant_Attendance__c.removeStartIgnoreCase('Y;');
        // FGL Applicant Job Duties: <fname> is/was responsible for 
        if (r.FGL_Applicant_job_duties__c != null && r.FGL_Applicant_job_duties__c.startswithignorecase('Y;')) 
            r.FGL_Applicant_job_duties__c = r.candidate_first_name__c + (presentTense ? ' is ' : ' was ') + 'responsible for' + r.FGL_Applicant_job_duties__c.removeStartIgnoreCase('Y;');            
        // FGL Applicant Team Player: Yes, <fname> is/was a team player 
        if (r.FGL_Applicant_team_player__c != null && r.FGL_Applicant_team_player__c.startswithignorecase('Y;')) 
            r.FGL_Applicant_team_player__c = 'Yes, ' + r.candidate_first_name__c + (presentTense ? ' is ' : ' was ') + 'a team player.' + r.FGL_Applicant_team_player__c.removeStartIgnoreCase('Y;');            
        // FGL Would you rehire: Yes, <Ref fname> <Ref lname> would rehire <fname>
        if (r.FGL_would_you_rehire__c != null && r.FGL_would_you_rehire__c.startswithignorecase('Y;')) 
            r.FGL_would_you_rehire__c= 'Yes, ' + (r.First_Name__c == null ? '' : r.First_Name__c + ' ') + (r.last_name__c == null ? '' : r.last_name__c + ' ') + 'would rehire ' + r.candidate_first_name__c + '.' + r.FGL_would_you_rehire__c.removeStartIgnoreCase('Y;');            
    } // end loop through refs

}