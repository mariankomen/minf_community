public with sharing class ReminderList {

    public integer OpenReminders {get; set;}

    public ApexPages.StandardSetController RemindersSSC{get; set;}
    public List<MFG_Reminder__c> RemindersList{get; set;}
    
    public ReminderList (ApexPages.StandardSetController controller) {
       RemindersList= [SELECT close_reminder__c, name, Status__c, SFDC_Job__c, 
                    Notes__c, Due_Date__c, Candidate__c, sfdc_job__r.ownerid, sfdc_job__r.name, sfdc_job__r.job_title__c, 
                    sfdc_job__r.job_status__c, candidate__r.name from MFG_Reminder__c where SFDC_Job__r.ownerid = :Userinfo.getUserId()
                    and status__c != 'Complete'];
       RemindersSSC = new ApexPages.StandardSetController(RemindersList);
       OpenReminders = RemindersList.size();
    }    
    
    
    // closes selected Reminders from list
    public PageReference CloseReminders() {

        // create a new list of Reminders that we be populated with Reminders that were selected in the list
        List<MFG_Reminder__c> updReminders = new List<MFG_Reminder__c>();
        // Cycle through the list and if "Close Reminder" check is selected we close the Reminder
        //       reset ths close flag as not needed otherwise
        for(MFG_Reminder__c r : RemindersList){
            if(r.close_reminder__c == true){
                r.status__c = 'Complete';
                r.close_reminder__c = false;
                updReminders.add(r);
            }
        } // end loop
        
        try { 
            update updReminders;

        } catch (Exception e) {
            system.debug('Errors updating Reminders: '+e);
        }
        // refresh the reminder component
        PageReference HomePage = Page.Reminders_List;
        HomePage.setRedirect(true);
        return HomePage;
    }

    
  
 
}