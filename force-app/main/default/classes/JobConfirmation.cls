/*********************
CLass: Job Confirmation, extension to VF page
Description: VF page is showing confirmation text regarding a new job that was just created.  Here we query for the job to get various fields that are
    needed in the job page for display or to decide what text to show/hide
    
Created: Nov 10/11, Vankerk Solutions
Modification Log:
    Nov 15/11: added SLA Level and Record Type Id to list of available fields
    July 9/12: added Delivery Agreement fields
    Jan 15/13: updated test method for new system deploy
    June 15/13: added Num Open Candidates field to query
    Sept 22/13: added code to use field values in creating duplicate URL
    Nov 5/13: update duplicate job link to use JobPreview as saveURL parameter

*********************/
public class JobConfirmation{

    // job that was just created, for reference in selecting text etc
    public SFDC_Job__c job {get; set;}
    // user language for use in VF page to display french or english
    public string lang {get ;set;}
    // boolean to determine if we display the Num open candidates message for this job - based on banner/Product
    public boolean showOpenCandidates {get; set;}
    // duplicate button fields
    public boolean allowDuplication {get; set;}
    public string duplicateURL {get; set;}
    
    public JobConfirmation() {
        job = new SFDC_Job__c();
        // see if we have a newid parameter on the page
        if (ApexPages.currentPage().getParameters().get('newid') != null)
            try { job = [select id, online_posting__c, name, Specific_Candidate_Preference__c, SLA_Level__c, recordtypeid, Num_of_Candidates_for_Delivery_Agreement__c,
                         Num_of_Days_for_Delivery_Agreement__c, num_open_candidates_upon_creation__c, HM_Portal_Phone_Number__c, MindField_Job_Type__c, OWF_Banner_of_Store__c,
                         Job_Description__c, Job_Preview_Pending__c, Job_Description_original__c
                         from SFDC_Job__c where id = :ApexPages.currentPage().getParameters().get('newid')]; }
            catch (Exception e) { }
        // if there is no paramter we will refer to the new, empty job created above
        // set user language for reference in VF page
        lang = Userinfo.getlanguage();
        
        // set showOpenCandidates - if banner OG is Save on Foods AB and Product not in a set, then we show the message if num open candidates > x (defined on page)
        if (job.OWF_Banner_of_Store__c == 'Save on Foods - AB' &&
                    job.MindField_Job_Type__c != 'TalentConnect - Post Only' &&
                    job.MindField_Job_Type__c != 'TalentConnect - Priority Post' &&
                    job.MindField_Job_Type__c != 'TalentConnect - Promote Post' &&
                    job.MindField_Job_Type__c != 'TalentReach')
            showOpenCandidates = true;
        else
            showOpenCandidates = false;
            
        // build Duplicate button code if user is not in profile that is banned from adding jobs
        // cycle through custom setting where full profile name is in Profile name custom field (too long for setting Name to be used)
        //allowDuplication = true;
        allowDuplication = !NewServiceModel_Util.IsSOFSourcingUser(Userinfo.getUserId());
        
        duplicateURL = '';
        // need user's profile name which we have to query from Profile table
        Profile userProfile = [select id, name from Profile where id = :userinfo.getprofileid()];
        for (BannedProfileList__c p : BannedProfileList__c.getall().values()) {
            // is current user's profile a match
            if (p.Profile_Name__c == userProfile.name) {
                allowDuplication = false;
                break;
            } // end if profile name matched
        } // end loop through banned profiles 
        // if we are allowed to show duplicate button, build button link
        if (allowDuplication) {
            // now build duplicate link using fields to null custom setting
            duplicateURL = job.id+'/e?clone=1&00NU0000003Auge=Open/Active Job&saveURL=/apex/jobPreview&retURL=/'+job.id;
            // now add other fields to be nulled out stored in Custom Setting
            for (CloneJobFields__c f : CloneJobFields__c.getall().values())
                duplicateURL += '&'+f.name+'='+(f.field_value__c == null ? '' : f.field_value__c); 
        }      
    }

}