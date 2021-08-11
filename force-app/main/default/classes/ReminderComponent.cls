/////////////////////////////////
//      Class: ReminderComponent
//      Purpose: This class contains methods to support the RemindersComponent visualforce page.  This page is shown
//              on the portal home page in an iframe and lists any open Reminder for the logged in user.  This includes
//              a wrapper class to include a checkbox in the list of Reminder so we can bulk Complete records
//
//      1. ReminderComponent(): method to initialize the page variables, querying for any open Reminders and creating
//                              a list of the Reminder and an unchecked box in the list
//      2. CloseReminder(): method to mark any selected Reminders as Complete.  Called from a button that first checks if anything
//                          was selected.  
//              - If all Candidates are Rejected and the rejectAction boolean is checked, the store wants more candidates sent so clone the Job
//                      and request more.
//              - If at least 1 candidate was hired, close out the job.  Then:
//                      - if more than 1 Candidate was hired and this is for OWF, clone the job and move the hired Candidate to this new job
//                      - if anyone was left as Interviewing, the store is still interviewing them for another job so clone the job and move
//                              the Interviewing Candidate to this new job
//                      - finally, send back null so the page button's action will open PSFT window and redirect to the Job
//
//      Created: Feb 20/2010 by Niki Vankerk, Vankerk Solutions, Inc
//      Modification Log:
/////////////////////////////////
public with sharing class ReminderComponent {

    public integer OpenReminders {get; set;}
    //Our collection of the class/wrapper objects cReminder - used to add checkbox to list of Reminders
    public List<cReminder> OpenList {get; set;}

    public ReminderComponent() {
        OpenList = new List<cReminder>();
        for(MFG_Reminder__c r : [select Status__c, SFDC_Job__r.Name, SFDC_Job__c, Candidate__c, Candidate__r.Name, SFDC_Job_Candidate__c, SFDC_Job_Candidate__r.name, Name, Due_Date__c From MFG_Reminder__c 
                where status__c <> 'Complete' and sfdc_job__r.ownerid = :UserInfo.getUserId()]){
            // As each reminder is found, we create a new cReminder object and add it to the OpenList 
            OpenList.add(new cReminder(r));
        }
        OpenReminders = OpenList.size();
    }

    // closes selected Reminders from list
    public PageReference CloseReminders() {

        // create a new list of Reminders that we be populated with Reminders that were selected in the list
        List<MFG_Reminder__c> selectedReminders = new List<MFG_Reminder__c>();
        
        // Cycle through our list of cReminders and will check to see if the 
        // selected property is set to true, if it is we add the Reminder to the 
        // selectedReminders list with the Complete status. 
        for(cReminder cRem : OpenList){
            if(cRem.selected == true){
                cRem.rem.status__c = 'Complete';
                selectedReminders.add(cRem.rem);
            }
        } // end loop
        
        try { 
            update selectedReminders;

        } catch (Exception e) {
            system.debug('Errors updating Reminders: '+e);
        }
        // refresh the reminder component
        PageReference HomePage = Page.ReminderComponent;
        HomePage.setRedirect(true);
        return HomePage;
    }


    // This is our wrapper/container class, containing both the Reminder object and a Boolean value 
    public class cReminder{
        public MFG_Reminder__c rem {get; set;}
        public Boolean selected {get; set;}
        
        // constructing a cReminder: set the rem property with the Reminder record passed in
        //    and set selected to false 
        public cReminder(MFG_Reminder__c r){
            rem = r;
            selected = false;
        }
    }
   
}