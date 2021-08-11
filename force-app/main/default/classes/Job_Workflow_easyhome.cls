/****************************
Class: Job_Workflow easyhome
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
    
****************************/
public class Job_Workflow_easyhome {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 

        // career site formula for easyhome since they want FT/PT at start
        string careerSiteEH;
        // if job title role filled in, use that else use job role title
        careerSiteEH = (j.job_title_for_banner__c == null ? j.job_role_title__c : j.job_title_for_banner__c);
        // add city based on profile
        if ((j.job_owner_profile__c == 'easyhome HirePortal HR User' || j.job_owner_profile__c =='easyfinancial and easyhome Head HirePortal HR User')) 
            careerSiteEH += ' - Mississauga';
        else
            careerSiteEH += (j.Location_Store_Name__c == null ? ' ('+j.job_city__c+')' : ' - ' + j.Location_Store_Name__c );
 // career site formula for easyfinancial since they don't want FT/PT at start
        string careerSiteEF;
        // if job title for role filled in, use that else use job role title
        careerSiteEF = (j.job_title_for_banner__c == null ? j.job_role_title__c : j.job_title_for_banner__c);
        // add city based on profile
        if ((j.job_owner_profile__c == 'easyfinancial HirePortal HR User' || j.job_owner_profile__c =='easyfinancial and easyhome Head HirePortal HR User')) 
            careerSiteEF += ' - Mississauga';
        else
            careerSiteEF += (j.Location_Store_Name__c == null ? ' ('+j.job_city__c+')' : ' - ' + j.Location_Store_Name__c );
        // EH Assistant Store Manager
        if ( j.Job_Title_for_Banner__c == 'Assistant Store Manager' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 9';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Assistant Managers make between $13.34 to $16.67 for Area 1; $14.44 to $17.85 for Area 2 or $14.61 to $18.93 for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        // EH Customer Retention Specialist
        else if ( j.Job_Title_for_Banner__c == 'Customer Retention Specialist' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 7';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Customer Retention Specialist make between $10.56 to $13.96 for Area 1; $11.63 to $15.04 for Area 2 or $12.98 to $18.39 for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        // EH Delivery Specialist
        else if ( j.Job_Title_for_Banner__c == 'Delivery Specialist' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 8';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Delivery Specialist make between $10.56 to $13.96 for Area 1; $11.63 to $15.04 for Area 2 or $12.98 to $18.39 for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 
        // EH EasyFinancial Assistant Branch Manager
        else if ( j.Job_Title_for_Banner__c == 'Assistant Branch Manager' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 2';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }                                                                               
        // EF EasyFinancial Branch Manager in Training
        else if ( j.Job_Title_for_Banner__c == 'Branch Manager in Training' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 11';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 
        // EF EasyFinancial Branch Manager Non-RPO
        else if ( j.Job_Title_for_Banner__c == 'Branch Manager' && j.Banner_of_Store__c == 'easyfinancial') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 3';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }                    
        // EF EasyFinancial Financial Services Representative
        else if ( j.Job_Title_for_Banner__c == 'Financial Service Representative' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 1';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }                     

        // EF EasyFinancial Financial Services Representative CSR/Customer Sales Representative
        else if ( j.Job_Title_for_Banner__c == 'Customer Sales Representative' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 13';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EF EasyFinancial Assistant Branch Manager CSR
        else if ( j.Job_Title_for_Banner__c == 'Assistant Branch Manager - CSR' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 14';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 
                                                
        // EH Leasing Specialist
        else if ( j.Job_Title_for_Banner__c == 'Leasing Specialist' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 6';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Leasing Specialist make between $10.56 to $13.96 for Area 1; $11.63 to $15.04 for Area 2 or $12.98 to $18.39 for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 
        // EH Other
        else if ( j.Job_Title_for_Banner__c == null && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 99';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EH Support Center
        else if ( j.Job_Title_for_Banner__c == null && j.Banner_of_Store__c == 'Support Centre' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 99';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
        } 

        // EF Other
        else if ( j.Job_Title_for_Banner__c == null && (j.Banner_of_Store__c == 'easyfinancial' || j.Banner_of_Store__c == 'National Shared Services')) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EF - 99';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EF Verification Agent
        else if ( j.Job_Title_for_Banner__c == 'Verification Agent' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 15';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EF Collector
        else if ( j.Job_Title_for_Banner__c == 'Collector' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 4';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EH Regional Manager
        else if ( j.Job_Title_for_Banner__c == 'Regional Manager' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 22';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EH Store Manager
        else if ( j.Job_Title_for_Banner__c == 'Store Manager' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 5';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Store Managers make between $36k to $50k (annually) for Area 1; $39k to $53k (annually) for Area 2 or $45k to $56k (annually) for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        } 

        // EH Store Manager in Training
        else if ( j.Job_Title_for_Banner__c == 'Store Manager in Training' && j.Banner_of_Store__c == 'easyhome' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 10';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEH;
            j.wage_details__c = 'Store Managers make between $36k to $50k (annually) for Area 1; $39k to $53k (annually) for Area 2 or $45k to $56k (annually) for Area 3.  Please reference the Wage Matrix if you have any questions.';
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EH National Shared Services - Loan Verification Agent
        else if ( j.Job_Title_for_Banner__c == 'Loan Verification Agent' && j.Banner_of_Store__c == 'National Shared Services' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 24';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // EH National Shared Services - Financial Services Representative
        else if ( j.Job_Title_for_Banner__c == 'Financial Services Representative' && j.Banner_of_Store__c == 'National Shared Services' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 25';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }   

        // EH National Shared Services - Collector
        else if ( j.Job_Title_for_Banner__c == 'Collector' && j.Banner_of_Store__c == 'National Shared Services' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 26';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }   
        
        else if ( j.Job_Title_for_Banner__c == 'New Store Opening' && j.Banner_of_Store__c == 'easyfinancial' ) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'EH - 27';
            j.Career_Site_Alternate_Job_Title__c = careerSiteEF;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }               
     }
     
     }