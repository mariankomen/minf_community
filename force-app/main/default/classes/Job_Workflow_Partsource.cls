/****************************
Class: Job_Workflow 
****************************/
public class Job_Workflow_Partsource {

  public static void processJob(SFDC_Job__c j) {
     // set global HM Portal details
    j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
    j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
    j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php';
    j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
    j.mindfield_service__c = 'Full-Cycle Recruitment';
    j.Program_Type__c = 'Subscription';  
    j.Credits_Used_for_Job__c = 1;
    j.Using_Interview_Scheduling__c = true; 
    j.wage_details__c = '';       
    j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
    j.Num_of_Days_for_Delivery_Agreement__c = 30; 
    j.Job_Status__c = 'Open/Active Job';
    
 
        if ( j.Job_Title_for_Role__c =='Team Leader')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Senior Automotive Parts Advisor' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Senior Automotive Parts Advisor' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'PS-1';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Commercial Specialist')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Commercial Auto Parts Sales Specialist' + ' - ' + j.Location_Store_Name__c):
                                                    ('Commercial Auto Parts Sales Specialist' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'PS-2';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Parts Pro')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Automotive Parts Advisor' + ' - ' + j.Location_Store_Name__c):
                                                    ('Automotive Parts Advisor' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'PS-3';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }

        else if ( j.Job_Title_for_Role__c =='Driver')
                {
                    j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                            ('Driver' + ' - ' + j.Location_Store_Name__c):
                                                            ('Driver' + ' - ' + j.Location_Store_Name__c);
                    j.OTHER_Job_Template_ID__c  = 'PS-4';
                    j.SLA_Level__c = 'Front Line 1';
                    j.Role_Type__c = 'Frontline 1';
                    j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
                    j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
                } 
        else if ( j.Job_Title_for_Role__c =='Dispatcher')
                {
                    j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                            ('Dispatcher' + ' - ' + j.Location_Store_Name__c):
                                                            ('Dispatcher' + ' - ' + j.Location_Store_Name__c);
                    j.OTHER_Job_Template_ID__c  = 'PS-5';
                    j.SLA_Level__c = 'Front Line 1';
                    j.Role_Type__c = 'Frontline 1';
                    j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
                    j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
                }  
        else if ( j.Job_Title_for_Role__c =='Logisitics Lead')
                {
                    j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                            ('Logisitics Lead' + ' - ' + j.Location_Store_Name__c):
                                                            ('Logisitics Lead' + ' - ' + j.Location_Store_Name__c);
                    j.OTHER_Job_Template_ID__c  = 'PS-6';
                    j.SLA_Level__c = 'Specialty 1';
                    j.Role_Type__c = 'Specialty 1';
                    j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
                    j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
                }
        else if ( j.Job_Title_for_Role__c =='Order Picker')
                {
                    j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                            ('Order Picker' + ' - ' + j.Location_Store_Name__c):
                                                            ('Order Picker' + ' - ' + j.Location_Store_Name__c);
                    j.OTHER_Job_Template_ID__c  = 'PS-7';
                    j.SLA_Level__c = 'Front Line 1';
                    j.Role_Type__c = 'Frontline 1';
                    j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
                    j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
                } 
        else if ( j.Job_Title_for_Role__c =='Shipper/Receiver')
                {
                    j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                            ('Shipper/Receiver' + ' - ' + j.Location_Store_Name__c):
                                                            ('Shipper/Receiver' + ' - ' + j.Location_Store_Name__c);
                    j.OTHER_Job_Template_ID__c  = 'PS-8';
                    j.SLA_Level__c = 'Front Line 1';
                    j.Role_Type__c = 'Frontline 1';
                    j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
                    j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
                }               
        }
        
   }