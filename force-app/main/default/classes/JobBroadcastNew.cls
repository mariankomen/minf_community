/***************************************
Class: Job Broadcast New
Controller: extension for VF pg Job Broadcast New

Description: This page creates a new Job Broadcast record as well as new links to related Jobs.  Launched from related list button on Job, defaults that
    Job in the list and allows for adding more

Created: Niki Vankerk, Sept 8/12
Modification Log:
    Sept 18/12: added support for Save & New function
    
****************************************/
public class JobBroadcastNew {

    public List<Job_Broadcasting_Link__c> jobs {get; set;}    // holds new links to Jobs for the new Broadcast
    public Job_Broadcasting__c broadcast {get; set;}    // holds details about the new Job Broadcast to create
    private SFDC_Job__c initialJob {get; set;}        // Job we launched from
    public string rownum {get; set;} // collects number of rows to add from user

    public integer numrows {set; get{        // indicates the number of Job link rows showing
        // returns the number of rows in the collection
        if (jobs == null) return 0;
        return jobs.size();
        }
    }
    public boolean isTest {get; set;}

    // constructor class
    public JobBroadcastNew(ApexPages.StandardController con) {
        isTest = false;
        broadcast = new Job_Broadcasting__c();
        // create first job record
        jobs = new List<Job_Broadcasting_Link__c>();
        jobs.add(new Job_Broadcasting_Link__c());
        
        // check if there is a parameter for jobid
        Id JobId = ApexPages.currentPage().getParameters().get('jid');
        // if we have a Job id then add to first Job Broadcast Link record
        if (JobId != null) {
            try {
                // query for initial job with duplicate and then go 5 levels further through dup for chained duplicate jobs
                initialJob = [select id, name, Duplicate_Job__c, 
                                               Duplicate_Job__r.Duplicate_Job__c, 
                                               Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c,
                                               Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c,
                                               Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c,
                                               Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c
                              from SFDC_Job__c where id = :JobId];
                // default first job link with initial job id if it was passed in
                jobs[0].job__c = initialJob.Id;
                // if we also have a duplicate job linked, add that to the list of links
                if (initialJob.Duplicate_Job__c != null) {
                    jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__c));
                    // continue down the line of dups through the dup job to add any more jobs
                    if (initialJob.Duplicate_Job__r.Duplicate_Job__c != null) {
                        jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__r.Duplicate_Job__c));
                        if (initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c != null) {
                            jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c));
                            if (initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c != null) {
                                jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c)); 
                                if (initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c != null) {
                                    jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c));                                 
                                    if (initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c != null) {
                                        jobs.add(new Job_Broadcasting_Link__c(job__c = initialJob.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__r.Duplicate_Job__c));                                 
                                    } // if dup 6
                                } // if dup 5
                            } // if dup 4
                        } // if dup 3                                                   
                    } // if dup 2
                } // if dup 1
            } catch (Exception e) {}
        }
        // default Add Rows number to 1
        rownum = '1';
    }
    
    // removes the last row in the list, one by one, except the first in the list
    public PageReference del() {
        try {
            if (jobs.size() > 1)
                jobs.remove(jobs.size() - 1);
        } catch (Exception e) {
            ApexPages.addMessages(e);
            system.debug('error removing the job link: '+e);
        }
        return null;
    }

    // method adds rows to the list of new Job links - if the num rows was not specified, use 1    
    public PageReference add() {
        integer row;
        // if they didn't specify the number of rows, use 1
        if (rownum == null || rownum.length() == 0) {
            rownum = '1'; 
        }         
        try {
            row = integer.valueof(rownum);
        } catch (Exception e) {  // catches if they enter words not a number
             ApexPages.addMessages(e);
             return null;
        }
        // add new lines to equal how many they asked for
        if (row != null) {
            for (integer i=0; i<row ; i++) {
                jobs.add(new Job_Broadcasting_Link__c());
            }
        }
      
        return null;
    }

    // Save method:    
    //    Check for required fields on the Broadcast, save and then save all related Job link records
    //    
    public PageReference save() {
      try {
          // check for required fields
          boolean error = false;
          
          // Job Broadcast required fields
          if (broadcast.New_Refresh__c == null) {
              broadcast.New_Refresh__c.adderror('Please enter a value');
              error = true;          
          }
          if (broadcast.Medium__c == null) {
              broadcast.Medium__c.adderror('Please enter a value');
              error = true;          
          }     
          if (error) return null;
          else {         

              Savepoint sp = Database.setSavepoint();
              try {
                  insert broadcast;
                  // now cycle through Job links to create Job Broadcast Link records
                  for (Job_Broadcasting_Link__c d : jobs) {
                      // add link to newly created comment
                      d.job_broadcasting__c = broadcast.id;
                  }
                  if (!jobs.isempty())
                      insert jobs;

                  // if we are testing, force an exception here
                  if (isTest) {
                      string e;
                      e.tolowercase();
                  }
              } catch (Exception e) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving Job Broadcast with Jobs links: '+e));
                  database.rollback(sp);   // this will delete the records from db but not ids from memory 
                  // now back out the Comment id, keeping values 
                  Job_Broadcasting__c temp = new Job_Broadcasting__c();
                  temp = broadcast;
                  broadcast = new Job_Broadcasting__c();
                  broadcast = temp.clone(false,true);
                  // now back out the Job Broadcast link id values, keeping user entered details
                  List<Job_Broadcasting_Link__c> templds = new List<Job_Broadcasting_Link__c>();
                  for (Job_Broadcasting_Link__c d : jobs) {
                      Job_Broadcasting_Link__c templd = new Job_Broadcasting_Link__c();
                      templd = d;
                      d = new Job_Broadcasting_Link__c();
                      d.job__c = templd.job__c;
                      templds.add(d);
                  }
                  jobs = templds;
                  system.debug('error saving Job Broadcast: : '+e); 
                  return null;                  
              } // end exception handling
          } // end if no errors

          // go back to the Job
          return new PageReference('/'+initialJob.id);
          
         } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error setting up Job Broadcast and jobs for saving, please start again: '+e));
            system.debug('error saving Broadcast: '+e);
            return null;
         }          
    }

    // Save & New method:    
    //    call save method and then open a new page for same job
    //    
    public PageReference save_new() {
        // call save and catch return value
        PageReference result = save();
        // if we had error, return null
        if (result == null) return null;
        // if we got back a page ref, redirect user to this same page again
        PageReference newJB = ApexPages.currentPage();
        newJB.setRedirect(true);
        return newJB;
    }



}