/****************************
Class: Job_Workflow_Eco_Group_NSM  
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, Dec 18
Modification Log:

    
****************************/
public class Job_Workflow_Eco_Group_NSM {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Credits_Used_for_Job__c = 1;
        j.Using_Interview_Scheduling__c = true; 
        
        j.Agency_Business_Unit__c = 'Customer Service & Sales';
        
        //Heather doen't want any automated posting done this client! 
        j.store_doesnt_allow_posting__c=true;

        // Eco Group - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Premium Car Driver') {
        
            j.OTHER_Job_Template_ID__c = 'ECG-1';
            j.wage_details__c = '$15.00 USD per hour base. Up to approximately $16.50 USD per hour with performance bonus.';
            
            
            j.Career_Site_Alternate_Job_Title__c = 'Luxury Car Driver - ' + j.Job_Category__c;
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7; 
        }  
        // END Eco Group - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------

    }    
      
}