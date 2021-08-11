@isTest
public class JobOrder_Tab_Test {
    private static testmethod void testPg() {
    	list<Job_order__c> jos = new list<Job_Order__c>();
        Job_Order__c j0 = new Job_Order__c(status__c = 'New', job_title__c = 'test1', order_amount__c = 1);
        jos.add(j0);
        Job_Order__c j1 = new Job_Order__c(status__c = 'Pending Payment', job_title__c = 'test5', order_amount__c = 2, tax_percent__c = 50);
        jos.add(j1);
        Job_Order__c j2 = new Job_Order__c(status__c = 'Pending Payment', job_title__c = 'test4', order_amount__c = 4);
        jos.add(j2);
        Job_Order__c j3 = new Job_Order__c(status__c = 'Order Completed', job_title__c = 'test3', order_amount__c = 5);
        jos.add(j3);
        Job_Order__c j4 = new Job_Order__c(status__c = 'Order Completed', job_title__c = 'test2', order_amount__c = 6);
        jos.add(j4);  
        insert jos;
        // basic list with 4 rows
        JobOrder_Tab con = new JobOrder_Tab();
        list<Job_Order__c> orders = con.getCurrentOrderList();
        system.assertequals(orders.size(), 4);
        // order by name which is auto numbered
        system.assertequals(orders[3].job_title__c, j4.job_title__c);
        // toggle sort to desc
        con.SortToggle();
		system.assertequals(con.SortDirection, 'desc NULLS LAST');
        orders = con.getCurrentOrderList();
        system.assertequals(orders[0].job_title__c, j4.job_title__c);
		con.SortToggle(); // back to asc
        // sort on job title, should stay on asc
		con.SortField = 'job_title__c';
        con.SortToggle(); 
        system.assertequals(con.SortDirection, 'asc');
        orders = con.getCurrentOrderList();
        system.assertequals(orders[0].job_title__c, j4.job_title__c);
        
        
    }
}