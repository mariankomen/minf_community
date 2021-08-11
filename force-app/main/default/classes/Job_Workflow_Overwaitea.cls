/****************************
Class: Job_Workflow 
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the associated test class to ensure coverage is sufficient.  Also note that the order of your tests is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_Workflow_Main class, which is called from Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, May 14/14
Modification Log:
    June 16/14: added override for Num Days Delivery = 5 for certain job titles
    Jan 25/16: Added Save On Foods - MB and Save On Foods - sk - Nick
    
****************************/
public class Job_Workflow_Overwaitea {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details and sla/credits
        j.Credits_Used_for_Job__c  = (j.Credits_Used_for_Job__c == null ? 1 : j.Credits_Used_for_Job__c );
        j.SLA_Level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
        j.HM_Portal_Address_URL__c = 'ofgmanagers.ca';
        j.HM_Portal_Address_URL_Shortened__c = 'www.ofgmanagers.ca';
        j.HM_Portal_Phone_Number__c = '1-866-631-1566';  
        // LPO jobs have job type/classification global values overridden
        j.MindField_Job_Type__c = (j.MindField_Job_Type__c == null ? 'TalentRecruit - Front Line' : j.MindField_Job_Type__c);
        j.Role_Type__c = 'FrontLine';
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Full-Cycle Recruitment';
        
        
        // June 2017 - New Banner - Save on Foods - YK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save on Foods - YK') {
        
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Role_Type__c = 'FrontLine';
            j.Job_Code_OWF__c = 'X0123';
            j.Credits_Used_for_Job__c = 1;
            j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
            j.Num_of_Days_for_Delivery_Agreement__c = 5;
            j.wage_details__c = 'Start rate: $12/hr';
            j.SLA_Level__c = 'Front Line';
           
            
           
            if (j.OWF_Department__c == '42 [Allocation]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk';
                j.OFG_Job_Template_Description__c = 'SCAllocation';
            }
            if (j.OWF_Department__c == '01 [Grocery]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SCGrocery';
            }
            if (j.OWF_Department__c == '03 [Produce]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'SCProduce';
            }
            if (j.OWF_Department__c == '04 [Bakery]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'SCBakery';
            }
            if (j.OWF_Department__c == '02 [Meat Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'SCMeat';
            }
            if (j.OWF_Department__c == '06 [Bulk]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bulk Clerk';
                j.OFG_Job_Template_Description__c = 'SCBulk';
            }
            if (j.OWF_Department__c == '09 [Front End Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Front End Clerk';
                j.OFG_Job_Template_Description__c = 'SCCashier';
            }
            if (j.OWF_Department__c == '19 [Deli]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'SCDeli';
            }
            if (j.OWF_Department__c == '26 [Fish/Seafood]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'SCSeafood';
            }
            if (j.OWF_Department__c == '28 [Dairy]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Dairy Clerk';
                j.OFG_Job_Template_Description__c = 'SCDairy';
            }
            if (j.OWF_Department__c == '29 [Frozen]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Frozen Clerk';
                j.OFG_Job_Template_Description__c = 'SCFrozen';
            }
            if (j.OWF_Department__c == '91 [Shipper/Receiver]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver Clerk';
                j.OFG_Job_Template_Description__c = 'SCShipper';
            }
            if (j.OWF_Department__c == '93 [Price Change]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'SCPriceChange';
            }
            
