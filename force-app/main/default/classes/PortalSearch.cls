/***********
Class: Portal Search
Description: Used in portal, users can search through various fields on Job or Candidate.  Search terms are currently searched as one text block with 
    wildcard * on front and back.  Called from sidebar component or can be used directly as a tab.
    
Created: Jan 28 2013, Vankerk Solutions.
Modification Log:
    Mar 13 2013: Added support to sort by any column displayed for job or candidate search results
    
***********/
public with sharing class PortalSearch{

    // job query fields
    public ApexPages.StandardSetController Jobresults {get; set;}
    public List<SFDC_Job__c> JobRecs {get; set;}
    public integer numJobRecs {get; set;}
    public boolean JobEditable {get; set;}
    // the column to sort jobs by and which direction (ASC, DESC)
    public String JobsortBy { get; set; }
    public String JobsortDir { get; set; }
    // candidate query fields
    public ApexPages.StandardSetController Canresults {get; set;}
    public List<SFDC_Job_Candidate__c> CanRecs {get; set;}
    public integer numCanRecs {get; set;}
    public boolean CanEditable {get; set;}
    // the column to sort candidates by and which direction (ASC, DESC)
    public String CansortBy { get; set; }
    public String CansortDir { get; set; }
            
    public string searchterms {get; set;}
    
    // constructor to default page field values
    public PortalSearch(){
        searchterms = '';
        // if parameter called searchTerms is present, default value
        if (ApexPages.currentpage().getparameters().get('searchTerms') != null)
            searchterms = ApexPages.currentpage().getparameters().get('searchTerms');
        numJobRecs = 0;  
        numCanRecs = 0;  
        
        // determine if user can edit Jobs or Candidates
        Schema.DescribeSObjectResult JobObj  = SFDC_Job__c.sObjectType.getDescribe();
        JobEditable = JobObj.isUpdateable();
        Schema.DescribeSObjectResult CanObj  = SFDC_Job_Candidate__c.sObjectType.getDescribe();
        CanEditable = CanObj.isUpdateable(); 
        Jobsortby  = 'Name';
        Jobsortdir = 'DESC';
        Cansortby  = 'Candidate_Name_Last_First__c';
        Cansortdir = 'ASC';        
    }
    
    // when page is first rendered, this function will call the Search if there is a default search term
    //  used so that when called from sidebar it will actually run the search function
    public pageReference initialSearch() {
        // if parameter called searchTerms is present, default value
        if (ApexPages.currentpage().getparameters().get('searchTerms') != null)
            return search();        
        return null;
    }
    
    // main search function.  At least 3 characters are required, then query in Job and Candidate for results.  Currently limited to 40
    public pageReference search(){
        string QryJob = '';
        string QryCan = '';
        try {
            // must have at least 3 characters to search
            if (searchterms == '' || searchterms.length() < 3) {
                return null;
                // since we are searching as the user types, don't present error message, just let them keep typing
            }
            // search for Jobs where My Stores Job or Manager is Me is Yes, Job Visible to Portal user and search terms is found in Job ID, Job Title or Location
            QryJob = 'select id, Name, New_Job_Title__c, Store_Name_Number__c, job_status__c, Days_Job_Open__c, Hiring_Manager_Name__c from SFDC_Job__c'+
                ' where ( My_Stores_Job__c = \'Yes\' or Manager_is_Me__c = \'Yes\' ) and Job_Visible_to_Portal_User__c = \'Yes\' and (' + 
                ' name like \'%' + string.escapeSingleQuotes(searchterms) + '%\' or '+
                ' new_job_title__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' or '+
                ' Store_Name_Number__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' ) order by name desc limit 40';
                
            // Mar 2013: was using standardsetcontroller for search but we can't seem to resort the results of the getRecords() command (collection is read only)
            //    so since we only want the top 40 rows without pagination and we do want sorting, went with just a dynamic query into a list
            //Jobresults = new ApexPages.StandardSetController(Database.getQueryLocator(QryJob));
            //Jobresults.setpagesize(40);
            //JobRecs = (List<SFDC_Job__c>) Jobresults.getrecords();
            JobRecs = Database.Query(QryJob);
            numJobRecs = JobRecs.size();
            
            // search for Candidates where related Job's My Stores Job or Manager is Me is Yes and Job Visible to Poartal User is yes and search terms is found in Job ID, 
            //   Job Title, Candidate name or email
            // NOTE: any column that is displayed on the results page and needs to be sortable must be a field within the Candidate object.  So we should find formula
            // fields on the Candiate to pull fields from the Job, like job_status__c instead of sfdc_job__r.job_status__c.
            QryCan = 'select id, Job_Record_Type_Developer_Name__c, Candidate_Email__c, Candidate_Name__c, Candidate_Name_Last_First__c, sfdc_job__c, Job_ID__c, Job_Status__c, Job_Title__c,  '+
                ' Location__c, date_candidate_sent_applied__c, Status_Details__c, sfdc_job__r.sla_level__c from SFDC_Job_Candidate__c'+
                ' where ( sfdc_job__r.My_Stores_Job__c = \'Yes\' or sfdc_job__r.Manager_is_Me__c = \'Yes\' ) and sfdc_job__r.Job_Visible_to_Portal_User__c = \'Yes\' and ( '+
                ' Candidate_Name__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' or '+
                ' Job_ID__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' or '+                
                ' Job_Title__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' or '+
                ' Candidate_Email__c like \'%' + string.escapeSingleQuotes(searchterms) + '%\' ) order by Candidate_Name_Last_First__c limit 40';            
            
            // Mar 2013: was using standardsetcontroller for search but we can't seem to resort the results of the getRecords() command (collection is read only)
            //    so since we only want the top 40 rows without pagination and we do want sorting, went with just a dynamic query into a list
            // Canresults = new ApexPages.StandardSetController(Database.getQueryLocator(QryCan));
            //Canresults.setpagesize(40);
            //CanRecs = (List<SFDC_Job_Candidate__c>) Canresults.getrecords();
            CanRecs = Database.Query(QryCan);            
            numCanRecs = CanRecs.size();            
        } catch (Exception e) {
            ApexPages.addMEssage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There was an error running your search.  Please contact MindField Group with the following error: '+
                e.getstacktracestring()+': '+e));
        }
        return null;
    }
  
    // called by clicking headers in Job results list
    public PageReference sortJobList() { 
        sortlist(JobRecs, 'Job');
        return null; 
    }
    
    // called by clicking headers in Candidates results list
    public PageReference sortCanList() { 
        sortlist(CanRecs, 'Candidate');
        return null; 
    }    

    // The sorting function works on all SObjects sorting on all fields
    // we are passing in the object name so we know which sortBy and sortDir value to use
    private List<SObject> sortList(List<SObject> cleanList, string objName) {
        string sortBy;
        string sortDir;
        // if our list contains jobs, use the JobsortBy/sortDir
        if (objName == 'Job') {
            sortBy = JobsortBy;
            sortDir = JobSortDir;
        }
        else if (objName == 'Candidate') {
            sortBy = CansortBy;
            sortDir = CanSortDir;    
        }
        // return the clean list if we don't have a sort field defined
        if (sortBy == null) { return cleanList; }
        // create an empty result List
        List<SObject> resultList = new List<SObject>();
        // and an object map which will be sorted
        Map<Object, List<SObject>> objectMap = new Map<Object, List<SObject>>();
        // now loop through the clean list and create the object map
        for (SObject item : cleanList) {
            // if we don't have a map entry for this items sortby field value, add it to the map
            if (objectMap.get(item.get(sortBy)) == null)
                objectMap.put(item.get(sortBy), new List<SObject>());
            // now add this record to the list for this sortby field value
            objectMap.get(item.get(sortBy)).add(item);
        }
        // get all the keys from the object map and sort them
        List<Object> keys = new List<Object>(objectMap.keySet());
        keys.sort();

        // now create a result list by adding all objects from the object map
        // in the sorted order
        for(Object key : keys) {
            resultList.addAll(objectMap.get(key));
        }
        // clear the clean list
        cleanList.clear();
        // depending on the direction add the items in the correct sorting to the clean list
        if (sortDir == 'ASC') {
          for (SObject item : resultList) {
            cleanList.add(item);
          }
        } else {
          for (Integer i = resultList.size()-1; i >= 0; i--) {
            cleanList.add(resultList[i]);
          }
        }
        // return the clean and now sorted list
        return cleanList;
    }
      
   
}