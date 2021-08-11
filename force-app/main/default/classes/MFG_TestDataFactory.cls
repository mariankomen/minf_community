@isTest
public class MFG_TestDataFactory {

static Integer[] charset;
    // static initialization brace for random string generation
    static {
        charset = new Integer[0];
        for(Integer i = 48; i < 58; i++) charset.add(i);
        for(Integer i = 65; i < 91; i++) charset.add(i);
        for(Integer i = 97; i < 123; i++) charset.add(i);
    }

    /* A utility method for returning a randomized
*  a-zA-Z0-9 strings of specified length
*
*  @param  len    - requested string length
*  @return String - randomized string
*/
    public static String genRndStrFast(Integer len) {
        Integer[] chars = new Integer[len];
        Integer key, size = charset.size();

        for(Integer idx = 0; idx < len; idx++) {
            chars[idx] = charset[Math.mod(Math.abs(Crypto.getRandomInteger()), size)];
        }

        return String.fromCharArray(chars);
    }
    // dummy user for test user creation
    private static User dummyUser {
        get {
            if (dummyUser==null) {
                dummyUser = [select TimeZoneSidKey, LocaleSidKey,
                             EmailEncodingKey, ProfileId, LanguageLocaleKey
                             from User WHERE isActive = true limit 1];
            }
            System.assertNotEquals(null, dummyUser);
            return dummyUser ;
        }
        set {
            System.assert(true);
        }
    }
    /*
*  Low level utility method to connect sObject <=> field defaults
*
*   @param sObj             - sObject to replicate
*   @param defaultClassName - string name of the object holding defaults
*   @return SObject         - the object that was created
*/
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            throw new TestFactoryException('No test data defaults found');
        }
        // instantiating field defaults for this object
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        // putting defaults into the sObject deep clone
        sObject tempObj = sObj.clone(true,true,true,true);
        addFieldDefaults(tempObj, defaults.getFieldDefaults(tempObj));
        System.assert(true);
        return tempObj;
    }
    /*
*  Low level utility method to fill sObject with field defaults
*
*   @param sObj         - sObject to replicate
*   @param defaults     - string name of the object holding defaults
*   @return SObject     - the user that was created
*/
    private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (String field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
        System.assert(true);
    }

    /*
*  Utility method to create a new generic sObject
*
*   @param sObj           - sObject to replicate
*   @return SObject       - the user that was created
*/
    public static SObject createSObject(SObject sObj) {
        //System.debug('In data factory for '+sObj);
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());
        // Construct the default values class. Salesforce doesn't allow '__' in class names
        List<String> nameSegs = objectName.split('__');
        if(nameSegs.size() >= 3){
            //have namespace
            objectName = nameSegs.get(1);
            // append __c back
            objectName = objectName + nameSegs.get(2);
        } else {
            // no namespace
            objectName = nameSegs.get(0);
            if(nameSegs.size() == 2){
                // custom object
                // append __c back
                objectName = objectName + '__'+nameSegs.get(1);
            }
        }
        // replace the custom object suffix for single underscore
        // to differentiate custom obj from standard ex. Account__c and Account
        String defaultClassName = 'MFG_TestDataFactory.' + objectName.replace('__c', '_') + 'Defaults';
        System.debug('==> In data factory '+defaultClassName);
        // If there is a class that exists for the default values, then use them
        if (Type.forName(defaultClassName) != null) {
            //objectName.replace('__c', '');
            sObj = createSObject(sObj, defaultClassName);

        }
        System.assert(true);
        return sObj;
    }
    /*
*  Utility method to create a new generic sObject
*  and insert it if required
*
*   @param sObj           - sObject to replicate
*   @param doInsert       - flag indicating whether to insert the sObj
*   @return SObject       - the object that was created
*/
    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        System.assertNotEquals(null, retObject);

        return retObject;
    }
    /*
*  Utility method to create list of generic sObjects
*
*
*   @param sObj                  - sObject to replicate
*   @param numberOfObjects       - number of times to replicate
*   @param defaultClassName      - the string identifying the defaults implementation
*   @return SObject[]            - list of replicated sObjects
*/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new SObject[] {};

            // Recreate the object the number of times requested
            for (Integer i = 0; i < numberOfObjects; i++) {
                SObject newObj;
                if (defaultClassName == null) {
                    newObj = createSObject(sObj);
                } else {
                    newObj = createSObject(sObj, defaultClassName);
                }
                sObjs.add(newObj);
            }
        System.assert(true);
        return sObjs;
    }
    /*
*  Utility method to handle insertion
*  of a list of generic sObjects
*
*
*   @param sObj                  - sObject to replicate
*   @param numberOfObjects       - number of times to replicate
*   @param defaultClassName      - the string identifying the defaults implementation
*   @param doInsert              - boolean flag to indicate the need to insert replicated data
*   @return SObject[]            - list of replicated sObjects
*/
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
        if (doInsert) {
            insert retList;
        }
        System.assert(true);
        return retList;
    }

    /*
*  Interface for sObj field standard values
*
*/
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults();
        Map<String, Object> getFieldDefaults(sObject temp);
    }

    /*
*  User standard values
*
*/
    public class UserDefaults implements FieldDefaults {
        String lastName = genRndStrFast(10);
        String email = lastName+'@hotmail.com';
        String alias = genRndStrFast(5);
        String nick = genRndStrFast(5);
        Profile standartProfile = [SELECT ID FROM Profile WHERE Name LIKE 'FGL Sports HirePortal Store User EN' LIMIT 1];
        public Map<String, Object> getFieldDefaults() {

            return new Map<String, Object> {
                'FirstName' => 'TestFName',
                    'LastName' => lastName,
                    'Email' => email,
                    'Username' => email,
                    'ProfileId' => standartProfile.ID,
                    'Alias' => alias,
                    'CommunityNickname' => nick,

                    'TimeZoneSidKey' => dummyUser.TimeZoneSidKey,
                    'LocaleSidKey' => dummyUser.LocaleSidKey,
                    'EmailEncodingKey' => dummyUser.EmailEncodingKey,
                    'LanguageLocaleKey' => dummyUser.LanguageLocaleKey
                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    /*
*  Account standard values
*
*/
    public class AccountDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name'=>'test'+system.now(),
                    'BillingStreet'=>'9 Tagore Lane',
                    'BillingCity'=>'Chicago',
                    'BillingStateCode'=>'IL',
                    'BillingPostalCode'=>'79000',
                    'BillingCountryCode'=>'US',
                    'Phone'=>'103'

                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    public class ContactDefaults implements FieldDefaults {
        String lastName = genRndStrFast(10);
        String email = lastName+'@hotmail.com';
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'FirstName' => 'First',
                    'LastName' => lastName,
                    'Email' => email

                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    public class CaseDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
               
                    'Subject'=>'Practice Registration Request',
                    'Status'=>'New'
                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    
     public class SFDC_Job_Defaults implements FieldDefaults {

        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Job_Title_for_Role__c' =>'test job'
                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    
    public class Hiring_Manager_Availability_Defaults implements FieldDefaults {
        
        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Interviewer_s_Available__c' =>10,
                'Interview_Duration__c' =>'30'
                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    } 
    
    public class SFDC_Job_Candidate_Defaults implements FieldDefaults {
       
        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
               
                    };
                        }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    } 
    
    public class Notification_Defaults implements FieldDefaults {
      
        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Body__c'=>'Body',
                    'Body_FR__c'=>'Body',
                    'Title__c'=>'Title',
                    'Title_FR__c'=>'Title',
                    'Display_Start_Date__c'=>system.today().addDays(-2),
                    'Display_End_Date__c'=>system.today().addDays(2)
            };
                }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    } 
    public class FAQ_Defaults implements FieldDefaults {
      
        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Body__c'=>'What is the most efficient method of contacting Mindfield',
                    'Display__c'=>'Yes',
                    'Title__c'=>'Title'
            };
                }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    public class SFDC_Candidate_Defaults implements FieldDefaults {
      
        public Map<String,Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name'=> genRndStrFast(10)
            };
                }
        public Map<String, Object> getFieldDefaults(sObject temp) {
            return this.getFieldDefaults();
        }
    }
    public class TestFactoryException extends Exception {}

}