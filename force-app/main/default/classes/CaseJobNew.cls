/***************************************
Class: Case Job New
Controller: extension for VF pg Case Job New

Description: This page creates links from an existing Case to related Jobs.  Launched from related list button on Case, allows for adding multiple Jobs in one screen

Created: Niki Vankerk, Sept 8/12
Modification Log:
    Jan 15/13: updated test method for new system deploy
    
****************************************/
public class CaseJobNew {

    public List<Case_Job_Link__c> jobs {get; set;}    // holds new links to Jobs for the Case
    public Case SFcase {get; set;}    // holds details about the Case
    public string rownum {get; set;} // collects number of rows to add from user

    public integer numrows {set; get{        // indicates the number of Job link rows showing
        // returns the number of rows in the collection
        if (jobs == null) return 0;
        return jobs.size();
        }
    }
   public boolean isTest {get; set;}

    // constructor class
    public CaseJobNew(ApexPages.StandardController con) {
        isTest = false;
        SFcase = (Case) con.getRecord();
        // create first job record
        jobs = new List<Case_Job_Link__c>();
        jobs.add(new Case_Job_Link__c(case__c = SFcase.id));
        
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
                jobs.add(new Case_Job_Link__c(case__c = SFcase.id));
            }
        }
      
        return null;
    }

    // Save method:    
    //    Save all related Job link records
    //    
    public PageReference save() {
          
          Savepoint sp = Database.setSavepoint();
          try {
              if (!jobs.isempty())
                  insert jobs;

              // if we are testing, force an exception here
              if (isTest) {
                  string e;
                  e.tolowercase();
              }
          } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving Case Jobs links: '+e));
              database.rollback(sp);   // this will delete the records from db but not ids from memory 
              // back out the Case Job link id values, keeping user entered details
              List<Case_Job_Link__c> templds = new List<Case_Job_Link__c>();
              for (Case_Job_Link__c d : jobs) {
                  Case_Job_Link__c templd = new Case_Job_Link__c();
                  templd = d;
                  d = new Case_Job_Link__c();
                  d.job__c = templd.job__c;
                  d.case__c = templd.case__c;
                  templds.add(d);
              }
              jobs = templds;
              system.debug('error saving Case Jobs: : '+e); 
              return null;                  
          } // end exception handling

          // go back to the Case
          return new PageReference('/'+SFcase.id);
         
    }

}