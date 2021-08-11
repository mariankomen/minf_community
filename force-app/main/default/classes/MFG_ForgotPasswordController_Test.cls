@IsTest
public class MFG_ForgotPasswordController_Test {
    @IsTest
    static void testLightningForgotPasswordControllerInvalidUserName() {
        System.assertEquals(MFG_ForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email);
        System.assertEquals(MFG_ForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email);
        System.assertEquals(MFG_ForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email);
    }
    
    @IsTest
    static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
        System.assertEquals(MFG_ForgotPasswordController.forgotPassword('a', null), 'Argument 1 cannot be null');
        System.assertEquals(MFG_ForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null');
    }
    
    @IsTest
    static void LightningForgotPasswordControllerInstantiation() {
        MFG_ForgotPasswordController controller = new MFG_ForgotPasswordController();
        String ExperienceId=   MFG_ForgotPasswordController.setExperienceId('ExperienceId');
        System.assertNotEquals(controller, null);
    }
}