            if (j.OWF_Department__c == '30 [Starbucks Barista]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Clerk';
                j.OFG_Job_Template_Description__c = 'Starbucks';
            }
            if (j.OWF_Department__c == '65 [E-Commerce]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)' ) {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'eCommerce Clerk';
                j.OFG_Job_Template_Description__c = 'SCPersonalShop';
            }
        }
        // END June 2017 - New Banner - Save on Foods - YK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
                        
        // OFG - CF - Allocation Crew (not OFG145)
        if ( j.OWF_Banner_of_Store__c == 'Cooper\'s Foods' && j.OWF_Job_Title__c == 'BC Allocation Crew (Z0123)' && j.Job_Owner_Alias__c != 'OFG145') {
            j.wage_details__c = 'Hourly Wage is $10.75/hour to start. No room for negotiation.';

        }
        // OFG - CF - Department Clerks with alt job title for Cash Up Clerk
        else if ( j.OWF_Banner_of_Store__c == 'Cooper\'s Foods' &&
                  (j.OWF_Job_Title__c == 'Computer Clerk (O0071)' || j.owf_job_title__c == 'Bakery Clerk (O0073)' || j.owf_job_title__c == 'Deli Clerk (O0029)' || 
                   j.owf_job_title__c == 'Floral Clerk (O0050)' || j.owf_job_title__c == 'Produce Clerk (O0072)' || j.owf_job_title__c == 'Grocery Clerk (O0034)' || 
                   j.owf_job_title__c == 'Cashier (O0035)' || j.owf_job_title__c == 'Lotto Clerk (O0074)' || j.OWF_Job_Title__c == 'Cash Up Clerk (O0070)' ) ) {
            j.wage_details__c = 'Hourly Wage is $10.75/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 520 hours of work experience';
            // special rule for Cash Up Clerk to have its own alt job title
            if (j.OWF_Job_Title__c == 'Cash Up Clerk (O0070)')
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cash & Payroll Office Clerk';

        }
        //OFG - AB Thickwood Service Clerk
        else if (j.OWF_Job_Title__c == 'Service Clerk (S0012)' ){
            j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager.'; 
        }
        // for store OFG24 we use $10.25
         //Change to logic order done at Sept 11 @ 10 AM
        else if  (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG24'))  {
            j.wage_details__c = 'Hourly Wage is $10.25/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager.'; 
        } 
        // OFG - CF - Meat Cutter
        else if ( j.OWF_Banner_of_Store__c == 'Cooper\'s Foods' && j.OWF_Job_Title__c == 'Meat Clerk (O0028)' ) {
            j.wage_details__c = 'Hourly Wage is $10.75/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 520 hours of work experience is $10.30/hour.';

        }
        // OFG - CF - Service Clerks
        else if (  j.OWF_Banner_of_Store__c == 'Cooper\'s Foods' && j.OWF_Job_Title__c == 'Service Clerk (O0039)') {
            j.wage_details__c = 'Hourly Wage is $10.75/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 520 hours of work experience is $10.30/hour.';

        }

        // OFG - PSF - Allocation Crew
        else if ( j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && j.OWF_Job_Title__c == 'BC Allocation Crew (SOFBC - Z0123)' ) {
            j.OFG_Job_Template_Description__c = 'Allocation';
            j.wage_details__c = 'Hourly Wage is $10.50/hour to start. No room for negotiation.';

        }
        
        
        
        
        
        // OFG - PSF - Food Clerk
        else if ( j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && j.OWF_Job_Title__c == 'Food Clerk (J0002)') {
            // for store OFG2220
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG2220'))
                j.wage_details__c = 'Hourly Wage is $11.90/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is TBD';
            else{
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $10.55/hour.';
                j.OFG_Job_Template_Description__c='Cust Serv';
                }
        }
        // OFG - PSF - Pharmacy Technician
        else if ( j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && j.OWF_Job_Title__c == 'Pharmacy Technician (A0045)' ) {
            j.wage_details__c = 'Hourly Wage is $12.25/hour to start. No room for negotiation. Next Wage Increase after 500 hours of work experience.';
        }
        // OFG - PSF - Cook
        else if ( j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && j.OWF_Job_Title__c == 'Cook PSF (J0010)' ) {
            j.wage_details__c = 'Hourly Wage is $14.00/hour to start. No room for negotiation. Next Wage Increase after 500 hours of work experience.';
            j.OFG_Job_Template_Description__c = 'Restaurant';
        }
        else if ( j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && j.OWF_Job_Title__c == 'Food Clerk - Ethnic (J0005)' ) {
            j.OFG_Job_Template_Description__c='Ethnic';
        }

        // OFG - SOFBC/OWT for various roles
        else if ( j.OWF_Banner_of_Store__c == 'Overwaitea Foods' || j.OWF_Banner_of_Store__c == 'Save On Foods - BC' ) {
        
           
        
            // OFG - SOFBC/OWT - Allocation Crew
            if ( j.OWF_Job_Title__c == 'BC Allocation Crew (OF - Z0123)' || j.OWF_Job_Title__c == 'BC Allocation Crew (SOFBC - Z0123)' ) 
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. No room for negotiation.';
            // OFG - SOFBC/OWT - Clerk Cashier - SOFBC title ONLY
            else if ( j.OWF_Job_Title__c == 'Clerk Cashier (SOFBC - A0035)') 
                j.wage_details__c = 'Hourly Wage is $11.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 520 hours of work experience is $10.30/hour.';
            // OFG - SOFBC/OWT - Container Mgmt Clerks
            else if ( j.OWF_Job_Title__c == 'Container Management Clerk (OF - H0023)' || j.OWF_Job_Title__c == 'Container Management Clerk (SOFBC - H0023)' ) 
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 520 hours of work experience is $10.30/hour.';
            // OFG - SOFBC/OWT - Junior Clerks ** moved General Clerk (OF A0034) and SOFBC A0034 down on their own so we can also test for Health department and set alt job title
            else if ( j.OWF_Job_Title__c == 'Floral Clerk (SOFBC - A0050)' || j.OWF_Job_Title__c == 'Floral Clerk (OF - A0050)' || 
                      j.OWF_Job_Title__c == 'Natural Foods Clerk (SOFBC - A0053)'  || j.OWF_Job_Title__c == 'Natural Foods Clerk (OF - A0053)' ||
                      j.OWF_Job_Title__c == 'Book Store Clerk (SOFBC - A0040)' || j.OWF_Job_Title__c == 'Book Store Clerk (OF - A0040)') 
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 520 hours of work experience is $10.30/hour.'; 
            // OFG - SOFBC/OWT - Meat Clerks 1518
            else if ( j.OWF_Job_Title__c == 'Meat Clerk - #1518 (SOFBC - A0028)' || j.OWF_Job_Title__c == 'Meat Clerk - #1518 (OF - A0028)' ) 
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';


            // OFG - SOFBC/OWT - Meat Clerks 247
            else if ( j.OWF_Job_Title__c == 'Junior Deli Clerk - #247 (SOFBC - B0197)' || j.OWF_Job_Title__c == 'Junior Meat Clerk - #247 (SOFBC - B0196)' || j.OWF_Job_Title__c == 'Junior Deli Clerk - #247 (OF - B0197)' || 

j.OWF_Job_Title__c == 'Junior Meat Clerk - #247 (OF - B0196)') 
                j.wage_details__c = 'Hourly Wage is $10.25/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
    
    
            
            
            // OFG - SOFBC/OWT - Service Clerks
            else if (j.OWF_Job_Title__c == 'Service Clerk (OF - A0139)' || j.OWF_Job_Title__c == 'Service Clerk (SOFBC - A0139)' ) 
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 520 hours of work experience is $10.30/hour.';
            // OFG - SOFBC/OWT - Pharmacy Technician Clerks - SOFBC title ONLY
            // ** also not valid for store OFG972
            else if ( j.Job_Owner_Alias__c != 'OFG972' && j.OWF_Job_Title__c == 'Pharmacy Technician (SOFBC - A0045)' ) 
                j.wage_details__c = 'Hourly Wage is $13.25/hour to start. No room for negotiation. Next Wage Increase after 520 hours of work experience.';
            // OFG SOFBC - Special Roles - Beauty Counter
            else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - BC' && j.OWF_Job_Title__c == 'Beauty Advisor (SOFBC - A0048)' &&j.OWF_Department__c == '39 [Cosmetics]') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Beauty Counter Clerk';
                //j.wage_details__c = '';
            }
            // OFG - SOFBC/OWT - Special Role General Clerk with alt job title if in Health dept
            else if ( j.OWF_Job_Title__c == 'General Clerk (OF - A0034)' || j.OWF_Job_Title__c == 'General Clerk (SOFBC - A0034)') {
                j.wage_details__c = 'Hourly Wage is $11.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 520 hours of work experience is $10.85/hour.'; 
                // if Health Dept, set Alt Job Title as well
                if ( j.OWF_Department__c == '18 [Health]' )
                    j.Career_Site_Alternate_Job_Title_OFG__c = 'Health Clerk';
            }

            
            // end this section with overwriting the wage details if this was store 21 - we want to keep any of the other alt job title settings etc if they were applied
            // OFG #21 Special Wages All roles
            if (j.Job_Owner_Alias__c == 'OFG21' ) {
                j.wage_details__c = 'Hourly Wage is $10.50/hour to start for ALL ROLES. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience.';
            }
        } // end SOFBC/OWT not store 21


        // OFG - SOFAB - Allocation Crew
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Alberta Allocation Crew (W0456)') {
            j.wage_details__c = 'Hourly Wage is $10.00/hour to start. No room for negotiation.';
        }
        
       

        // OFG - SOFAB - Courtesty Specialist 
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Courtesy Specialist (C0555)' ) {
            // for store OFG6628
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 for mac
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6607'))
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6604, OFG6606 or OFG6632 calgary
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6604') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6632')))
                j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
            // for other stores
            else
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $9.90/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }
        // OFG - SOFAB - Department Specialist
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Department Specialist (C0550)' ) {
            // if Department is 18 [Health] then assign Alt Job Title
            if (j.OWF_Department__c == '18 [Health]')
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Health Clerk';
            else if(j.OWF_Department__c == '26 [Fish/Seafood]' )
                j.OFG_Job_Template_Description__c = 'Seafood';
                

            // now set Wages based on store:                            
            // for store OFG6628 Grand Prairie
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 Fort Mac
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6607') ||j.Job_Owner_Alias__c.contains('OFG6616') || j.Job_Owner_Alias__c.contains('OFG6617')))
                j.wage_details__c = 'Hourly Wage is $13.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6604, OFG6606 or OFG6632
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6604') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6632')))
                j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
            // for other stores
            // for store OFG6614 Calgary
            //else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6632') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6604')))
            //    j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
            //        'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
            //        '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6635 Canmore
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6635'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            else
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 500 hours of work experience is $10.20/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }
        // OFG - SOFAB - Customer Service Specialist
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Customer Service Specialist (C0545)') {
            // if Department is 18 [Health] then assign Alt Job Title
            if (j.OWF_Department__c == '18 [Health]')
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Health Clerk';
                
            // now set Wages based on store:
            // for store OFG6628 Grand Prairie
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.35/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 Fort Mac
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6607') ||j.Job_Owner_Alias__c.contains('OFG6616') || j.Job_Owner_Alias__c.contains('OFG6617')))
                j.wage_details__c = 'Hourly Wage is $13.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6604, OFG6606 or OFG6632
            //else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6604') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6632')))
            //    j.wage_details__c = 'Hourly Wage is $11.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
            // for store OFG6614 Calgary
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6632') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6604')))
                j.wage_details__c = 'Hourly Wage is $11.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $11.60/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6635 Canmore
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6635'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+ 'Next Wage Increase after 500 hours of work experience is $12.35/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';        
            // for other stores
            else
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $11.20/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }
        // OFG - SOFAB - Pharmacy Technician
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Pharmacy Technician (A0045)' ) {
            j.wage_details__c = 'Hourly Wage is $13.25/hour to start. No room for negotiation except in Fort McMurray where they may go up to $19.30/hour. '+
                'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }

        // OFG - SOFAB - Senior Specialist
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Senior Specialist (C0540)' ) {
            // for store OFG6628 Grand Prairie
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 For Mac
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6607') || j.Job_Owner_Alias__c.contains('OFG6616') || j.Job_Owner_Alias__c.contains('OFG6617')))
                j.wage_details__c = 'Hourly Wage is $14.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6604, OFG6606 or OFG6632
            //else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6604') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6632')))
            //    j.wage_details__c = 'Hourly Wage is $11.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
            // for other stores
            // for store OFG6614 Calgary
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6632') || j.Job_Owner_Alias__c.contains('OFG6606') ))
                j.wage_details__c = 'Hourly Wage is $13.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $13.30/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6635 Canmore
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6635'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            else
                j.wage_details__c = 'Hourly Wage is $13.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $13.00/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }

        // OFG - SOFAB - Specialty Department Specialist 
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Specialty Department Specialist (C0535)' ) {
            // for store OFG6628 Grand Prairie
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $12.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 Fort Mac
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6607'))
                j.wage_details__c = 'Hourly Wage is $13.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6614 Calgary
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6614'))
                    j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6635 Canmore
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6635'))
                    j.wage_details__c = 'Hourly Wage is $13.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            else
                j.wage_details__c = 'Hourly Wage is $11.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $10.50/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }

        // OFG - UF - Allocation Crew
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'BC Allocation Crew (Z0123)') {
            j.wage_details__c = 'Hourly Wage is $10.50/hour to start. No room for negotiation.';
        }
        /** OFG - UF - Cook 1
        else if ( (j.OWF_Banner_of_Store__c == 'Urban Fare' || j.OWF_Banner_of_Store__c == 'Urban Fare - Mission Park' || j.OWF_Banner_of_Store__c == 'Urban Fare - False Creek') && j.OWF_Job_Title__c == 'Cook 1 (G0255)' ) {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Line Cook';
            j.OFG_Job_Template_Description__c = 'Cook 1';
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }
        // OFG - UF - Cook 2
        else if ( (j.OWF_Banner_of_Store__c == 'Urban Fare' || j.OWF_Banner_of_Store__c == 'Urban Fare - False Creek' || j.OWF_Banner_of_Store__c == 'Urban Fare - Mission Park') && j.OWF_Job_Title__c == 'Cook 2 (G0256)' ) {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Prep Cook';
            j.OFG_Job_Template_Description__c = 'Cook 2';
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }**/
        
        else if ( (j.OWF_Banner_of_Store__c == 'Urban Fare' || j.OWF_Banner_of_Store__c == 'Urban Fare - False Creek' || j.OWF_Banner_of_Store__c == 'Urban Fare - Mission Park') && j.OWF_Job_Title__c == 'Cook (G0256)' ) {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Cook';
            j.OFG_Job_Template_Description__c = 'Cook';
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }

        // OFG - SOFAB - Cook (Calgary Stores Only)
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Cook (C0576)') {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Cook';
            j.OFG_Job_Template_Description__c = 'Cook';
            j.wage_details__c = 'Hourly Wage is $13.60/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }

        // OFG - SOFAB - Food Service Specialist (Calgary Stores Only)
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Food Service Specialist (C0577)') {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
            j.OFG_Job_Template_Description__c = 'Restaurant';
            j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }


        // OFG - SOFAB - Front End Specialist (Calgary Stores Only)
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Front End Specialist (C0575)') {
            //For store ofg6628 Grand Prairie
            if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6628'))
                j.wage_details__c = 'Hourly Wage is $12.05/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $12.20/hr. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6607 Fort Mac
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6607') || j.Job_Owner_Alias__c.contains('OFG6616') || j.Job_Owner_Alias__c.contains('OFG6617')))
                j.wage_details__c = 'Hourly Wage is $13.60/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6614 Calgary
            else if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6632') || j.Job_Owner_Alias__c.contains('OFG6606') || j.Job_Owner_Alias__c.contains('OFG6604')))
                    j.wage_details__c = 'Hourly Wage is $11.40/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            // for store OFG6635 Canmore
            else if (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6635'))
                    j.wage_details__c = 'Hourly Wage is $12.05/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
            else
                j.wage_details__c = 'Hourly Wage is $11.20/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                    'Next Wage Increase after 500 hours of work experience is $10.50/hour. ADDITIONAL BONUSES REGARDLESS OF LOCATION - (1)Employees working ANYTIME on Sundays receive an additional $1/hour. '+
                    '(2)Employees working ANYTIME between midnight and 7am will receive an additional $1/hour for the hours worked during that midnight to 7am period.';
        }


        // OFG - SOFAB - Specialty Clerk (Calgary Stores Only)
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - AB' && j.OWF_Job_Title__c == 'Speciality Clerk (C0574)') {
            j.wage_details__c = 'Hourly Wage is $13.60/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        }

        // OFG - UF - Food Services Clerk
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Food Services Clerk (G0253)' ) {
            j.wage_details__c = 'Hourly Wage is $11.00 - $14.00. Potential Increase for Appropriate Experience - Decided by Store Manager.';
        }
        // OFG - UF - Starbucks
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Cap Bar - Starbucks (G0253)' ) {
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks';                        
            j.wage_details__c = 'Hourly Wage is $10.25/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 500 hours of work experience is $10.30/hour.';
        }
        // OFG - UF - Food Store Clerk 5
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Food Store Clerk 5 (G0248)' ) {
            j.wage_details__c = 'Hourly Wage is $11.00 - $16.00 with opportunity to increase to $19.00.' ;  
            
            //added meat clerk so HD ID can be set
            if(j.OWF_Department__c == '02 [Meat Clerk]') {
                j.OFG_Job_Template_Description__c = 'Meat Clerk';
            }                                                 
        }
        // OFG - UF - Food Store Clerk 5 for False Creek
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare - False Creek' && j.OWF_Job_Title__c == 'Food Store Clerk 5 (G0248)' ) {
            j.wage_details__c = 'Hourly Wage is $11.00 - $16.00 with opportunity to increase to $19.00';                                                     
        }
        // OFG - UF - Guest Services Clerk
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Guest Services Clerk (G0250)'  ) {
            j.wage_details__c = 'Hourly Wage is $10.25/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. '+
                'Next Wage Increase after 500 hours of work experience is $10.30/hour.';
        }
        // OFG - UF - Head Chef
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Head Chef - Non-Union (Z0258)' ) {
            j.OFG_Job_Template_Description__c = 'Manual';
        }
        // OFG - UF - Sous Chef 7614 - needed since each store has their own unique job description for this role
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)' && j.Job_Owner_Alias__c.contains('OFG7614')) {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'SousChef7614';
        }
        // OFG - UF - Sous Chef 7615 - needed since each store has their own unique job description for this role
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)' && j.Job_Owner_Alias__c.contains('OFG7615')) {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'SousChef7615';
        }

        // OFG - UF - Sous Chef 7618 - needed since each store has their own unique job description for this role
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)' && j.Job_Owner_Alias__c.contains('OFG7618')) {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'SousChef7618';
        }

        // OFG - UF - Sous Chef 7623 - needed since each store has their own unique job description for this role
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare - False Creek' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)') {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'SousChef7623';
        }

        // OFG - UF - Sous Chef 7638 - needed since each store has their own unique job description for this role
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare - Mission Park' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)') {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'SousChef7638';
        }
        // OFG - UF - Sous Chef - in case none of the above match
        else if ( j.OWF_Banner_of_Store__c == 'Urban Fare' && j.OWF_Job_Title__c == 'Sous Chef - Non-Union (Z0259)') {
            j.wage_details__c = 'Hourly Wage is $12.10 - $16.50. Role is non-union so no promised increases thereafter.';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'sous chef';
            j.OFG_Job_Template_Description__c = 'Manual';
        }
        // OFG Special Roles - LPA
        else if ( j.OWF_Banner_of_Store__c == 'Head Office' && (j.OWF_Job_Title__c == 'Loss Prevention Assessor (Z0218)' ) && j.OWF_Department__c == '90 [Loss Prevention]') {
            j.SLA_Level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Assessor';
            j.OFG_Job_Template_Description__c = 'LPA';
            j.Num_of_Candidates_for_Delivery_Agreement__c = NULL;
            j.Num_of_Days_for_Delivery_Agreement__c = NULL;
            // override job type/classification for LPO jobs
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.wage_details__c = 'Hourly Wage is $10.59/hour to start. Everyone starts at the same rate - no room for negotiation. Next Wage Increase after 3 month review with a max of $13.28';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        // OFG Special Roles - LPAAB
        else if ( j.OWF_Banner_of_Store__c == 'Head Office' && (j.OWF_Job_Title__c == 'AB Greeter (W0218)' ) && j.OWF_Department__c == '90 [Loss Prevention]') {
            j.SLA_Level__c = (j.SLA_Level__c == null ? 'Front Line' : j.SLA_Level__c );
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Greeter';
            j.OFG_Job_Template_Description__c = 'LPAAB';
            j.Num_of_Candidates_for_Delivery_Agreement__c = NULL;
            j.Num_of_Days_for_Delivery_Agreement__c = NULL;
            // override job type/classification for LPO jobs
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.wage_details__c = 'Hourly Wage is $10.59/hour to start. Everyone starts at the same rate - no room for negotiation. Next Wage Increase after 3 month review with a max of $13.28';
            j.Career_Site_Alternate_Job_Title__c = j.ft_or_pt__c + ' Greeter' + ' - Overwaitea Food Group (' + j.Job_City__c + ')';
            j.SLA_Level__c = 'Job Posting Only';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        // OFG Special Roles - LPO
        else if ( j.OWF_Banner_of_Store__c == 'Head Office' && (j.OWF_Job_Title__c == 'Loss Prevention Officer (Z0217)' ) && j.OWF_Department__c == '90 [Loss Prevention]') {
            j.SLA_Level__c = 'Job Posting Only';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
            j.OFG_Job_Template_Description__c = 'LPO';
            j.Num_of_Candidates_for_Delivery_Agreement__c = NULL;
            j.Num_of_Days_for_Delivery_Agreement__c = NULL;
            // override job type/classification for LPO jobs
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.wage_details__c = 'Hourly Wage is $17.68/hour to start. Everyone starts at the same rate - no room for negotiation. Next Wage Increase after 3 month review.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }
        // OFG Special Roles - LPOAB
        else if ( j.OWF_Banner_of_Store__c == 'Head Office' && (j.OWF_Job_Title__c == 'AB-Loss Prevention Personnel (W0217)' ) && j.OWF_Department__c == '90 [Loss Prevention]') {
            j.SLA_Level__c = 'Job Posting Only';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Personal';
            j.OFG_Job_Template_Description__c = 'LPOAB';
            j.Num_of_Candidates_for_Delivery_Agreement__c = NULL;
            j.Num_of_Days_for_Delivery_Agreement__c = NULL;
            // override job type/classification for LPO jobs
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.wage_details__c = 'Hourly Wage is $17.68/hour to start. Everyone starts at the same rate - no room for negotiation. Next Wage Increase after 3 month review.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';          
        }
        // OFG Special Roles - Uniformed LPO
        else if ( j.OWF_Banner_of_Store__c == 'Head Office' && j.OWF_Job_Title__c == 'Uniformed Loss Prevention Officer (Z0217)' && j.OWF_Department__c == '90 [Loss Prevention]') {
            j.SLA_Level__c = 'Job Posting Only';
            j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
            j.OFG_Job_Template_Description__c = 'LPOUNI';
            j.Num_of_Candidates_for_Delivery_Agreement__c = NULL;
            j.Num_of_Days_for_Delivery_Agreement__c = NULL;
            // override job type/classification for LPO jobs
            j.MindField_Job_Type__c = 'TalentConnect - Promote Post';
            j.wage_details__c = 'Hourly Wage is $17.68/hour to start. Everyone starts at the same rate - no room for negotiation. Next Wage Increase after 3 month review.';
            j.Role_Type__c = 'FrontLine';
            j.Program_Type__c = 'Subscription';         
            j.mindfield_service__c = 'Candidate Sourcing';
        }

        // ** separate code block to set OFG Job Template Description field for Save on AB only ** //
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - AB' || j.OWF_Banner_of_Store__c == 'Save On Foods AB - Thickwood') {
            if (j.OWF_Department__c == '01 [Grocery]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Job_Title__c == 'Cook (C0576)')
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cook';
            else if (j.OWF_Job_Title__c == 'Food Service Specialist (C0577)'){
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';   
                if (j.OWF_Department__c == '30 [Coffee Bar Clerk]'){
                    j.OFG_Job_Template_Description__c = 'Coffee Bar';
                    j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
            }
            }
            else if (j.OWF_Department__c == '02 [Meat Cutter]')
                j.OFG_Job_Template_Description__c = 'Meat';
            else if (j.OWF_Department__c == '02 [Meat Clerk]')
                j.OFG_Job_Template_Description__c = 'Meat';                                       
            else if (j.OWF_Department__c == '03 [Produce]')
                j.OFG_Job_Template_Description__c = 'Produce';
            else if (j.OWF_Department__c == '04 [Bakery]')
                j.OFG_Job_Template_Description__c = 'Bakery';
            else if (j.OWF_Department__c == '04 [Cake Centre]')
                j.OFG_Job_Template_Description__c = 'Cake Centre';
            else if (j.OWF_Department__c == '06 [Bulk]')
                j.OFG_Job_Template_Description__c = 'Bulk';
            else if (j.OWF_Department__c == '08 [Tobacco]')
                j.OFG_Job_Template_Description__c = 'Cust Serv';
            else if (j.OWF_Department__c == '09 [Front End Specialist]')
                j.OFG_Job_Template_Description__c = 'Cashier';
            else if (j.OWF_Department__c == '09 [Cashier]')
                j.OFG_Job_Template_Description__c = 'Cashier';
            else if (j.OWF_Department__c == '09 [Service Clerk]')
                j.OFG_Job_Template_Description__c = 'Service Clerk';
            else if (j.OWF_Department__c == '11 [Natural Foods]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Department__c == '12 [General Merchandise]')
                j.OFG_Job_Template_Description__c = 'GenMerch';
            else if (j.OWF_Department__c == '13 [Non Foods/Gas Bar]')
                j.OFG_Job_Template_Description__c = 'Gas Bar';
            else if (j.OWF_Department__c == '17 [Pharmacy Assistant]')
                j.OFG_Job_Template_Description__c = 'Pharm Tech';
            else if (j.OWF_Department__c == '17 [Pharmacy Tech]')
                j.OFG_Job_Template_Description__c = 'Pharm Tech';
            else if (j.OWF_Department__c == '18 [Health]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Department__c == '19 [Deli]')
                j.OFG_Job_Template_Description__c = 'Deli';
            else if (j.OWF_Department__c == '25 [Cap Bar]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '26 [Fish/Seafood]')
                j.OFG_Job_Template_Description__c = 'Seafood';
        //Took Restaurant out and code seperately above so that the Cook (C0576) can be coded differently than the Food Service Specialist (C0577)
            else if (j.OWF_Department__c == '28 [Dairy]')
                j.OFG_Job_Template_Description__c = 'Dairy';
            else if (j.OWF_Department__c == '29 [Frozen]')
                j.OFG_Job_Template_Description__c = 'Frozen';
            else if (j.OWF_Department__c == '31 [Floral]')
                j.OFG_Job_Template_Description__c = 'Floral';
            else if (j.OWF_Department__c == '36 [Books]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Department__c == '39 [Cosmetics]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Department__c == '39 [Personal Care]')
                j.OFG_Job_Template_Description__c = 'Grocery';
            else if (j.OWF_Department__c == '42 [Allocation]')
                j.OFG_Job_Template_Description__c = 'Allocation';
            else if (j.OWF_Department__c == '48 [Environment]')
                j.OFG_Job_Template_Description__c = 'Environment';
            else if (j.OWF_Department__c == '50 [Ethnic Cake]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '51 [Ethnic Bread]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '52 [Ethnic Deli]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '53 [Ethnic Meat]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '54 [Ethnic Seafood]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '55 [Ethnic Bakery]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '56 [Ethnic Produce]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '57 [Ethnic Grocery]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '58 [Ethnic BBQ]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '59 [Ethnic Sushi]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '60 [Ethnic Hot Food]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '61 [Ethnic Dim Sum]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '86 [Janitorial]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '90 [Loss Prevention]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '91 [Shipper/Receiver]')
                j.OFG_Job_Template_Description__c = 'Shipper';
            else if (j.OWF_Department__c == '93 [Price Change]')
                j.OFG_Job_Template_Description__c = 'Price Chg';
            else if (j.OWF_Department__c == '95 [Payroll/Office]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '96 [Hostess]')
                j.OFG_Job_Template_Description__c = 'Manual';
            else if (j.OWF_Department__c == '98 [Demo]')
                j.OFG_Job_Template_Description__c = 'Demo Clerk';
            else if (j.OWF_Department__c == '99 [General]')
                j.OFG_Job_Template_Description__c = 'Cust Serv';
            else if (j.OWF_Department__c == ' [Cake Centre]'){
                j.OFG_Job_Template_Description__c = 'SOFAB – Cake Centre';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';}
            else if (j.OWF_Department__c == '30 [Coffee Shop]'){
                j.OFG_Job_Template_Description__c = 'Coffee Shop';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Shop';
            }
            else if(j.OWF_Department__c == '65 [E-Commerce]'){
                j.OFG_Job_Template_Description__c = 'Shopper';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Personal Shopper Specialist';
            }
                
            else
                j.OFG_Job_Template_Description__c = 'Manual';              
        } // end setting OFG for SOF AB Job Template

        // ** separate code block to set OFG Job Template Description field for Save on BC and Overwaitea Foods only - added in January 2014 in CR-89 ** //
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - BC' || j.OWF_Banner_of_Store__c == 'Overwaitea Foods') {
            if (j.OWF_Department__c == '01 [Grocery]') {
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '02 [Meat Cutter]'){
                j.OFG_Job_Template_Description__c = 'Meat';
            }
            else if (j.OWF_Department__c == '02 [Meat Clerk]'){
                j.OFG_Job_Template_Description__c = 'Meat';                                       
            }
            else if (j.OWF_Department__c == '03 [Produce]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '04 [Bakery]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '04 [Cake Centre]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '06 [Bulk]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '08 [Tobacco]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '09 [Cashier]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '09 [Service Clerk]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '11 [Natural Foods]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '12 [General Merchandise]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '13 [Non Foods/Gas Bar]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '17 [Pharmacy Assistant]'){
                j.OFG_Job_Template_Description__c = 'Pharm Tech';
            }
            else if (j.OWF_Department__c == '17 [Pharmacy Tech]'){
                j.OFG_Job_Template_Description__c = 'Pharm Tech';
            }
            else if (j.OWF_Department__c == '18 [Health]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '19 [Deli]'){
                j.OFG_Job_Template_Description__c = 'Deli';
            }
            else if (j.OWF_Department__c == '25 [Cap Bar]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '26 [Fish/Seafood]'){
                j.OFG_Job_Template_Description__c = 'Fresh Foods';
            }
            else if (j.OWF_Department__c == '27 [Restaurant]'){
                j.OFG_Job_Template_Description__c = 'Fresh Foods';
            }
            else if (j.OWF_Department__c == '28 [Dairy]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '29 [Frozen]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '30 [Coffee Shop]'){
                j.OFG_Job_Template_Description__c = 'Coffee Shop';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Shop';
            }
            else if (j.OWF_Department__c == '31 [Floral]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '36 [Books]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '39 [Cosmetics]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '39 [Personal Care]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '42 [Allocation]'){
                j.OFG_Job_Template_Description__c = 'Allocation';
            }
            else if (j.OWF_Department__c == '48 [Environment]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '50 [Ethnic Cake]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '51 [Ethnic Bread]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '52 [Ethnic Deli]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '53 [Ethnic Meat]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '54 [Ethnic Seafood]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '55 [Ethnic Bakery]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '56 [Ethnic Produce]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '57 [Ethnic Grocery]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }       
            else if (j.OWF_Department__c == '58 [Ethnic BBQ]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '59 [Ethnic Sushi]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '60 [Ethnic Hot Food]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '61 [Ethnic Dim Sum]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '86 [Janitorial]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '91 [Shipper/Receiver]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '93 [Price Change]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '95 [Payroll/Office]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '96 [Hostess]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '98 [Demo]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '99 [General]'){
                j.OFG_Job_Template_Description__c = 'Grocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
            }
            else if (j.OWF_Department__c == '65 [E-Commerce]'){
                j.OFG_Job_Template_Description__c = 'Shopper';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Personal Shopper';
            }
            else
                j.OFG_Job_Template_Description__c = 'Manual';              
        } // end setting OFG for SOF AB Job Template
        
          if (j.OWF_Banner_of_Store__c == 'Overwaitea Foods - Grand Forks') {
            if (j.OWF_Department__c == '19 [Deli]') {
                j.OFG_Job_Template_Description__c = 'Deli';
            }
          
          }

        // ** separate code block to set Number Candidates/Days for Delivery Agreement ** //
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - AB' || j.OWF_Banner_of_Store__c == 'Save On Foods AB - Thickwood' || (j.OWF_Banner_of_Store__c != null && j.OWF_Banner_of_Store__c.contains('Overwaitea')) ) {
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 5 : j.Num_of_Days_for_Delivery_Agreement__c);
        }   
        else if (j.OWF_Banner_of_Store__c != 'Head Office') {
            j.Num_of_Candidates_for_Delivery_Agreement__c = (j.Num_of_Candidates_for_Delivery_Agreement__c == null ? 2 : j.Num_of_Candidates_for_Delivery_Agreement__c);
            j.Num_of_Days_for_Delivery_Agreement__c = (j.Num_of_Days_for_Delivery_Agreement__c == null ? 3 : j.Num_of_Days_for_Delivery_Agreement__c);
        } // end if anything other than Head Office 
        // override the Num Days Delivery for these jobs titles
        set<string> JobTitles_5DaysDelivery = new set<string>{'Cook 1 (G0255)', 'Cook 2 (G0256)', 'Sous Chef – Non-Union (Z0259)', 'Cook 1 (O0255)', 'Cook 2 (O0256)'};
        if (j.OWF_Job_Title__c != null && JobTitles_5DaysDelivery.contains(j.OWF_Job_Title__c))
            j.Num_of_Days_for_Delivery_Agreement__c = 5;

    // OFG - SOFBC - Cook
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - BC' && j.OWF_Job_Title__c == 'Cook (A0076)' ) {
            j.OFG_Job_Template_Description__c = 'Cook'; 
        j.wage_details__c = 'Hourly Wage is $14.15/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';
        j.Career_Site_Alternate_Job_Title_OFG__c = 'Cook';
        }

        // OFG - SOFBC - Restaurant
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - BC' && j.OWF_Job_Title__c == 'Restaurant Clerk (A0077)' ) {
            j.OFG_Job_Template_Description__c = 'Restaurant'; 
            j.wage_details__c = 'Hourly Wage is $11.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';  
        }
        
        else if ( j.OWF_Banner_of_Store__c == 'Save On Foods - BC' && (j.OWF_Job_Title__c == 'Restaurant Clerk (A0077)'||j.OWF_Job_Title__c == 'Coffee Shop Clerk (A0078)'||j.OWF_Job_Title__c == 'Wine Advisor (A0071)'||j.OWF_Job_Title__c == 'Personal Shopper (A0015)'))  {
            //j.OFG_Job_Template_Description__c = 'Restaurant'; 
            j.wage_details__c = 'Hourly Wage is $11.00/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';  
        }
        
        else if ( j.Job_Owner_Alias__c=='OFG21' ) {
            
            j.wage_details__c = 'Hourly Wage is $13.10/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';  
        }
        
        else if ( j.Job_Owner_Alias__c=='OFG2220' ) {
            
            j.wage_details__c = 'Hourly Wage is $11.90/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager. ';  
        }

        // separate code block to override wage details for Safeway stores that use the same wage detail for all jobs at the store
        // for store OFG6616/6635 we use $13.50 - No longer used
        //if (j.Job_Owner_Alias__c != null && (j.Job_Owner_Alias__c.contains('OFG6616') || j.Job_Owner_Alias__c.contains('OFG6635')) ) {
        //    j.wage_details__c = 'Hourly Wage is $13.50/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager.'; 
        //} 
        
        // for store OFG6617 we use $13.55
        else if  (j.Job_Owner_Alias__c != null && j.Job_Owner_Alias__c.contains('OFG6617'))  {
            j.wage_details__c = 'Hourly Wage is $13.55/hour to start. Potential Increase for Appropriate Experience - Decided by Store Manager.'; 
        } 
        
        
        /****************************************************************************************************************************************************
        Fresh start for Save On Foods - MB and Save On Foods - SK
        *****************************************************************************************************************************************************/
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - SK')
        {
        
           
            if (j.OWF_Department__c == '42 [Allocation]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCAllocation';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;

            }
            else if (j.OWF_Department__c == '01 [Grocery]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCGrocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '03 [Produce]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCProduce';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '04 [Bakery]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCBakery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '02 [Meat Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCMeat';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '06 [Bulk]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCBulk';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bulk Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '09 [Cashier]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCCashier';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '11 [Natural Foods]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCNaturalFoods';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Natural Foods Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '12 [General Merchandise]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCGeneralMerch';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'General Merchandise Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '18 [Health]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCHealth';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Pharmacy Stock Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '19 [Deli]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCDeli';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '26 [Fish/Seafood]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCSeafood';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '28 [Dairy]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCDairy';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Dairy Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '29 [Frozen]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCFrozen';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Frozen Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '39 [Personal Care]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPersonal';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'General Merchandise Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '91 [Shipper/Receiver]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCShipper';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '93 [Price Change]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPriceChange';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '04 [Bakery]' && j.OWF_Job_Title__c == 'Speciality Clerk (R0002)' ){
                j.OFG_Job_Template_Description__c = 'Bakery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.Job_Code_OWF__c = 'R0002';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '31 [Floral]' && j.OWF_Job_Title__c == 'Speciality Clerk (R0002)' ){
                j.OFG_Job_Template_Description__c = 'Floral';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Floral Clerk';
                j.Job_Code_OWF__c = 'R0002';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '27 [Restaurant]' && j.OWF_Job_Title__c == 'Speciality Clerk (R0002)' ){
                j.OFG_Job_Template_Description__c = 'Restaurant';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.Job_Code_OWF__c = 'R0002';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '04 [Cake Centre]' && j.OWF_Job_Title__c == 'Speciality Clerk (R0002)' ){
                j.OFG_Job_Template_Description__c = 'Cake';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cake Centre Clerk';
                j.Job_Code_OWF__c = 'R0002';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            
            else if (j.OWF_Department__c == '09 [Cashier]' && j.OWF_Job_Title__c == 'Service Clerk (R0006)' ){
                j.OFG_Job_Template_Description__c = 'Cashier';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.Job_Code_OWF__c = 'R0006';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '27 [Fast Foods/Restaurant]' && j.OWF_Job_Title__c == 'Restaurant Clerk (R0007)' ){
                j.OFG_Job_Template_Description__c = 'RCRestaurant';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.Job_Code_OWF__c = 'R0007';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '30 [Coffee Bar Clerk]' && j.OWF_Job_Title__c == 'Restaurant Clerk (R0007)' ){
                j.OFG_Job_Template_Description__c = 'RCCoffee';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.Job_Code_OWF__c = 'R0007';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '27 [Fast Foods/Restaurant]' && j.OWF_Job_Title__c == 'Cook (R0008)' ){
                j.OFG_Job_Template_Description__c = 'Cook';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.Job_Code_OWF__c = 'R0008';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '65 [E-Commerce]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPersonalShop';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Personal Shopper';
                j.Job_Code_OWF__c = 'R0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
            else if (j.OWF_Department__c == '02 [Meat Cutter]' && j.OWF_Job_Title__c == 'Meat Cutter (R0004)' ){
                j.OFG_Job_Template_Description__c = 'Meat Cutter';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.Job_Code_OWF__c = 'R0004';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
            }
        
            
        }
        //Save on foods MB
        
         if (j.OWF_Banner_of_Store__c == 'Save On Foods - MB')
        {
            
            
            
            if (j.OWF_Department__c == '42 [Allocation]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCAllocation';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';

            }
            //Oct 24, 2016 - Add new job title 'Meat Cutter (M0011)'
            else if (j.OWF_Department__c == '02 [Meat Cutter]' && j.OWF_Job_Title__c == 'Meat Cutter (M0011)' ){
                j.OFG_Job_Template_Description__c = 'MeatCutter';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.Job_Code_OWF__c = 'M0002';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = 'The start rate is $16-$24, however there is flexibility for candidates that have the correct skill set.';
            }
            else if (j.OWF_Department__c == '01 [Grocery]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCGrocery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '03 [Produce]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCProduce';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '04 [Bakery]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCBakery';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '02 [Meat Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCMeat';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '06 [Bulk]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCBulk';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bulk Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '09 [Cashier]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCCashier';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            
                        
            else if (j.OWF_Department__c == '12 [General Merchandise]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCGeneralMerch';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'General Merchandise Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            
                       
            else if (j.OWF_Department__c == '19 [Deli]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCDeli';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '26 [Fish/Seafood]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCSeafood';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '28 [Dairy]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCDairy';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Dairy Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '29 [Frozen]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCFrozen';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Frozen Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '39 [Personal Care]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPersonal';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'General Merchandise Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            
            else if (j.OWF_Department__c == '91 [Shipper/Receiver]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCShipper';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '93 [Price Change]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPriceChange';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            
            
            else if (j.OWF_Department__c == '09 [Cashier]' && j.OWF_Job_Title__c == 'Service Clerk (M0009)' ){
                j.OFG_Job_Template_Description__c = 'Cashier';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.Job_Code_OWF__c = 'M0009';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$11.50/hr';
            }
            else if (j.OWF_Department__c == '27 [Fast Foods/Restaurant]' && j.OWF_Job_Title__c == 'Restaurant Clerk (M0007)' ){
                j.OFG_Job_Template_Description__c = 'RCRestaurant';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.Job_Code_OWF__c = 'M0007';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '30 [Coffee Bar Clerk]' && j.OWF_Job_Title__c == 'Restaurant Clerk (M0007)' ){
                j.OFG_Job_Template_Description__c = 'RCCoffee';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.Job_Code_OWF__c = 'M0007';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            else if (j.OWF_Department__c == '27 [Fast Foods/Restaurant]' && j.OWF_Job_Title__c == 'Western Cook (M0008)' ){
                j.OFG_Job_Template_Description__c = 'Cook';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.Job_Code_OWF__c = 'M0008';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$13.50/hr';
            }
            else if (j.OWF_Department__c == '65 [E-Commerce]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' ){
                j.OFG_Job_Template_Description__c = 'SCPersonalShop';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Personal Shopper';
                j.Job_Code_OWF__c = 'M0001';
                j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
                j.Num_of_Days_for_Delivery_Agreement__c = 5;
                j.wage_details__c = '$12.00/hr';
            }
            
        
        }
        If (j.Reason_for_resend__c == 'Hiring for a different department' || j.Reason_for_resend__c == 'Time out of Peoplesoft' || j.Reason_for_resend__c == 'Same Store Rehire' || j.Reason_for_resend__c == 'Head Office Approval' || j.Reason_for_resend__c == 'Non Mindfield recruitment hiring')
        {
            j.Credits_Used_for_Job__c = 1;
            j.Num_of_Days_for_Delivery_Agreement__c = 3;
            j.Num_of_Candidates_for_Delivery_Agreement__c = 1;
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
            j.Job_Internal_Status__c = 'Broadcasting Not Needed';
            j.Online_Posting__c = 'Job is for resend';
            j.Job_For_Resend__c = true;
        }
        IF(j.Specific_Candidate_Preference__c == 'Yes - Phone Screen')
        {
            j.Date_Job_Scheduled_for_Automatic_Closure__c = null;
            j.Credits_Used_for_Job__c = 1;
            j.MindField_Job_Type__c = 'TalentRecruit - Front Line';
        }
             
     
     // Enhancement Request: 00128108 ---------------------------------------------------------------------------------------------------------------
     //add this at the end since there is so much code above, this will ensure what we want is set properly
     if (j.OWF_Banner_of_Store__c == 'Save on Foods - YK' && 
         j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (X0123)')
     {
         j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
         j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
         j.Job_Code_OWF__c = 'X0123';
         j.wage_details__c = '';
         j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
         j.Num_of_Days_for_Delivery_Agreement__c = 5;
     }
     
     // Enhancement Request: 00138592---------------------------------------------------------------------------------------------------------------
     //add this at the end since there is so much code above, this will ensure what we want is set properly
     if (j.OWF_Banner_of_Store__c == 'Save on Foods - YK' && 
         j.OWF_Department__c == '27 [Fast Foods/Restaurant]' && j.OWF_Job_Title__c == 'Restaurant Clerk (N0007)')
     {
         j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
         j.OFG_Job_Template_Description__c = 'RestaurantClerk';
         j.Job_Code_OWF__c = 'N0007';
         j.wage_details__c = 'Starting wage: $12.50/hr with $.25/hr raises every 520 hours';
         j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
         j.Num_of_Days_for_Delivery_Agreement__c = 5;
     }
     
     if (j.OWF_Banner_of_Store__c == 'PriceSmart Foods' && 
         j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Food Clerk (J0002)' )
     {
         j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
         j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
         j.Job_Code_OWF__c = 'J0002';
         j.wage_details__c = '';
         j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
         j.Num_of_Days_for_Delivery_Agreement__c = 5;
      }
      
      if ((j.OWF_Banner_of_Store__c == 'Overwaitea Foods' || j.OWF_Banner_of_Store__c == 'Overwaitea Foods - Grand Forks' || j.OWF_Banner_of_Store__c == 'Save On Foods - BC') &&
           j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && 
           (j.OWF_Job_Title__c == 'General Clerk (OF - A0034)' || j.OWF_Job_Title__c == 'General Clerk (SOFBC - A0034)'))
      {
           j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
           j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight General Clerk';
           j.Job_Code_OWF__c = 'A0034';
           j.wage_details__c = '';
           j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
           j.Num_of_Days_for_Delivery_Agreement__c = 5;
      }
      
      if (j.OWF_Banner_of_Store__c == 'Save On Foods AB - Thickwood' &&
           j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Service Clerk (S0012)')
      {
          j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
          j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
          j.Job_Code_OWF__c = 'S0012';
          j.wage_details__c = '';
          j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
          j.Num_of_Days_for_Delivery_Agreement__c = 5;
      }
      
      if (j.OWF_Banner_of_Store__c == 'Save On Foods - AB' &&
           j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Department Specialist (C0550)')
      {
          j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
          j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
          j.Job_Code_OWF__c = 'C0550';
          j.wage_details__c = '';
          j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
          j.Num_of_Days_for_Delivery_Agreement__c = 5;
      }
      
      if (j.OWF_Banner_of_Store__c == 'Save On Foods - MB' &&
          j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (M0001)' )
      {
          j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
          j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
          j.Job_Code_OWF__c = 'M0001';
          j.wage_details__c = '';
          j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
          j.Num_of_Days_for_Delivery_Agreement__c = 5;
      }
      
      if (j.OWF_Banner_of_Store__c == 'Save On Foods - SK' && 
          j.OWF_Department__c == '01 [Overnight Grocery Clerk]' && j.OWF_Job_Title__c == 'Store Clerk (R0001)' )
      {
          j.OFG_Job_Template_Description__c = 'OVERNIGHTCLERK';
          j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
          j.Job_Code_OWF__c = 'R0001';
          j.wage_details__c = '';
          j.Num_of_Candidates_for_Delivery_Agreement__c = 2;
          j.Num_of_Days_for_Delivery_Agreement__c = 5;
       }
        
      // END Enhancement Request: 00128108 ---------------------------------------------------------------------------------------------------------
     
    }

}