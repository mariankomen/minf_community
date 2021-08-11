/********************
Class: Reset Portal Password, controller for VF page
Description: basic class to allow a portal user with the custom header HTML to reset their password.  Action method called the resetpassword with email setting and     sends the user to the Logout page.    
Created: Feb 14/12, Vankerk Solutions
Modification Log:
********************/

public class ResetPortalPwd {

// action method for page to call reset method and send user to the logout screen
public PageReference ResetPwd() {
// call reset function, but only when not testing as this kicks the deploying user out of the system (annoying)
if (!test.isrunningtest())system.resetPassword(userinfo.getuserid(), true);

// send user to the Logout page
return new PageReference('/secur/logout.jsp');
}


}