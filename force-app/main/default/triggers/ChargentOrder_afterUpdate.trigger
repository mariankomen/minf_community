/*******
Trigger: Chargent Order After update
Description: If a Chragent order status changes to Complete (workflow update when Chargent Order Balance Due is 0) then update related job order status to Order Completed
    and order completed date to today

Created: February 2015, Vankerk Solutions
Modification Log:

*******/
trigger ChargentOrder_afterUpdate on ChargentOrders__ChargentOrder__c (after update) {
    // map of job orders to update status after payment is complete
    Map<id, job_order__c> jobOrdersMap = new map<Id, job_order__c>();
    // cycle through chargent orders and track related Job Order id if the Chargent order was just completed
    for (ChargentOrders__ChargentOrder__c c : trigger.new) {
        if (c.ChargentOrders__Status__c == 'Complete' && trigger.oldmap.get(c.id).ChargentOrders__Status__c != 'Complete' && c.job_order__c != null)
            jobOrdersMap.put(c.job_order__c, new job_order__c(id = c.job_order__c, status__c = 'Order Completed', order_completed_date__c = date.today()));
    }
    if (jobOrdersMap.size() > 0)
        update jobOrdersMap.values();
}