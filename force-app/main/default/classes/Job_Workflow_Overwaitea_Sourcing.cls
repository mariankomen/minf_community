/****************************
Class: Job_Workflow 
Purpose: This is the new job workflow class for the OFG sourcing solution.
    
****************************/
public class Job_Workflow_Overwaitea_Sourcing {

     public static void processJob(SFDC_Job__c j) {
        // set global HM Portal details and sla/credits
        j.HM_Portal_Address_URL__c = 'ofgmanagers.ca';
        j.HM_Portal_Address_URL_Shortened__c = 'ofgmanagers.ca';
        j.HM_Portal_Phone_Number__c = '1-866-631-1566';  
        
        j.Credits_Used_for_Job__c  = 1;
        j.SLA_Level__c = 'Job Posting Only';
        j.MindField_Job_Type__c = 'TalentConnect - Post Only';
        j.Role_Type__c = 'Frontline';
        j.Program_Type__c = 'Subscription';         
        j.mindfield_service__c = 'Candidate Sourcing';
        j.Agency_Business_Unit__c = 'Customer Service & Sales'; //default
        
        //just leave as empty
        //j.Num_of_Candidates_for_Delivery_Agreement__c = 0;
        //j.Num_of_Days_for_Delivery_Agreement__c = 0;
        
        //j.Number_Of_Hours_Per_Week__c = '33 to 37.5 hours'; //required for HD sync but not in SF...just set something
        j.Specific_Candidate_Preference__c = 'No'; //required for HD sync but not in SF
        j.Name_of_Person_Submitting_Request__c = 'Not Required'; //pulling this off of sourcing page
        
        //NOTE, Job_Template_ID_for_HireDesk_Integration__c is the field that goes to HD to determine job template 
        //For OFG, this is built from OFG_New_Job_Template_ID__c = 'BannerCode' + OFG_Job_Template_Description__c 
        //EG: SOFAB - Service Clerk
        //Laura coded in the job template ids for sourcing differently so we need to work around.
        //What I did is have Job_Template_ID_for_HireDesk_Integration__c just pull straight OFG_Job_Template_Description__c rather than building. 
        
        // Overwaitea Foods
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Overwaitea Foods') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'OFGCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'OFGCS-6';
            }
           
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'OFGCS-3';
            }
            
             if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'OFGCS-4';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'OFGCS-2';
            }
           
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'OFGCS-5';
            }
        }
        // END Overwaitea Foods
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // PriceSmart Foods
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'PriceSmart Foods') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'PSFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'PSFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'PSFCS-2';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-10';
            }
            
            if(j.OWF_Job_Title__c == 'Fish/Seafood Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-11';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-3';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'PSFCS-15';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-5';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Cutter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.OFG_Job_Template_Description__c = 'PSFCS-6';
            }
            
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-4';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Pharmacy Technician') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Pharmacy Technician';
                j.OFG_Job_Template_Description__c = 'PSFCS-14';
            }
            
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-13';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-7';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'PSFCS-12';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'PSFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'PSFCS-17';
            }
        }
        // END PriceSmart Foods
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // Save On Foods - AB
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - AB') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'SOFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Assistant Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Assistant Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-2';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-3';
            }
            
            if(j.OWF_Job_Title__c == 'Cake Centre Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cake Centre Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-4';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'SOFCS-5';
            }
            
            if(j.OWF_Job_Title__c == 'Coffee Bar Clerk') {
                //ER: 00162270, update alternative job title
                //j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'SOFCS-6';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
           
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'SOFCS-7';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Fish/Seafood Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Floral Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Floral Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-10';
            }
            
            if(j.OWF_Job_Title__c == 'Greeter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Greeter';
                j.OFG_Job_Template_Description__c = 'SOFCS-11';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-12';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-14';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-17';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Cutter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.OFG_Job_Template_Description__c = 'SOFCS-18';
            }
            
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-19';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Personal Shopper') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Order Picker';
                j.OFG_Job_Template_Description__c = 'SOFCS-20';
            }
            
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change';
                j.OFG_Job_Template_Description__c = 'SOFCS-21';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-22';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'SOFCS-23';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Personnel') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-26';
            }
            
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-28';
            }
        }
        // END Save On Foods - AB
        ////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
         // Save On Foods - BC
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - BC') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'SOFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Assistant Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Assistant Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-2';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Coffee Bar Clerk') {
                //ER: 00162270, update alternative job title
                //j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'SOFCS-6';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'SOFCS-7';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-12';
            }
           
            if(j.OWF_Job_Title__c == 'Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-14';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Assessor') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Assessor';
                j.OFG_Job_Template_Description__c = 'SOFCS-15';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-19';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Personal Shopper') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Order Picker';
                j.OFG_Job_Template_Description__c = 'SOFCS-20';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-26';
            }
            
            if(j.OWF_Job_Title__c == 'Wine Advisor') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Wine Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-27';
            }
            
            if(j.OWF_Job_Title__c == 'Wine Advisor') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Wine Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-27';
            }
            
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-28';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
        }
        // END Save On Foods - BC
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // Save On Foods - MB
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - MB') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'SOFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Assistant Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Assistant Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-2';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-3';
            }
            
            if(j.OWF_Job_Title__c == 'Cake Centre Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cake Centre Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-4';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'SOFCS-5';
            }
           
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'SOFCS-7';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Fish/Seafood Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-12';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-14';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-17';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Cutter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.OFG_Job_Template_Description__c = 'SOFCS-18';
            }
            
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-19';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Personal Shopper') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Order Picker';
                j.OFG_Job_Template_Description__c = 'SOFCS-20';
            }
            
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-21';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-22';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'SOFCS-23';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Personnel') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-26';
            }
            
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-28';
            }
            
            //ER: 00162270, add bew job title for MB
            if(j.OWF_Job_Title__c == 'Starbucks Barista') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'SOFCS-6';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
        }
        // END Save On Foods - MB
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // Save On Foods - SK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - SK') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'SOFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Assistant Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Assistant Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-2';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-3';
            }
            
            if(j.OWF_Job_Title__c == 'Cake Centre Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cake Centre Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-4';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'SOFCS-5';
            }
            
            if(j.OWF_Job_Title__c == 'Coffee Bar Clerk') {
                //ER: 00162270, update alternative job title
                //j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'SOFCS-6';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
           
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'SOFCS-7';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Fish/Seafood Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Floral Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Floral Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-10';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-12';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Delivery Driver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Delivery Driver';
                j.OFG_Job_Template_Description__c = 'SOFCS-14';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-17';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Cutter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.OFG_Job_Template_Description__c = 'SOFCS-18';
            }
            
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-19';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Personal Shopper') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Order Picker';
                j.OFG_Job_Template_Description__c = 'SOFCS-20';
            }
            
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-21';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-22';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'SOFCS-23';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Personnel') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-26';
            }
            
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-28';
            }
        }
        // END Save On Foods - SK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //  Save On Foods - YK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Save On Foods - YK') {
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'SOFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-3';
            }
            
            if(j.OWF_Job_Title__c == 'Cake Centre Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cake Centre Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-4';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'SOFCS-5';
            }
            
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'SOFCS-7';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Fish/Seafood Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Fish/Seafood Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-12';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-16';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-17';
            }
                       
            if(j.OWF_Job_Title__c == 'Overnight Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Overnight Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-19';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-21';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-22';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'SOFCS-23';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
             if(j.OWF_Job_Title__c == 'Starbucks Barista') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'SOFCS-24';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Personnel') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'SOFCS-26';
            }
           
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'SOFCS-28';
            }
        }
        // END  Save On Foods - YK
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //  Urban Fare  
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (j.OWF_Banner_of_Store__c == 'Urban Fare') {
        
            if(j.OWF_Job_Title__c == 'Restaurant Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Restaurant Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-19';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
        
            if(j.OWF_Job_Title__c == 'Allocation') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Store Re-line Clerk (Contract)';
                j.OFG_Job_Template_Description__c = 'UFCS-1';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
            if(j.OWF_Job_Title__c == 'Bakery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Bakery Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-9';
            }
            
            if(j.OWF_Job_Title__c == 'Cap Bar') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Coffee Bar Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-3';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Cashier') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Cashier';
                j.OFG_Job_Template_Description__c = 'UFCS-10';
            }
            
            if(j.OWF_Job_Title__c == 'Coffee Shop') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Starbucks Barista';
                j.OFG_Job_Template_Description__c = 'UFCS-4';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Cook') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Helper';
                j.OFG_Job_Template_Description__c = 'UFCS-2';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Deli Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Deli Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-11';
            }
            
            if(j.OWF_Job_Title__c == 'Grocery Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Grocery Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-5';
            }
            
            if(j.OWF_Job_Title__c == 'Guest Services Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Guest Services Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-14';
            }
            
            if(j.OWF_Job_Title__c == 'Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'UFCS-17';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-6';
            }
            
            if(j.OWF_Job_Title__c == 'Meat Cutter') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Meat Cutter';
                j.OFG_Job_Template_Description__c = 'UFCS-7';
            }
            
            if(j.OWF_Job_Title__c == 'Pharmacy Technician') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Pharmacy Technician';
                j.OFG_Job_Template_Description__c = 'UFCS-16';
            }
                       
            if(j.OWF_Job_Title__c == 'Price Change Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Price Change Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-13';
            }
            
            if(j.OWF_Job_Title__c == 'Produce Clerk') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Produce Clerk';
                j.OFG_Job_Template_Description__c = 'UFCS-8';
            }
            
            if(j.OWF_Job_Title__c == 'Shipper/Receiver') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Shipper/Receiver';
                j.OFG_Job_Template_Description__c = 'UFCS-12';
                j.Agency_Business_Unit__c = 'Industrial Support';
            }
            
             if(j.OWF_Job_Title__c == 'Sous Chef') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Kitchen Team Lead';
                j.OFG_Job_Template_Description__c = 'UFCS-15';
                j.Agency_Business_Unit__c = 'Restaurant & Hospitality';
            }
            
            if(j.OWF_Job_Title__c == 'Uniformed Loss Prevention Officer') {
                j.Career_Site_Alternate_Job_Title_OFG__c = 'Uniformed Loss Prevention Officer';
                j.OFG_Job_Template_Description__c = 'UFCS-18';
            }
            
           
        }
        // END  Urban Fare  
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }

}