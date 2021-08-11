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
public class Job_Workflow_SourceforSports {

     public static void processJob(SFDC_Job__c j) {
		// set global HM Portal details
		j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
		j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
		j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
		// j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 

		// SFS Customer Service Associate
		if ( j.Job_Title_for_Role__c == 'Customer Service Associate' ) {
			j.Credits_Used_for_Job__c = 3;
			j.OTHER_Job_Template_ID__c  = 'SFS - 3';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
			j.Job_Billing_Amount__c = 199;
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);
			j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + '- Source for Sports' + ' ('+j.job_city__c+')';
		}
		// SFS Sales Associate
		else if ( j.Job_Title_for_Role__c == 'Sales Associate' ) {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'SFS - 1';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
			j.Job_Billing_Amount__c = 199;
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);
			j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + '- Source for Sports' + ' ('+j.job_city__c+')';
		} 
		// SFS Technician
		else if ( j.Job_Title_for_Role__c == 'Technician' ) {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'SFS - 2';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
			j.Job_Billing_Amount__c = 199;
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);
			j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + '- Source for Sports' + ' ('+j.job_city__c+')';
		}                                                 
		// SFS Other - if neither of those job title for roles then continue
		else {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'SFS - 99';
			j.sla_level__c = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
			//j.Job_Billing_Amount__c = 369;
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
		}       
     }
}