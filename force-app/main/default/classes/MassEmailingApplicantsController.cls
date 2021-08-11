/*==============================================================================
 * Author 		: Henry Caballero | floatintotheclouds
 * Date			: 5/6/2020
 * Description	: Jira Issue => MFG-142
 * Changes		: HC | 6/17/2020 | Jira Issue => MFG-191 
 * ===========================================================================*/


public class MassEmailingApplicantsController 
{
	private list<Applicant_Job_Apps__c> jobApps {get;set;}
    public list<string> jobApplicantsIds {get;set;}
    public Applicant_Job_Apps__c tmpJobApp  {get;set;}
    public  string JobId {get;set;}    
    public string jobApps2 {get;set;}

    @TestVisible
    private static map<string,map<string,string>> getMergefields(string templateBody )
    {
        // extract the the fields delimited by {}
        Pattern brackets = Pattern.compile( '\\{!([^}]+)\\}');
    	Matcher matcher = brackets.matcher(templateBody);        
        
        // this map will store  <object name, <merge field syntax, field api name>  >
        map<string,map<string,string>> fieldsMAP = new map<string,map<string,string>>();
        
        while ( matcher.find() )
        {
            map<string,string> fields = new map<string,string>();
            // extract the object name from the field	
           	string field = matcher.group(1);			
            string objectName = field.substringBefore('.').toLowerCase();
            
            if (fieldsMAP.containsKey(objectName))
            	fields = fieldsMAP.get(objectName);
            
            fields.put(field, field.substringAfter('.') );
            fieldsMAP.put(objectName,fields );                       
        }

        return fieldsMAP;
        
    }
        
    
    public MassEmailingApplicantsController(ApexPages.StandardSetController controller)
    {        
        if (!test.isRunningTest()) controller.addFields(new List<String>{'Job__c','Job__r.Name', 'Applicant__c','Applicant__r.First_Name__c','Applicant__r.Last_Name__c','Applicant__r.Email__c'} );
        
        tmpJobApp = new Applicant_Job_Apps__c();
        this.jobApps =  controller.getSelected();

        this.JobId = (string)controller.getRecords()[0].get('Job__c');                            
        jobApplicantsIds = new list<string>();
        for ( Applicant_Job_Apps__c a : jobApps)
        {
            jobApplicantsIds.add(a.id);
        }
        
        jobApps2 = json.serialize(this.jobApps);
    }
    
    @AuraEnabled(cacheable=true)
    public static map<string, object> getRecords( string jobApplicants )
    {
        map<string, object> data = new map<string, object>();
        data.put('email_templates', getTemplates() );
        data.put('applicants', getApplicants(jobApplicants) );
        data.put('from', getFromAddresses() );
        return data;
    }
    
    private static list<object> getApplicants( string jobApplicants)
    {
        list<Applicant_Job_Apps__c> jobApps = ( list<Applicant_Job_Apps__c>)JSON.deserialize(jobApplicants,  list<Applicant_Job_Apps__c>.class );
        list<object> applicants = new list<object>();      
        for (Applicant_Job_Apps__c aj : jobApps )
        {
            map<string, string> applicant = new map<string, string>();
            applicant.put('type','icon' );
            applicant.put('label', aj.Applicant__r.First_Name__c + ' ' +  aj.Applicant__r.Last_Name__c );
            applicant.put('name', aj.Applicant__c );
            applicant.put('iconName','standard:contact' );
            applicants.add(applicant);
        }
        
        return applicants;
    }

    
    @AuraEnabled(cacheable=true)
    public  static map<string,string> getTemplateBody(string templateId, string whatId)
    {
		list<emailtemplate> templates = [select id,HTMLValue, subject from emailtemplate where  id = : templateId];
        if (templates.isEmpty() )
            return null;
        
        string body = templates[0].HTMLValue;        
        string subject = templates[0].subject!=null ? templates[0].subject : '';        
        map<string,map<string,string>> mergeFields = getMergefields(body ); 

        map<id,sObject> jobs = getDataForMerging(mergeFields, 'sfdc_job__c', new set<id> {whatId});
        map<id,sObject> users = getDataForMerging(mergeFields, 'user', new set<id> {userinfo.getUserId()});

       	body = applyMergeFields(body, mergeFields.get('sfdc_job__c'), jobs.get(whatId) );
        subject = applyMergeFields(subject, mergeFields.get('sfdc_job__c'), jobs.get(whatId) );
        
        body = applyMergeFields(body, mergeFields.get('user'), users.get(userinfo.getUserId()) );
        subject = applyMergeFields(subject, mergeFields.get('user'), users.get(userinfo.getUserId()) );
       
    
        return new map <string,string>{'body'=>body,'subject'=>subject};
    }

