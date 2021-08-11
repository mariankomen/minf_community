/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Jeff Perron, October 6/17
Modification Log:

    
****************************/
public class Job_Workflow_Tim_Hortons_NSM {

    public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_Shortened__c = 'mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Address_URL_FR__c  = ''; 
        j.Credits_Used_for_Job__c = 1;
        j.Using_Interview_Scheduling__c = true; 
        
        j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
        

        // Tim Hortons - Job Title 1 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Restaurant Team Member' ||
            j.Job_Title_for_Banner__c == 'Restaurant Team Member - Graveyard') {
        
            j.OTHER_Job_Template_ID__c = 'TH-1';
            j.wage_details__c = '';
            
            
            j.Career_Site_Alternate_Job_Title__c = 'Counter Attendant' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line 1';
            j.Role_Type__c = 'Frontline 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 30; 
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '0957016 BC Ltd.') {
                j.Num_of_Days_for_Delivery_Agreement__c=90; //override above, re-implement April 13, 2018. Devliery set from 30 to 90
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 2----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Multiplex Food Services Inc.') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 3----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = 'FT with unrestricted availability (24/7 Mon-Sun): $11.60/hr + premium-$15/hr; FT with restricted availability: $11.60/hr-$14/hr; PT with restricted availability: $11.60/hr-$13/hr; PT students under 18 years old: $10.90/hr-$13/hr';
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 4----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'R.A.F Holdings Ltd') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
            }
            //------------------------------------------------------------------------------------------------
        
            
            //Store Banner 5----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Branison Holdings Inc') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = 'Starting wage: $12.00/hr';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 6----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Churchill Foods Ltd') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = 'Starting wage: $11.75- $12.25/hr';
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 7----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'I&G Bismarketing Ltd') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = '$11.35 starting wage. Graveyard $1.00/hr shift premium';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 8----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '1008904 BC Ltd') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = '$11.35/hr starting wage. Graveyard $1.05/hr shift premium';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 9----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Interwest Restaurants Inc') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = '$11.00 minimum wage + premiums for people who start early (4-6am) $1.05 + $1.50 for graveyard';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 10----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '474722BCLTD') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = 'Minimum wage; Graveyard varies by store shift premium depending on the store, can be flexible based on the work experience';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 11----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Kesther Enterprises Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 12----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'GB Emett Holdings') {
              j.wage_details__c = '';
                if(j.Candidate_Availability__c == 'Days'){
                j.Career_Site_Alternate_Job_Title__c = 'Counter Attendant - Day Shift' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                }
                if(j.Candidate_Availability__c == 'Weekday Afternoons'){
                j.Career_Site_Alternate_Job_Title__c ='Counter Attendant - Afternoon Shift' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.OTHER_Job_Template_ID__c = 'TH-6';
                }
                if(j.Candidate_Availability__c == 'Weekday Afternoons & Weekends'){
                j.Career_Site_Alternate_Job_Title__c = 'Counter Attendant - Afternoon Shift' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.OTHER_Job_Template_ID__c = 'TH-6';
                }
                if(j.Candidate_Availability__c == 'Overnights'){
                j.Career_Site_Alternate_Job_Title__c = 'Counter Attendant - Overnight Shift' + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
                j.OTHER_Job_Template_ID__c = 'TH-7';
                }
           
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            j.SLA_Level__c = 'Front Line 1';
            j.Role_type__c = 'Frontline 1';
            }
            //------------------------------------------------------------------------------------------------
        
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Tim Hortons - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
               //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.Num_of_Days_for_Delivery_Agreement__c=30; //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 1 ---------------------------------------------------------------------------------------------------------------------------
    
    
        // Tim Hortons - Job Title 2 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Assistant Store Manager') {
        
            j.OTHER_Job_Template_ID__c = 'TH-2';
            j.wage_details__c = '';
            j.Career_Site_Alternate_Job_Title__c = 'Assistant Manager' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30; 
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '0957016 BC Ltd.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 2----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Multiplex Food Services Inc.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 3----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 4----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'R.A.F Holdings Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            
            //Store Banner 5----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Branison Holdings Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 6----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Churchill Foods Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 7----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'I&G Bismarketing Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 8----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '1008904 BC Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 9----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Interwest Restaurants Inc') {
           
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 10----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '474722BCLTD') {
           
            }
            //------------------------------------------------------------------------------------------------
        
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Tim Hortons - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Management'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 2 ---------------------------------------------------------------------------------------------------------------------------
    
    
        // Tim Hortons - Job Title 3 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Restaurant General Manager') {
        
            j.OTHER_Job_Template_ID__c = 'TH-3';
            j.Career_Site_Alternate_Job_Title__c = 'General Manager' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            //j.SLA_Level__c = 'Management 1';
            //j.Role_Type__c = 'Management 1';
            j.SLA_Level__c = 'Management 2';
            j.Role_Type__c = 'Management 2';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30; 
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '0957016 BC Ltd.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 2----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Multiplex Food Services Inc.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 3----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 4----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'R.A.F Holdings Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            
            //Store Banner 5----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Branison Holdings Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 6----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Churchill Foods Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 7----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'I&G Bismarketing Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 8----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '1008904 BC Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 9----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Interwest Restaurants Inc') {
            
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 10----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '474722BCLTD') {
            
            }
            //------------------------------------------------------------------------------------------------
        
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Tim Hortons - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Management'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 3 ---------------------------------------------------------------------------------------------------------------------------
    
    
        // Tim Hortons - Job Title 4 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Baker') {
        
            j.OTHER_Job_Template_ID__c = 'TH-4';
            j.Career_Site_Alternate_Job_Title__c = 'Baker' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.SLA_Level__c = 'Front Line';
            j.Role_Type__c = 'Frontline';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            //j.Num_of_Days_for_Delivery_Agreement__c = 14; 
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '0957016 BC Ltd.') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 2----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Multiplex Food Services Inc.') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 3----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
            
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 4----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'R.A.F Holdings Ltd') {
               
            }
            //------------------------------------------------------------------------------------------------
        
            
            //Store Banner 5----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Branison Holdings Inc') {
              
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 6----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Churchill Foods Ltd') {
            
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 7----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'I&G Bismarketing Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 8----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '1008904 BC Ltd') {
                j.wage_details__c = '$11.35 starting wage. Wage increases to $12.75/hr once training has been completed.';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 9----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Interwest Restaurants Inc') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = '$11.00 minimum wage + premiums for people who start early (4-6am) $1.05 + $1.50 for graveyard';
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 10----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '474722BCLTD') {
                //j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = 'Minimum wage; Graveyard varies by store shift premium depending on the store, can be flexible based on the work experience';
            }
            //------------------------------------------------------------------------------------------------
        
             //Store Banner 11----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Kesther Enterprises Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 12----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'GB Emett Holdings') {
                j.Num_of_Days_for_Delivery_Agreement__c=14; //override above
                j.wage_details__c = '';
            }
            //------------------------------------------------------------------------------------------------
        
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Tim Hortons - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Front Line'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
                j.Num_of_Days_for_Delivery_Agreement__c=30;           //override above
            }
            //------------------------------------------------------------------------------------------------
        }
        //END Job title 4 ---------------------------------------------------------------------------------------------------------------------------
    
        // Tim Hortons - Job Title 5 ---------------------------------------------------------------------------------------------------------------------------
        if (j.Job_Title_for_Banner__c == 'Shift Supervisor') {
        
            j.OTHER_Job_Template_ID__c = 'TH-5';
            j.Career_Site_Alternate_Job_Title__c = 'Shift Supervisor' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30; 
                   
            //Store Banner 1----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '0957016 BC Ltd.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 2----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Multiplex Food Services Inc.') {
               
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 3----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'QSR Group Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 4----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'R.A.F Holdings Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            
            //Store Banner 5----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Branison Holdings Inc') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 6----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Churchill Foods Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
        
            //Store Banner 7----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'I&G Bismarketing Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 8----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '1008904 BC Ltd') {
                
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 9----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Interwest Restaurants Inc') {
           
            }
            //------------------------------------------------------------------------------------------------
            
            //Store Banner 10----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == '474722BCLTD') {
           
            }
            //------------------------------------------------------------------------------------------------
        
            //ON DEMAND----------------------------------------------------------------------------------
            if (j.Banner_of_Store__c == 'Tim Hortons - Ondemand') {
                j.MindField_Job_Type__c = 'TalentDrive - Management'; //override above
                j.Program_Type__c = 'On Demand';                      //override above
            }
            //------------------------------------------------------------------------------------------------
          
        
        }
        //END Job title 5 ---------------------------------------------------------------------------------------------------------------------------
            if (j.Job_Title_for_Banner__c == 'Assistant Restaurant Manager') {
        
            j.OTHER_Job_Template_ID__c = 'TH-2';
            j.Career_Site_Alternate_Job_Title__c = 'Assistant Store Manager' + (j.department__c == null ? '' : ' ('+j.department__c+')') + (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c );
            
            j.MindField_Job_Type__c = 'TalentRecruit - Management';
            j.SLA_Level__c = 'Management 1';
            j.Role_Type__c = 'Management 1';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Full-Cycle Recruitment';
            
            j.Num_of_Candidates_for_Delivery_Agreement__c = 3;
            j.Num_of_Days_for_Delivery_Agreement__c = 30;
            } 
    }
}