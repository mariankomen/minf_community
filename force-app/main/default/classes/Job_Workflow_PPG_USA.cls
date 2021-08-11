/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Nick Onusko March 11, 2016
Modification Log:
may 18, 2016 - Added logic for union locations - Nick
    
****************************/
public class Job_Workflow_PPG_USA {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'www.mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        
        j.Agency_Business_Unit__c = 'Customer Service & Sales'; //default
        //j.Name_of_Person_Submitting_Request__c  = 'Not Required';
        //j.Confidential__c  = 'No';
        // set Wage Details based on job province
        boolean unionLocation = false; 
        
        if (j.Job_Owner_Alias__c == 'PPG8116' || j.Job_Owner_Alias__c == 'PPG8121' || j.Job_Owner_Alias__c == 'PPG8065' ||j.Job_Owner_Alias__c == 'PPG8069' ||j.Job_Owner_Alias__c == 'PPG8070' ||j.Job_Owner_Alias__c == 'PPG8072' ||j.Job_Owner_Alias__c == 'PPG8077' ||j.Job_Owner_Alias__c == 'PPG8078' ||j.Job_Owner_Alias__c == 'PPG9741' ||j.Job_Owner_Alias__c == 'PPG8068' ||j.Job_Owner_Alias__c == 'PPG8073' ||j.Job_Owner_Alias__c == 'PPG8074' ||j.Job_Owner_Alias__c == 'PPG8114' ||j.Job_Owner_Alias__c == 'PPG8115'){
            unionLocation = true;
        }
        if (j.is_cloned_job__C == 'true')
            j.job_status__c = 'Open/Active Job';
        

        // formula for Career Site Alt Job Title: ft/pt job title (department) - banner of store ( Location store name )
        string careerSite = j.job_title_for_banner__c + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
        //j.auto_submit_job_for_approvals__c = true;
                
        // Canadian tire front end manager
        if ( j.Job_Title_for_Banner__c == 'Store Sales Associate') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = 'Sales Associate '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.wage_details__c = '$9.60 - $12.00 plus 10-20% unique market geographic differentials'; //Oct 14th, Heather wanted reset back.
            //j.wage_details__c = '$17.00 plus 10-20% unique market geographic differentials'; //Update Oct 4th, 2016 Case:00100535
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            if(unionlocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-1CBA';
            else
                j.OTHER_Job_Template_ID__c  = 'PPG-1';
            
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        else if ( j.Job_Title_for_Banner__c == 'Store Sales Specialist') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PPG-2';
            j.Career_Site_Alternate_Job_Title__c = 'Sales Lead '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
        }
        else if ( j.Job_Title_for_Banner__c == 'Store Sales Lead') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PPG-3';
            j.Career_Site_Alternate_Job_Title__c = 'Retail Sales Specialist '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        else if ( j.Job_Title_for_Banner__c == 'Designer Store') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PPG-4';
            j.Career_Site_Alternate_Job_Title__c = 'Decorator '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            if(unionLocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-4 CBA';
            else
                j.OTHER_Job_Template_ID__c  = 'PPG-4';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        else if ( j.Job_Title_for_Banner__c == 'Store Driver') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            if(unionLocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-5CBA';
            else            
                j.OTHER_Job_Template_ID__c  = 'PPG-5';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        else if ( j.Job_Title_for_Banner__c == 'Delivery System Driver') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            
            j.Career_Site_Alternate_Job_Title__c = 'Delivery Driver '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            if (unionLocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-6CBA';
            else
                j.OTHER_Job_Template_ID__c  = 'PPG-6';
             j.Agency_Business_Unit__c = 'Industrial Support';   
        }
        
        else if ( j.Job_Title_for_Banner__c == 'Truck Driver CDL') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$16.00-$20.00 plus 10-20% unique market geographic differentials'; //Updated on Feb 10th 2017
            //j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials'; //Oct 14th, Heather wanted reset back.
            //j.Wage_Details__c = '$17.50/HR - $21.90/HR plus 10-20% unique market geographic differentials'; //Update Oct 4th, 2016 Case:00100535
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            if(unionLocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-7CBA';
            else
                j.OTHER_Job_Template_ID__c  = 'PPG-7';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        else if ( j.Job_Title_for_Banner__c == 'Warehouse Spray - Sales Technician') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            
            j.Career_Site_Alternate_Job_Title__c = 'Spray Technician '  + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front LIne' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            //j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Wage_Details__c = '$9.60-14.40 plus 10-20% unique market geographic differentials';
            j.SLA_Level__c = 'Front Line';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            if (unionLocation == true)
                j.OTHER_Job_Template_ID__c  = 'PPG-8';
            else
                j.OTHER_Job_Template_ID__c  = 'PPG-8';
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        
     }
     
}