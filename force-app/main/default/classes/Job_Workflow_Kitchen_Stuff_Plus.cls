/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Nick Onusko, Jan 18, 2016
Modification Log:
****************************/
public class Job_Workflow_Kitchen_Stuff_Plus {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        // j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Role_Type__c = 'Management';
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Full-Cycle Recruitment';

        
        string careerSite = j.job_title_for_banner__c ;
       
        
        // Hubbub Team mate
        if (j.Job_Title_for_Banner__c == 'Shift Leader') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            careerSite = 'Shift Supervisor ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Wage_Details__c = 'Wage range: $13.00 -$14.00/hour pending experience';
            j.OTHER_Job_Template_ID__c  = 'KSPI-1';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        //Updated Oct 17, 2016------------------------------------------------------------
        else if (j.Job_Title_for_Banner__c == 'Warehouse Shift Leader') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            careerSite = 'Warehouse Shift Leader ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Wage_Details__c = 'Starting Wage: $13.25-$16 based on experience';
            j.OTHER_Job_Template_ID__c  = 'KSPI-2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        else if (j.Job_Title_for_Banner__c == 'Assistant Store Manager') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            careerSite = 'Assistant Store Manager ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Wage_Details__c = 'Salary: $32,000-$40,000/year based on experience and volume of store';
            j.OTHER_Job_Template_ID__c  = 'KSPI-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        //END Updated Oct 17, 2016------------------------------------------------------------
     }
}