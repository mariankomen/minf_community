@isTest
public class JobOrder_Tests {
	// test job order after update - if status changes to Payment Complete, set all related jobs to Open/Active Job
    private static testmethod void testJobOrder_Afterupdate(){
        list<job_order__c> jos = new list<job_order__c>();
        job_order__c jo1 = new job_order__c();
        jos.add(jo1);
        job_order__c jo2 = new job_order__c();
        jos.add(jo2);
        insert jos;
        
        list<Sfdc_job__c> js = new list<sfdc_job__c>();
        // job 1 - jo 1
        SFDC_Job__c j1 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test1', banner_of_store__c = 'b1', job_order__c = jo1.id, job_cost__c = 100);
        js.add(j1);
        // job 2 - jo 1
        SFDC_Job__c j2 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test2', banner_of_store__c = 'b2', job_order__c = jo1.id, job_cost__c = 100);
        js.add(j2);
        // job 3 - jo 1
        SFDC_Job__c j3 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test2', banner_of_store__c = 'b2', job_order__c = jo1.id);
        js.add(j3);
        // job 4 - jo 2
        SFDC_Job__c j4 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test2', banner_of_store__c = 'b2', job_order__c = jo2.id, job_cost__c = 400);
        js.add(j4);
        // job 5 - jo 2
        SFDC_Job__c j5 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test2', banner_of_store__c = 'b2', job_order__c = jo2.id, job_cost__c = 400);
        js.add(j5); 
        insert js;
        system.assertequals([select count() from sfdc_job__c where job_status__c = 'Pending Order'], 5);
        // update both orders to Order Completed
        jos[0].status__c = 'Order Completed';
        jos[1].status__c = 'Order Completed';
        update jos;
        js = [select id, job_status__c, recordtype.name from sfdc_job__c where id in :js];
        system.debug('updated job status values: '+js);
        system.assertequals([select count() from sfdc_job__c where job_status__c = 'Open/Active Job'], 5);
    }
    
	// test chargent order after update - if status changes to Payment Complete, set all related jobs to Open/Active
    private static testmethod void testChargentOrder_Afterupdate(){
        list<job_order__c> jos = new list<job_order__c>();
        job_order__c jo1 = new job_order__c();
        jos.add(jo1);
        job_order__c jo2 = new job_order__c();
        jos.add(jo2);
        insert jos;
        
        list<Sfdc_job__c> js = new list<sfdc_job__c>();
        // job 1 - jo 1
        SFDC_Job__c j1 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test1', banner_of_store__c = 'b1', job_order__c = jo1.id, job_cost__c = 100);
        js.add(j1);
        // job 2 - jo 2
        SFDC_Job__c j2 = new SFDC_Job__C(job_status__c = 'Pending Order', Job_Title_for_Banner__c = 'test2', banner_of_store__c = 'b2', job_order__c = jo2.id, job_cost__c = 100);
        js.add(j2);
        insert js;
        // add chargent order to each job order
        list<ChargentOrders__ChargentOrder__c> cos = new list<ChargentOrders__ChargentOrder__c>();
        ChargentOrders__ChargentOrder__c charge1 = new ChargentOrders__ChargentOrder__c(job_order__c = jo1.id, ChargentOrders__Subtotal__c = 100, ChargentOrders__Status__c = 'Initiated');
		cos.add(charge1);
        ChargentOrders__ChargentOrder__c charge2 = new ChargentOrders__ChargentOrder__c(job_order__c = jo2.id, ChargentOrders__Subtotal__c = 100, ChargentOrders__Status__c = 'Initiated');
		cos.add(charge2);
        insert cos;
        // add transactions for full amount to each
        list<ChargentOrders__Transaction__c> tos = new list<ChargentOrders__Transaction__c>();
        ChargentOrders__Transaction__c t1 = new ChargentOrders__Transaction__c(ChargentOrders__Order__c = charge1.id, ChargentOrders__Type__c = 'Charge', 
                                                                               ChargentOrders__Amount__c = 100, ChargentOrders__Response_Status__c = 'Approved');
		tos.add(t1);
        ChargentOrders__Transaction__c t2 = new ChargentOrders__Transaction__c(ChargentOrders__Order__c = charge2.id, ChargentOrders__Type__c = 'Charge', 
                                                                               ChargentOrders__Amount__c = 100, ChargentOrders__Response_Status__c = 'Approved');
		tos.add(t2);
        insert tos;
        // job orders should be status of Order Completed
        jos = [select id, status__c from job_order__c where id in :jos];
        system.assertequals(jos[0].status__c, 'Order Completed');
        system.assertequals(jos[1].status__c, 'Order Completed');
        
    }

}