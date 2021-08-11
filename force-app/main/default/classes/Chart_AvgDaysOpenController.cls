/******************
Class: Chart - Avg Days Open Controller for VF Component
Description:  Finds all Jobs the user can see Filled last month and group them Job Title with average time to Send and Send to Close number of days
           
Created: Oct 25 2013, Vankerk Solutions
Modification Log

******************/
public with sharing class Chart_AvgDaysOpenController {

    // avg days open to send and send to fill
    // closed last month - using date Job Filled but this is blank if not filled.  what happens to job opened to filled if not filled, just closed?
    public List<AvgDaysData> getAvgDaysData(){
        List<AvgDaysData> results = new List<AvgDaysData>();
        // cycle through aggregated jobs and add rows
        for (AggregateResult ar : [select avg(TTS_Time_to_Send_Numerical__c) TimetoSend , avg(TTS_Time_to_Decide_by_Store_Numerical__c) SendtoClose, chart_Job_Title__c JobTitle 
                                    from SFDC_Job__c 
                                    where (manager_is_me__c = 'Yes' or My_Stores_Job__c = 'Yes') and chart_job_title__c != null and (date_job_filled__c = LAST_MONTH or Date_Job_Not_Filled_by_Store__c = LAST_MONTH)
                                    group by chart_job_title__c])
            results.add(new AvgDaysData((decimal) ar.get('TimetoSend'), (decimal) ar.get('SendtoClose'), (string) ar.get('JobTitle')) );
        // if we don't have any data, add 1 row
        if (results.size() == 0)
            results.add(new AvgDaysData(0,0,'None'));
        return results;
    }

    public integer getAvgDaysData_Size() {
        return getAvgDaysData().size();
    }
    
    // using wrapper class instead of sending Aggregate Data over so we can fill in an empty row if none are found
    public class AvgDaysData{
        public decimal TimetoSend {get; set;}
        public decimal SendtoClose {get; set;}
        public string JobTitle {get; set;}
        
        public AvgDaysData(decimal Send, decimal Close, string Title){
            TimetoSend = (Send == null ? 0 : Send);
            SendtoClose = (Close == null ? 0 : Close);
            JobTitle = (Title.length() > 20 ? title.left(20) : title);
        }
    }
}