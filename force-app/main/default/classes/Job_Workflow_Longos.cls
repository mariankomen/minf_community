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
public class Job_Workflow_Longos {

     public static void processJob(SFDC_Job__c j) {
		// set global HM Portal details
		j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
		j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
		j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
		// j.HM_Portal_Address_URL_FR__c  = ''; 

		// career site formula
		string careerSite;
		// if job title for role filled in, use that else use job role title
		careerSite = j.ft_or_pt__c + ' ' + (j.job_title_for_role__c == null ? j.job_role_title__c : j.job_title_for_role__c) + ' - Longos';
		// add city based on profile
		if (j.job_owner_profile__c == 'Longos HirePortal HR User') 
			careerSite += ' (Toronto)';
		else
			careerSite += ' ' + (j.Location_Store_Name__c == null ? '' : ' (' + j.Location_Store_Name__c +')');
				
		// LO OnDemand (Entered by our Team)
		if (j.MindField_Job_Type__c == 'TalentReach' || j.MindField_Job_Type__c == 'TalentDrive - TBD'|| j.MindField_Job_Type__c == 'TalentDrive - Front Line'|| j.MindField_Job_Type__c == 'TalentDrive - Management') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 99';
			j.SLA_Level__c  = (j.SLA_Level__c == null ? 'Job Posting Only' : j.SLA_Level__c );
			//j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;
		}   

		   // LO Bakery Assistant Department Manager
		else if ( j.Job_Title_for_Role__c == 'Bakery Assistant Department Manager') {
			j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 4 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 21';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $15.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Bakery Clerk
		else if ( j.Job_Title_for_Role__c == 'Bakery Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 2';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Barista
		else if ( j.Job_Title_for_Role__c == 'Barista') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 14';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Cake Decorator
		else if ( j.Job_Title_for_Role__c == 'Cake Decorator') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 18';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $12.50';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Cashier
		else if ( j.Job_Title_for_Role__c == 'Cashier') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 3';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Customer Service Clerk
		else if ( j.Job_Title_for_Role__c == 'Customer Service Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 4';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $12.50';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Dairy/Frozen Food Clerk
		else if ( j.Job_Title_for_Role__c == 'Dairy/Frozen Food Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 8';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Deli Assistant Department Manager
		else if ( j.Job_Title_for_Role__c == 'Deli Assistant Department Manager') {
			j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 4 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 22';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $15.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Deli Clerk
		else if ( j.Job_Title_for_Role__c == 'Deli Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 5';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Floral Clerk
		else if ( j.Job_Title_for_Role__c == 'Floral Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 7';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Grocery Clerk
		else if ( j.Job_Title_for_Role__c == 'Grocery Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 6';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Grocery Gateway Driver
		else if ( j.Job_Title_for_Role__c == 'Grocery Gateway Driver') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 16';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Grocery Gateway Shopper
		else if ( j.Job_Title_for_Role__c == 'Grocery Gateway Shopper') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 15';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Meat Clerk
		else if ( j.Job_Title_for_Role__c == 'Meat Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 10';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Meat Cutter
		else if ( j.Job_Title_for_Role__c == 'Meat Cutter') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 17';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $15.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Pizza Artists
		else if ( j.Job_Title_for_Role__c == 'Pizza Artist') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 19';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Prepared Foods Assistant Department Manager
		else if ( j.Job_Title_for_Role__c == 'Prepared Foods Assistant Department Manager') {
			j.Credits_Used_for_Job__c = 4;
			j.OTHER_Job_Template_ID__c  = 'LO - 23';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $15.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Prepared Foods Clerk
		else if ( j.Job_Title_for_Role__c == 'Prepared Foods Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 12';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Produce Clerk
		else if ( j.Job_Title_for_Role__c == 'Produce Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 9';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Seafood Clerk
		else if ( j.Job_Title_for_Role__c == 'Seafood Clerk') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 11';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $11.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Starbucks Captain
		else if ( j.Job_Title_for_Role__c == 'Starbucks Captain') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 24';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: TBD';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Store Manager
		else if ( j.Job_Title_for_Role__c == 'Store Manager') {
			j.Credits_Used_for_Job__c = (j.Credits_Used_for_Job__c == null ? 4 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 20';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}
		// LO Store Receiver
		else if ( j.Job_Title_for_Role__c == 'Store Receiver') {
			j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
			j.OTHER_Job_Template_ID__c  = 'LO - 13';
			j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
			j.Wage_Details__c = 'CONFIDENTIAL: $15.00';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
			j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
			j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
			j.Career_Site_Alternate_Job_Title__c = careerSite;

		}           
     }
}