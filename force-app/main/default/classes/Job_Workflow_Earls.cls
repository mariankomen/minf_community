/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, June 10/14
Modification Log:
    
****************************/
public class Job_Workflow_Earls {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 

        // Global settings for all roles
        j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
        j.sla_level__c = 'Front Line';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        j.Num_of_Days_for_Delivery_Agreement__c = 5;
        j.Credits_Used_for_Job__c  = 1;


        // career site is standard with variation based on Job Title - translate Display Job Title for this job and assign the Career Site at the end
        // start with selected job title
        string DisplayJobTitle = j.Job_Title_for_Banner__c;
        
        // depending on banner and job title, assign template ID and display job title for Career Site value
        
        // Hostess/Host
        if (j.Job_Title_for_Banner__c == 'Hostess/Host') {
            // display job title same for either banner
            DisplayJobTitle = 'Hostess/Host';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-1';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-8';    
        }
        // Setter
        else if (j.Job_Title_for_Banner__c == 'Setter') {
            // display job title same for either banner
            DisplayJobTitle = 'Restaurant Setter';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-2';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-9';    
        }
        // Server
        else if (j.Job_Title_for_Banner__c == 'Server') {
            // display job title same for either banner
            DisplayJobTitle = 'Restaurant Server';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-3';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-10';    
        }
        // Bartender
        else if (j.Job_Title_for_Banner__c == 'Bartender') {
            // display job title same for either banner
            DisplayJobTitle = 'Bartender';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-4';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-11';    
        }
        // Recruit
        else if (j.Job_Title_for_Banner__c == 'Recruit') {
            // display job title same for either banner
            DisplayJobTitle = 'Restaurant Recruit-Dishwasher';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-5';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-12';    
        }
        // Line Team
        else if (j.Job_Title_for_Banner__c == 'Line Team') {
            // display job title same for either banner
            DisplayJobTitle = 'Restaurant Line Cook';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-6';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-13';    
        }
        // Prep Team
        else if (j.Job_Title_for_Banner__c == 'Prep Team') {
            // display job title same for either banner
            DisplayJobTitle = 'Restaurant Prep Cook';
            // USA template ID
            if (j.Banner_of_Store__c == 'EARLS - USA')
                j.OTHER_Job_Template_ID__c  = 'ERL-7';
            else
                j.OTHER_Job_Template_ID__c  = 'ERL-14';    
        }
        
        // Formula: PT/FT + Display Job Name + 'Earls' (store location)
        j.Career_Site_Alternate_Job_Title__c = j.FT_or_PT__c +' '+ DisplayJobTitle + ' - Earls';
        // add Location between () if set
        j.Career_Site_Alternate_Job_Title__c += (j.Location_Store_Name__c == null ? '' : ' (' + j.Location_Store_Name__c + ')' );       
    }
}