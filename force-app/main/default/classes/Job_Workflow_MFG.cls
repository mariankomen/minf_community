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
public class Job_Workflow_MFG {

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
    
 
    if ( j.Job_Title_for_Role__c =='Retail Associate' || j.Job_Title_for_Role__c =='Associé aux ventes')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Retail Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis aux ventes au détail' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-7';
            j.Job_Title_FR__c = 'Commis aux ventes au détail';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
         else if ( j.Job_Title_for_Role__c =='Food Service Worker' || j.Job_Title_for_Role__c ==' Commis à la restauration')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Food Service Worker' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis à la restauration' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-14';
            j.Job_Title_FR__c = ' Commis à la restauration';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Warehouse Associate'|| j.Job_Title_for_Role__c =='Commis d’entrepôt')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis d’entrepôt' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-16';
            j.Job_Title_FR__c = 'Commis d’entrepôt';
            j.SLA_Level__c = 'Front Line 2';
            j.Role_Type__c = 'Frontline 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Production Worker' || j.Job_Title_for_Role__c == 'Travailleur de production' )  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Production Worker' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Travailleur de production' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-17';
            j.Job_Title_FR__c = 'Travailleur de production';
            j.SLA_Level__c = 'Front Line 2';
            j.Role_Type__c = 'Frontline 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Team Lead'|| j.Job_Title_for_Role__c =='Chef d’équipe')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Team Lead' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Chef d’équipe' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-24';
            j.Job_Title_FR__c = 'Chef d’équipe';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Assistant Manager'|| j.Job_Title_for_Role__c =='Assistant-gérant de magasin')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Manager' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Assistant-gérant de magasin' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-25';
            j.Job_Title_FR__c = 'Assistant-gérant de magasin';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
            else if ( j.Job_Title_for_Role__c =='Manager' || j.Job_Title_for_Role__c =='Gérant')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Manager' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Gérant' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-27';
            j.Job_Title_FR__c = 'Gérant';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
           else if ( j.Job_Title_for_Role__c =='Call Centre Representative' || j.Job_Title_for_Role__c =='Agent de centre d’appels')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Call Centre Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Agent de centre d’appels' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-28';
            j.Job_Title_FR__c = 'Agent de centre d’appels';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
          else if ( j.Job_Title_for_Role__c =='Delivery Driver' || j.Job_Title_for_Role__c =='Livreur')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Delivery Driver' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Livreur' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-29';
            j.Job_Title_FR__c = 'Livreur';
            j.SLA_Level__c = 'Front Line 2';
            j.Role_Type__c = 'Frontline 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        
        
          else if ( j.Job_Title_for_Role__c =='Forklift Operator' || j.Job_Title_for_Role__c == 'Conducteur de chariot élévateur')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Forklift Operator' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Conducteur de chariot élévateur' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-32';
            j.Job_Title_FR__c = 'Conducteur de chariot élévateur';
            j.SLA_Level__c = 'Speciality 2';
            j.Role_Type__c = 'Speciality 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        

        
               else if ( j.Job_Title_for_Role__c =='Experienced Retail Associate')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Experienced Retail Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis aux ventes au détail avec expérience' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-37';
            j.Job_Title_FR__c = 'Commis aux ventes au détail avec expérience';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
     
               else if ( j.Job_Title_for_Role__c =='Experienced Warehouse Associate')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Experienced Warehouse Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis d’entrepôt avec expérience' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-43';
            j.Job_Title_FR__c = 'Commis d’entrepôt avec expérience';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        else if ( j.Job_Title_for_Role__c =='Experienced Production Worker')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Experienced Production Worker' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Travailleur de production avec expérience' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-44';
            j.Job_Title_FR__c = 'Travailleur de production avec expérience';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
                else if ( j.Job_Title_for_Role__c =='Warehouse Associate (Overnight)')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate (Overnight)' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis d’entrepôt de nuit' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-45';
            j.Job_Title_FR__c = 'Commis d’entrepôt de nuit';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
         else if ( j.Job_Title_for_Role__c =='Experienced Call Centre Representative')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Experienced Call Centre Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Agent de centre d’appels avec expérience' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-46';
            j.Job_Title_FR__c = 'Agent de centre d’appels avec expérience';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        } 
        else if ( j.Job_Title_for_Role__c =='Reach Truck Operator')  
          
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Reach Truck Operator' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Conducteur de chariot à mât rétractable' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'OD-48';
            j.Job_Title_FR__c = 'Conducteur de chariot à mât rétractable';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }       
        
           if(j.Job_Owner_Language_Profile__c =='French')
        {
        j.OTHER_Job_Template_ID__c = j.OTHER_Job_Template_ID__c + ' FR';
        }
           
        
        
   }
}