/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
28/4/2016 - Nick - Added Role type, program type and mindfield service
    
****************************/
public class Job_Workflow_HYLouie {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        // j.HM_Portal_Address_URL_FR__c  = ''; 

        // all roles have same defaults
        j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.OTHER_Job_Template_ID__c  = 'HYL - 99';
        j.sla_level__c = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
        j.Mindfield_Service__c = 'Full-Cycle Recruitment';
        j.Role_type__c = 'Management';
        j.Program_Type__c = 'On Demand';
        
             
     }
}