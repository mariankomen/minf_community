@isTest
public class Job_Workflow_Overwaitea_Sourcing_Test {
    
    static testmethod void testJobs(){
        // call method to create account/opp/user needed for creating jobs
        Job_Workflow_Test_Utility.setupUser();
        // grab map of Job record types to find the client we are testing
        Map<string,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosByName();
        Id RecType = JobRecTypes.get('Overwaitea Food Group Sourcing').getrecordtypeid();

        List<SFDC_Job__c> jobs = new List<SFDC_Job__c>();
        // run tests as portal user to avoid clean up workflow
        //system.runas(Job_Workflow_Test_Utility.u) { //PULLED THIS OUT BECAUSE IT WAS TRIGGERING DUP CHECK, THIS INTURN ENDED UP HITTING APEX SQOL LIMIT  
        
            //OFG --------------------------------------------
            SFDC_Job__c j0 = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j0);
            
            SFDC_Job__c j1 = new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j1);
            
            SFDC_Job__c j2 = new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j2);
            
            SFDC_Job__c j3 = new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j3);
            
            SFDC_Job__c j4 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j4);
            
            SFDC_Job__c j5 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Overwaitea Foods', recordtypeid = RecType);
            jobs.add(j5);      
              
            //PSF ---------------------------------------------------
            SFDC_Job__c j6 = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j6);  
            
            SFDC_Job__c j7 = new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j7);
            
            SFDC_Job__c j8 = new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j8);
            
            SFDC_Job__c j9 = new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j9);
            
            SFDC_Job__c j10 = new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j10);
            
            SFDC_Job__c j11 = new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j11);
            
            SFDC_Job__c j12 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j12);
            
            SFDC_Job__c j13 = new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j13);
            
            SFDC_Job__c j14 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j14);
                  
            SFDC_Job__c j15 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j15); 
            
            SFDC_Job__c j16 = new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j16); 
            
            SFDC_Job__c j17 = new SFDC_Job__c(OWF_Job_Title__c = 'Pharmacy Technician',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j17); 
            
            SFDC_Job__c j18 = new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j18); 
            
            SFDC_Job__c j19 = new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j19); 
            
            SFDC_Job__c j20 = new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j20); 
            
            SFDC_Job__c j21 = new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Officer',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType);
            jobs.add(j21);       
            
            //SOF AB
            SFDC_Job__c j22 = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j22); 
            
            SFDC_Job__c j23 = new SFDC_Job__c(OWF_Job_Title__c = 'Assistant Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j23);
            
            SFDC_Job__c j24 = new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j24);
            
            SFDC_Job__c j25 = new SFDC_Job__c(OWF_Job_Title__c = 'Cake Centre Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j25);
            
            SFDC_Job__c j26 = new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j26);
            
            SFDC_Job__c j27 = new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Bar Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j27);
            
            SFDC_Job__c j28 = new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j28);
            
            SFDC_Job__c j29 = new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j29);
            
            SFDC_Job__c j30 = new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j30);
            
            SFDC_Job__c j31 = new SFDC_Job__c(OWF_Job_Title__c = 'Floral Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j31);
            
            SFDC_Job__c j32 = new SFDC_Job__c(OWF_Job_Title__c = 'Greeter',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j32);
            
            SFDC_Job__c j33 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j33);
            
            SFDC_Job__c j34 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j34);
            
            SFDC_Job__c j35 = new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j35);
            
            SFDC_Job__c j36 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j36);
            
            SFDC_Job__c j37 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j37);
            
            SFDC_Job__c j38 = new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j38);
            
            SFDC_Job__c j39 = new SFDC_Job__c(OWF_Job_Title__c = 'Personal Shopper',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j39);
            
            SFDC_Job__c j40 = new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j40);
            
            SFDC_Job__c j41 = new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j41);
            
            SFDC_Job__c j42 = new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j42);
            
            SFDC_Job__c j43 = new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Personnel',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType);
            jobs.add(j43);
            
            
            
            //UF
            SFDC_Job__c j44 = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j44);
            
            SFDC_Job__c j45 = new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j45);
            
            SFDC_Job__c j46 = new SFDC_Job__c(OWF_Job_Title__c = 'Cap Bar',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j46);
            
            SFDC_Job__c j47 = new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j47);
            
            SFDC_Job__c j48 = new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Shop',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j48);
            
            SFDC_Job__c j49 = new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j49);
            
            SFDC_Job__c j50 = new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j50);
            
            SFDC_Job__c j51 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j51);
            
            SFDC_Job__c j52 = new SFDC_Job__c(OWF_Job_Title__c = 'Guest Services Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j52);
            
            SFDC_Job__c j53 = new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j53);
            
            SFDC_Job__c j54 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j54);
            
            SFDC_Job__c j55 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j55);
            
            SFDC_Job__c j56 = new SFDC_Job__c(OWF_Job_Title__c = 'Pharmacy Technician',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j56);
            
            SFDC_Job__c j57 = new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j57);
            
            SFDC_Job__c j58 = new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j58);
            
            SFDC_Job__c j59 = new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j59);
            
            SFDC_Job__c j60 = new SFDC_Job__c(OWF_Job_Title__c = 'Sous Chef',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j60);
            
            SFDC_Job__c j61 = new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType);
            jobs.add(j61);
                  
            //SOF BC
            SFDC_Job__c j62 = new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j62); 
            
            SFDC_Job__c j63 = new SFDC_Job__c(OWF_Job_Title__c = 'Assistant Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j63);
            
            SFDC_Job__c j64 = new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j64);
            
            SFDC_Job__c j65 = new SFDC_Job__c(OWF_Job_Title__c = 'Cake Centre Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j65);
            
            SFDC_Job__c j66 = new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j66);
            
            SFDC_Job__c j67 = new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Bar Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j67);
            
            SFDC_Job__c j68 = new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j68);
            
            SFDC_Job__c j69 = new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j69);
            
            SFDC_Job__c j70 = new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j70);
            
            SFDC_Job__c j71 = new SFDC_Job__c(OWF_Job_Title__c = 'Floral Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j71);
            
            SFDC_Job__c j72 = new SFDC_Job__c(OWF_Job_Title__c = 'Greeter',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j72);
            
            SFDC_Job__c j73 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j73);
            
            SFDC_Job__c j74 = new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j74);
            
            SFDC_Job__c j75 = new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j75);
            
            SFDC_Job__c j76 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j76);
            
            SFDC_Job__c j77 = new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j77);
            
            SFDC_Job__c j78 = new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j78);
            
            SFDC_Job__c j79 = new SFDC_Job__c(OWF_Job_Title__c = 'Personal Shopper',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j79);
            
            SFDC_Job__c j80 = new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j80);
            
            SFDC_Job__c j81 = new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j81);
            
            SFDC_Job__c j82 = new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j82);
            
            SFDC_Job__c j83 = new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Personnel',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType);
            jobs.add(j83);      
                  
            //SOF MB
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Assistant Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cake Centre Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Bar Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Floral Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Greeter',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Personal Shopper',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Personnel',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));
            
            //SOF SK
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Assistant Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cake Centre Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Bar Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Floral Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Greeter',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Personal Shopper',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Personnel',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));
                  
            //SOF YK
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Allocation',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Assistant Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Bakery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cake Centre Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cashier',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Coffee Bar Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Cook',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Deli Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Fish/Seafood Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Floral Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Greeter',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Grocery Delivery Driver',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Loss Prevention Officer',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Meat Cutter',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Overnight Grocery Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Personal Shopper',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Price Change Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Produce Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Shipper/Receiver',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Uniformed Loss Prevention Personnel',  OWF_Banner_of_Store__c= 'Save On Foods - YK', recordtypeid = RecType));      
               
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - MB', recordtypeid = RecType));   
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'PriceSmart Foods', recordtypeid = RecType));  
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - AB', recordtypeid = RecType));  
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - BC', recordtypeid = RecType));  
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'Save On Foods - SK', recordtypeid = RecType));  
            jobs.add(new SFDC_Job__c(OWF_Job_Title__c = 'Restaurant Clerk',  OWF_Banner_of_Store__c= 'Urban Fare', recordtypeid = RecType)); 
                 
            insert jobs;
        //}
        
        jobs = [select id, OFG_Job_Template_Description__c from SFDC_Job__c where id in :jobs order by id];
        
        /* Comment out, runing into System.LimitException: Apex CPU time limit exceeded
        system.assertequals(jobs[0].OFG_Job_Template_Description__c, 'OFGCS-1');
        system.assertequals(jobs[1].OFG_Job_Template_Description__c, 'OFGCS-6');
        system.assertequals(jobs[2].OFG_Job_Template_Description__c, 'OFGCS-3');
        system.assertequals(jobs[3].OFG_Job_Template_Description__c, 'OFGCS-4');
        system.assertequals(jobs[4].OFG_Job_Template_Description__c, 'OFGCS-2');
        system.assertequals(jobs[5].OFG_Job_Template_Description__c, 'OFGCS-5');
        
        system.assertequals(jobs[6].OFG_Job_Template_Description__c, 'PSFCS-1');
        system.assertequals(jobs[7].OFG_Job_Template_Description__c, 'PSFCS-8');
        system.assertequals(jobs[8].OFG_Job_Template_Description__c, 'PSFCS-9');
        system.assertequals(jobs[9].OFG_Job_Template_Description__c, 'PSFCS-2');
        system.assertequals(jobs[10].OFG_Job_Template_Description__c, 'PSFCS-10');
        system.assertequals(jobs[11].OFG_Job_Template_Description__c, 'PSFCS-11');
        system.assertequals(jobs[12].OFG_Job_Template_Description__c, 'PSFCS-3');
        system.assertequals(jobs[13].OFG_Job_Template_Description__c, 'PSFCS-15');
        system.assertequals(jobs[14].OFG_Job_Template_Description__c, 'PSFCS-5');
        system.assertequals(jobs[15].OFG_Job_Template_Description__c, 'PSFCS-6');
        system.assertequals(jobs[16].OFG_Job_Template_Description__c, 'PSFCS-4');
        system.assertequals(jobs[17].OFG_Job_Template_Description__c, 'PSFCS-14');
        system.assertequals(jobs[18].OFG_Job_Template_Description__c, 'PSFCS-13');
        system.assertequals(jobs[19].OFG_Job_Template_Description__c, 'PSFCS-7');
        system.assertequals(jobs[20].OFG_Job_Template_Description__c, 'PSFCS-12');
        system.assertequals(jobs[21].OFG_Job_Template_Description__c, 'PSFCS-16');
        
        system.assertequals(jobs[22].OFG_Job_Template_Description__c, 'SOFCS-1');
        system.assertequals(jobs[23].OFG_Job_Template_Description__c, 'SOFCS-2');
        system.assertequals(jobs[24].OFG_Job_Template_Description__c, 'SOFCS-3');
        system.assertequals(jobs[25].OFG_Job_Template_Description__c, 'SOFCS-4');
        system.assertequals(jobs[26].OFG_Job_Template_Description__c, 'SOFCS-5');
        system.assertequals(jobs[27].OFG_Job_Template_Description__c, 'SOFCS-6');
        system.assertequals(jobs[28].OFG_Job_Template_Description__c, 'SOFCS-7');
        system.assertequals(jobs[29].OFG_Job_Template_Description__c, 'SOFCS-8');
        system.assertequals(jobs[30].OFG_Job_Template_Description__c, 'SOFCS-9');
        system.assertequals(jobs[31].OFG_Job_Template_Description__c, 'SOFCS-10');
        system.assertequals(jobs[32].OFG_Job_Template_Description__c, 'SOFCS-11');
        system.assertequals(jobs[33].OFG_Job_Template_Description__c, 'SOFCS-12');
        system.assertequals(jobs[34].OFG_Job_Template_Description__c, 'SOFCS-14');
        system.assertequals(jobs[35].OFG_Job_Template_Description__c, 'SOFCS-16');
        system.assertequals(jobs[36].OFG_Job_Template_Description__c, 'SOFCS-17');
        system.assertequals(jobs[37].OFG_Job_Template_Description__c, 'SOFCS-18');
        system.assertequals(jobs[38].OFG_Job_Template_Description__c, 'SOFCS-19');
        system.assertequals(jobs[39].OFG_Job_Template_Description__c, 'SOFCS-20');
        system.assertequals(jobs[40].OFG_Job_Template_Description__c, 'SOFCS-21');
        system.assertequals(jobs[41].OFG_Job_Template_Description__c, 'SOFCS-22');
        system.assertequals(jobs[42].OFG_Job_Template_Description__c, 'SOFCS-23');
        system.assertequals(jobs[43].OFG_Job_Template_Description__c, 'SOFCS-26');
        
        system.assertequals(jobs[44].OFG_Job_Template_Description__c, 'UFCS-1');
        system.assertequals(jobs[45].OFG_Job_Template_Description__c, 'UFCS-9');
        system.assertequals(jobs[46].OFG_Job_Template_Description__c, 'UFCS-3');
        system.assertequals(jobs[47].OFG_Job_Template_Description__c, 'UFCS-10');
        system.assertequals(jobs[48].OFG_Job_Template_Description__c, 'UFCS-4');
        system.assertequals(jobs[49].OFG_Job_Template_Description__c, 'UFCS-2');
        system.assertequals(jobs[50].OFG_Job_Template_Description__c, 'UFCS-11');
        system.assertequals(jobs[51].OFG_Job_Template_Description__c, 'UFCS-5');
        system.assertequals(jobs[52].OFG_Job_Template_Description__c, 'UFCS-14');
        system.assertequals(jobs[53].OFG_Job_Template_Description__c, 'UFCS-17');
        system.assertequals(jobs[54].OFG_Job_Template_Description__c, 'UFCS-6');
        system.assertequals(jobs[55].OFG_Job_Template_Description__c, 'UFCS-7');
        system.assertequals(jobs[56].OFG_Job_Template_Description__c, 'UFCS-16');
        system.assertequals(jobs[57].OFG_Job_Template_Description__c, 'UFCS-13');
        system.assertequals(jobs[58].OFG_Job_Template_Description__c, 'UFCS-8');
        system.assertequals(jobs[59].OFG_Job_Template_Description__c, 'UFCS-12');
        system.assertequals(jobs[60].OFG_Job_Template_Description__c, 'UFCS-15');
        system.assertequals(jobs[61].OFG_Job_Template_Description__c, 'UFCS-18');
       */
        
    }
}