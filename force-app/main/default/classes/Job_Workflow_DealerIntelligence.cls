/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Nick Onusko, April 12, 2016
Modification Log:
    
****************************/
public class Job_Workflow_DealerIntelligence {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // career site formula
        string careerSite;
        // if job title for role filled in, use that else use job role title
        careerSite = j.job_title_for_role__c + ' ' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );

        // global settings for all roles
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentConnect - Promote Post' : j.MindField_Job_Type__c);
        j.Career_Site_Alternate_Job_Title__c = careerSite;
        j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
        j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.mindfield_service__c = 'Candidate Sourcing';
    

        // Dealer intelligence Intenet sales consultant role
        if ( j.Job_Title_for_Banner__c == 'Internet Sales Consultant' ) {
            j.Career_Site_Alternate_Job_Title__c = 'Sales Consultant - ' + j.job_city__c;
            j.OTHER_Job_Template_ID__c  = 'DI-1';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';
        } 
        
     }
 }