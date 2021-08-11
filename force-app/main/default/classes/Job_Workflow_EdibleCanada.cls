/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
    
****************************/
public class Job_Workflow_EdibleCanada {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + ' - Edible Canada';
        // add city based on profile
        if (j.job_owner_profile__c == 'Edible Canada HirePortal HR User') 
            careerSite += ' (Vancouver)';
        else
            careerSite += ' (Vancouver)';

        // global settings for all roles
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
        j.Career_Site_Alternate_Job_Title__c = careerSite;
        j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
        j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );

        // EdibleCanada Retail Sales Associate
        if ( j.Job_Title_for_Role__c == 'Retail Sales Associate' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 1';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
            
        // EdibleCanada Bartender
        else if ( j.Job_Title_for_Role__c == 'Bartender' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 2';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Hostess
        else if ( j.Job_Title_for_Role__c == 'Hostess' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 3';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Server
        else if ( j.Job_Title_for_Role__c == 'Server' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 4';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Server Assistant
        else if ( j.Job_Title_for_Role__c == 'Server Assistant' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 5';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Junior Sous Chef
        else if ( j.Job_Title_for_Role__c == 'Junior Sous Chef' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 6';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Server Supervisor 
        else if ( j.Job_Title_for_Role__c == 'Station Cook' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 7';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Server Supervisor 
        else if ( j.Job_Title_for_Role__c == 'Server Supervisor' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 8';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Assistant Restaurant Manager 
        else if ( j.Job_Title_for_Role__c == 'Assistant Restaurant Manager' ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 9';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EdibleCanada Other
        else if ( j.Job_Role_Title__c != null ) {
            j.OTHER_Job_Template_ID__c  = 'EC - 99';
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
     }
}