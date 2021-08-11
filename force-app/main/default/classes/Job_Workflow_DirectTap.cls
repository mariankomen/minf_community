/****************************
Class: Job_Workflow_DirectTap
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, May, 2017
Modification Log:
****************************/
public class Job_Workflow_DirectTap {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        
        j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
               
        // formula for Career Site Alt Job Title: ft/pt job title (department) - banner of store ( Location store name )
        string careerSite = j.job_title_for_banner__c + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
        // DirectTap Customer Experience Representative ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Customer Experience Representative') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-1';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Customer Experience Representative ---------------------------------------------------------------------------------------------------------------------------
       
        
        // DirectTap Swamper ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Swamper') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-2';
                j.Career_Site_Alternate_Job_Title__c = 'Delivery Swamper' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = 'Starting Wage: $15-$17';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Victoria - Island Beverage Distributors'-------------------------------------
            if (j.Banner_of_Store__c == 'Victoria - Island Beverage Distributors') {
                j.OTHER_Job_Template_ID__c  = 'DRT-7';
                j.Career_Site_Alternate_Job_Title__c = 'Delivery Swamper' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Summerland - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Summerland - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-2';
                j.Career_Site_Alternate_Job_Title__c = 'Delivery Swamper' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Swamper ---------------------------------------------------------------------------------------------------------------------------
       
        
        // DirectTap Class 5 Delivery Driver ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Class 5 Delivery Driver') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-3';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = 'Starting Wage: $18.25/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Victoria - Island Beverage Distributors'-------------------------------------
            if (j.Banner_of_Store__c == 'Victoria - Island Beverage Distributors') {
                j.OTHER_Job_Template_ID__c  = 'DRT-6';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = 'Starting wage: $18/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Summerland - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Summerland - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-3';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Class 5 Delivery Driver ---------------------------------------------------------------------------------------------------------------------------
       
        
        // DirectTap Warehouse Hand ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Warehouse Hand') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-4';
                j.Career_Site_Alternate_Job_Title__c = 'Warehouse Worker' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Victoria - Island Beverage Distributors'-------------------------------------
            if (j.Banner_of_Store__c == 'Victoria - Island Beverage Distributors') {
                j.OTHER_Job_Template_ID__c  = 'DRT-8';
                j.Career_Site_Alternate_Job_Title__c = 'Warehouse Worker' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Summerland - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Summerland - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-4';
                j.Career_Site_Alternate_Job_Title__c = 'Warehouse Worker' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Warehouse Hand ---------------------------------------------------------------------------------------------------------------------------
       
        
        // DirectTap Class 3 Delivery Driver  ---------------------------------------------------------------------------------------------------------------------------
        if ( j.Job_Title_for_Banner__c == 'Class 3 Delivery Driver') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-5';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = 'Starting Wage: $19-$20/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Victoria - Island Beverage Distributors'-------------------------------------
            if (j.Banner_of_Store__c == 'Victoria - Island Beverage Distributors') {
                j.OTHER_Job_Template_ID__c  = 'DRT-9';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner, 'Summerland - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Summerland - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-5';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Specialty';
                j.Role_Type__c = 'Specialty';
                j.Program_Type__c = 'On Demand';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Class 3 Delivery Driver  ---------------------------------------------------------------------------------------------------------------------------
       
       
       //Sept 8 - DT Addendum
       // DirectTap Product Picker  ---------------------------------------------------------------------------------------------------------------------------
       if ( j.Job_Title_for_Banner__c == 'Product Picker') {
                              
            //Store Banner, 'Vancouver - Direct Tap'-------------------------------------
            if (j.Banner_of_Store__c == 'Vancouver - Direct Tap') {
                j.OTHER_Job_Template_ID__c  = 'DRT-10';
                j.Career_Site_Alternate_Job_Title__c = careerSite;
                j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
                j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 21 : j.Num_of_Days_for_Delivery_Agreement__c); 
                j.SLA_Level__c = 'Front Line';
                j.Role_Type__c = 'Frontline';
                j.Program_Type__c = 'Subscription';         
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        }
        //END DirectTap Product Picker  ---------------------------------------------------------------------------------------------------------------------------
       
        
     }
}