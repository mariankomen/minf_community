/****************************
Class: Job_Workflow
Purpose: This class contains code to handle setting various job defaults like portal address details, credits/SLA and wage details.  Written to replace workflow rules which were at
        the limit.
        NOTE: changes to this class also require changes to the test methods in 'Job_Workflow_Tests'.  Also note that the order of your tests within a Client bracket is important
            since the first if statement that matches criteria will be used and none others evaluated.  Specific rules should precede the  more general rules.
        
        This class is called from the Job_BeforeInsertUpdate trigger on the first update of a job, after the Duplicate/Confidentiality Check method.
        
Created: Vankerk Solutions, Aug 24/2012
Modification Log:
    Nov 27/12: broke main class up into multiple methods per client
    May 15, 2014: broke up main class to have a lass per client along with separate test class
    June 10/14: added Earls as  new client
    Sept 14/16: added Turnabout as new client
    
****************************/
public class Job_Workflow {

    // run through Job values before insert to see whether we can default job field values
    // replacing workflow as MFG has hit their limit for rules/updates
    public static boolean SetJobDefaults(List<SFDC_Job__c> jobs) {
        try {
            // grab map of Job record types to decode record type id into name
            Map<Id,Schema.RecordTypeInfo> JobRecTypes = Schema.SObjectType.SFDC_Job__c.getRecordTypeInfosById();
            // cycle through Jobs to test by record type
            for (SFDC_Job__c j : jobs){
                string Client = JobRecTypes.get(j.recordtypeid).getName();
                //system.debug('Client name is: '+Client);
                
                // Akzo Nobel tests
                if (Client == 'AkzoNobel') 
                   Job_Workflow_AkzoNobel.processJob(j);                                                            
                 // Cob's Bread rules
               // else if (Client == 'COBS Bread') 
                //    Job_Workflow_COBS.processJob(j); 
                // Earls Client
               // else if (Client == 'Earls') 
               //     Job_Workflow_Earls.processJob(j);
                // easyhome Client
               // else if (Client == 'easyhome') 
                //    Job_Workflow_easyhome.processJob(j);
                // Edible Canada Client
               // else if (Client == 'Edible Canada') 
               //     Job_Workflow_EdibleCanada.processJob(j);                
                // FGL Sports rules
                if (Client == 'FGL Sports') 
                    Job_Workflow_FGLSports.processJob(j);
                // General Paint rules
              //  else if (Client == 'General Paint') 
              //      Job_Workflow_GeneralPaint.processJob(j);
                // GrowthWorks rules
              //  else if (Client == 'GrowthWorks') 
              //      Job_Workflow_GrowthWorks.processJob(j);
                // HY Louie rules
              //  else if (Client == 'HY Louie')
              //      Job_Workflow_HYLouie.processJob(j);
                // Kal-Tire rules
             //   else if (Client == 'Kal-Tire')
             //       Job_Workflow_Kaltire.processJob(j);
                // Loblaw rules
              //  else if (Client == 'Loblaw') 
              //      Job_Workflow_Loblaw.processJob(j);
                // Longo's rules
             //   else if (Client == 'Longo\'s') 
               //     Job_Workflow_Longos.processJob(j);
                // Lowe's rules
              //  else if (Client == 'Lowe\'s') 
              //      Job_Workflow_Lowes.processJob(j);
                // MFG rules
                else if (Client == 'MindField OnDemand') 
                    Job_Workflow_MFG.processJob(j);
                // Mark's rules
                else if (Client == 'Marks') 
                    Job_Workflow_Marks.processJob(j);
                // MindField Internal rules
                else if (Client == 'MindField Internal')
                    Job_Workflow_MindFieldInternal.processJob(j);
                // Mr Lube rules
                else if (Client == 'Mr. Lube Franchise') 
                    Job_Workflow_MrLube.processJob(j);
                // No Limit/a52 rules
                else if (Client == 'No Limits Group') 
                   Job_Workflow_NoLimitsGroup.processJob(j);
                // Olsen Europe rules
             //   else if (Client == 'Olsen Europe')
               //     Job_Workflow_Olsen.processJob(j);
                 // Overwaitea Food Group rules
              //  else if (Client == 'Overwaitea Food Group') 
                 //   Job_Workflow_Overwaitea.processJob(j);
                // Prairie Lube rules
              //  else if (Client == 'Prairie Lube')
               //     Job_Workflow_PrairieLube.processJob(j);
                // skoah rules
               // else if (Client == 'skoah')
               //     Job_Workflow_skoah.processJob(j);
                // Source for Sports rules
              //  else if (Client == 'Source for Sports') 
                //    Job_Workflow_SourceforSports.processJob(j);
              //  else if (Client == 'Provident Security-CSS') 
              //      Job_Workflow_Provident_Security.processJob(j);  
              //  else if (Client == '1800GotJunk-FCR' || Client == '1800GotJunk-CSS' || Client == '1800GotJunk-PO') 
             //       Job_Workflow_1800GotJunk.processJob(j);  
             //   else if (Client == 'Proline Trucking') 
             //       Job_Workflow_Proline_Trucking.processJob(j);
              //  else if (Client == 'North West Company') 
              //      Job_Workflow_North_West_Company.processJob(j);
                else if (Client == 'Canadian Tire') 
                    Job_Workflow_Canadian_Tire.processJob(j);
              //  else if (Client == 'Tim Hortons') 
              //      Job_Workflow_Tim_Hortons.processJob(j);
              //  else if (Client == 'Hubbub') 
              //      Job_Workflow_Hubbub.processJob(j);
              // else if (Client == 'Kitchen Stuff Plus') 
              //      Job_Workflow_Kitchen_Stuff_Plus.processJob(j);
              //  else if (Client == 'PPG USA') 
              //      Job_Workflow_PPG_USA.processJob(j);
              //  else if (Client == 'Dealer Intelligence') 
              //      Job_Workflow_DealerIntelligence.processJob(j);
              //  else if (Client == 'The Grocery Shop') 
              //      Job_Workflow_The_Grocery_Store.processJob(j);
                //Jeff Perron, Sept 14 2016, added for new Turnabout client
              //  else if (Client == 'Turnabout - FCR') 
              //      Job_Workflow_Turnabout.processJob(j);
                //Jeff Perron, April 10 2017, added for new Country Grocer client
             //   else if (Client == 'Country Grocer') 
             //       Job_Workflow_CountryGrocer.processJob(j);
                //Jeff Perron, May 10 2017, added for new DirectTap client
             //   else if (Client == 'Direct Tap') 
             //       Job_Workflow_DirectTap.processJob(j);
                //Jeff Perron, October 5 2017, added for new tim horton franchise
                else if (Client == 'Tim Hortons - NSM') 
                    Job_Workflow_Tim_Hortons_NSM.processJob(j);
                //Jeff Perron, November 1 2017, added for new wendys franchise
                else if (Client == 'Wendys - NSM') 
                    Job_Workflow_Wendys_NSM.processJob(j);
                //Jeff Perron, Dec 2017, added for new OFG sourcing
               // else if (Client == 'Overwaitea Food Group Sourcing') 
               //     Job_Workflow_Overwaitea_Sourcing.processJob(j);
                //Jeff Perron, Jan 2018, added for Capilano Golf and Country Club
              //  else if (Client == 'Capilano Golf and Country Club - NSM') 
               //     Job_Workflow_Capilano_Golf_NSM.processJob(j);
                    //Jeff Perron, Jan 2018, added for Wallace & Carey Inc - NSM
              //  else if (Client == 'Wallace & Carey Inc - NSM') 
                //    Job_Workflow_Wallace_Carey_Inc_NSM.processJob(j);
                //Jeff Perron, Dec 2018, added for new Eco Group client
              //  else if (Client == 'Ecoservice Group') 
              //      Job_Workflow_Eco_Group_NSM.processJob(j);
                //Jeff Perron, March 2019, added for new Golf Town client
               else if (Client == 'Golf Town') 
                   Job_Workflow_Golf_Town_NSM.processJob(j);
                else if (Client == 'Sporting Life') 
                    Job_Workflow_Sporting_Life_NSM.processJob(j);
                else if (Client == 'Partsource') 
                    Job_Workflow_Partsource.processJob(j);
                else if (Client == 'Best Buy') 
                    Job_Workflow_Best_Buy.processJob(j);
                else if (Client == 'CT Financial Services')
                    Job_Workflow_CTFinancialServices.processJob(j);            

            } // end cycle through Jobs
            return true;
        } catch (Exception e) {
            // build single email to send to Jeff with error details
           // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           // String[] toAddresses = new String[] {'jeff.perron@mindfieldgroup.com', 'mfgsysadmin@mindfieldgroup.com'}; 
         //   mail.setToAddresses(toAddresses);
            // Specify the name used as the display name.  
         //   mail.setSenderDisplayName('Salesforce Apex Error Report');
            // Specify the subject line for your email address.  
        //    mail.setSubject('Job Workflow Method Errors');
       //     mail.setBccSender(false);
         //  mail.setUseSignature(false);
         //   mail.setPlainTextBody('There was an error trying to set new jobs with default values in the Job_Workflow class\n' + e.getstacktracestring() + ': '+e+'\n Jobs being created: \n'+
        //        jobs);
         //   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           return false;
        }
    }

   
}