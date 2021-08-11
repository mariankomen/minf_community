/*
Date Created: August 31, 2016
Author: Jeff Perron
Purpose: Encapsulate commom functionalities to be accessed by other classes.
*/

public class Utilities {

    //Method returns whether or not date passed in is a reoccuring holiday 
    //according to reoccuring holidays as scheduled in SF------------------------------------------------------------------------------------------
    public static boolean IsReoccurringHoliday(Datetime dateTimeToCheck) {
    
        Date dateToCheck = date.newinstance(dateTimeToCheck.year(), dateTimeToCheck.month(), dateTimeToCheck.day());

       //find all yearly reoccuring holidays
       List<Holiday> reoccurringHolidays=[SELECT h.Name, h.ActivityDate, h.RecurrenceType, h.RecurrenceMonthOfYear, h.RecurrenceDayOfMonth, h.RecurrenceDayOfWeekMask, h.RecurrenceInstance, h.RecurrenceEndDateOnly, h.RecurrenceStartDate FROM Holiday h 
                                          WHERE h.IsRecurrence =: true AND
                                                h.RecurrenceStartDate <=: dateToCheck AND
                                                (h.RecurrenceType =: 'RecursYearly' OR h.RecurrenceType =: 'RecursYearlyNth')];
        
        if(reoccurringHolidays.Size() > 0) {    
            if(isHolidayToday(dateTimeToCheck, reoccurringHolidays)) { //determine if holiday is TODAY
                return true;
            }  
        }   
    
        return false;
    }
    
    //holiday name is set here so can be displayed in anncouncement pages
    public static string StatHolidayName { 
        get
        {
            return StatHolidayName;
        } 
        set{
            StatHolidayName = value;
        } 
    }
        
    private static boolean isHolidayToday(DateTime dateTimeToCheck, List<Holiday> rh) {
       //loop through reoccuring yearly holidays
       for(Holiday h:rh) {
           //date reoccurs same date every year and not past end date
           if(h.RecurrenceType == 'RecursYearly' && (h.RecurrenceEndDateOnly==null || h.RecurrenceEndDateOnly >= dateTimeToCheck)) {
               //find month and day
               if(dateTimeToCheck.month() == findMonth(h.RecurrenceMonthOfYear) && dateTimeToCheck.day() == h.RecurrenceDayOfMonth) {
                   StatHolidayName = h.Name;
                   return true; //if found, jump out of loop and return right away
               }
           }
           //date reoccurs the nth day of a month and not past end date (For multiday recurring events, RecurrenceEndDateOnly is the day on which the last occurrence starts.) 
           else if(h.RecurrenceType == 'RecursYearlyNth' && (h.RecurrenceEndDateOnly==null || h.RecurrenceEndDateOnly.addYears(1) >= dateTimeToCheck)) {
               if(isTodayRecurrenceDay(h, dateTimeToCheck)) {
                   StatHolidayName = h.Name;
                   return true; //if found, jump out of loop and return right away
               }
           }
       }
       return false;
    }
   
    private static boolean isTodayRecurrenceDay(Holiday h, Datetime dateTimeToCheck) {
        if(
            //does holiday occurence and today in same month
            findMonth(h.RecurrenceMonthOfYear) == dateTimeToCheck.Month()
            &&
            (
            h.RecurrenceDayOfWeekMask == 127 && //is holiday mask nth day of the month
            (
                    h.RecurrenceInstance == 'First' && dateTimeToCheck.day() == 1  || //first day of month
                    h.RecurrenceInstance == 'Second' && dateTimeToCheck.day() == 2 || //second day of month
                    h.RecurrenceInstance == 'Third' && dateTimeToCheck.day() == 3  || //third day of month
                    h.RecurrenceInstance == 'Fourth' && dateTimeToCheck.day() == 4 || //fourth day of month
                    h.RecurrenceInstance == 'Last' && dateTimeToCheck.day() == Date.daysInMonth(dateTimeToCheck.year(), dateTimeToCheck.month()) //last day of month
            )
            ||
            (
                isnthWeekofMonth(dateTimeToCheck, h.RecurrenceDayOfWeekMask, h.RecurrenceInstance)
            
                /*
                (
                    //is the day the same
                    (h.RecurrenceDayOfWeekMask == 1 && integer.valueof(dateTimeToCheck.format('u')) == 7)  || //is holiday mask and today a Sunday
                    (h.RecurrenceDayOfWeekMask == 2 && integer.valueof(dateTimeToCheck.format('u')) == 1)  || //is holiday mask and today a Monday
                    (h.RecurrenceDayOfWeekMask == 4 && integer.valueof(dateTimeToCheck.format('u')) == 2)  || //is holiday mask and today a Tuesday
                    (h.RecurrenceDayOfWeekMask == 8 && integer.valueof(dateTimeToCheck.format('u')) == 3)  || //is holiday mask and today a Wednesday
                    (h.RecurrenceDayOfWeekMask == 16 && integer.valueof(dateTimeToCheck.format('u')) == 4) || //is holiday mask and today a Thursday
                    (h.RecurrenceDayOfWeekMask == 32 && integer.valueof(dateTimeToCheck.format('u')) == 5) || //is holiday mask and today a Friday
                    (h.RecurrenceDayOfWeekMask == 64 && integer.valueof(dateTimeToCheck.format('u')) == 6)    //is holiday mask and today a Saturday
                 ) 
                &&
                 (
                     //is the week of the month the same
                     (h.RecurrenceInstance == 'First' && integer.valueof(dateTimeToCheck.format('W')) == 1)  || //is holiday occurrence and today in first week of the month
                     (h.RecurrenceInstance == 'Second' && integer.valueof(dateTimeToCheck.format('W')) == 2) || //is holiday occurrence and today in second week of the month
                     (h.RecurrenceInstance == 'Third' && integer.valueof(dateTimeToCheck.format('W')) == 3)  || //is holiday occurrence and today in third week of the month
                     (h.RecurrenceInstance == 'Fourth' && integer.valueof(dateTimeToCheck.format('W')) == 4) || //is holiday occurrence and today in fourth week of the month
                     (h.RecurrenceInstance == 'Last' && integer.valueof(dateTimeToCheck.format('W')) == 5)      //is holiday occurrence and today last week of the month
                 )
                 */
             ))
          ) 
          { 
              return true;
          }
        return false;
    }
      
