public class InterviewAvailabilityTriggerHandler extends fflib_SObjectDomain{
    public InterviewAvailabilityTriggerHandler(List<SObject> records){
        super(records); 
    }
    
    
    public override void onBeforeInsert() {
        setInterviewAvailabilityFields(records);
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        for(Hiring_Manager_Availability__c hma:(List<Hiring_Manager_Availability__c>)records){
            
          Hiring_Manager_Availability__c oldhma = (Hiring_Manager_Availability__c)existingRecords.get(hma.Id);
            
            if((hma.MFG_Interview_Start_Date__c!=oldhma.MFG_Interview_Start_Date__c || 
               hma.MFG_Start_Time__c!=oldhma.MFG_Start_Time__c ||
               hma.MFG_Recurrence_Ends_On__c!=oldhma.MFG_Recurrence_Ends_On__c || 
               hma.MFG_End_Time__c!=oldhma.MFG_End_Time__c) && hma.MFG_Interview_Start_Date__c!=null && hma.MFG_Start_Time__c!=null &&
               hma.MFG_Recurrence_Ends_On__c!=null && hma.MFG_End_Time__c!=null
               ){
                   
                   hma.Start_Date__c=Datetime.newInstance(hma.MFG_Interview_Start_Date__c,hma.MFG_Start_Time__c); 
                   hma.End_Date__c=Datetime.newInstance(hma.MFG_Recurrence_Ends_On__c,hma.MFG_End_Time__c); 
               }
              
            
            
           /* if( (hma.Start_Date__c!=oldhma.Start_Date__c && hma.Start_Date__c!=null) || 
               (hma.End_Date__c!=oldhma.End_Date__c && hma.End_Date__c!=null)
              ){*/
            if( hma.Start_Date__c!=null && hma.End_Date__c!=null){
                  hma.MFG_Interview_Start_Date__c=hma.Start_Date__c.date();
                  hma.MFG_Start_Time__c=hma.Start_Date__c.time();
                  hma.MFG_Recurrence_Ends_On__c=hma.End_Date__c.date();
                  hma.MFG_End_Time__c=hma.End_Date__c.time();  
              }
            
            
            
        }
        
        
      
    }
    

    
    public static void setInterviewAvailabilityFields(List<SObject> sobjs){
        for(Hiring_Manager_Availability__c hma:(List<Hiring_Manager_Availability__c>)sobjs){           
            if(hma.MFG_Interview_Start_Date__c==null && hma.MFG_Start_Time__c==null &&
               hma.MFG_Recurrence_Ends_On__c==null && hma.MFG_End_Time__c==null && hma.Start_Date__c!=null && hma.End_Date__c!=null
              ){
                  hma.MFG_Interview_Start_Date__c=hma.Start_Date__c.date();
                  hma.MFG_Start_Time__c=hma.Start_Date__c.time();
                  hma.MFG_Recurrence_Ends_On__c=hma.End_Date__c.date();
                  hma.MFG_End_Time__c=hma.End_Date__c.time();
              }
            if(hma.MFG_Interview_Start_Date__c!=null && hma.MFG_Start_Time__c!=null &&
               hma.MFG_Recurrence_Ends_On__c!=null && hma.MFG_End_Time__c!=null && hma.Start_Date__c==null && hma.End_Date__c==null
              ){
                  hma.Start_Date__c=Datetime.newInstance(hma.MFG_Interview_Start_Date__c,hma.MFG_Start_Time__c); 
                  hma.End_Date__c=Datetime.newInstance(hma.MFG_Recurrence_Ends_On__c,hma.MFG_End_Time__c); 
              }
        }
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new InterviewAvailabilityTriggerHandler(sObjectList);
        }
    }
}