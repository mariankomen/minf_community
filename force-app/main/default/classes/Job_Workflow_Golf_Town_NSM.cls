/****************************
Class: Job_Workflow_Eco_Group_NSM  
Purpose: This class contains code Job_Workflow_Golf_Town_NSMto handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, March 19
Modification Log:

    
****************************/
public class Job_Workflow_Golf_Town_NSM {

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
        
        
          if(String.isBlank(j.Job_Title_for_Banner__c)) {
           j.Job_Title_for_Banner__c = j.Job_Title_for_Role__c;
        } 
               
        // Golf Town - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Sales Associate - Golf Soft Goods' ||
            j.Job_Title_for_Banner__c == 'Associé aux Ventes - Vêtements de Golf') {
        
            j.Job_Title_FR__c='Associé aux Ventes';
            j.OTHER_Job_Template_ID__c = 'GT-1';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux Ventes' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }  
        
        // Golf Town - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Sales Associate - Golf Hard Goods' ||
            j.Job_Title_for_Banner__c == 'Associé aux Ventes – Équipements de Golf') {
        
            j.Job_Title_FR__c='Associé aux Ventes – Golf';
            j.OTHER_Job_Template_ID__c = 'GT-2';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate – Golf' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux Ventes - Golf' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }  

        // Golf Town - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Sales Associate - Seasonal' ||
            j.Job_Title_for_Banner__c == 'Associé aux Ventes - Saisonnier') {
        
            j.Job_Title_FR__c='Associé aux ventes - Golf - Saisonnier';
            j.OTHER_Job_Template_ID__c = 'GT-3';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate - Golf - Seasonal' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes - Golf - Saisonnier' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 4 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Receiving Associate' ||
            j.Job_Title_for_Banner__c == 'Associé à la Reception') {
        
            j.Job_Title_FR__c='Associé aux ventes et à la réception';
            j.OTHER_Job_Template_ID__c = 'GT-4';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales & Receiving Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes et à la réception' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Industrial Support';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 5 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Bilingual Customer Service Representative' ||
            j.Job_Title_for_Banner__c == 'Représentant Bilingue au Service à la Clientèle') {
        
            j.Job_Title_FR__c='Représentant Bilingue au Service à la Clientèle';
            j.OTHER_Job_Template_ID__c = 'GT-5';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Bilingual Customer Service Representative' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Représentant Bilingue au Service à la Clientèle' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 6 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Department Manager - Golf Soft Goods' ||
            j.Job_Title_for_Banner__c == 'Gérant de Département - Vêtements de Golf') {
        
            j.Job_Title_FR__c='Gérant de Département - Mode';
            j.OTHER_Job_Template_ID__c = 'GT-6';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Department Manager - Fashion' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de Département - Mode' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 7 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Department Manager - Golf Hard Goods' ||
            j.Job_Title_for_Banner__c == 'Gérant de Département - Équipements de Golf') {
        
            j.Job_Title_FR__c='Gérant de Département - Golf';
            j.OTHER_Job_Template_ID__c = 'GT-7';
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Department Manager - Golf' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de Département - Golf' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 8 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Assistant Manager' ||
            j.Job_Title_for_Banner__c == 'Assistant-Gérant de Magasin') {
        
            j.Job_Title_FR__c='Assistant-Gérant de Magasin';
            j.OTHER_Job_Template_ID__c = 'GT-8';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Store Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Assistant-Gérant de Magasin' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 9 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'General Store Manager' ||
            j.Job_Title_for_Banner__c == 'Gérant de Magasin') {
        
            j.Job_Title_FR__c='Gérant de Magasin';
            j.OTHER_Job_Template_ID__c = 'GT-9';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('General Store Manager' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Gérant de Magasin' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 



        // Golf Town - Job Title 10 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Associate Buyer' ||
            j.Job_Title_for_Banner__c == 'Acheteur asssocié') {
        
            j.Job_Title_FR__c='Acheteur asssocié';
            j.OTHER_Job_Template_ID__c = 'GT-10';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Associate Buyer' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Acheteur asssocié' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

        // Golf Town - Job Title 11 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Buyer' ||
            j.Job_Title_for_Banner__c == 'Acheteur') {
        
            j.Job_Title_FR__c='Acheteur';
            j.OTHER_Job_Template_ID__c = 'GT-11';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Buyer' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Acheteur' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

         // Golf Town - Job Title 12 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Merchandising Analyst' ||
            j.Job_Title_for_Banner__c == 'Analyste - Mise en marché') {
        
            j.Job_Title_FR__c='Analyste - Mise en marché';
            j.OTHER_Job_Template_ID__c = 'GT-12';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Merchandising Analyst' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Analyste - Mise en marché' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 

         // Golf Town - Job Title 13 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Vendor Relationship Specialist' ||
            j.Job_Title_for_Banner__c == 'Spécialiste Partenariat avec les fournisseurs') {
        
            j.Job_Title_FR__c='Spécialiste Partenariat avec les fournisseurs';
            j.OTHER_Job_Template_ID__c = 'GT-13';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Vendor Relationship Specialist' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Spécialiste Partenariat avec les fournisseurs' + ' - ' + j.Location_Store_Name__c);
                                                    
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        } 
        
             // Golf Town - Job Title 14 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'HR Business Partner - Corporate' ||
            j.Job_Title_for_Banner__c == 'Partenaire d’affaire RH - Corporatif') {
        
            j.Job_Title_FR__c='Partenaire d’affaire RH - Corporatif';
            j.OTHER_Job_Template_ID__c = 'GT-14';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Human Resources Business Partner' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Partenaire d’affaire RH - Corporatif' + ' - ' + j.Location_Store_Name__c);
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
              // Golf Town - Job Title 15 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'HR Business Partner - Retail (Bilingual)' ||
            j.Job_Title_for_Banner__c == 'Partenaire d’affaire RH - Commerce au détail (Bilingue)') {
        
            j.Job_Title_FR__c='Partenaire d’affaire RH - Commerce au détail (Bilingue)';
            j.OTHER_Job_Template_ID__c = 'GT-15';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Bilingual Human Resources Business Partner' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Partenaire d’affaire RH - Commerce au détail (Bilingue)' + ' - ' + j.Location_Store_Name__c);
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
               // Golf Town - Job Title 16 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Data Compliance Specialist' ||
            j.Job_Title_for_Banner__c == 'Spécialiste de la conformité des données') {
        
            j.Job_Title_FR__c='Spécialiste de la conformité des données';
            j.OTHER_Job_Template_ID__c = 'GT-16';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Data Compliance Specialist' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Spécialiste de la conformité des données' + ' - ' + j.Location_Store_Name__c);
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
                  // Golf Town - Job Title 17 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Account Executive' ||
            j.Job_Title_for_Banner__c == 'Directeur de comptes') {
        
            j.Job_Title_FR__c='Directeur de comptes';
            j.OTHER_Job_Template_ID__c = 'GT-17';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Account Executive' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Directeur de comptes' + ' - ' + j.Location_Store_Name__c);
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
                     // Golf Town - Job Title 18 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Email CRM Specialist') {
        
            j.OTHER_Job_Template_ID__c = 'GT-18';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c = ('Email CRM Specialist');
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        
                     // Golf Town - Job Title 20 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Allocation Analyst') {
        
            j.OTHER_Job_Template_ID__c = 'GT-20';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Career_Site_Alternate_Job_Title__c = ('Allocation Analyst');
                                                    
          j.Agency_Business_Unit__c = 'Customer Service & Sales';
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }

    }    
      
}