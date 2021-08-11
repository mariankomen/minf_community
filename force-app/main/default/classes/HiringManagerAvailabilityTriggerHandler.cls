public class HiringManagerAvailabilityTriggerHandler extends fflib_SObjectDomain{
    public HiringManagerAvailabilityTriggerHandler(List<SObject> records){
        super(records); 
    }
    
    
    public override void onAfterInsert(){
        try{
            List<Hiring_Manager_Availability__c> resultList = new List<Hiring_Manager_Availability__c>();
            
            
            for(MFG_Hiring_Manager_Availability__c hra :(List<MFG_Hiring_Manager_Availability__c>)records) {
                
                
                Date resultStartDate =hra.Interview_Start_Date__c;
                Date resultEndDate = hra.Recurrence_Ends_On__c;
                system.debug(resultStartDate);
                system.debug(resultEndDate);
                
                
                if(resultStartDate == resultEndDate){
                    system.debug('resultStartDate.date() == resultEndDate.date()');
                    Hiring_Manager_Availability__c hiringManagerAvailability = new Hiring_Manager_Availability__c();
                    
                    hiringManagerAvailability.Hiring_Managers_Store__c = hra.Hiring_Managers_Store__c;
                    hiringManagerAvailability.Interview_Duration__c = hra.Interview_Duration__c;
                    hiringManagerAvailability.Interviewer_s_Available__c = hra.Interviewer_s_Available__c;
                    hiringManagerAvailability.Start_Date__c = Datetime.newInstance(resultStartDate,hra.Start_Time__c);
                    hiringManagerAvailability.End_Date__c = Datetime.newInstance(resultEndDate,hra.End_Time__c);
                    
                    
                    hiringManagerAvailability.MFG_Interview_Start_Date__c=resultStartDate;
                    hiringManagerAvailability.MFG_Start_Time__c=hra.Start_Time__c;
                    
                    hiringManagerAvailability.MFG_Recurrence_Ends_On__c=resultEndDate;
                    hiringManagerAvailability.MFG_End_Time__c=hra.End_Time__c;
                    
                    
                    
                    
                    resultList.add(hiringManagerAvailability); 
                }else{
                    while (resultStartDate <= resultEndDate) {
                        if(hra.Recurs_every_week_on__c!=null && hra.Recurs_every_week_on__c.contains(Datetime.newInstance(resultStartDate,hra.Start_Time__c).format('EEEE')) ){
                            
                            Hiring_Manager_Availability__c hiringManagerAvailability = new Hiring_Manager_Availability__c();
                            
                            hiringManagerAvailability.Hiring_Managers_Store__c = hra.Hiring_Managers_Store__c;
                            hiringManagerAvailability.Interview_Duration__c = hra.Interview_Duration__c;
                            hiringManagerAvailability.Interviewer_s_Available__c = hra.Interviewer_s_Available__c;
                            
                            
                            DateTime startDateTime=Datetime.newInstance(resultStartDate,hra.Start_Time__c);
                            DateTime endDateTime=Datetime.newInstance(resultStartDate,hra.End_Time__c);
                            
                            hiringManagerAvailability.Start_Date__c = startDateTime;
                            hiringManagerAvailability.End_Date__c = endDateTime;
                            hiringManagerAvailability.MFG_Interview_Start_Date__c=resultStartDate;
                            hiringManagerAvailability.MFG_Start_Time__c=hra.Start_Time__c;
                            
                            hiringManagerAvailability.MFG_Recurrence_Ends_On__c=resultEndDate;
                            hiringManagerAvailability.MFG_End_Time__c=hra.End_Time__c;
                            resultStartDate= resultStartDate.addDays(1);
                            resultList.add(hiringManagerAvailability);
                        }else{
                            resultStartDate= resultStartDate.addDays(1);
                        }
                        
                    }   
                }
                
                
            }   
            system.debug(resultList.size());
            insert resultList;
        }Catch(Exception e){
            system.debug(e);
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new HiringManagerAvailabilityTriggerHandler(sObjectList);
        }
    }
}