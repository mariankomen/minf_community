/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
****************************/
public class Job_Workflow_CTFinancialServices {

     public static void processJob(SFDC_Job__c j) {
     
        j.Using_Interview_Scheduling__c = true;
        j.HM_Portal_Address_URL__c  = 'hourlyjobsportal.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'hourlyjobsportal.com';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Confidential__c  = 'No';
        j.Agency_Business_Unit__c = 'Customer Service & Sales'; //default
        j.Credits_Used_for_Job__c = 1;
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        j.Num_of_Days_for_Delivery_Agreement__c = 30; 
        j.Job_Status__c = 'Open/Active Job';
        j.Program_Type__c = 'Subscription';
        if ( j.Job_Title_for_Role__c == 'Road Side Assistance Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Road Side Assistance Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-1';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }
            
       else if ( j.Job_Title_for_Role__c == 'Bilingual Road Side Assistance Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Bilingual Road Side Assistance Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-2';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }
            
       else if ( j.Job_Title_for_Role__c == 'Corporate Customer Service Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Corporate Customer Service Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-3';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }
            
       else if ( j.Job_Title_for_Role__c == 'Bilingual Corporate Customer Service Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Bilingual Corporate Customer Service Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-4';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }
            
       else if ( j.Job_Title_for_Role__c == 'Digital Channel Customer Service Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Digital Channel Customer Service Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-5';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }
            
       else if ( j.Job_Title_for_Role__c == 'Bilingual Digital Channel Customer Service Representative') {
        
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Bilingual Digital Channel Customer Service Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'CTFS-6';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            }

}
}