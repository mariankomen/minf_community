/***************************************
Class: Recruiter Comment New
Controller: extension for VF pg Recruiter Comment New

Description: This page creates a new Recruiter Comment record as well as new links to related Jobs.  Launched from related list button on Job, defaults that
    Job in the list and allows for adding more

Created: Niki Vankerk, July 29/12
Modification Log:

****************************************/
public class RecruiterCommentNew {

    public List<Job_Recruiter_Comment__c> jobs {get; set;}    // holds new links to Jobs for the new Comment
    public Recruiter_Comment__c comment {get; set;}    // holds details about the new Comment to create
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
    public RecruiterCommentNew(ApexPages.StandardController con) {
        isTest = false;
        comment = new Recruiter_Comment__c();
        // create first job record
        jobs = new List<Job_Recruiter_Comment__c>();
        jobs.add(new Job_Recruiter_Comment__c());
        
        // check if there is a parameter for jobid
        Id JobId = ApexPages.currentPage().getParameters().get('jid');
        // if we have a Job id then add to first Job Recruiter Comment record
        if (JobId != null) {
            try {
                initialJob = [select id, name from SFDC_Job__c where id = :JobId];
                // default first job link with initial job id if it was passed in
                jobs[0].job__c = initialJob.Id;
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
                jobs.add(new Job_Recruiter_Comment__c());
            }
        }
      
        return null;
    }

    // Save method:    
    //    Check for required fields on the Comment, save and then save all related Job link records
    //    
    public PageReference save() {
      try {
          // check for required fields
          boolean error = false;
          
          // Comment required fields
          if (comment.shortlisted_candidates__c == null) {
              comment.shortlisted_candidates__c.adderror('Please enter a value');
              error = true;          
          }
          if (comment.calls__c == null) {
              comment.calls__c.adderror('Please enter a value');
              error = true;          
          }
          if (comment.voicemails__c == null) {
              comment.voicemails__c.adderror('Please enter a value');
              error = true;          
          }
          if (comment.number_of_candidates_rejected__c == null) {
              comment.number_of_candidates_rejected__c.adderror('Please enter a value');
              error = true;          
          }
          if (comment.most_common_rejection_reasons__c == null) {
              comment.most_common_rejection_reasons__c.adderror('Please enter a value');
              error = true;          
          }     
        
          if (error) return null;
          else {         

              Savepoint sp = Database.setSavepoint();
              try {
                  insert comment;
                  // now cycle through Job links to create Job Recruiter Comment records
                  for (Job_Recruiter_Comment__c d : jobs) {
                      // add link to newly created comment
                      d.recruiter_comment__c = comment.id;
                  }
                  if (!jobs.isempty())
                      insert jobs;

                  // if we are testing, force an exception here
                  if (isTest) {
                      string e;
                      e.tolowercase();
                  }
              } catch (Exception e) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving Comment with Jobs links: '+e));
                  database.rollback(sp);   // this will delete the records from db but not ids from memory 
                  // now back out the Comment id, keeping values 
                  Recruiter_Comment__c temp = new Recruiter_Comment__c();
                  temp = comment;
                  comment = new Recruiter_Comment__c();
                  comment= temp.clone(false,true);
                  // now back out the job Recruiter Comment id values, keeping user entered details
                  List<Job_Recruiter_Comment__c> templds = new List<Job_Recruiter_Comment__c>();
                  for (Job_Recruiter_Comment__c d : jobs) {
                      Job_Recruiter_Comment__c templd = new Job_Recruiter_Comment__c();
                      templd = d;
                      d = new Job_Recruiter_Comment__c();
                      d.job__c = templd.job__c;
                      templds.add(d);
                  }
                  jobs = templds;
                  system.debug('error saving Job Recruiter Comments: : '+e); 
                  return null;                  
              } // end exception handling
          } // end if no errors

          // go back to the Job
          return new PageReference('/'+initialJob.id);
          
         } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error setting up Comment and jobs for saving, please start again: '+e));
            system.debug('error saving Comment: '+e);
            return null;
         }          
    }

   
}