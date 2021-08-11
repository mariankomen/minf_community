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
public class Job_Workflow_Capilano_Golf_NSM {

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
        j.Num_of_Days_for_Delivery_Agreement__c = 45; 
        j.wage_details__c = '';
        

        // Capilano Golf - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == '1st Cook') {
            j.OTHER_Job_Template_ID__c = 'CAP-12';
            j.Career_Site_Alternate_Job_Title__c = 'Cook' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 1 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == '2nd Cook') {
            j.OTHER_Job_Template_ID__c = 'CAP-1';
            j.Career_Site_Alternate_Job_Title__c = 'Cook' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 2 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == '3rd Cook') {
            j.OTHER_Job_Template_ID__c = 'CAP-2';
            j.Career_Site_Alternate_Job_Title__c = 'Cook' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 3 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 4 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Banquet Saucier') {
            j.OTHER_Job_Template_ID__c = 'CAP-3';
            j.Career_Site_Alternate_Job_Title__c = 'Banquet Saucier' +   (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 4 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 5 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Banquet Bartender') {
            j.OTHER_Job_Template_ID__c = 'CAP-4';
            j.Career_Site_Alternate_Job_Title__c = 'Banquet Bartender'  +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 5 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 6 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Banquet Server') {
            j.OTHER_Job_Template_ID__c = 'CAP-5';
            j.Career_Site_Alternate_Job_Title__c = 'Banquet Server' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 6 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 7 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Bartender') {
            j.OTHER_Job_Template_ID__c = 'CAP-6';
            j.Career_Site_Alternate_Job_Title__c = 'Bartender' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 7 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 8 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Busser/Expo') {
            j.OTHER_Job_Template_ID__c = 'CAP-7';
            j.Career_Site_Alternate_Job_Title__c = 'Busser/Expo' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 8 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 9 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Server') {
            j.OTHER_Job_Template_ID__c = 'CAP-8';
            j.Career_Site_Alternate_Job_Title__c = 'Server' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 9 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 10 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Kitchen Helper') {
            j.OTHER_Job_Template_ID__c = 'CAP-9';
            j.Career_Site_Alternate_Job_Title__c = 'Kitchen Helper' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 10 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 11 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Night Cleaner/Janitorial') {
            j.OTHER_Job_Template_ID__c = 'CAP-10';
            j.Career_Site_Alternate_Job_Title__c = 'Cleaner - Nights' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 11 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 12 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Grounds Person') {
            j.OTHER_Job_Template_ID__c = 'CAP-11';
            j.Career_Site_Alternate_Job_Title__c = 'Grounds Person' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 12 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 13 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Assistant Horticulturist') {
            j.OTHER_Job_Template_ID__c = 'CAP-13';
            j.Career_Site_Alternate_Job_Title__c = 'Assistant Horticulturist' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 13 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 14 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Equipment Technician') {
            j.OTHER_Job_Template_ID__c = 'CAP-14';
            j.Career_Site_Alternate_Job_Title__c = 'Equipment Technician' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 14 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 15 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Chef De Partie') {
            j.OTHER_Job_Template_ID__c = 'CAP-15';
            j.Career_Site_Alternate_Job_Title__c = 'Chef De Partie' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        }
        //END Job title 15 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 16 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Locker Attendant') {
            j.OTHER_Job_Template_ID__c = 'CAP-16';
            j.Career_Site_Alternate_Job_Title__c = 'Clubhouse Attendant' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 16 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 17 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Day Cleaner') {
            j.OTHER_Job_Template_ID__c = 'CAP-17';
            j.Career_Site_Alternate_Job_Title__c = 'Cleaner - Days' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 17 ---------------------------------------------------------------------------------------------------------------------------
        
        // Capilano Golf - Job Title 18 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Backshop Colleague') {
            j.OTHER_Job_Template_ID__c = 'CAP-18';
            j.Career_Site_Alternate_Job_Title__c = 'Outside Golf Attendant' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 18 ---------------------------------------------------------------------------------------------------------------------------
        
        
         // Capilano Golf - Job Title 19 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Arborist') {
            j.OTHER_Job_Template_ID__c = 'CAP-19';
            j.Career_Site_Alternate_Job_Title__c = 'Arborist' +  (' - ' + j.Banner_of_Store__c);
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //END Job title 19 ---------------------------------------------------------------------------------------------------------------------------
        
         // Capilano Golf - Job Title 20 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Seasonal Shop Assistant') {
            j.OTHER_Job_Template_ID__c = 'CAP-20';
            j.Career_Site_Alternate_Job_Title__c = 'Seasonal Shop Assistant' +  (' - ' + j.Banner_of_Store__c);
             j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        //END Job title 20 ---------------------------------------------------------------------------------------------------------------------------
    
    }
}