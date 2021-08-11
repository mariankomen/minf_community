/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
Feb 2017, data in fields can now be determined by job title AND banner.
This allows us to distinguish differences in franchises
    
****************************/
public class Job_Workflow_Canadian_Tire {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        //j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        //j.HM_Portal_Address_URL_Shortened__c = 'Mindfield HirePortal';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        //j.Name_of_Person_Submitting_Request__c  = 'Not Required';
        //j.Confidential__c  = 'No';
        // set Wage Details based on job province
        j.Credits_Used_for_Job__c = 1;
        

        // formula for Career Site Alt Job Title: ft/pt job title (department) - banner of store ( Location store name )
        string careerSite = j.job_title_for_banner__c + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
    
        // Canadian tire cashier ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Cashier') {
        
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7; 
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
                   
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = '$11.05-$11.20/hr based on experience and expertise with opportunity to quickly move up based on job performance ';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = '$12.65/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-4';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
            
        }
        //END Canadian tire cashier ---------------------------------------------------------------------------------------------------------------------------
    
        // Canadian tire Sales Associate-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Sales Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr.  $12.75 would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = '$11.05-$11.20/hr based on experience and expertise with opportunity to quickly move up based on job performance';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = '$12.65/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-9';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Sales Associate-----------------------------------------------------------------------------------------------------------------------
         
        // Canadian tire Customer Service Representative-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Customer Service Representative') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = 'Wage Range: $12.00-$13.00/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = 'Wage Range: $12.00-$13.00/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = 'Wage Range: $12.00-$13.00/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = '$11.05-$11.20/hr based on experience and expertise with opportunity to quickly move up based on job performance';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017 
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr-$12 based on previous big box experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = '$12.65/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-5';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Customer Service Representative-----------------------------------------------------------------------------------------------------------------------
        
        // Canadian tire Service Advisor-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Service Advisor') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = 'Wage Range: $13.00-$20.00 + Bonus opportunity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = 'Wage Range: $13.00-$20.00 + Bonus opportunity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = 'Wage Range: $13.00-$20.00 + Bonus opportunity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = '$12/hr based on experience';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = '$12.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = '$12.65/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-10';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Service Advisor-----------------------------------------------------------------------------------------------------------------------
         
          
        // Canadian tire Automotive Parts Associate-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Automotive Parts Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = 'Wage Range: Minimum - $16.00/hr. To qualify for $13-$16/hr, candidates would need to have a few years of relevant automotive parts experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = 'Wage Range: Minimum - $16.00/hr. To qualify for $13-$16/hr, candidates would need to have a few years of relevant automotive parts experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = 'Wage Range: Minimum - $16.00/hr. To qualify for $13-$16/hr, candidates would need to have a few years of relevant automotive parts experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = '$13.00/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-2';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Automotive Parts Associate-----------------------------------------------------------------------------------------------------------------------
            
        // Canadian tire Automotive Service Installer-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Automotive Service Installer') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = 'Wage range: $11.00-$15.00. Majority of candidates start under $13/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = 'Wage range: $11.00-$15.00. Majority of candidates start under $13/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = 'Wage range: $11.00-$15.00. Majority of candidates start under $13/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = '$12.50/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            //Removed from NSM program, but keep in anyways if it comes back
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = '$15-$18/hr based on experience.  Higher wage would indicate completion of some schooling';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-3';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Automotive Service Installer-----------------------------------------------------------------------------------------------------------------------
         
        // Canadian tire Garden Centre Associate-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Garden Centre Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';         
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr . $12.75/hr would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr . $12.75/hr would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = 'Wage Range: Minimum - $12.75/hr . $12.75/hr would be based on a few years of relevant experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = '$10.70/hr for students under 18, otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = '$10.25-$11.00/hr based on experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-7';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Garden Centre Associate-----------------------------------------------------------------------------------------------------------------------
         
          
        // Canadian tire Licensed Automotive Technician-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Licensed Automotive Technician') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.wage_details__c = 'Flat rate system between $28 - $36/hr (based on a sliding scale; the more hour/units done, the more earned per hour/unit)';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';             
            j.Role_Type__c = 'Specialty';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = 'Wage Range: $28.00-$36.00/hr flat rate scale based on productivity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = 'Wage Range: $28.00-$36.00/hr flat rate scale based on productivity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = 'Wage Range: $28.00-$36.00/hr flat rate scale based on productivity';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-8';
                j.wage_details__c = '$30.00/hr plus incentives';
                j.SLA_Level__c = 'Specialty 2';
                j.MindField_Job_Type__c = 'TalentRecruit - Front Line';             
                j.Role_Type__c = 'Specialty 2';
                j.Program_Type__c = 'Subscription';         
                j.mindfield_service__c = 'Full-Cycle Recruitment';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Licensed Automotive Technician-----------------------------------------------------------------------------------------------------------------------
         
        // Canadian tire Stock Handler-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Stock Handler') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
                      
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = 'Wage Range: $11.75-$12.25/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = 'Wage Range: $11.75-$12.25/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = 'Wage Range: $11.75-$12.25/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = '$13.00 - $13.50/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-12';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Stock Handler-----------------------------------------------------------------------------------------------------------------------
         
        // Canadian tire Department Manager-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Department Manager') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
                      
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = 'Wage Range: $30,000-$42,000/year + bonus based on performance up to $10,000/yr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = 'Wage Range: $30,000-$42,000/year + bonus based on performance up to $10,000/yr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = 'Wage Range: $30,000-$42,000/year + bonus based on performance up to $10,000/yr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-6';
                j.wage_details__c = '$17.50/hr';
                j.SLA_Level__c = 'Management';
                j.MindField_Job_Type__c = 'TalentRecruit - Management';             
                j.Role_Type__c = 'Management';
                j.Program_Type__c = 'Subscription';         
                j.mindfield_service__c = 'Full-Cycle Recruitment';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Department Manager-----------------------------------------------------------------------------------------------------------------------
              
          
        // Canadian tire Service Manager-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Service Manager') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
                      
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-13';
                j.wage_details__c = '$25.00/hr';
                j.SLA_Level__c = 'Management';
                j.MindField_Job_Type__c = 'TalentRecruit - Management';             
                j.Role_Type__c = 'Management';
                j.Program_Type__c = 'Subscription';         
                j.mindfield_service__c = 'Full-Cycle Recruitment';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Service Manager-----------------------------------------------------------------------------------------------------------------------
          
          
       // Canadian tire Supervisor-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Supervisor') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
                      
            //Store Banner, 'Greater Vancouver Associated Stores - Cambie'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Cambie') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = 'Wage Range:$14.00-$18.00';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Greater Vancouver Associated Stores - Grandview'-------------------------------------
            if (j.Banner_of_Store__c == 'Greater Vancouver Associated Stores - Grandview') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = 'Wage Range:$14.00-$18.00';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = 'Wage Range:$14.00-$18.00';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Endress Sales & Distribution Ltd'-------------------------------------
            //Banner shut down May 2017
            /*if (j.Banner_of_Store__c == 'Endress Sales & Distribution Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = '';
            }*/
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-14';
                j.wage_details__c = '$15.00/hr';
                j.SLA_Level__c = 'Management';
                j.MindField_Job_Type__c = 'TalentRecruit - Management';             
                j.Role_Type__c = 'Management';
                j.Program_Type__c = 'Subscription';         
                j.mindfield_service__c = 'Full-Cycle Recruitment';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Supervisor-----------------------------------------------------------------------------------------------------------------------
        
        
        // Canadian tire Sales Advisor-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Sales Advisor') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7; 
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            j.OTHER_Job_Template_ID__c  = 'CT-18';          
           
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.wage_details__c = '$12.65/hr';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Sales Advisor-----------------------------------------------------------------------------------------------------------------------
        
        
        // Canadian tire Pro Shop Associate-----------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Pro Shop Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7; 
            j.SLA_Level__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            j.OTHER_Job_Template_ID__c  = 'CT-19';          
           
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.wage_details__c = '$15.00/hr';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Pro Shop Associate-----------------------------------------------------------------------------------------------------------------------
          
           
        // Canadian tire Store Warehouse Associate-----------------------------------------------------------------------------------------------------------------------
        //only for Giacomo D'Amico Holding Inc
        //if ( j.Job_Title_for_Banner__c == 'Warehouse Associate') {
        if ( j.Job_Title_for_Banner__c == 'Store Warehouse Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-15';
                j.wage_details__c = '$10.70 student wage for people under 18: otherwise, $11.40/hr';
            }
            
            //Store Banner, 'Peter Charles Holdings Ltd'-------------------------------------
            //New banner, July 2017
            if (j.Banner_of_Store__c == 'Peter Charles Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-15';
                j.wage_details__c = '$13.00 - $13.50/hr';
            }
            
            //Store Banner, 'GS McMillan Holdings Ltd'-------------------------------------
            //New banner, July 2017
            if (j.Banner_of_Store__c == 'GS McMillan Holdings Ltd') {
                j.OTHER_Job_Template_ID__c  = 'CT-15';
                j.wage_details__c = '$10.70/hr for students under 18, otherwise, $11.40/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'T. Macrae Family Sales'-------------------------------------
            if (j.Banner_of_Store__c == 'T. Macrae Family Sales') {
                j.OTHER_Job_Template_ID__c  = 'CT-15';
                j.wage_details__c = 'Starting wage: $11.50/hr';
                j.Using_Interview_Scheduling__c = true; //used with NSM to indicate if interview scheduling is used
                j.Num_of_Days_for_Delivery_Agreement__c = 30; 
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Store Warehouse Associate-----------------------------------------------------------------------------------------------------------------------
          
          
          
          
        // Canadian tire Store Manager-----------------------------------------------------------------------------------------------------------------------
        //only for Giacomo D'Amico Holding Inc
        if ( j.Job_Title_for_Banner__c == 'Store Manager') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Management' : j.MindField_Job_Type__c);
            //j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-16';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Store Manager-----------------------------------------------------------------------------------------------------------------------
  
        // Canadian tire General Manager-----------------------------------------------------------------------------------------------------------------------
        //only for Giacomo D'Amico Holding Inc
        if ( j.Job_Title_for_Banner__c == 'General Manager') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Management' : j.MindField_Job_Type__c);
            //j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            //Store Banner, 'Giacomo D'Amico Holding Inc'-------------------------------------
            //New banner, May 2017
            if (j.Banner_of_Store__c == 'Giacomo D\'Amico Holding Inc') {
                j.OTHER_Job_Template_ID__c  = 'CT-17';
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Canadian tire Store Manager-----------------------------------------------------------------------------------------------------------------------  
          
          
          
          
          
          
        /*  
         ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
        // Canadian tire front end manager
        if ( j.Job_Title_for_Banner__c == 'Front End Manager') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'CT-1';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.wage_details__c = 'Salary range: $30,000 -$36,000 based on experience + bonus';
            j.SLA_Level__c = 'Management';
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
        }
        
       
        // Canadian tire Service Advisor
        if ( j.Job_Title_for_Banner__c == 'Service Advisor') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'CT-10';
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 7 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.wage_details__c = 'Wage range: $13-$20 + substanstial bonus opportunity';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
        }
        // Canadian tire Supervisor - no used anymore
        //if ( j.Job_Title_for_Banner__c == 'Supervisor') {
          //  j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            //j.OTHER_Job_Template_ID__c  = 'CT-11';
            //j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            //j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            //j.Role_Type__c = 'Management';
            //j.Program_Type__c = 'Subscription';         
            //j.mindfield_service__c = 'Full-Cycle Recruitment';
            
        //}
        */
        
     }
}