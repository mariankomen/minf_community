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
public class Job_Workflow_MrLube {

     public static void processJob(SFDC_Job__c j) {
        //March 2018, setting to NSM
        j.Using_Interview_Scheduling__c = true;
     
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 
        
        //Case: 00107653
        //string careerSiteTitle = j.Job_Title_for_Banner__c + ' - ' + j.job_city__c;
        string careerSiteTitle = j.Job_Title_for_Banner__c + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
        
        j.Agency_Business_Unit__c = 'Industrial Support';
        j.Using_Interview_Scheduling__c = true; 

        // March 2018 NSM -------------------------------------------------------------------------------------------------------------------------------------
        if(j.Banner_of_Store__c=='Mr. Lube') //only Mr. Lube banner at this time
        {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Role_Type__c = 'FrontLine 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.sla_level__c = 'Front Line 1';
            
            //Lower Technician
            if (j.Job_Title_for_Banner__c =='Lower Technician') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 6';
                j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
                j.Role_Type__c = 'FrontLine 2';
                j.MindField_Job_Type__c = 'TalentDrive - Front Line';
                j.sla_level__c = 'Front Line 2';
            }
            
            //Customer Service and Sales Representative
            if (j.Job_Title_for_Banner__c =='Customer Service and Sales Representative') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 7';
                j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
                j.Role_Type__c = 'FrontLine 1';
                j.MindField_Job_Type__c = 'TalentDrive - Front Line';
                j.sla_level__c = 'Front Line 1';
            }
            if (j.Job_Title_for_Banner__c =='Assistant Manager') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 3 ';
                j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
                j.Role_Type__c = 'Specialty 2';
                j.MindField_Job_Type__c = 'TalentDrive - Front Line';
                j.sla_level__c = 'Specialty 2';
            }
            
            if (j.Job_Title_for_Banner__c =='Store Manager') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 4 ';
                j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
                j.Role_Type__c = 'Management 2';
                j.MindField_Job_Type__c = 'TalentDrive - Management';
                j.sla_level__c = 'Management 2';
                j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            }
            
            
            //Sales Advisor
            if (j.Job_Title_for_Banner__c =='Sales Advisor') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 10';
                j.Career_Site_Alternate_Job_Title__c = 'Sales Advisor' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            }
            
            //Greeter
            if (j.Job_Title_for_Banner__c =='Greeter') {
                j.OTHER_Job_Template_ID__c  = 'MLF - 20';
                j.Career_Site_Alternate_Job_Title__c = 'Mr. Lube Greeter' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            }
        }
         }
    
}