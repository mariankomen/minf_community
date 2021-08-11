@isTest
public class MFG_UserProfileController_Test {
    @isTest
    public static void insertNotification(){ 
        
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        
        User userWithRole = (User)MFG_TestDataFactory.createsObject(new User(userroleid = r.id, profileid = UserInfo.getProfileId()),true);  
        System.runAs(userWithRole){
            System.Test.StartTest();
            
            sObject userDetails= MFG_UserProfileController.getUserDetails();
            system.assertNotEquals(null, userDetails);
            
            MFG_UserProfileController.UserPicklist opt= MFG_UserProfileController.getPiclistOptions();
            system.assertNotEquals(null, opt);
            
            MFG_UserProfileController.saveUserDetails(system.JSON.serialize(userWithRole));
            
            System.Test.StopTest();
        }
        
    }
    
}