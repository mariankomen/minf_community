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
public class Job_Workflow_Kaltire {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 
        
        string careerSiteTitle = (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c)+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                
        // KT OnDemand
        if (j.MindField_Job_Type__c == 'TalentReach' || j.MindField_Job_Type__c == 'TalentDrive - TBD' || j.MindField_Job_Type__c == 'TalentDrive - Front Line' || j.MindField_Job_Type__c == 'TalentDrive - Management') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'KT - 99';
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
            //j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }

        // KT Career Tracker
        else if ( j.Job_Title_for_Role__c == 'Career Tracker') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'KT - 5';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Store Project - Included in RPO Billing' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = 'Management Trainee '+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // KT Warehouse ASM
        else if ( j.Job_Title_for_Role__c == 'Warehouse Assistant Manager') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'KT - 1';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // KT Warehouse Service
        else if ( j.Job_Title_for_Role__c == 'Shipper/Receiver') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'KT - 2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }    
        // KT Outside Sales rep
        else if ( j.Job_Title_for_Role__c == 'Outside Sales Representative') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'KT - 6';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Store Project - Included in RPO Billing' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = 'Outside Sales Representative - Kal Tire';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
     }
}