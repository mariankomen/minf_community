/****************************
Class: Job_Workflow COBS
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
    
****************************/
public class Job_Workflow_COBS {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite = (j.job_title_for_banner__c == null ? j.job_role_title__c : j.job_title_for_banner__c);
        // add city based on profile
        if (j.job_owner_profile__c == 'COBS Bread HirePortal HR User') 
            careerSite += ' - Vancouver';
        else
            careerSite += (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c);

        // Cobs OnDemand
        if (j.MindField_Job_Type__c == 'TalentReach' || j.MindField_Job_Type__c == 'TalentDrive - TBD' || j.MindField_Job_Type__c == 'TalentDrive - Front Line' || j.MindField_Job_Type__c == 'TalentDrive - Management' || 

j.Job_Role_Title__c != null) {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.OTHER_Job_Template_ID__c  = 'COB - 99';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
            //j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
        }


        // Cobs Bakery Manager
        else if ( j.Job_Title_for_Banner__c == 'Bakery Manager'   && j.Banner_of_Store__c == 'Cobs Store Level'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 1';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }

        // Cobs Assistant Bakery Manager
        else if ( j.Job_Title_for_Banner__c == 'Assistant Bakery Manager'   && j.Banner_of_Store__c == 'Cobs Store Level'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 2';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }

        // Cobs Brand Ambassador
        else if ( j.Job_Title_for_Banner__c == 'Brand Ambassador Team Member'  && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 3';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }

        // Cobs Baker
        else if ( j.Job_Title_for_Banner__c == 'Baker'   && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 4';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }

        // Cobs Production Manager
        else if ( j.Job_Title_for_Banner__c == 'Production Manager' && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 5';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }

        // Cobs Management Trainee
        else if ( j.Job_Title_for_Banner__c == 'Management Trainee' && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 16';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';
        }


        // Cobs Office - Information Services
        else if ( j.Job_Title_for_Banner__c == 'Support Services Technician'  && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 6';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;     
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';          
        }

        // Cobs Office - Junior Support Services Technician
        else if ( j.Job_Title_for_Banner__c == 'Junior Support Services Technician'  && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 7';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Office - Receptionist
        else if ( j.Job_Title_for_Banner__c == 'Receptionist & Finance Assistant' && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 8';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Office - Junior Accountant
        else if ( j.Job_Title_for_Banner__c == 'Junior Accountant' && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 9';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Office - Graphic Designer
        else if ( j.Job_Title_for_Banner__c == 'Graphic Designer' && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 10';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

         // Cobs Sales Assistant
        else if ( j.Job_Title_for_Banner__c == 'Sales Assistant' && j.Banner_of_Store__c == 'Cobs Store Level'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 11';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Sales Team Leader
        else if ( j.Job_Title_for_Banner__c == 'Sales Team Leader' && j.Banner_of_Store__c == 'Cobs Store Level'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 12';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Sales Manager
        else if ( j.Job_Title_for_Banner__c == 'Sales Manager' && j.Banner_of_Store__c == 'Cobs Store Level'){
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 13';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Lead Baker
        else if ( j.Job_Title_for_Banner__c == 'Lead Baker'   && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 14';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

        // Cobs Manage to Own
        else if ( j.Job_Title_for_Banner__c == 'Manage to Own'   && j.Banner_of_Store__c == 'Cobs Store Level') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 15';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

    // Cobs Projects Assistant
        else if ( j.Job_Title_for_Banner__c == 'Projects Assistant'   && j.Banner_of_Store__c == 'COBS Support Office') {
            j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'COB - 17';
            j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = careerSite;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
            if (j.MindField_Service_Offering__c == 'Post Online')
                j.mindfield_service__c = 'Posting Only';
            else
                j.mindfield_service__c = 'Candidate Sourcing';  
        }

     }
}