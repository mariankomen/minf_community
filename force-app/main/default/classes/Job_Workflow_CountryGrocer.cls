/****************************
Class: Job_Workflow_CountryGrocer 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, April 10, 2017
Modification Log:
****************************/
public class Job_Workflow_CountryGrocer {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        // j.HM_Portal_Address_URL_FR__c  = ''; 
        
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
        j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
        j.Using_Interview_Scheduling__c = true; 
                        
        // Grocery Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Grocery Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Grocery Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-1';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Bakery Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Bakery Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Bakery Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Deli Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Deli Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Deli Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Floral Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Floral Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Floral Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-4';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Bulk Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Bulk Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Bulk Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-5';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Produce Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Produce Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Produce Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-6';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Front-End Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Front-End Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Cashier ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-7';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        /*June 2018, Deprecated
        // Dairy Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Dairy Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Dairy Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        */
        
        /*June 2018, Deprecated
        // Post-Office Service Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Post-Office Service Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Postal Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr.';
            j.OTHER_Job_Template_ID__c  = 'CG-9';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        */
        
        // Baker ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Baker') {
            j.Career_Site_Alternate_Job_Title__c = 'Baker ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Wage range: $17-$21/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-10';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Specialty 1' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Meat Cutter ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Meat Cutter') {
            j.Career_Site_Alternate_Job_Title__c = 'Meat Cutter ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'None-ticketed Meat Cutters wage range is $15-$18/hr and ticketed and certified Meat Cutters wage range is $17-$21/hr based on previous experience.';
            j.OTHER_Job_Template_ID__c  = 'CG-11';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 2' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Specialty 2' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Shift Supervisor ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Shift Supervisor') {
            j.Career_Site_Alternate_Job_Title__c = 'Shift Supervisor ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Max wage is $17/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-12';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Specialty 1' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        /*June 2018, Deprecated
        // Scanning Supervisor ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Scanning Supervisor') {
            j.Career_Site_Alternate_Job_Title__c = 'Scanning Supervisor ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Max wage is $21/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-13';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Speciality' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'speciality' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        */
        
        // Meat Wrapper ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Meat Wrapper') {
            j.Career_Site_Alternate_Job_Title__c = 'Meat Wrapper ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Wage range: $14-$19/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-14';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        /*June 2018, Deprecated
        // Seafood Specialist ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Seafood Specialist') {
            j.Career_Site_Alternate_Job_Title__c = 'Seafood Specialist ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = '';
            j.OTHER_Job_Template_ID__c  = 'CG-15';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
       }
       */
        
        // Nutrition Advisor ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Nutrition Advisor') {
            j.Career_Site_Alternate_Job_Title__c = 'Nutrition Advisor ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = '';
            j.OTHER_Job_Template_ID__c  = 'CG-16';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Shipper/Receiver ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Shipper/Receiver') {
            j.Career_Site_Alternate_Job_Title__c = 'Shipper/Receiver ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = '';
            j.OTHER_Job_Template_ID__c  = 'CG-17';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Fresh Cut Produce Clerk ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Fresh Cut Produce Clerk') {
            j.Career_Site_Alternate_Job_Title__c = 'Fresh Cut Produce Clerk ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'High School students are hired are $11.25/hr; College/University students are hired at $12/hr. 2+ years previous retail or similar experience starts at $13.50/hr and 3+ years previous retail or similar experience starts at $15/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-18';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Frontline' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Cake Decorator ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Cake Decorator') {
            j.Career_Site_Alternate_Job_Title__c = 'Cake Decorator ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Wage range: $14-$19.50/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-19';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Specialty 1' : j.Role_Type__c );
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        // Grocery Supervisor ------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Grocery Supervisor') {
            j.Career_Site_Alternate_Job_Title__c = 'Grocery Supervisor ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Wage_Details__c = 'Wage range: $15-$23/hr';
            j.OTHER_Job_Template_ID__c  = 'CG-21';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            j.Role_Type__c = (j.Role_Type__c == null ? 'Specialty 1' : j.Role_Type__c );
           j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
     }
}