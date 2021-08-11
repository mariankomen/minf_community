/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions/Gary Boun, Mar 1/15
Modification Log:
Mar 1/15: Added French template support
    
****************************/
public class Job_Workflow_1800GotJunk {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details
        j.HM_Portal_Address_URL__c  = 'mindfieldgroup.com/validator.php';
        j.HM_Portal_Address_URL_Shortened__c = 'login.mindfieldgroup.com/hiringportal.php';
        j.HM_Portal_Phone_Number__c  = '1-877-834-1751';
        j.HM_Portal_Address_URL_FR__c  = 'mindfieldgroup.com/validatorfr.php'; 
        j.Location_Country__c = j.Location_Store_Country__c;
     
        // career site is standard with variation based on Job Title - translate Display Job Title for this job and assign the Career Site at the end
        // start with selected job title
        //string DisplayJobTitle = j.Job_Title_for_Banner__c;
        
        // depending on banner and job title, assign template ID and display job title for Career Site value
        
        /*****************OLD JOB TITLES START***************/
        
        // Truck Team Member - FCR
        if (j.Job_Title_for_Banner__c == 'Truck Team Member' && j.Mindfield_Service__c== 'Full-cycle Recruitment') {
            j.MindField_Job_Type__c = 'TalentDrive - Front Line';
            j.sla_level__c = 'Front Line';
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 7;
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';
           if (j.Location_Country__c =='United States')
                j.OTHER_Job_Template_ID__c  = '18G-TTMFCRUS';
           else if (j.Location_Country__c =='Australia')
                j.OTHER_Job_Template_ID__c  = '18G-TTMFCRAUS';
            else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                j.OTHER_Job_Template_ID__c  = '18G-TTMFCRFR';    
            else 
                j.OTHER_Job_Template_ID__c  = '18G-TTMFCRCA';    
        }
        // Truck Team Member - CSS
        else if (j.Job_Title_for_Banner__c == 'Truck Team Member' && j.Mindfield_Service__c== 'Candidate Sourcing') {
            j.MindField_Job_Type__c = 'TalentReach';
            j.sla_level__c = 'Job Posting Only';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';
            if (j.Location_Country__c =='United States')
            
                j.OTHER_Job_Template_ID__c  = '18G-TTMCSSUS';
           else if (j.Location_Country__c =='Australia')
                j.OTHER_Job_Template_ID__c  = '18G-TTMCSSAUS';
            else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                j.OTHER_Job_Template_ID__c  = '18G-TTMCSSFR';    
           else 
                j.OTHER_Job_Template_ID__c  = '18G-TTMCSSCA';    
        }
        // Operations Manager - CSS
       else if (j.Job_Title_for_Banner__c == 'Operations Manager' && j.Mindfield_Service__c== 'Candidate Sourcing') {
           j.MindField_Job_Type__c = 'TalentReach';
           j.sla_level__c = 'Job Posting Only';
           j.Role_Type__c = 'Management';
           j.Program_Type__c = 'On Demand';
             if (j.Location_Country__c =='United States')
               j.OTHER_Job_Template_ID__c  = '18G-51';
                   else if (j.Location_Country__c =='Australia')
               j.OTHER_Job_Template_ID__c  = '18G-OPMCSSAUS';
                   else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                j.OTHER_Job_Template_ID__c  = '18G-OPMCSSFR';    
                  else 
                       j.OTHER_Job_Template_ID__c  = '18G-OPMCSSCA';    
        }
        // Truck Team Member - PO
        else if (j.Job_Title_for_Banner__c == 'Truck Team Member' && j.Mindfield_Service__c== 'Posting Only') {
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.sla_level__c = 'Job Posting Only';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'On Demand';
            if (j.Location_Country__c =='United States')
                j.OTHER_Job_Template_ID__c  = '18G-52';
           else if (j.Location_Country__c =='Australia')
                j.OTHER_Job_Template_ID__c  = '18G-TTMPOAUS';
            else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                j.OTHER_Job_Template_ID__c  = '18G-TTMPOFR';    
           else 
                j.OTHER_Job_Template_ID__c  = '18G-TTMPOCA';    
        }
        // Operations Manager - PO
       else if (j.Job_Title_for_Banner__c == 'Operations Manager' && j.Mindfield_Service__c== 'Posting Only') {
           j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
           j.sla_level__c = 'Job Posting Only';
           j.Role_Type__c = 'Management';
           j.Program_Type__c = 'On Demand';
             if (j.Location_Country__c =='United States')
               j.OTHER_Job_Template_ID__c  = '18G-OPMPOUS';
                   else if (j.Location_Country__c =='Australia')
               j.OTHER_Job_Template_ID__c  = '18G-OPMPOAUS';
                   else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                j.OTHER_Job_Template_ID__c  = '18G-OPMPOFR';    
                  else 
                       j.OTHER_Job_Template_ID__c  = '18G-OPMPOCA';    
        }
        
