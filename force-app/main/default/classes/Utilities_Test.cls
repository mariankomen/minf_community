//Jeff Perron - Sept 24, 2016
//Test class for new utilites class

@isTest
private class Utilities_Test {


    static testmethod void test() {

        Test.startTest();
        
        //start test on IsReoccurringHoliday functionallity----------------------------------------------
        DateTime d = DateTime.newInstanceGMT(2016, 12, 25);
        boolean b = Utilities.IsReoccurringHoliday(d);
        //System.assertEquals(b, true); // christmas
        string day = Utilities.StatHolidayName; //Get name 
        //System.assertEquals(day, 'Christmas Day');
 
        d = DateTime.newInstanceGMT(2017, 8, 22); // Labour Day 2017
        b = Utilities.IsReoccurringHoliday(d);
        d = DateTime.newInstanceGMT(2018, 8, 28); // Labour Day 2018
        b = Utilities.IsReoccurringHoliday(d);
        d = DateTime.newInstanceGMT(2019, 8, 27); // Labour Day 2019
        b = Utilities.IsReoccurringHoliday(d);
        d = DateTime.newInstanceGMT(2020, 8, 25); // Labour Day 2020
        b = Utilities.IsReoccurringHoliday(d);
        //System.assertEquals(b, true); // Labour Day
        day = Utilities.StatHolidayName; //Get name 
        //System.assertEquals(day, 'Canada Day');
        
        //d = DateTime.newInstanceGMT(2016, 1, 1);
        //b = Utilities.IsReoccurringHoliday(d);
       // System.assertEquals(b, true); // New Years Day
        //day = Utilities.StatHolidayName; //Get name 
        //System.assertEquals(day, 'New Year\'s Day');
        //STOP test on IsReoccurringHoliday functionallity----------------------------------------------
 
        Test.stopTest();

   }

}