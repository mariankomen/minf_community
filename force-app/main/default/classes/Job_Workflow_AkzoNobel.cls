/****************************
Class: Job_Workflow Akzo Nobel
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
    
****************************/
public class Job_Workflow_AkzoNobel {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php';                    

        // New Store tests are first since they don't differentiate by job title etc
        // AN TalentReach
        if ((j.Job_Classed_as_New_Store__c == 'Yes' || j.MindField_Job_Type__c == 'TalentReach' || j.MindField_Job_Type__c == 'TalentDrive - TBD' || j.MindField_Job_Type__c == 'TalentDrive - Front Line' || j.MindField_Job_Type__c == 'TalentDrive - Management' && j.Job_Role_Title__c != null)) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 99';
            j.SLA_Level__c = (j.SLA_Level__c == null ? 'Store Project - Separate Invoice from RPO Billing' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.job_role_title__c + ' - ' + j.job_city__c;
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }

        // AN Corporate Field Services Rep
        else if (j.Job_Title_for_Banner__c == 'Field Service Rep' && j.Banner_of_Store__c == 'PPG Architectural Coatings' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 11';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Commis au service à la clientele';
            j.Career_Site_Alternate_Job_Title__c = 'Field Services Representative' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        } 
        // AN Corporate Territory Manager
        else if (j.Job_Title_for_Banner__c == 'Territory Manager - DIY' && j.Banner_of_Store__c == 'PPG Architectural Coatings' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 12';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Commis au service à la clientele';
            j.Career_Site_Alternate_Job_Title__c = 'Territory Manager' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 1'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        } 
        
        // March 15, 2017 - add store banner back in
        else if (j.Job_Title_for_Banner__c == 'Warehouse Associate' && j.Banner_of_Store__c == 'PPG Architectural Coatings' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PPGAC-1';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Associé d\'entrepôt';
            j.Career_Site_Alternate_Job_Title__c = 'Warehouse Associate' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
             j.wage_details__c = 'Base salary: $15.49/hr';
            j.Agency_Business_Unit__c = 'Industrial Support';
        } 
        
        
        // AN Manager in Training Betonel
        else if ( (j.Job_Title_for_Banner__c == 'Manager in Training - Internal Hire' || j.Job_Title_for_Banner__c == 'Manager in Training')
             && j.Banner_of_Store__c == 'Betonel' ) {
            //j.Credits_Used_for_Job__c =(j.Credits_Used_for_Job__c == null ? 3 : j.Credits_Used_for_Job__c );
            j.Credits_Used_for_Job__c =(j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 4';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 1' : j.SLA_Level__c ); //update to match NSM
            j.Job_Title_FR__c  = 'Gérant en formation';
            j.Career_Site_Alternate_Job_Title__c = 'Gérant en formation'+ (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 1'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        // AN Manager in Training Dulux
        else if ( (j.Job_Title_for_Banner__c == 'Manager in Training - Internal Hire' || j.Job_Title_for_Banner__c == 'Manager in Training')
             && (j.Banner_of_Store__c == 'ICI Paints' || j.Banner_of_Store__c == 'Dulux Paints') ) {
            //j.Credits_Used_for_Job__c =(j.Credits_Used_for_Job__c == null ? 3 : j.Credits_Used_for_Job__c );
            j.Credits_Used_for_Job__c =(j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 3';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 1' : j.SLA_Level__c ); //update to match NSM
            j.Job_Title_FR__c  = 'Gérant en formation';
            j.Career_Site_Alternate_Job_Title__c = 'Manager in Training' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 1'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }                    
        // AN Sales Associate Betonel
        else if ( (j.Job_Title_for_Banner__c == 'Store Service Rep' || j.Job_Title_for_Banner__c == 'Store Service Rep - Internal Hire')
             && j.Banner_of_Store__c == 'Betonel' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 1 FR';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Représentant de service à la clientèle au détail';
            //j.Career_Site_Alternate_Job_Title__c = 'Représentant de service à la clientèle au détail'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = 'Commis Magasin'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        } 
        // AN Sales Associate Commercial Dulux
        else if ( (j.Job_Title_for_Banner__c == 'Store Service Rep - Commercial Centre' || j.Job_Title_for_Banner__c == 'Store Service Rep - Commercial Centre - Internal Hire')
             && (j.Banner_of_Store__c == 'ICI Paints' || j.Banner_of_Store__c == 'Dulux Paints') ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 9';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Associé commercial à la marchandise';
            //j.Career_Site_Alternate_Job_Title__c = 'Customer Service Representative' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = 'Commercial Store Sales Specialist' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        } 

        // AN Sales Associate Commercial Betonel
        else if ( (j.Job_Title_for_Banner__c == 'Store Service Rep - Commercial Centre' || j.Job_Title_for_Banner__c == 'Store Service Rep - Commercial Centre - Internal Hire')
            && j.Banner_of_Store__c == 'Betonel' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 9 FR';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Représentant de service à la clientèle';
            //j.Career_Site_Alternate_Job_Title__c = 'Représentant de service à la clientèle'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Career_Site_Alternate_Job_Title__c = 'Commis Magasin Commerical'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        } 


        // AN Sales Associate Dulux
        else if ( (j.Job_Title_for_Banner__c == 'Store Service Rep' || j.Job_Title_for_Banner__c == 'Store Service Rep - Internal Hire')
             && (j.Banner_of_Store__c == 'ICI Paints' || j.Banner_of_Store__c == 'Dulux Paints') ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 2';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Job_Title_FR__c  = 'Commis au service à la clientele';
            //j.Career_Site_Alternate_Job_Title__c = 'Retail Customer Service Representative'+ (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
            j.Career_Site_Alternate_Job_Title__c = 'Store Sales Specialist (Retail CSR)'+ (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }


        // AN Store Manager Betonel
        else if ( (j.Job_Title_for_Banner__c == 'Store Manager' || j.Job_Title_for_Banner__c == 'Store Manager - Internal Hire')
             && j.Banner_of_Store__c == 'Betonel' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 6 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 5 FR';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 2' : j.SLA_Level__c ); //update to match NSM
            j.Job_Title_FR__c  = 'Directeur de magasin';
            j.Career_Site_Alternate_Job_Title__c = 'Directeur de magasin'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 2'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        // AN Store Manager Dulux
        else if ( (j.Job_Title_for_Banner__c == 'Store Manager' || j.Job_Title_for_Banner__c == 'Store Manager - Internal Hire')
             && (j.Banner_of_Store__c == 'ICI Paints' || j.Banner_of_Store__c == 'Dulux Paints') ) {
            //j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 6 : j.Credits_Used_for_Job__c );
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 6';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 2' : j.SLA_Level__c ); //update to match NSM
            j.Job_Title_FR__c  = 'Gérant de magasin';
            j.Career_Site_Alternate_Job_Title__c = 'Store Manager'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 2'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }     

        // AN Trade Sales Rep Betonel
        else if ( (j.Job_Title_for_Banner__c == 'Trade Sales Rep' || j.Job_Title_for_Banner__c == 'Trade Sales Rep - Internal Hire')
             && j.Banner_of_Store__c == 'Betonel' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 6 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 8';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Other (3 in 30)' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = 'Trade Sales Rep'+(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }

        // AN Trade Sales Rep Dulux - Deleted as no longer used and shared template ID with Store Manager
       
        
           else if ((j.Job_Title_for_Banner__c == 'Assistant Gérant' || j.Job_Title_for_Banner__c == 'Assistant Gérant -Embauche Interne') && j.Banner_of_Store__c == 'Betonel')  {
            //j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 3 : j.Credits_Used_for_Job__c );
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN-10 FR';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 1' : j.SLA_Level__c ); //update to match NSM
            j.Career_Site_Alternate_Job_Title__c = 'Assistant directeur de magasin' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Wage_Details__c =' $12.41 to $14 based on relevant experience';
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 1'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        //June 2017, new jpb title for Dulux
          else if (j.Job_Title_for_Banner__c == 'Assistant Store Manager' && j.Banner_of_Store__c == 'Dulux Paints')  {
            //j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 3 : j.Credits_Used_for_Job__c );
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'AN - 11';
            //j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Management 1' : j.SLA_Level__c ); //update to match NSM
            j.Career_Site_Alternate_Job_Title__c = 'Assistant Store Manager' +(j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 45 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Wage_Details__c ='Refer to QCP matrix';
            //j.Role_Type__c = 'Management';
            j.Role_Type__c = 'Management 1'; //update to match NSM
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            j.Agency_Business_Unit__c = 'Customer Service & Sales';
        }
        
        
    } 
}