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
public class Job_Workflow_Olsen {

     public static void processJob(SFDC_Job__c j) {
		// set global HM Portal details
		j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
		j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
		j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
		j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 

		// career site formula
		string careerSite;
		// if job title for role filled in, use that else use job role title
		careerSite = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + ' - Olsen';
		// add city based on profile
		if (j.job_owner_profile__c == 'Olsen Europe HirePortal HR User') 
			careerSite += ' (Mississauga)';
		else
			careerSite += ' ('+j.job_city__c+')';

		// OE OnDemand
		if (j.MindField_Job_Type__c == 'TalentDrive - TBD') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'OE - 99';
			j.sla_level__c = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
			//j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
		}

		// OE Sales Associate
		else if ( j.Job_Title_for_Role__c == 'Sales Associate' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 1';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}       
		// OE Store Manager
		else if ( j.Job_Title_for_Role__c == 'Store Manager' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 2';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}
		// OE Senior Sales Associate
		else if ( j.Job_Title_for_Role__c == 'Senior Sales Associate' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 3';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}
		// OE Sales Associate – FRENCH
		else if ( j.Job_Title_for_Role__c == 'Sales Associate – FRENCH' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 5';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}
		// OE Senior Sales Associate – FRENCH
		else if ( j.Job_Title_for_Role__c == 'Senior Sales Associate – FRENCH' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 6';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}
		// OE Store Manager – FRENCH
		else if ( j.Job_Title_for_Role__c == 'Store Manager – FRENCH' ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 7';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}

		// OE Asst. Shoppe Manager
		//else if ( j.Job_Title_for_Role__c == 'Assistant Shoppe Manager' ) {
		//    j.OTHER_Job_Template_ID__c  = 'OE - 4';
		//    j.Career_Site_Alternate_Job_Title__c = careerSite;
		//}

		// OE Other
		else if ( j.Job_Title_for_Role__c == null ) {
			j.OTHER_Job_Template_ID__c  = 'OE - 99';
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}
     }
}