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
public class Job_Workflow_Proline_Trucking {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 
        j.MindField_Job_Type__c ='TalentConnect - Promote Post';

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite =  (j.job_title_for_banner__c == null ? j.job_role_title__c : j.job_title_for_banner__c)+ (j.Location_Store_Name__c == null ? ' - '+ j.job_city__c : ' - ' + j.Location_Store_Name__c );
        
        if (j.Job_Title_for_Banner__c == 'Local Driver'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PST-1';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = 'TalentConnect';
            j.Role_Type__c = 'Front Line';
            j.mindfield_service__c = 'Candidate Sourcing';
            j.Program_Type__c = 'Subscription';
        }
        else if (j.Job_Title_for_Banner__c == 'Over-The-Road Truck Driver'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PST-2';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = 'TalentConnect';
            j.Role_Type__c = 'Front Line';
            j.mindfield_service__c = 'Candidate Sourcing';
            j.Program_Type__c = 'Subscription';
        }
           
     }
}