public class JobListHelp {
    
    public string Language {get; set;}
    
    public JobListHelp() {
        Language = UserInfo.getLanguage();    
    }

}