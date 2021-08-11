/*******
Class: JobOrder Tab, controller for VF page used by Portal users to view Job Orders
Description: query all the job orders they can see that are Pending or Complete, includes sorting columns and standard set paging

Created: February 2015, Vankerk Solutions
Modification Log:

 *******/
public with sharing class JobOrder_Tab {
   
    // constructor that builds query with default sort settings
    public JobOrder_Tab() {
        BuildQuery();
    }
    public String SortFieldSave;

    /***
    * StdSetControllerOrder - paging through the Order list
    ***/ 
    public ApexPages.StandardSetController StdSetControllerOrder {
        get {
            if(StdSetControllerOrder == null) {
                StdSetControllerOrder = new ApexPages.StandardSetController(Database.getQueryLocator(QueryOrder));
                // sets the number of records in each page set
                StdSetControllerOrder.setPageSize(15);
            }
            return StdSetControllerOrder;
        }
        set;
    }
    
    /***
    * getCurrentOrderList - return an Order list for the table
    ***/  
    public list<Job_Order__c> getCurrentOrderList() {

        OrderList = (list<Job_Order__c>)StdSetControllerOrder.getRecords();
        return OrderList;
    }  
    
    private list<Job_Order__c> OrderList {get; set;}
    private String QueryOrder;
    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        StdSetControllerOrder = null;

        QueryOrder = 'SELECT Id, Name, status__c, job_title__c, createddate, order_amount__c, order_total__c, tax_amount__c ' +
            ' FROM Job_Order__c where status__c = \'Order Completed\' or status__c = \'Pending Payment\' '; 
 
        QueryOrder += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
 
        system.debug('QueryOrder:' + QueryOrder);
    }
    
    /***
    * SortDirection - return sort direction. Default ascending(asc)
    ***/
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
 
    /***
    * SortField - return sort by field. Default to Name
    ***/
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; SortFieldSave = 'Name'; } return SortField;  }
        set; 
    }
 
    /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset sort sequence if sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }
}