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
public class Job_Workflow_GeneralPaint {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite = (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c);

        // add city based on profile
        if (j.job_owner_profile__c == 'General Paint HirePortal HR User') 
            careerSite += ' - Vancouver';
        else
            careerSite += (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // global settings for all roles
        j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
        j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );      

        // GP Other
        if ( j.Job_Role_Title__c != null ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 99';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Posting Only';
            
        }                    

        // GP Store Associate
        else if ( j.Job_Title_for_Role__c == 'Customer Service Representative' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 1';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // GP Summer Student
        else if ( j.Job_Title_for_Role__c == 'Summer Student' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 8';
            j.Career_Site_Alternate_Job_Title__c = 'Customer Service Representative' + ' - '+ j.job_city__c;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // GP Store Associate - Forklift
        else if ( j.Job_Title_for_Role__c == 'Forklift Customer Service Representative' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 3';
            j.Career_Site_Alternate_Job_Title__c = 'Customer Service Representative' + ' - '+ j.job_city__c;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // GP Store Associate - Full Time
        else if ( j.Job_Title_for_Role__c == 'Full Time Customer Service Representative' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 4';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // GP Store Associate - Heavy Lifting
        else if ( j.Job_Title_for_Role__c == 'Heavy Lifting Customer Service Representative' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 5';
            j.Career_Site_Alternate_Job_Title__c = 'Customer Service Representative' + ' - ' + j.job_city__c;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }
            
        // GP Store Manager
        else if ( j.Job_Title_for_Role__c == 'Store Manager' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 2';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // GP Outside Sales Representative
        else if ( j.Job_Title_for_Role__c == 'Outside Sales Representative' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 6';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        //GP Assistant Store Manager
        else if ( j.Job_Title_for_Role__c == 'Assistant Store Manager' ) {
            j.OTHER_Job_Template_ID__c  = 'GP - 7';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            j.mindfield_service__c = 'Candidate Sourcing';
        }


        // else some other job title filled in that was not listed above
        else {
            j.OTHER_Job_Template_ID__c  = 'GP - 99';
        }   
     }
}