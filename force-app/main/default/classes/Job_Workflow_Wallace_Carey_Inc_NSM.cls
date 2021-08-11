/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, Jan 2018
Modification Log:

    
****************************/
public class Job_Workflow_Wallace_Carey_Inc_NSM {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Credits_Used_for_Job__c = 1;
        j.Using_Interview_Scheduling__c = true; 
        j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        j.Num_of_Days_for_Delivery_Agreement__c = 60; 
        j.wage_details__c = '';
        j.Agency_Business_Unit__c = 'Industrial Support';

        // Wallace & Carey Inc. - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Order Assembler/General Warehouse Worker') {
            j.OTHER_Job_Template_ID__c = 'WAC-1';
            j.Career_Site_Alternate_Job_Title__c = 'Warehouse Worker' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Front Line';
            j.wage_details__c = '$14+/hr -$19/hr+ with experience; flexibility for quality employees with good experience';
        }
        //END Job title 1 ---------------------------------------------------------------------------------------------------------------------------
        
        // Wallace & Carey Inc. - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Forklift Operator') {
            j.OTHER_Job_Template_ID__c = 'WAC-2';
            j.Career_Site_Alternate_Job_Title__c = 'Forklift Operator' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.wage_details__c = '$17+/hr depending on experience; we are open to increase wage within probation period based on performance';
        }
        //END Job title 2 ---------------------------------------------------------------------------------------------------------------------------
        
        // Wallace & Carey Inc. - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'AZ Truck Driver') {
            j.OTHER_Job_Template_ID__c = 'WAC-3';
            j.Career_Site_Alternate_Job_Title__c = 'Truck Driver' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.wage_details__c = '$21+/hr depending on experience; can be flexible for someone with experience';
        }
        //END Job title 3 ---------------------------------------------------------------------------------------------------------------------------
    
    }
}