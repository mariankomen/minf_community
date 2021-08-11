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
public class Job_Workflow_skoah {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite = j.job_title_for_role__c + ' ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // global settings for all roles
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
        j.Career_Site_Alternate_Job_Title__c = careerSite;
        j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
        j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.mindfield_service__c = 'Candidate Sourcing';
    

        // skoah Skin Care Coach - Canada
        if ( j.Job_Title_for_Role__c == 'Skin Care Coach - Canada' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Retail Sales Associate - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 1';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
        } 

        // skoah Skin Care Coach - USA
        else if ( j.Job_Title_for_Role__c == 'Skin Care Coach - USA' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Retail Sales Associate - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 2';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
        } 
        // skoah Skin Care Trainer - Canada
        else if ( j.Job_Title_for_Role__c == 'Skin Care Trainer - Canada' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Esthetician - skoah - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 3';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
        } 
        // skoah Skin Care Trainer - USA
        else if ( j.Job_Title_for_Role__c == 'Skin Care Trainer - USA' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Esthetician - skoah - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 4';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
        }                   
        // skoah Retail Store Manager - Canada
        else if ( j.Job_Title_for_Role__c == 'General Manager - Canada' ) {
            j.Career_Site_Alternate_Job_Title__c ='Retail Store Manager - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 5';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
        } 
        // skoah Retail Store Manager - USA
        else if ( j.Job_Title_for_Role__c == 'General Manager - USA' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Retail Store Manager - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 6';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
        }                
        // skoah Retail Store Associate Manager - Canada
        else if ( j.Job_Title_for_Role__c == 'Associate Manager - Canada' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Retail Store Associate Manager - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 7';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
        }   
        // skoah Retail Store Associate Manager - USA
        else if ( j.Job_Title_for_Role__c == 'Associate Manager - USA' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Retail Store Associate Manager - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 8';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
        }           
        // skoah Other
        else if ( j.Job_Role_Title__c != null ) {
            j.Career_Site_Alternate_Job_Title__c = j.Job_Role_Title__c + ' - '+ j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'SK - 99';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';
        }
     }
}