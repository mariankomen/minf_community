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
public class Job_Workflow_Lowes {

     public static void processJob(SFDC_Job__c j) {
		// set global HM Portal details
		j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
		j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
		j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
		// j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php';

		// currently all LOWES are Job Posting Only, if not the case in the future move this line into each job setting below 
		j.sla_level__c = 'Job Posting Only';
		// currently all LOWES are 1 credit, if not the case in the future move this line into each job setting below 
		j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
							
		// LOW OnDemand
		if (j.MindField_Job_Type__c == 'TalentDrive - TBD' || j.MindField_Job_Type__c == 'TalentDrive - Front Line' || j.MindField_Job_Type__c == 'TalentDrive - Management') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 99';
			j.sla_level__c = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
			//j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
		} 

		// LOW Commercial Customer Service Associate
		else if ( j.Job_Title_for_Role__c == 'Commercial Customer Service Associate' ) {
			j.OTHER_Job_Template_ID__c  = 'LOW - 1';
		}
		// LOW Commercial Sales Associate
		else if ( j.Job_Title_for_Role__c == 'Commercial Sales Associate') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 2';

		}   
		// LOW Department Manager - Delivery/Freight Flow
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Delivery/Freight Flow') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 3';

		}                                 
		// LOW Department Manager – Appliances
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Appliances') {                        
			j.OTHER_Job_Template_ID__c  = 'LOW - 4';

		}                                 
		// LOW Department Manager – Electrical
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Electrical') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 5';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);

		}                                 
		// LOW Department Manager – Flooring
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Flooring') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 6';
			j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentReach' : j.MindField_Job_Type__c);

		}                                 
		// LOW Department Manager – Hardware/Tools
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Hardware/Tools') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 7';

		}                                 
		// LOW Department Manager – Inside Lawn and Garden
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Inside Lawn and Garden') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 8';

		}                                 
		// LOW Department Manager - Outside Lawn and Garden
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Outside Lawn and Garden') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 9';

		}                                 
		// LOW Department Manager – Night Crew
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Night Crew') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 10';

		}                                 
		// LOW Department Manager – Overnight Receiving/Stocking
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Overnight Receiving/Stocking') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 11';

		}                                 
		// LOW Department Manager – Paint
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Paint') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 12';

		}                                 
		// LOW Department Manager – Plumbing
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Plumbing') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 13';

		}                                 
		// LOW Department Manager – PSA
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'PSA') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 14';

		}                                 
		// LOW Department Manager – Tools
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Tools') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 15';

		}                                 
		// LOW Department Manager – Various Departments
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Various Departments') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 16';

		}                                 
		// LOW Department Manager – Receiving
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Receiving') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 17';

		}                                 
		// LOW Department Manager – Windows and Walls
		else if ( j.Job_Title_for_Role__c == 'Department Manager' && j.other_department__c == 'Windows and Walls') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 18';

		}                                 
		// LOW Electrical Professional
		else if ( j.Job_Title_for_Role__c == 'Electrical Professional') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 19';

		}                                 
		// LOW Loss Prevention Manager
		else if ( j.Job_Title_for_Role__c == 'Loss Prevention Manager') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 20';

		}                                 
		// LOW Plumbing Professional
		else if ( j.Job_Title_for_Role__c == 'Plumbing Professional') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 21';

		}                                 
		// LOW Product Services Specialist
		else if ( j.Job_Title_for_Role__c == 'Product Services Specialist') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 22';

		}                                 
		// LOW Sales Specialist – Cabinets and Home Organizations
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Cabinets and Home Organizations') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 23';

		}
		// LOW Sales Specialist – Commercial Sales
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Commercial Sales') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 24';

		}
		// LOW Sales Specialist – Flooring
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Flooring') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 25';

		}
		// LOW Sales Specialist – Kitchen Cabinets
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Kitchen Cabinets') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 26';

		}
		// LOW Sales Specialist – Millwork
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Millwork') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 27';

		}
		// LOW Sales Specialist – Plumbing
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Plumbing') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 28';
		}
		// LOW Sales Specialist – Windows and Walls
		else if ( j.Job_Title_for_Role__c == 'Sales Specialist' && j.other_department__c == 'Windows and Walls') {
			j.OTHER_Job_Template_ID__c  = 'LOW - 29';
		}       
     }
}