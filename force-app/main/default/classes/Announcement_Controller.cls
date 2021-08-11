//Jeff Perron, Sept 23 2016
//Controller used for the portal page components below.
//It allows us to call the Utilities.IsReoccurringHoliday method.
//   Announcement_FGL_RPO_TC
//   Announcement_FGL_Special
//   Announcement_GotJunk
//   Announcement_ofg
//   Announcement_fr

public class Announcement_Controller {

    //getters/setters
    private final boolean isHoliday;
    public boolean getIsHoliday { 
        get
        {
             DateTime now = system.now(); 
             
             //check if today or next day is holiday
             return (Utilities.IsReoccurringHoliday(now));
             // || Utilities.IsReoccurringHoliday(now.addDays(1))); 
             //can add this later but for now we only show datetime.now on announcement page 
             //we would need to show the date geting passed in
        } 
        set{} 
    }
    
    private final string StatHolidayName;
    public string getStatHolidayName { 
        get
        {
             return Utilities.StatHolidayName;
        } 
        set{} 
    }

    //ctor 
    public Announcement_Controller() {
        
    }
   


}