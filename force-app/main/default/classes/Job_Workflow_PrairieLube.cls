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
public class Job_Workflow_PrairieLube {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        // j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 
        j.Agency_Business_Unit__c = 'Customer Service & Sales';

        // PL OnDemand
        if ((j.MindField_Job_Type__c == 'TalentDrive - TBD' || j.MindField_Job_Type__c == 'TalentDrive - Front Line' || j.MindField_Job_Type__c == 'TalentDrive - Management' || j.MindField_Job_Type__c == 'TalentReach')) {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PL - 99';
            j.sla_level__c = (j.SLA_Level__c == null ? 'OnDemand Opening/Client' : j.SLA_Level__c );
           j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' ' + j.job_role_title__c + ' - Mr. Lube ('+j.job_city__c+')';
            //j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentDrive - TBD' : j.MindField_Job_Type__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }

        // PL Assistant Store Manager
        else if ( j.Job_Title_for_Banner__c == 'Assistant Store Manager' && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c = 2;
            j.OTHER_Job_Template_ID__c  = 'PL - 3';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
           j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Assistant Store Manager - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // PL Greeter
        else if ((j.Job_Title_for_Banner__c == 'Greeter' || j.Job_Title_for_Banner__c == 'Greeter')  && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PL - 9';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Greeter - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 5 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            // wage details depends on user's store (using Alias for store number in owner_
            // stores in Calgary (18,17,106,109,16,69,116) and Lethbridge (108, 54) are $12/hr
            set<string> perHr12 = new Set<string>{'PL18','PL17','PL106','PL109','PL16','PL69','PL116','PL108','PL54'};
            // stores in Saskatoon (23, 65) are $11.50/ hr
            set<String> perHr1150 = new Set<string>{'PL23','PL65'};
            if (perHr12.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start';
            else if (perHr1150.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $11.50/hour to start';
        } 
        // PL Sales Advisor
        else if ((j.Job_Title_for_Banner__c == 'Sales Advisor' || j.Job_Title_for_Banner__c == 'Sales Advisor')  && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MLF - 10';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Sales Advisor - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 5 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            // wage details depends on user's store (using Alias for store number in owner_
            // stores in Calgary (18,17,106,109,16,69,116) and Lethbridge (108, 54) are $12/hr
            set<string> perHr12 = new Set<string>{'PL18','PL17','PL106','PL109','PL16','PL69','PL116','PL108','PL54'};
            // stores in Saskatoon (23, 65) are $13.00/ hr
            set<String> perHr1150 = new Set<string>{'PL23','PL65'};
            if (perHr12.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $13.00/hour to start';
            else if (perHr1150.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $13.00/hour to start';
        } 
        
        
        // PL Store Manager
        else if (j.Job_Title_for_Banner__c == 'Store Manager' && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c = 2;
            j.OTHER_Job_Template_ID__c  = 'PL - 4';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Store Manager - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // PL Supervisor
        else if ( j.Job_Title_for_Banner__c == 'Supervisor' && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c = 2;
            j.OTHER_Job_Template_ID__c  = 'PL - 8';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Supervisor - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
        // PL Lower Technician
        else if (( j.Job_Title_for_Banner__c == 'Lower Service Technician' || j.Job_Title_for_Banner__c == 'Lower Technician') && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PL - 6';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Lower Service Technician - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 5 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            // wage details depends on user's store (using Alias for store number in owner_
            // stores in Calgary (18,17,106,109,16,69,116) and Lethbridge (108, 54) are $12/hr
            set<string> perHr12 = new Set<string>{'PL18','PL17','PL106','PL109','PL16','PL69','PL116','PL108','PL54'};
            // stores in Saskatoon (23, 65) are $11.50/ hr
            set<String> perHr1150 = new Set<string>{'PL23','PL65'};
            if (perHr12.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start';
            else if (perHr1150.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $11.50/hour to start';
        }                    
        // PL Upper Technician
        else if ((j.Job_Title_for_Banner__c == 'Upper Service Technician' || j.Job_Title_for_Banner__c == 'Upper Technician') && j.Banner_of_Store__c=='Mr. Lube') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PL - 7';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Customer Service Representative - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 5 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            // wage details depends on user's store (using Alias for store number in owner_
            // stores in Calgary (18,17,106,109,16,69,116) and Lethbridge (108, 54) are $12/hr
            set<string> perHr12 = new Set<string>{'PL18','PL17','PL106','PL109','PL16','PL69','PL116','PL108','PL54'};
            // stores in Saskatoon (23, 65) are $11.50/ hr
            set<String> perHr1150 = new Set<string>{'PL23','PL65'};
            if (perHr12.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start';
            else if (perHr1150.contains(j.Job_Owner_Alias__c))
                j.wage_details__c = 'Hourly Wage is $11.50/hour to start';
        } 
        // PL Wal-Mart Service Technician Regular
        else if (j.Job_Title_for_Banner__c =='Service Technician' && j.Banner_of_Store__c=='TLE Mr. Lube' && j.MindField_Service_Offering__c != 'Post Online' && j.MindField_Service_Offering__c != 'Promote' && j.MindField_Job_Type__c != 'TalentConnect - Post Only' && j.MindField_Job_Type__c != 'TalentConnect - Promote Post') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'pl-10';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Service Technician - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }      
        // PL Wal-Mart Service Advisor Regular
        else if (j.Job_Title_for_Banner__c =='Service Advisor' && j.Banner_of_Store__c=='TLE Mr. Lube' && j.MindField_Service_Offering__c != 'Post Online' && j.MindField_Service_Offering__c != 'Promote' && j.MindField_Job_Type__c != 'TalentConnect - Post Only' && j.MindField_Job_Type__c != 'TalentConnect - Promote Post') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'PL-11';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' Service Advisor - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Front Line';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }


        // PL Wal-Mart Store Leader Regular
        else if (j.Job_Title_for_Banner__c =='Store Leader' && j.Banner_of_Store__c=='TLE Mr. Lube' && j.MindField_Service_Offering__c != 'Post Online' && j.MindField_Service_Offering__c != 'Promote' && j.MindField_Job_Type__c != 'TalentConnect - Post Only' && j.MindField_Job_Type__c != 'TalentConnect - Promote Post') {
            j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
            j.OTHER_Job_Template_ID__c  = 'MLF - 13';
            j.sla_level__c = (j.SLA_Level__c == null ? 'Management' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c +' Store Leader - Mr. Lube ('+j.job_city__c+')';
            j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Management' : j.MindField_Job_Type__c);
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 30 : j.Num_of_Days_for_Delivery_Agreement__c);
            j.Role_Type__c = 'Management';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
        }
     }
}