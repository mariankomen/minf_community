//Project: Holiday Update
//Date: Oct 12, 2016
//Author: Jeff Perron
//Description: This handles batch update on SFDC_Job__c.Holiday_Deduction_in_days__c
//             Called from scheduled job, scheduledHolidayUpdate

global class jobHolidayUpdateBatch implements Database.Batchable<sObject> {

    global final Date dInput;  

    global jobHolidayUpdateBatch(Date d) {
        // Batch Constructor
        dInput = d;
    }

    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //String sDate = String.valueOf(dInput);
        String sDate = DateTime.newInstance(dInput, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                
        // Generate your string query on any object here with limit 10000
        /*String Query = 'SELECT ID, Name, Job_Status__c,Create_Date_Time__c, OWF_Job_Title__c, Career_Site_Alternate_Job_Title__c, Holiday_Deduction_in_days__c ' + 
                        'FROM SFDC_Job__C ' +
                        'WHERE Date_Job_Added_or_Opened__c <=' + sDate + ' AND ' +
                        '          (recordtypeid=\'012U00000009Qqf\' OR ' + //FGL
                        '           recordtypeid=\'012U00000009Qri\' OR ' + //OFG
                        '           recordtypeid=\'012U00000009U3e\' OR ' + //Marks
                        '           recordtypeid=\'012U00000009QqV\' OR ' + //PPG Can
                        '           recordtypeid=\'012U0000000brvc\') AND ' + //PPG USA
                        '      (Job_Status__c LIKE \'Open/Active Job\' OR Job_Status__c LIKE \'Additional Candidate(s) Required\' OR ' +
                        '       Job_Status__c LIKE \'Job On Hold\' OR Job_Status__c LIKE \'Open/Active Job - Talent Connect\') AND ' +
                        '      OWF_Job_Title__c NOT IN (\'AB Floorwalker-LPO (W0217)\', \'AB Greeter (W0218)\', \'Loss Prevention Assessor (Z0218)\', \'Loss Prevention Officer (Z0217)\',\'Uniformed Loss Prevention Officer (Z0217)\', \'AB Uniformed Loss Prevention Personnel (WO217)\')';     
        */
        
        //update Sept 11, 2017
        //just get 'Full-Cycle Recruitment'
        String Query = 'SELECT ID, Name, Job_Status__c,Create_Date_Time__c, OWF_Job_Title__c, Career_Site_Alternate_Job_Title__c, Holiday_Deduction_in_days__c, mindfield_service__c ' + 
                        'FROM SFDC_Job__C ' +
                        'WHERE Date_Job_Added_or_Opened__c <=' + sDate + ' AND ' +
                        '       mindfield_service__c LIKE \'Full-Cycle Recruitment\' AND ' + 
                        '      (Job_Status__c LIKE \'Open/Active Job\' OR Job_Status__c LIKE \'Additional Candidate(s) Required\' OR ' +
                        '       Job_Status__c LIKE \'Job On Hold\' OR Job_Status__c LIKE \'Open/Active Job - Talent Connect\')'; 
                                                               
        return Database.getQueryLocator(Query); //Query is Required on object which you want to run Batch
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List<SFDC_Job__c> joblist) {
        //update jobs
        for (SFDC_Job__c jUpdate : joblist) {
            Decimal checkNull = jUpdate.Holiday_Deduction_in_days__c;
            If(checkNull == null) {
                checkNull = 0.00;            
            }
            jUpdate.Holiday_Deduction_in_days__c = checkNull + 1;
        }
        update joblist;
    }
     

    global void finish(Database.BatchableContext BC ) {
        // Logic to be Executed at finish
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                         TotalJobItems, CreatedBy.Email
                         FROM AsyncApexJob WHERE Id =: BC.getJobId()];

        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Job Holiday Update ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
   
}