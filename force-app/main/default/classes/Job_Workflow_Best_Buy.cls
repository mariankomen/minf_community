public class Job_Workflow_Best_Buy {

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
    
 
        if ( j.Job_Title_for_Role__c =='Geek Squad Field Agent I – Retail (CIA 1)')
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Field Tech Specialist' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Spécialiste technique sur le terrain' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-1';
            j.Job_Title_FR__c = 'Agent sur le terrain de l’équipe du soutien informatique – Ventes';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Geek Squad Technicians – DC')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Computer Repair Specialist' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-2';
            j.Job_Title_FR__c = '';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Product Process Specialist – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Product Experience Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis à l’expérience produits' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-3';
            j.Job_Title_FR__c = 'Spécialiste des processus sur les produits – Ventes';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Solutions Advisor – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Tech Sales Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis technique aux ventes' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-4';
            j.Job_Title_FR__c = 'Conseiller en solutions – Ventes';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Warehouse Associate – DC')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Warehouse Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis d’entrepôt' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-5';
            j.Job_Title_FR__c = 'Commis d’entrepôt – Centre de distribution';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Customer Service Specialist')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Retail Customer Service Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Agent du service à la clientèle aux ventes' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-6';
            j.Job_Title_FR__c = 'Spécialiste du service à la clientèle';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Customer Experience Associate - CHQ')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Customer Experience Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis à l’expérience client' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-7';
            j.Job_Title_FR__c = 'Commis à l’expérience client – Siège social';
            j.SLA_Level__c = 'Specialty 1';
            j.Role_Type__c = 'Specialty 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Seasonal Retail Associate')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Seasonal Retail Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis saisonnier aux ventes' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-8';
            j.Job_Title_FR__c = 'Commis saisonnier aux ventes';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Counter Intelligence Agent')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Front Line Tech Specialist' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Spécialiste technique de première ligne' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-9';
            j.Job_Title_FR__c = 'Commis du service des renseignements';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Sr. Administration – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sr Sales and Admin Support Representative' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Agent principal du soutien administratif et des ventes' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-10';
            j.Job_Title_FR__c = 'Préposé à l’administration principal – Ventes';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        
        else if ( j.Job_Title_for_Role__c =='Team Lead – DC')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Retail Shift Leader' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-11';
            j.Job_Title_FR__c = '';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Sr. Advisor – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Senior Retail Associate' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Commis principal aux ventes' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-12';
            j.Job_Title_FR__c = 'Conseiller principal – Ventes';
            j.SLA_Level__c = 'Specialty 2';
            j.Role_Type__c = 'Specialty 2';
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';                          
        }
        
        else if ( j.Job_Title_for_Role__c =='Precinct Chief – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Tech Specialist Department Manager' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Directeur du service des spécialistes techniques' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-13';
            j.Job_Title_FR__c = 'Chef de secteur – Ventes';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;          
        }
    
        else if ( j.Job_Title_for_Role__c =='Team Lead (Supervisor) – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Senior Shift Leader' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Chef d’équipe principal' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-14';
            j.Job_Title_FR__c = 'Chef d’équipe (superviseur) – Ventes';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;          
        }
    
        else if ( j.Job_Title_for_Role__c =='Supervisor – DC')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Store Supervisor' + ' - ' + j.Location_Store_Name__c): 
                                                    ('' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-15';
            j.Job_Title_FR__c = '';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;          
        }
    
        else if ( j.Job_Title_for_Role__c =='Assistant Store Leader – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Assistant Store Leader' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Assistant-gérant de magasin' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-16';
            j.Job_Title_FR__c = 'Assistant-gérant de magasin – Ventes';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;          
        }
    
        else if ( j.Job_Title_for_Role__c =='Store Leader – Retail')
        
        {
            j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Store Leader' + ' - ' + j.Location_Store_Name__c): 
                                                    ('Gérant de magasin' + ' - ' + j.Location_Store_Name__c);
            j.OTHER_Job_Template_ID__c  = 'BB-17';
            j.Job_Title_FR__c = 'Gérant de magasin – Ventes';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.MindField_Job_Type__c = 'TalentDrive - Management';
            j.Mindfield_Service__c = 'Full-Cycle Recruitment';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;          
        }
    
              
        
           if(j.Job_Owner_Language_Profile__c =='French')
        {
        j.OTHER_Job_Template_ID__c = j.OTHER_Job_Template_ID__c + ' FR';
        }
           
        
        
   }
}