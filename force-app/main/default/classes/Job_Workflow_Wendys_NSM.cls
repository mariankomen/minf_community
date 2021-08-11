/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, October 6/17
Modification Log:

    
****************************/
public class Job_Workflow_Wendys_NSM {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Credits_Used_for_Job__c = 1;
        j.Using_Interview_Scheduling__c = true; 
        j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        j.wage_details__c = '';
        

        // Wendys - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Crew Member') {
        
            j.OTHER_Job_Template_ID__c = 'WEN-1';
            j.Career_Site_Alternate_Job_Title__c = 'Crew Member' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            //j.Num_of_Days_for_Delivery_Agreement__c = 14; 
            j.Num_of_Days_for_Delivery_Agreement__c = 30; //update for 00161281
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
                 j.wage_details__c = 'FT with unrestricted availability (24/7 Mon-Sun): $11.60/hr + premium-$16/hr; FT with restricted availability: $11.60/hr-$14/hr; PT with restricted availability: $11.60/hr-$13/hr; PT students under 18 years old: $10.90/hr-$13/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Wendys - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 1 ---------------------------------------------------------------------------------------------------------------------------
    
    
       // Wendys - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Assistant Manager') {
        
            j.OTHER_Job_Template_ID__c = 'WEN-2';
            j.Career_Site_Alternate_Job_Title__c = 'Assistant Manager' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
                   
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Wendys - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 2 ---------------------------------------------------------------------------------------------------------------------------
    
    
       // Wendys - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'General Manager') {
        
            j.OTHER_Job_Template_ID__c = 'WEN-3';
            j.Career_Site_Alternate_Job_Title__c = 'General Manager' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
                   
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Wendys - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 3 ---------------------------------------------------------------------------------------------------------------------------
    
    
        // Wendys - Job Title 4 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Shift Supervisor') {
        
            j.OTHER_Job_Template_ID__c = 'WEN-4';
            j.Career_Site_Alternate_Job_Title__c = 'Shift Supervisor' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
                   
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Wendys - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 4 ---------------------------------------------------------------------------------------------------------------------------
    
    }
}