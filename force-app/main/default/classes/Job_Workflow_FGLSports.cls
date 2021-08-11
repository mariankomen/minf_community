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
public class Job_Workflow_FGLSports {

    public static void processJob(SFDC_Job__c j) {
    
    
    
        //March 2018, setting to NSM
        j.Using_Interview_Scheduling__c = true; 
        j.Agency_Business_Unit__c = 'Customer Service & Sales'; //default
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'hourlyjobsportal.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'hourlyjobsportal.com';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Name_of_Person_Submitting_Request__c  = 'Not Required';
        j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
        j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Confidential__c  = 'No';
        
        
        if(String.isBlank(j.Job_Title_for_Banner__c)) {
           j.Job_Title_for_Banner__c = j.Job_Title_for_Role__c;
        }
        

        
        
        // set Wage Details based on job province
        if (j.job_province__c == 'British Columbia')
            j.wage_details__c = 'Part time 10.930 to 14.00 (GVA 10.930 to 14.230). Full time 11.80 to 18.730 (GVA 12.00 to 19.00). Sales Support Coordinator 13.80 to 20.730 (GVA 14.00 to 21.00)';
        else if (j.job_province__c == 'Alberta')
            j.wage_details__c= 'Part time 11.70 to 14.230. Full time 12.00 to 19.00. Sales Support Coordinator 14.00 to 21.00';
        else if (j.job_province__c == 'Saskatchewan')
            j.wage_details__c= 'Part time 11.00 to 13.90. Full time 11.60 to 18.300. Sales Support Coordinator 13.60 to 20.300';                            
        else if (j.job_province__c == 'Manitoba')
            j.wage_details__c= 'Part time 11.300 to 14.230. Full time 11.60 to 18.300. Sales Support Coordinator 13.60 to 20.300';
        else if (j.job_province__c == 'Ontario')
            j.wage_details__c= 'Part time 11.730 to 130.40. Full time 11.80 to 18.730 (GTA 12.00 to 19.00). Sales Support Coordinator 13.730 to 20.730 (GVA 14.00 to 21.00)';
        else if (j.job_province__c == 'New Brunswick')
            j.wage_details__c= 'Part time 11.130 to 13.300. Full time 11.20 to 18.00. Sales Support Coordinator 13.20 to 20.730';
        else if (j.job_province__c == 'Nova Scotia')
            j.wage_details__c= 'Part time 11.20 to 14.300. Full time 11.20 to 18.00. Sales Support Coordinator 13.20 to 20.00';
        else if (j.job_province__c == 'Newfoundland and Labrador')
            j.wage_details__c= 'Part time 11.00 to 130.00. Full time 11.20 to 18.00. Sales Support Coordinator 13.20 to 20.00';
        else if (j.job_province__c == 'Prince Edward Island')
            j.wage_details__c= 'Part time 11.00 to 13.300. Full time 11.20 to 18.00. Sales Support Coordinator 13.20 to 20.00';
        // if you want to default the wage detail for any job that didn't match the provices listed above, use the following.  Otherwise delete the lines
        else
            j.wage_details__c = 'No Wage Details Available';

        // formula for Career Site Alt Job Title: ft/pt job title (department) - banner of store ( Location store name )
        string careerSite = j.job_title_for_banner__c + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // formula for Career Site Alt Job Title: ft/pt job title - DEpartment (which is Banner of Nevada Bob or Hockey Experts with reference to location
        string careerSiteHockeyExpertandNevada = j.job_title_for_banner__c + ' '+j.department__c+' (Located in Sport Chek)' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // formula for Career Site Alt Job Title: ft/pt job title (department) - banner of store ( Location store name )
        string careerSalesSite = 'Sales Associate' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // formula for Career Site Alt Job Title: ft/pt job title - DEpartment (which is Banner of Nevada Bob or Hockey Experts with reference to location
        string careerSiteSALESHockeyExpertandNevada = 'Sales Associate ' +j.department__c+' (Located in Sport Chek)' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                
        // formula for Career Site Alt Job Title: ft/pt job title - DEpartment (which is Banner National Sports and Job title is Sports Advisor
        string careerSiteSportsAdvisor = 'Sales Associate ' + '(' +j.department__c+ ')' +' - ' + (j.Location_Store_Name__c == null ? '' : j.Location_Store_Name__c );

                

                
//// ATMOSPHER JOBS ----------------------------------------------------------------------------------------------/////             
                
        // FGL Atmosphere Sales Associate Other
        if ((j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.OTHER_Job_Template_ID__c  = 'FGLAT-22'; 
            if (j.Department__c=='Hiking')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';   
            }
            else if (j.Department__c=='Camping')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';
            }
            else if (j.Department__c=='Kayaking/Canoeing')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';
            }
            else if (j.Department__c=='Climbing')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';
            }
            else if (j.Department__c=='Trail Running')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';
            }
            else if(j.Department__c=='General')
            {
                j.OTHER_Job_Template_ID__c  = 'FGLAT-22';
            }
         }        

        // FGL Atmosphere Cashier
        else if ( j.Job_Title_for_Banner__c == 'Cashier' && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLAT-17';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // FGL Atmosphere Visual Merchandiser
        else if ( j.Job_Title_for_Banner__c == 'Visual Merchandiser' && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLAT-19';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }                    
        // FGL Atmosphere Shipper/Receiver
        else if ( j.Job_Title_for_Banner__c == 'Shipper/Receiver' && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLAT-18';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }

        // Seasonal Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Associate' && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLAT-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }   
        
        // Seasonal Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Order Fulfillment Associate' && j.Banner_of_Store__c == 'Atmosphere' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLAT-21';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }                   

        
        //// National Sports Jobs ----------------------------------------------------------------------------------------------
        //National Sports Cashier
        
        else if ( j.Job_Title_for_Banner__c == 'Cashier' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-1';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        //National Sports Shipper/Receiver
        else if ( j.Job_Title_for_Banner__c == 'Shipper/Receiver' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-2';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        //National Sports Sports Advisor
        else if ( j.Job_Title_for_Banner__c == 'Sports Advisor' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name ) 
            j.Career_Site_Alternate_Job_Title__c = careerSiteSportsAdvisor;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            if (j.Department__c=='Clothing')
            {
                j.OTHER_Job_Template_ID__c  = 'NS-3';   
            }
            else if (j.Department__c=='Footwear')
            {
                j.OTHER_Job_Template_ID__c  = 'NS-3';
            }
            else if (j.Department__c=='Hard Goods - Hockey')
            {
                j.OTHER_Job_Template_ID__c  = 'NS-3';
            }
            else if (j.Department__c=='Hard Goods - Baseball')
            {
                j.OTHER_Job_Template_ID__c  = 'NS-3';
            }
            else if (j.Department__c=='Hard Goods - General')
            {
                j.OTHER_Job_Template_ID__c  = 'NS-3';
            
            }
                        
        }

        //Service Shop Technician
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-9';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
        //Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Order Fulfillment Associate' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
        //Seasonal Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Associate' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-11';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
        //Seasonal Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Order Fulfillment Associate' && j.Banner_of_Store__c == 'National Sports' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'NS-12';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }

        
        



//// End national sports jobs--------------------------------------------------------------------------------------------


//// Pro Hockey Life jobs
        //Pro Hockey Life Cashier
        else if ( j.Job_Title_for_Banner__c == 'Cashier' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-1';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
        }
        
        //Pro Hockey Life Sales Associate
        else if ( j.Job_Title_for_Banner__c == 'Sales Associate' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            if (j.Department__c=='General')
            {
                j.OTHER_Job_Template_ID__c  = 'PHL-2';  
            }
            else if (j.Department__c=='Goalie')
            {
                j.OTHER_Job_Template_ID__c  = 'PHL-2'; 
            }

        }
    
        //Pro Hockey Life Pro Shop Service Technician
        else if ( j.Job_Title_for_Banner__c == 'Pro Shop Service Technician' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        //Pro Hockey Life Shipper/Receiver
        else if ( j.Job_Title_for_Banner__c == 'Shipper/Receiver' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-4';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }

        //Pro Hockey Life Visual Merchandiser
        else if ( j.Job_Title_for_Banner__c == 'Visual Merchandiser' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-7';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
         //Pro Hockey Life Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Order Fulfillment Associate' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
         //Pro Hockey Life Seasonal Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Associate' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-9';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
         //Pro Hockey Life Seasonal Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Order Fulfillment Associate' && j.Banner_of_Store__c == 'Pro Hockey Life' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PHL-10';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            // j.wage_details__c = 
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }

//// End Pro Hockey Life Jobs
        
                          
        // FGL Sport Chek Cashier
        else if ( j.Job_Title_for_Banner__c == 'Cashier' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-6';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
     
        // FGL Sport Chek Sales Advisor Bike
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && j.department__c == 'Hard Goods - Bike' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // FGL Sport Chek Sales Advisor Footwear
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && j.department__c == 'Footwear' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }
   
        // FGL Sport Chek Sales Advisor Hockey
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && j.department__c == 'Hard Goods - Hockey' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }

        // FGL Sport Chek Sales Advisor Other
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && j.department__c == 'Clothing' && j.Banner_of_Store__c == 'Sport Chek' ) {                    
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }

        // FGL Sport Chek Sales Advisor Ski
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && (j.department__c == 'Hard Goods - Ski') && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            //j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }
         
        // FGL Sport Chek Sales Advisor Golf
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && (j.department__c == 'Hard Goods - Golf') && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            //j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }

        // FGL Sport Chek Sales Advisor Other
        else if ( (j.Job_Title_for_Banner__c == 'Sales Associate' || j.Job_Title_for_Banner__c == 'Sales Advisor') && (j.department__c == 'Hard Goods - General') && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-20';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSalesSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
         }
     
        // FGL Sport Chek Service Shop Technician BASIC SKI
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician - Basic' && j.Banner_of_Store__c == 'Sport Chek' && j.department__c == 'Hard Goods - Ski') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-18C';
            //Above has to have no spaces between because template code has to be 10 characters or less
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = 'Service Shop Technician' + ' (Ski-Basic)' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            //j.wage_details__c = 'SST Basic - Provincial Standard to Provincial Standard +$2';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
                   
        // FGL Sport Chek Service Shop Technician ADVANCED SKI
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician - Advanced' && j.Banner_of_Store__c == 'Sport Chek' && j.department__c == 'Hard Goods - Ski') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-18C';
            //Above has to have no spaces between because template code has to be 10 characters or less
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = 'Service Shop Technician ' + '(Ski-Advanced)' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            //j.wage_details__c = 'SST Advanced - Provincial Standard +$4.300 to Provincial Standard +$7 ';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }         
        // FGL Sport Chek Service Shop Technician BASIC Bike
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician - Basic' && j.Banner_of_Store__c == 'Sport Chek' && j.department__c == 'Hard Goods - Bike') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-17C';
            //Above has to have no spaces between because template code has to be 10 characters or less
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = 'Service Shop Technician ' + '(Bike-Basic)' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            //j.wage_details__c = 'SST Basic - Provincial Standard to Provincial Standard +$2';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // FGL Sport Chek Service Shop Technician ADVANCED Bike
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician - Advanced' && j.Banner_of_Store__c == 'Sport Chek' && j.department__c == 'Hard Goods - Bike') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-17C';
            //Above has to have no spaces between because template code has to be 10 characters or less
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = 'Service Shop Technician' + ' (Bike-Advanced)' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            //j.wage_details__c = 'SST Advanced - Provincial Standard +$4.300 to Provincial Standard +$7 ';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 
        // FGL Sport Chek Service Shop Technician (In Case Type Not Chosen)
        else if ( j.Job_Title_for_Banner__c == 'Service Shop Technician' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $13.730 to $16.030 with 2 or less years experience. In GTA area candidates will earn an extra $0.230/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // FGL Sport Chek Shipper/Receiver
        else if ( j.Job_Title_for_Banner__c == 'Shipper/Receiver' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $13.730 to $16.030 with 2 or less years experience in Ontario.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
     
        // FGL Sport Chek Visual Merchandiser
        else if ( j.Job_Title_for_Banner__c == 'Visual Merchandiser' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-7';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $10.230 to $11.97 with 2 or less years experience for PART TIME roles. '+
            //    'Candidates will get paid between $11.80 to $14.08 with 2 or less years experience for FULL TIME role for Ontario. Candidates in GTA will get extra $.20/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
         // FGL Sport Chek Seasonal Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Associate' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-19';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $10.230 to $11.97 with 2 or less years experience for PART TIME roles. '+
            //    'Candidates will get paid between $11.80 to $14.08 with 2 or less years experience for FULL TIME role for Ontario. Candidates in GTA will get extra $.20/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // FGL Sport Chek Seasonal Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Seasonal Order Fulfillment Associate' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-21';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $10.230 to $11.97 with 2 or less years experience for PART TIME roles. '+
            //    'Candidates will get paid between $11.80 to $14.08 with 2 or less years experience for FULL TIME role for Ontario. Candidates in GTA will get extra $.20/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        
        // FGL Sport Chek Order Fulfillment Associate
        else if ( j.Job_Title_for_Banner__c == 'Order Fulfillment Associate' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-22';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $10.230 to $11.97 with 2 or less years experience for PART TIME roles. '+
            //    'Candidates will get paid between $11.80 to $14.08 with 2 or less years experience for FULL TIME role for Ontario. Candidates in GTA will get extra $.20/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // FGL Sport Chek Order Fulfillment Lead
        else if ( j.Job_Title_for_Banner__c == 'Order Fulfillment Lead' && j.Banner_of_Store__c == 'Sport Chek' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'FGLSC-24';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            // ft/pt job title (department) - banner of store ( Location store name )
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Candidates will get paid between $10.230 to $11.97 with 2 or less years experience for PART TIME roles. '+
            //    'Candidates will get paid between $11.80 to $14.08 with 2 or less years experience for FULL TIME role for Ontario. Candidates in GTA will get extra $.20/hour.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
         
 

   
     }
}