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
public class Job_Workflow_Marks {

     public static void processJob(SFDC_Job__c j) {
        //March 2018, setting to NSM
        j.Using_Interview_Scheduling__c = true;
     
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'hourlyjobsportal.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'hourlyjobsportal.com';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Name_of_Person_Submitting_Request__c  = 'Not Required';
        j.Confidential__c  = 'No';
        j.Agency_Business_Unit__c = 'Customer Service & Sales'; //default
        
        // formula for Career Site Alt Job Title: ft/pt job title - Store Names ( Location store name )
        string careerSite = j.job_title_for_role__c + ' ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
        
        if(j.job_province__c == 'Alberta'){
            j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $11.20 to $12.15. Full Time wage for Alberta is $11.20 to $12.60. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';
        }
        else{
            j.wage_details__c = 'Part time wage for Ontario is $11.25 to $12.65. Full time wage for Ontario is $11.25 to $13.15.';
        }
        // Mark's Sales Associate
        if ( j.Job_Title_for_Role__c == 'Sales Associate' || j.Job_Title_for_Role__c == 'Associé aux ventes' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-1';
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $11.20 to $12.15. Full Time wage for Alberta is $11.20 to $12.60. Part time wage for Ontario is $11.25 to $12.65. Full time wage for Ontario is $11.25 to $13.15  Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            j.Job_Title_FR__c='Associé aux ventes';
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Sales Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé aux ventes/Sales Associate' + ' - ' + j.Location_Store_Name__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 5;
            //j.Targeted_Average_Time_to_Deliver__c = 7;
            //j.Targeted_Send_to_Hire__c = 2.5;
        }

        // Mark's Keyholder
        else if ( j.Job_Title_for_Role__c == 'Key Holder' || j.Job_Title_for_Role__c == 'Troisième clé' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );
            j.Job_Title_FR__c='Détenteur de clés';
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Key Holder' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Première clé/Key Holder' + ' - ' + j.Location_Store_Name__c);
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';      
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 10;
            //j.Targeted_Average_Time_to_Deliver__c = 12;
            //j.Targeted_Send_to_Hire__c = 3;
        }

        // Mark's Shipper/Receiver
        else if ( j.Job_Title_for_Role__c == 'Shipper/Receiver' || j.Job_Title_for_Role__c == 'Commis à l’expédition/réception' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-4';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            j.Job_Title_FR__c='Commis à l’expédition/réception';
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Shipper/Receiver' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Expéditeur/réceptionnaire/Shipper Receiver' + ' - ' + j.Location_Store_Name__c);//j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 6;
            //j.Targeted_Average_Time_to_Deliver__c = 10;
            //j.Targeted_Send_to_Hire__c = 3;
            j.Agency_Business_Unit__c = 'Industrial Support';
        }
        // Mark's OnDemand (at bottom so doesn't trigger on other roles)
        else if ( j.Job_Title_for_Role__c == null ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-99';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 7 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // Mark's Seasonal Associate 
        else if ( j.Job_Title_for_Role__c == 'Seasonal Associate' || j.Job_Title_for_Role__c == 'Associé saisonnier' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-7';
            j.Job_Title_FR__c='Associé saisonnier';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
    
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Seasonal Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé saisonnier/Seasonal Associate' + ' - ' + j.Location_Store_Name__c);
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';      
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 10;
            //j.Targeted_Average_Time_to_Deliver__c = 12;
            //j.Targeted_Send_to_Hire__c = 3;
        }
        
        // Mark's Seasonal Order Fulfillment Associate
        else if ( j.Job_Title_for_Role__c == 'Seasonal Order Fulfillment Associate' || j.Job_Title_for_Role__c == 'Associé saisonnier en remplissage des commandes ' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-8';
            j.Job_Title_FR__c='Associé saisonnier en remplissage des commandes';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );

             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Seasonal Order Fulfillment Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé saisonnier responsable de l’exécution des commandes/ Seasonal Order Fulfillment Associate' + ' - ' + j.Location_Store_Name__c);
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';      
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 10;
            //j.Targeted_Average_Time_to_Deliver__c = 12;
            //j.Targeted_Send_to_Hire__c = 3;
        }
        
        else if ( j.Job_Title_for_Role__c == 'Seasonal Order Fulfillment/Stock Associate' || j.Job_Title_for_Role__c == 'Associé en remplissage des commandes saisonnier/Responsable des stocks' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-8';
            j.Job_Title_FR__c='Associé en remplissage des commandes saisonnier/Responsable des stocks';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 2' : j.SLA_Level__c );
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Seasonal Order Fulfillment Associate/Stock Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé saisonnier responsable de l’exécution des commandes/ Seasonal Order Fulfillment Associate' + ' - ' + j.Location_Store_Name__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';

        }        
        
        
        
        
        // Mark's Visual Merchandiser
        else if ( j.Job_Title_for_Role__c == 'Visual Merchandiser' || j.Job_Title_for_Role__c == 'Marchandiseur visuel' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-5';
            j.Job_Title_FR__c='Marchandiseur visuel';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Specialty 1' : j.SLA_Level__c );

             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Visual Merchandiser' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Étalagiste/Visual Merchandiser' + ' - ' + j.Location_Store_Name__c);
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';      
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Specialty 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 10;
            //j.Targeted_Average_Time_to_Deliver__c = 12;
            //j.Targeted_Send_to_Hire__c = 3;
        }
        
        

        
        // Mark's Order Fulfillment Associate
        else if ( j.Job_Title_for_Role__c == 'Order Fulfillment Associate' || j.Job_Title_for_Role__c == 'Associé en remplissage des commandes' ) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MK-6';
            j.Job_Title_FR__c='Associé en remplissage des commandes';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line 1' : j.SLA_Level__c );
         
             j.Career_Site_Alternate_Job_Title__c =  j.Job_Owner_Language_Profile__c=='English' ? 
                                                    ('Order Fulfillment Associate' + ' - ' + j.Location_Store_Name__c) :
                                                    ('Associé responsable de l’exécution des commandes/Order Fulfillment Associate' + ' - ' + j.Location_Store_Name__c);
            //j.wage_details__c = 'Part Time wage in Alberta for Part-Time roles is $10.20 to $12.05.  Based on years of experience and expertise, potential maximum is $13.20.   Full Time wage is $10.20 to $13.50.  Based on years of experience and expertise, potential maximum is $15.40. Effective immediately there is no longer benefit eligibility or coverage for any Part time role in Mark\'s.';      
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            //j.Target_Days_for_50_of_Jobs_for_Delivery__c = 10;
            //j.Targeted_Average_Time_to_Deliver__c = 12;
            //j.Targeted_Send_to_Hire__c = 3;
        }
        if(j.Job_Owner_Language_Profile__c =='French')
        {
        j.OTHER_Job_Template_ID__c = j.OTHER_Job_Template_ID__c + ' FR';
        }
        
        
    }
}