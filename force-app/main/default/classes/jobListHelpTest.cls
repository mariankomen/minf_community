@istest
private class jobListHelpTest{
@istest
    static void jobListHelpTest(){
        JobListHelp test = new JobListHelp();
        string lang = UserInfo.getLanguage();
        system.assertequals(lang, test.Language);
    }
    }