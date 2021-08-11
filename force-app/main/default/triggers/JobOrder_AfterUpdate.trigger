/*******
Trigger: Job Order After update
Description: If a Job order status changes to Order Completed (triggered from Chargent Order being Complete) then update all related jobs to Open/Active Job status

Created: February 2015, Vankerk Solutions
Modification Log:

*******/
trigger JobOrder_AfterUpdate on Job_Order__c (after update) {
    // map of jobs to update status after order payment is complete
    List<sfdc_job__c> updjobs = new List<sfdc_job__c>();
    set<id> jobOrderIds = new set<id>();
    // cycle through orders and track related Job Order id if the order was just completed
    for (Job_Order__c o : trigger.new) {
        if (o.Status__c == 'Order Completed' && trigger.oldmap.get(o.id).Status__c != 'Order Completed')
            jobOrderIds.add(o.id);
    }
    // cycle through completed orders and related jobs to update status
    for (SFDC_Job__c j : [select id, job_status__c from sfdc_Job__c where job_order__c in :jobOrderIds and job_status__c = 'Pending Order']) {
            updjobs.add(new SFDC_Job__c (id = j.id, job_status__c = 'Open/Active Job', Date_Job_Added_or_Opened__c = null));
    }
    if (updjobs.size() > 0)
        update updjobs;
}