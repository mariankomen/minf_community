/******************
Class: Chart - Hiring Funnel Controller for VF Component
Description:  Finds all Candidates hired or rejected last month that the user can see and sum the number that were sent, interviewed and hired
           
Created: Oct 25 2013, Vankerk Solutions
Modification Log

******************/
public with sharing class Chart_HiringFunnelController {

    public List<HiringFunnel> getHiringFunnelData(){
        try {
            List<HiringFunnel> results = new List<HiringFunnel>();
            // using wrapper class to provide a name for Status axis, since we have nothing to group on
            AggregateResult ar = [select SUM(Candidate_Sent__c) Sent, SUM(Candidate_Interviewed__c) Interviewed, SUM(Hired__c) Hired
                from SFDC_Job_Candidate__c
                where (Hire_Date__c = last_month or Date_Candidate_Rejected__c = last_month) and (manager_is_me__c = 'Yes' or my_stores_job__C = 'Yes')];
            
            // build row for each metric - if no jobs found these will all go to 0 in chart
            results.add(new HiringFunnel((decimal) ar.get('Hired'), 'Hired') );
            results.add(new HiringFunnel((decimal) ar.get('Interviewed'), 'Interviewed') );
            results.add(new HiringFunnel((decimal) ar.get('Sent'), 'Sent') );

            return results;
        } catch (Exception e) {
            apexpages.addmessage(new apexpages.message(apexpages.severity.fatal, 'There was an error building the Hiring Funnel chart: '+e));
            return null;
        }
    }
    
    public integer getHiringFunnelData_Size() {
        return getHiringFunnelData().size();
    }
    
    // wrapper class to take a single aggregate result and break into 3 data series for charting
    public class HiringFunnel{
        public string name {get; set;}
        public integer recCount {get; set;}
        // pass in name (Sent, Interviewed, Hired) and count
        public HiringFunnel(decimal ct, string nm) { 
            try {
                name = nm; 
                recCount = (ct == null ? 0 : ct.intvalue());
            } catch (Exception e) {
                apexpages.addmessage(new apexpages.message(apexpages.severity.fatal, 'There was an error building the Hiring Funnel chart: '+e));
            }                
        }
    }    

}