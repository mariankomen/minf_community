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
public class Job_Workflow_Provident_Security {

  public static void processJob(SFDC_Job__c j) {
     // set global HM Portal details
    j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
    j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
    j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
    j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 
    
    string careerSiteTitle = j.Job_Title_for_Banner__c + ' - '+ j.Location_Store_Name__c;

    

    if (j.Banner_of_Store__c == 'Provident Security')
    {
    j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
    j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
    j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
    j.Role_Type__c = 'Front Line';
    j.Program_Type__c = 'Subscription';
    j.mindfield_service__c = 'Candidate Sourcing';
        
        if ( j.Job_Title_for_Banner__c =='Alarm Technician')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = 'Wage is commensurate with experience. $16 to $40 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-1';
        
        }
        else if (j.Job_Title_for_Banner__c == 'Customer Service Representative')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = '$12 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-2';
        }
        else if (j.Job_Title_for_Banner__c == 'Security Personnel')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = '$13 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-3';
        }
        else if (j.Job_Title_for_Banner__c == 'Bike Patrol')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = '$13 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-4';
        }
        else if (j.Job_Title_for_Banner__c == 'Mobile Team Member')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = '$13 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-5';
        }
        else if (j.Job_Title_for_Banner__c == 'Sales Representative')
        {
            j.Career_Site_Alternate_Job_Title__c = careerSiteTitle;
            j.wage_details__c = '$13 per hour';
            j.OTHER_Job_Template_ID__c  = 'PS-6';
        }
    
        
    }
}   
}