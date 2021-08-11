/****************************
Class: Job_Workflow_Sporting_Life_NSM  
Purpose: This class contains code Job_Workflow_Golf_Town_NSMto handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jami Silzer, July 22
Modification Log:

    
****************************/
public class Job_Workflow_Sporting_Life_NSM {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Credits_Used_for_Job__c = 1;
        j.Using_Interview_Scheduling__c = true; 
        j.wage_details__c = '';       
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        j.Num_of_Days_for_Delivery_Agreement__c = 30; 

        
        
               
        // Sporting Life - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Cash' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Caissier') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Caissier';
            j.External_Alert_Email_Address__c=j.manager_emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-1';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Cashier' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Caissier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 
        
        // Sporting Life - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Footwear' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Chaussures') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Chaussures';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-2';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Footwear' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Chaussures' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }       
        
        // Sporting Life - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Soft Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Vêtements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Vêtements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-3';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Soft Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Chaussures' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }   

        
        // Sporting Life - Job Title 4 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Hard Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Équipements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Équipements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-4';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Hard Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Équipements' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 
 
      
        // Sporting Life - Job Title 5 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Personal Shopper' ||
            j.Job_Title_For_Role_Classification__c == 'Acheteur personnel') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Acheteur personnel';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-5';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Personal Shopper' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Acheteur personnel' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Sporting Life - Job Title 6 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Restocker' ||
            j.Job_Title_For_Role_Classification__c == 'Réapprovisionneur')  &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Réapprovisionneur';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-6';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Restocker' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Réapprovisionneur' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }   

        // Sporting Life - Job Title 7 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'E-Commerce Shipping Associate' ||
            j.Job_Title_For_Role_Classification__c == 'Associé à l\'expédition - Commerce en ligne') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé à l\'expédition - Commerce en ligne';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-7';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('E-Commerce Shipping Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé à l\'expédition - Commerce en ligne' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }       

        // Sporting Life - Job Title 8 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Warehouse Associate' ||
            j.Job_Title_For_Role_Classification__c == 'Associé d\'entrepôt') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé d\'entrepôt';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-8';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé d\'entrepôt' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }       
        
        // Sporting Life - Job Title 9 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Warehouse Lead Hand' ||
            j.Job_Title_For_Role_Classification__c == 'Entrepôt - Chef d\'équipe') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Entrepôt - Chef d\'équipe';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-9';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Lead Hand' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Entrepôt - Chef d\'équipe' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 2';
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }   
        
        // Sporting Life - Job Title 10 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Key Holder' ||
            j.Job_Title_For_Role_Classification__c == 'Détenteur de clé') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Détenteur de clé';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-10';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Key Holder' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Détenteur de clé' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 11 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Boot Fitter' ||
            j.Job_Title_For_Role_Classification__c == 'Ajusteur de bottes') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Ajusteur de bottes';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-11';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Boot Fitter' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Ajusteur de bottes' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 12 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Service Shop Technician' ||
            j.Job_Title_For_Role_Classification__c == 'Technicien d\'atelier') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Technicien d\'atelier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-12';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Service Shop Technician' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Technicien d\'atelier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 13 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Service Shop Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant d\'atelier') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant d\'atelier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-13';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Service Shop Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant d\'atelier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 14 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Merchandiser' ||
            j.Job_Title_For_Role_Classification__c == 'Étalagiste') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Étalagiste';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-14';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Merchandiser' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Étalagiste' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 15 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Visual Display Artist' ||
            j.Job_Title_For_Role_Classification__c == 'Artiste à la Présentation Visuelle') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Artiste à la Présentation Visuelle';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-15';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Visual Display Artist' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Artiste à la Présentation Visuelle' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 16 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Training Coordinator' ||
            j.Job_Title_For_Role_Classification__c == 'Coordonnateur à la formation') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Coordonnateur à la formation';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-16';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Training Coordinator' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Coordonnateur à la formation' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 17 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Warehouse Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant d\'entrepôt') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant d\'entrepôt';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-17';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant d\'entrepôt' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 18 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Department Manager - Soft Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant de département - Vêtements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant de département - Vêtements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-18';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Department Manager - Soft Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de département - Vêtements' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 19 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Department Manager - Hard Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant de département -  Équipements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant de département -  Équipements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-19';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Department Manager - Hard Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de département -  Équipements' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 20 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Assistant Cash Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Assistant-Gérant des caisses') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Assistant-Gérant des caisses';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-20';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Cash Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Assistant-Gérant des caisses' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 21 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Cash Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant des caisses') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant des caisses';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-21';
            
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Cash Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant des caisses' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 22 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Assistant Merchandising Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Assistant-Gérant Marchandisage') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Assistant-Gérant Marchandisage';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-22';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Merchandising Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Assistant-Gérant Marchandisage' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 23 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Merchandising Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant Marchandisage') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant Marchandisage';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-23';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Merchandising Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant Marchandisage' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 24 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Visual Display Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant - Présentation Visuelle') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant - Présentation Visuelle';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-24';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            
           
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Visual Display Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant - Présentation Visuelle' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 25 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Divisional Manager - Soft Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Chef de division - Vêtements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Chef de division - Vêtements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-25';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Divisional Manager - Soft Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Chef de division - Vêtements' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 26 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Divisional Manager - Hard Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Chef de division - Vêtements') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Chef de division - Équipements';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-26';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Divisional Manager - Hard Goods' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Chef de division - Équipements' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 27 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Store Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gérant de Magasin') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gérant de Magasin';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-27';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Store Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de Magasin' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 28 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Cash' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Caissier') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Caissier - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-28';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Cashier - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Caissier - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 29 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Footwear' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Chaussures') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Chaussures - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-29';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Footwear - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Chaussures - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 30 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Soft Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Vêtements') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Vêtements - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-30';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Soft Goods - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Vêtements - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 31 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Sales Associate - Hard Goods' ||
            j.Job_Title_For_Role_Classification__c == 'Associé aux ventes - Équipements') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé aux ventes - Équipements - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-31';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Hard Goods - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Équipements - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 32 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Restocker' ||
            j.Job_Title_For_Role_Classification__c == 'Réapprovisionneur') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Réapprovisionneur - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-32';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Restocker - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Réapprovisionneur - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 33 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Warehouse Associate' ||
            j.Job_Title_For_Role_Classification__c == 'Associé d\'entrepôt') &&
            (j.role_classification__c == 'Seasonal'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Associé d\'entrepôt - Saisonnier';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-33';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé d\'entrepôt - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
        // Sporting Life - Job Title 34 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Accounts Payable Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Gestionnaire des comptes fournisseurs') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Gestionnaire des comptes fournisseurs';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-34';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Accounts Payable Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gestionnaire des comptes fournisseurs' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 35 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Accounts Payable Clerk' ||
            j.Job_Title_For_Role_Classification__c == 'Commis aux comptes payables') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Commis aux comptes payables';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-35';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Accounts Payable Clerk' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Commis aux comptes payables' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
                // Sporting Life - Job Title 36 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Customer Care Representative' ||
            j.Job_Title_For_Role_Classification__c == 'Représentant au service à la clientèle') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Représentant au service à la clientèle';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-36';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Customer Care Representative' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Représentant au service à la clientèle' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
           // Sporting Life - Job Title 37 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Social Media Specialist' ||
            j.Job_Title_For_Role_Classification__c == 'Spécialiste des médias sociaux') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Spécialiste des médias sociaux';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-37';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Social Media Specialist' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Spécialiste des médias sociaux' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
          // Sporting Life - Job Title 38 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Junior Graphic Designer' ||
            j.Job_Title_For_Role_Classification__c == 'Concepteur graphique junior') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Concepteur graphique junior';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-38';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Junior Graphic Designer' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Concepteur graphique junior' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Sporting Life - Job Title 39 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Customer Care Assistant Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Directeur Adjoint au Service à la clientèle') &&
            (j.role_classification__c == 'Corporate'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Directeur Adjoint au Service à la clientèle';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-39';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Customer Care Assistant Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Directeur Adjoint au Service à la clientèle' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
         // Sporting Life - Job Title 40 ---------------------------------------------------------------------------------------------------------------------------
        if (
            (j.Job_Title_For_Role_Classification__c == 'Planning Analyst'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-40';
            
            j.Career_Site_Alternate_Job_Title__c = ('Planning Analyst' + ' - ' + j.Location_Store_Name__c);
                                                    
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
        }
        
        // Sporting Life - Job Title 41 ---------------------------------------------------------------------------------------------------------------------------
     
         if (
            (j.Job_Title_For_Role_Classification__c == 'Email CRM Specialist'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-41';
            
            j.Career_Site_Alternate_Job_Title__c = ('Email CRM Specialist' + ' - ' + j.Location_Store_Name__c);
                                                    
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
        }
        // Sporting Life - Job Title 42 ---------------------------------------------------------------------------------------------------------------------------
     
         if (
            (j.Job_Title_For_Role_Classification__c == 'Office Manager'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-42';
            
            j.Career_Site_Alternate_Job_Title__c = ('Office Manager' + ' - ' + j.Location_Store_Name__c);
                                                    
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        }
        
        // Sporting Life - Job Title 43 ---------------------------------------------------------------------------------------------------------------------------
     
         if (
            (j.Job_Title_For_Role_Classification__c == 'Retail Graphic Designer'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-43';
            
            j.Career_Site_Alternate_Job_Title__c = ('Retail Graphic Designer' + ' - ' + j.Location_Store_Name__c);
                                                    
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
        }
        
        // Sporting Life - Job Title 44 ---------------------------------------------------------------------------------------------------------------------------
     
         if (
            (j.Job_Title_For_Role_Classification__c == 'Digital Media Manager'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-44';
            
            j.Career_Site_Alternate_Job_Title__c = ('Digital Media Manager' + ' - ' + j.Location_Store_Name__c);
                                                    
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
        }
        
         // Sporting Life - Job Title 45 ---------------------------------------------------------------------------------------------------------------------------
     
         if (
            (j.Job_Title_For_Role_Classification__c == 'Junior Systems Support Administrator'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-45';
            
            j.Career_Site_Alternate_Job_Title__c = ('Junior Systems Support Administrator' + ' - ' + j.Location_Store_Name__c);
                                                          
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
        }
        
         // Sporting Life - Job Title 46 ---------------------------------------------------------------------------------------------------------------------------
     
        if(
            (j.Job_Title_For_Role_Classification__c == 'Assistant Store Manager' ||
            j.Job_Title_For_Role_Classification__c == 'Assistant-Gérant de Magasin') &&
            (j.role_classification__c == 'Permanent'))
            {
            
            j.Job_Title_for_Banner__c=j.Job_Title_For_Role_Classification__c;
            j.Job_Title_FR__c='Assistant-Gérant de Magasin';
            j.External_Alert_Email_Address__c=j.Manager_Emails__c;
            j.OTHER_Job_Template_ID__c = 'SPL-46';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Store Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Assistant-Gérant de Magasin' + ' - ' + j.Location_Store_Name__c);
                                                          
            
            j.MindField_Job_Type__c = 'TalentRecruit - Managemente';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
        }
        
    }   
        
    
}