    private static boolean isnthWeekofMonth(DateTime dateTimeToCheck, integer RecurrenceDayOfWeekMask, string holidaynthWeek) {
        Date dateToCheck = date.newinstance(dateTimeToCheck.year(), dateTimeToCheck.month(), dateTimeToCheck.day());
        
        //determine day of week in holiday from mask
        integer dayOfWeek=1;
        if(RecurrenceDayOfWeekMask == 1)
            dayOfWeek = 7; //Sunday
        else if(RecurrenceDayOfWeekMask == 2)
            dayOfWeek = 1; //Monday
        else if(RecurrenceDayOfWeekMask == 4)
            dayOfWeek = 2; //Tuesday
        else if(RecurrenceDayOfWeekMask == 8)
            dayOfWeek = 3; //Wednesday
        else if(RecurrenceDayOfWeekMask == 16)
            dayOfWeek = 4; //Thursday
        else if(RecurrenceDayOfWeekMask == 32)
            dayOfWeek = 5; //Friday
        else if(RecurrenceDayOfWeekMask == 64)
            dayOfWeek = 6; //Saturday
        
        //determine number of days to add to get to nth week of the month     
        integer daysToAdd=0; 
        if(holidaynthWeek == 'First')
            daysToAdd = 0; //add 0 days
        else if(holidaynthWeek == 'Second')
            daysToAdd = 7; //Add one week
        else if(holidaynthWeek == 'Third')
            daysToAdd = 14; //Add two weeks
        else if(holidaynthWeek == 'Fourth')
            daysToAdd = 21; //Add three weeks 
        else if(holidaynthWeek == 'Last') {
            //if adding four weeks to date goes over number of days in month and month is still the same
            if(Date.daysInMonth(dateToCheck.year(), dateToCheck.month()) >= dateToCheck.addDays(28).day() &&
               dateToCheck.Month() == dateToCheck.addDays(28).Month()) {
                daysToAdd = 28; //Add four weeks 
            }
            else {
                daysToAdd = 21; //Add three weeks
            }
        }    
        
        //gives us first day of the month, day determined by dayOfWeek.
        //eg: if dayOfWeek=1, then we would have first Monday of the month
        //    if dayOfWeek=3, then we would have first Wednesday of the month
        Date firstDayofWeek = dateToCheck.toStartOfMonth().toStartOfWeek().addDays(dayOfWeek);    
        //add a week if "firstMonday" is in last month    
        if(firstDayofWeek < dateToCheck.toStartOfmonth()) {
            firstDayofWeek = firstDayofWeek.addDays(7);
        }
        
        Date nthWeekofTheMonth = firstDayofWeek.addDays(daysToAdd);
        return (nthWeekofTheMonth == dateToCheck);
    }  
      
    //RecurrenceMonthOfYear returns string, so we need to find numeric representation of month
    private static integer findMonth(string m) {
       if(m == 'January') {
           return 1;
       }
       else if(m == 'February') {
           return 2;
       }
       else if(m == 'March') {
           return 3;
       }
       else if(m == 'April') {
           return 4;
       }
       else if(m == 'May') {
           return 5;
       }
       else if(m == 'June') {
           return 6;
       }
       else if(m == 'July') {
           return 7;
       }
       else if(m == 'August') {
           return 8;
       }
       else if(m == 'September') {
           return 9;
       }
       else if(m == 'October') {
           return 10;
       }
       else if(m == 'November') {
           return 11;
       }
       else { //december
           return 12;
       }
   }
   //END hiliday methods--------------------------------------------------------------------------------------------------------------------------------

}