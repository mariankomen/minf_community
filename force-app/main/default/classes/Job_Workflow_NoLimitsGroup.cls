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
public class Job_Workflow_NoLimitsGroup {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
    j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
    j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
    j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php';
    j.HM_Community_Address__c = 'https://mindfield.force.com/mindfield/s/login/'; 
    j.Program_Type__c = 'On Demand';
    j.Credits_Used_for_Job__c = 1;
    j.Using_Interview_Scheduling__c = true; 
    j.wage_details__c = '';       
    j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
    j.Num_of_Days_for_Delivery_Agreement__c = 30; 
    j.Job_Status__c = 'Open/Active Job';
    
 
        if ( j.Job_Title_for_Role__c =='Hourly Associate')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'A52-1';
            j.SLA_Level__c = 'Front Line 2';
            j.Role_Type__c = 'Frontline 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Warehouse Supervisor')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Supervisor' + ' - ' + j.Location_Store_Name__c):
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'A52-2';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Warehouse Flow Coordinator')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Flow Coordinator' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'A52-3';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Maintenance Specialist')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Maintenance Specialist' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'A52-4';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
       
        
   }
}