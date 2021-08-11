//Jeff Perron - Sept 24, 2016
//Test class for Announcement_Controller

@isTest
private class Announcement_Controller_Test {


    static testmethod void test() {

        Test.startTest();
        
        PageReference pageRef = Page.Announcement_FGL_Special;
        Test.setCurrentPage(pageRef);
   
        Announcement_Controller controller = new Announcement_Controller();

        boolean b = controller.getIsHoliday;
        string s = controller.getStatHolidayName;
         
        Test.stopTest();
   }

}