        /*********************** Posting Only
        else if (j.Mindfield_Service__c== 'Posting Only') {
                j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
                j.sla_level__c = 'Job Posting Only';
                j.Role_Type__c = 'FrontLine';
                j.Program_Type__c = 'On Demand';
                if (j.Location_Country__c =='Canada')
                j.OTHER_Job_Template_ID__c  = '18G-POCSSCA';
                   else if (j.Location_Country__c =='United States')
               j.OTHER_Job_Template_ID__c  = '18G-POCSSUSA';
               
        }
        ***********************/
        
        /*****************OLD JOB TITLES End***************/
        
        
        /*****************New JOB TITLES START***************/
        
        //Service Member Roll
        else if (j.Job_Title_for_Banner__c == 'Service Member')
        {
        
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-1';
                    }
                    else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-13';
                    }
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-25';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-37';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-5';
                    }
                    else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-17';
                    }
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-29';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-41';
                    }
                }
                
                
        
        }
        
        
        //Super heroes roll
        else if (j.Job_Title_for_Banner__c == 'Route Team Member (Superheroes Wanted) $15-$20')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Route Team Member (Superheroes Wanted)';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-2';
                    }
                    
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-26';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-38';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-6';
                    }
                    
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-30';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-42';
                    }
                }
                
                
        
        }
        
        else if (j.Job_Title_for_Banner__c == 'Route Team Member (Superheroes Wanted) $13-$18')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Route Team Member (Superheroes Wanted)';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-62';
                    }
                    
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-63';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-67';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-60';
                    }
                    
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-65';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-69';
                    }
                }
                
                
        
        }
        
        //Route Team Member (Want More Work Happy) roll
        else if (j.Job_Title_for_Banner__c == 'Route Team Member (Want More Work Happy) $15-$20')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Route Team Member (Want More Work Happy)';
        
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-3';
                    }
                    
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-27';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-39';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-7';
                    }
                   
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-31';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-43';
                    }
                }
                
                else if (j.Mindfield_Service__c == 'Full-cycle Recruitment')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-11';
                    }
                    else if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-23';
                    }
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-35';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-47';
                    }
                }
        
        }
        
        //Route Team Member (Want More Work Happy) roll
        else if (j.Job_Title_for_Banner__c == 'Route Team Member (Want More Work Happy) $13-$18')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Route Team Member (Want More Work Happy)';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-61';
                    }
                   
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-64';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-68';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'English')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-74';
                    }
                   
                    else if (j.Location_Country__c =='United States')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-66';
                    }
                    else if (j.Location_Country__c =='Australia')
                    {
                        j.OTHER_Job_Template_ID__c  = '18G-70';
                    }
                }
                
                
        
        }
        
        
        
        //Route Team Member (Want More Work Happy) roll
        else if (j.Job_Title_for_Banner__c == 'Équipier de trajet (Exigez plus. Soyez heureux.) - 13$-18$')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Le bonheur, c’est de travailler avec nous!';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-15';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-73';
                    }                
                               
                }
        }
        
        //Route Team Member (Want More Work Happy) roll
        else if (j.Job_Title_for_Banner__c == 'Équipier de trajet (Exigez plus. Soyez heureux.) - 15$-20$')
        {
        j.Career_Site_Alternate_Job_Title__c = 'Le bonheur, c’est de travailler avec nous!';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-72';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-19';
                    }                
                               
                }
        }
        
        //Super-héros demandés - 13$-18$ roll
        else if (j.Job_Title_for_Banner__c == 'Super-héros demandés - 13$-18$')
        {
        j.Career_Site_Alternate_Job_Title__c = 'À la recherche de superhéros!';
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-71';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-72';
                    }                
                               
                }
        }
        
        //Super-héros demandés - 13$-18$ roll
        else if (j.Job_Title_for_Banner__c == 'Super-héros demandés - 15$-20$')
        {
        j.Career_Site_Alternate_Job_Title__c = 'À la recherche de superhéros!';
        
            
            j.Role_Type__c = 'FrontLine';
                if (j.Mindfield_Service__c == 'Posting Only')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-14';
                    }
                }
                                
                
                else if (j.Mindfield_Service__c == 'Candidate Sourcing')
                {
                j.sla_level__c = 'Job Posting Only';
                j.MindField_Job_Type__c = 'TalentReach';
                j.Program_Type__c = 'On Demand';
                    if (j.Location_Country__c =='Canada' && j.Job_Owner_Language_Profile__c == 'French')
                    {
                         j.OTHER_Job_Template_ID__c  = '18G-18';
                    }                
                               
                }
        }
        
       
        
        
        /*****************NEw JOB TITLES END***************/
        
        // set Career Site Alt Job Title
        // Formula: PT/FT + Display Job Name + '1-800-Got-Junk?' (store location)
        
        // if posting only, don't include PT/FT
        if (j.Job_Title_for_Banner__c == 'Service Member') {
            if (j.Job_Owner_Language_Profile__c == 'French') 
            {
                j.Career_Site_Alternate_Job_Title__c = 'Militaires';
            }
            else
            {
                j.career_site_alternate_Job_Title__c =  'Service Member';
            }
            
           }
           else if (j.Job_Title_for_Banner__c == 'Super Heroes Wanted') {
            if (j.Job_Owner_Language_Profile__c == 'French') 
            {
                j.Career_Site_Alternate_Job_Title__c = 'À la recherche de superhéros!';
            }
            else
            {
                j.career_site_alternate_Job_Title__c =  'Super Heroes Wanted';
            }
            
           }
           else if (j.Job_Title_for_Banner__c == 'Route Team Member (Want More Work Happy)') {
            if (j.Job_Owner_Language_Profile__c == 'French') 
            {
                j.Career_Site_Alternate_Job_Title__c = 'Le bonheur, c’est de travailler avec nous!';
            }
            else
            {
                j.career_site_alternate_Job_Title__c =  'Route Team Member (Want More Work Happy)';
            }
            
           }
           else if (j.Job_Title_for_Banner__c == 'Best Job Ever') {
            if (j.Job_Owner_Language_Profile__c == 'French') 
            {
                j.Career_Site_Alternate_Job_Title__c = 'Vous aimez travailler dehors?';
            }
            else
            {
                j.career_site_alternate_Job_Title__c =  'Best Job Ever';
            }
            
           }
        else if (j.Job_Title_for_Banner__c == 'Operations Manager') {
             if (j.Job_Owner_Language_Profile__c == 'French') 
             j.Career_Site_Alternate_Job_Title__c = 'Directeur des Opérations - Membre d\'équipe';
             else
            j.Career_Site_Alternate_Job_Title__c = 'Customer Crew Operations Manager';
           }
        else if (j.Job_Title_for_Banner__c == 'Truck Team member') {
            if (j.Job_Owner_Language_Profile__c == 'French')
             j.Career_Site_Alternate_Job_Title__c = 'Équipier Sur la Route - Membre d\'équipe';
             else
            j.Career_Site_Alternate_Job_Title__c = 'Customer Crew Truck Team Member';
        }
        // then add Location between () if set
        
        j.Career_Site_Alternate_Job_Title__c += (j.Location_Store_Name__c == null ? '' : ' - ' + j.Location_Store_Name__c  );       
    }
}