public class Apex_Clone_Job_Controller {
    @AuraEnabled
    public static List<sObject> executeQuery(String theQuery){
        try{
            String query = String.escapeSingleQuotes(theQuery);
            return Database.query(query);
       }catch(Exception e){
            throw new AuraHandledException('Error doing the query: '+theQuery+' Error: '+e.getMessage());
        }
    }
}