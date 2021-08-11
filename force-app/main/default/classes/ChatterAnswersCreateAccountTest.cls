@isTest
private class ChatterAnswersCreateAccountTest {
  static testMethod void validateAccountCreation() {
    /* test failing as it queries for all users and then it happens that the first one they grabbed is inactive
        also would fail if we grabbed a portal user that can't own accounts.
        Changed to use current running user to pass test in Prod.
        Vankerk June 15/13
        
    User[] user = [SELECT Id, Firstname, Lastname from User];
    // We cannot create account without a user.
    if (user.size() == 0) { return; }
    */
    User currUser = [select id, firstname, lastname from user where id = :UserInfo.getuserid()];
    String firstName = currUser.FirstName;
    String lastName = currUser.LastName;
    String userId = currUser.Id;
    String accountId = new ChatterAnswers().createAccount(firstName, lastName, userId);
    Account account = [SELECT name, ownerId from Account where Id =: accountId];
    System.assertEquals(firstName + ' ' + lastName, account.name);
    System.assertEquals(userId, account.ownerId);
  }
}