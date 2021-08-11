/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Nick Onusko, Oct 26, 2015
Modification Log:
Added default job owner for all jobs
    
****************************/
public class Job_Workflow_Tim_Hortons {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        // j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Role_Type__c = 'Frontline';
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Full-Cycle Recruitment';

        
        string careerSite = j.job_title_for_banner__c ;
        //j.Job_is_for_Store_if_applicable__c = '950';
        //j.Job_Internal_Status__c = 'Broadcasting Not Needed';
        User JobOwner = [SELECT Name, id FROM user where name ='Tim Hortons DC (Warehouse) - Guelph - 950'];
        j.OwnerID = jobowner.id;
        
        
        // NoLimit Warehouse - Morning TC
        if (j.Job_Title_for_Banner__c == 'Warehouse Associate') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            careerSite = j.job_title_for_banner__c + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Wage_Details__c = 'Starting wage: $16.75 plus an additional $1.25 per hour for working the continental night shift';
            j.OTHER_Job_Template_ID__c  = 'THDC-2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 7 : j.Num_of_Days_for_Delivery_Agreement__c);
        }
        
     }
}