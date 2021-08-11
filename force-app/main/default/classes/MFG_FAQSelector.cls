public class MFG_FAQSelector extends fflib_SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            FAQ__c.id,
                FAQ__c.Name,
                FAQ__c.Body__c,
                FAQ__c.Display__c,
                FAQ__c.Title__c,
                FAQ__c.Title_FR__c,
                FAQ__c.Body_FR__c
                };
                    }
    
    
    public Schema.SObjectType getSObjectType(){
        return FAQ__c.sObjectType;
    }
    public List<FAQ__c> selectById(Set<ID> idSet){
        return (List<FAQ__c>) selectSObjectsById(idSet);
    }
    
    public List<FAQ__c> selectAllDisplayed(){
        assertIsAccessible();
        String yes='Yes';
        String query = String.format('select {0} FROM {1} WHERE Display__c=:yes ORDER BY ID ASC ', 
                                     new List<String>{
                                         getFieldListString(),
                                             getSObjectName()
                                             });
        
        system.debug(query);
        return (List<FAQ__c>) Database.query(query);
    }
}