    @AuraEnabled
    public static void sendEmail (string jobApplicants, string emailInfoJson)
    {
        map<string, object> emailInfo = (map<string, object>)Json.deserializeUntyped(emailInfoJson);
        list<Applicant_Job_Apps__c> jobApps = ( list<Applicant_Job_Apps__c>)JSON.deserialize(jobApplicants,  list<Applicant_Job_Apps__c>.class );        
        map<string,map<string,string>> mergeFields = getMergefields((string)emailInfo.get('body') + ' ' + (string)emailInfo.get('subject') );
        
        set<id> setOfApplicants = new set<id>();
        set<id> setOfappJobApp = new set<id>();
               
        for (Applicant_Job_Apps__c aj : jobApps)
        {
            setOfApplicants.add(aj.Applicant__c);
            setOfappJobApp.add(aj.id);
        }
        
        map<id, sObject> applicantMAP = getDataForMerging(mergeFields, 'applicant__c', setOfApplicants);
        map<id, sObject> appJobAppMAP = getDataForMerging(mergeFields, 'applicant_job_apps__c', setOfappJobApp);
             
        list<Messaging.SingleEmailMessage> messages = new list<Messaging.SingleEmailMessage>();
        list <emailmessage> emailmessage = new list <emailmessage> ();
        
        string FromEmailAddress = (string)emailInfo.get('from');
        
        map<id, task> appJob_tasksMAP = new map<id, task>();
        
        for ( Applicant_Job_Apps__c aj : jobApps)
        {
            string message = (string)emailInfo.get('body');
            string subject = (string)emailInfo.get('subject');
            message = applyMergeFields(message, mergeFields.get('applicant_job_apps__c'), appJobAppMAP.get(aj.id) );
            message = applyMergeFields(message, mergeFields.get('applicant__c'), applicantMAP.get(aj.Applicant__c) );
            subject = applyMergeFields(subject, mergeFields.get('applicant_job_apps__c'), appJobAppMAP.get(aj.id) );
            subject = applyMergeFields(subject, mergeFields.get('applicant__c'), applicantMAP.get(aj.Applicant__c) );
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage() ;
            email.setToAddresses(new list<string> {aj.Applicant__r.Email__c} );
            if (UserInfo.getUserEmail()!=FromEmailAddress )
                email.setOrgWideEmailAddressId(FromEmailAddress);
            
            email.setSubject(subject);
            email.setHtmlBody(message);
            email.setWhatId(aj.Applicant__c );
            email.setSaveAsActivity(true);
            messages.add(email);
            emailmessage.add(new emailmessage(status = '3', RelatedToId = aj.id  ,toAddress=aj.Applicant__r.Email__c, Subject=(string)emailInfo.get('subject') , HtmlBody = message ) );            
        }

        Messaging.sendEmail(messages);        
        insert emailmessage;
    }


    private static map<id,sObject> getDataForMerging( map<string,map<string,string>> mergeFields, string objectName, set<id> setOfIds)
    {
        map<string,string> fields = mergeFields.get(objectName);
        string query = buildQuery(mergeFields,objectName);
        
        return query==null ? new map<id,sObject>() : new map<id,sObject>(database.query(query +  ' where id in : setOfIds'));            
    } 

    private static string applyMergeFields(string body, map<string,string> fields, sObject record)
    {
        
        if(fields==null)
            return body;

        for (string mergeField : fields.keyset() )
        {
            string value;            
            string fieldApiName = fields.get(mergeField);
            list<string> field_relationship = fieldApiName.split('\\.');    
            
            // there is not a parent relationship 
            if (field_relationship.size()==1)
                value = (string)record.get(fieldApiName);                
            else if(field_relationship.size() >1)        
            {
                sObject currentObject;
                for (integer path=0; path<field_relationship.size()-1; path++ )
                {
                    currentObject= record.getSObject(field_relationship[path]);
                }
                
                value = (string)currentObject.get(field_relationship[field_relationship.size()-1]);
            }

            body = body.replace( '{!'+mergeField+'}', value!=null ? value : ''  );            	                    
        }

        return body;            
    }



    private static string buildQuery(map<string,map<string,string>> data, string objectName)
    {
        map<string,string> fields = data.get(objectName.toLowerCase());
        
        if (fields==null)
        	return null;
        
        return 'select ' + string.join( fields.values(),',')  + ' from ' + objectName ;
    }
    
    private static list<object> getFromAddresses()
    {
        list<object> Addresses = new list<object>();                
        user u =[ select name, email from user where id=:UserInfo.getUserId() ];
        Addresses.add( new map<string,string>{'label'=> u.name + ' <' + u.email + '>','value'=>  u.email});

        for ( OrgWideEmailAddress owe : [select id,Address , DisplayName from OrgWideEmailAddress ])
        {
            Addresses.add( new map<string,string>{'label'=> owe.DisplayName + ' <' + owe.Address + '>','value'=>  owe.id});
        }

        return Addresses;
    }

    private static list<object> getTemplates()
    {
        list<object> templates = new list<object>();        
        templates.add( new map<string,string>{'label'=>'-none-','value'=> null});
        for ( EmailTemplate et : [select Id , DeveloperName , Name , IsActive from EmailTemplate where isActive=true and Folder.DeveloperName='Mass_Applicant_Email_Templates'] )
        {
            templates.add(new map<string,string>{'label'=>et.Name,'value'=> et.id});            
        }
        
        return templates;
    }
}