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
public class Job_Workflow_MindfieldInternal {

     public static void processJob(SFDC_Job__c j) {

        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 
        j.Mindfield_Service__c = 'Candidate Sourcing'; 
        j.MindField_Job_Type__c = 'TalentReach';
        j.sla_level__c = 'Job Posting Only';
        j.Role_Type__c = 'FrontLine';
        j.Program_Type__c = 'Evergreen';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 999;
        j.Num_of_Days_for_Delivery_Agreement__c = 999;
                           
      
        // formula for Career Site Alt Job Title: job title 
        string careerSite = j.Job_Title_for_Banner__c + ' - Burnaby';

        // MindField Internal's Senior Talent Acquisition Specialist
        if ( j.Job_Title_for_Banner__c == 'Recruiter' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-1';
            //j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
           
        }

        // MindField Internal's Talent Acquisition Specialist
        else if ( j.Job_Title_for_Banner__c == 'Candidate Contact Representative' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }

        // MindField Internal's Talent Marketing Coordinator
        else if ( j.Job_Title_for_Banner__c == 'Candidate Sourcing Coordinator' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }

        // MindField Internal's Customer Success Specialist
        else if ( j.Job_Title_for_Banner__c == 'Customer Experience Specialist' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-4';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }

        // MindField Internal's Reference Checker
        else if ( j.Job_Title_for_Banner__c == 'Candidate Reference Specialist' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-5';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }

        // MindField Internal's Account Manager
        else if ( j.Job_Title_for_Banner__c == 'Recruitment Operations Manager' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-6';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }

        // MindField Internal's Bilingual Talent Acquisition Specialist
        else if ( j.Job_Title_for_Banner__c == 'Bilingual Candidate Contact Rep' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-7';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }
        
        else if ( j.Job_Title_for_Banner__c == 'Accounting & Payroll Administrator' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }
        else if ( j.Job_Title_for_Banner__c == 'System Administrator' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-9';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }
        else if ( j.Job_Title_for_Banner__c == 'Technical Support Specialist' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-10';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }
        else if ( j.Job_Title_for_Banner__c == 'Director of Recruitment Operations' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-11';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            
        }
         else if ( j.Job_Title_for_Banner__c == 'MFG Custom' && j.Banner_of_Store__c == 'MindField Internal' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 0 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MFG-99';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.Job_Role_Title__c + ' - Burnaby';
            
        }
     
     }
}