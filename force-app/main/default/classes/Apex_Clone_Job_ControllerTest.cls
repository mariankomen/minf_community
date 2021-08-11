@isTest
public with sharing class Apex_Clone_Job_ControllerTest {

    private static testmethod void executeQueryTest(){
        Apex_Clone_Job_Controller.executeQuery('SELECT Id FROM Usesr');
    }
}