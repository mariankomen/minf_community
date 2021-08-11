public with sharing class TalemetryGateway implements Queueable,Database.AllowsCallouts {
    public static List<Talemetry_Logger__c> taleLoggerList = new List<Talemetry_Logger__c>();
    //public static List<Logger__e> loggerEvents = new List<Logger__e>();
    SFDC_Job__c jobRecord;
    public TalemetryGateway(SFDC_Job__c jobRecord) {
        this.jobRecord = jobRecord;
    }

    @AuraEnabled
    public Static Map<String, String> getProfileURL(Id recordId, String sobjectName){
        Id applicantId;
        if(sobjectName == 'Applicant_Job_Apps__c') {
            Applicant_Job_Apps__c record = [Select Id, Applicant__c from Applicant_Job_Apps__c where Id =: recordId];
            if(NULL == record || NULL == record.Applicant__c) return new Map<String, String>{'fail' => 'Unable to fetch data.'};
            applicantId = record.Applicant__c;
        } else applicantId = recordId;
        
        Applicant__c applicant = [Select Id, Web_Profile__c, Last_Talemetry_TxnId__c from Applicant__c where Id =: applicantId];
        if(NULL != applicant.Web_Profile__c) return new Map<String, String>{'pass' => applicant.Web_Profile__c};
        if(NULL == applicant.Last_Talemetry_TxnId__c) return new Map<String, String>{'fail' => 'Applicant not synced with Talemetry'};  
            
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        String retrieveOrderPayload = retrieveResultPayload(applicant.Last_Talemetry_TxnId__c);
        system.debug('retrieveOrderPayload: '+retrieveOrderPayload);
        HttpResponse response = callout(new HttpRequest(), retrieveOrderPayload, settings.get('Endpoint').Value__c+settings.get('path_retrieveOrderAPI').Value__c);
        Map<String, String> retrieveOrderResponseMap = parseRespose_retrieveResult(response);
        system.debug('retrieveOrderResponseMap: '+retrieveOrderResponseMap);
        Applicant__c candidate = new Applicant__c(Id = applicantId);
        candidate.Web_Profile__c = 'https://match.talemetry.com/candidate/'+retrieveOrderResponseMap.get('profile-id');
        try {
            update candidate;
        } catch(Exception e){
            return new Map<String, String>{'fail' => 'Error Occured: '+e};  
        }                	
        return new Map<String, String>{'pass' => candidate.Web_Profile__c}; 
    }    

    public static  Talemetry_Logger__c calloutTalemetry(SFDC_Job__c jobNew, SFDC_Job__c jobOld, SFDC_Job__c job){ 
        System.debug(jobNew.Job_Status__c);
        System.debug(jobOld.Job_Status__c);
        System.debug(job.Job_Status__c);
        System.debug('true' +(jobOld.Job_Status__c != jobNew.Job_Status__c));
        if( System.isFuture() || 
            System.isBatch() || 
            system.isQueueable() || 
            NULL == job.Job_Description__c ||
            job.Job_Status__c == 'Implementation/Job Discovery' ||
            job.Job_Status__c == 'Job On Hold' ||
            job.Job_Status__c == 'Job Awaiting Approval' ||
            job.Job_Status__c == 'Pending Order' ||
            (jobOld.LastTalemetrySyncStatus__c != jobNew.LastTalemetrySyncStatus__c && (jobNew.LastTalemetrySyncStatus__c == 'Pending' || jobNew.LastTalemetrySyncStatus__c == 'Completed'))
            )
            return null;
        else if(
            job.Job_Status__c == 'Open/Active Job' ||
            job.Job_Status__c == 'Open/Active Job - Talent Connect' ||
            job.Job_Status__c == 'Open/Active Job for New Store' ||
            job.job_status__c == 'Additional Candidate(s) Required'
        ) {
            Talemetry_Logger__c tl = new Talemetry_Logger__c();
            tl = TalemetryParseResponseUtil.getLogging('Trigger Job Handler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Job_Id__c  = jobNew.Id;
            tl.Processed__c = false;
            return tl;
           // callout(Json.serialize(job), false); 
        }
        else if(
            jobOld.Job_Status__c != jobNew.Job_Status__c && 
            (
                jobNew.Job_Status__c == 'Filled Closed Job' ||
                jobNew.Job_Status__c == 'Filled Internally Closed Job' ||
                jobNew.Job_Status__c == 'Not Filled/Closed by Mgr' ||
                jobNew.Job_Status__c == 'Filled Closed Job for New Store' ||
                jobNew.Job_Status__c == 'Filled Internally Closed Job for New Store' ||
                jobNew.Job_Status__c == 'Not Filled/Closed by Mgr for New Store' ||
                jobNew.Job_Status__c == 'Implementation/Job Discovery' ||
                jobNew.Job_Status__c == 'Job Awaiting Approval' ||
                jobNew.Job_Status__c == 'Job On Hold' ||
                jobNew.Job_Status__c == 'Pending Order' ||
                jobNew.Job_Status__c == 'Not Filled/Job Re-opened'
            )
        ) {
            Talemetry_Logger__c tl = new Talemetry_Logger__c();
            tl = TalemetryParseResponseUtil.getLogging('Trigger Job Handler', 'task trigger', null);
            tl.Status__c = 'Pending';
            tl.Job_Id__c  = jobNew.Id;
            tl.Processed__c = false;
            return tl;
            
        }
       
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static String getRelatedFiles(Id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        system.debug('sObjName: '+sObjName);
        String tempId = recordId;
        if(sObjName == 'Applicant_Job_Apps__c') {
            tempId = [Select Id, Applicant__c from Applicant_Job_Apps__c where Id =: recordId].Applicant__c;
        }
        system.debug('tempId: '+tempId);
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :tempId]) {
            fileIDs.add(docLink.ContentDocumentId);
        }    

        List<fileDetails> lstfD = new List<fileDetails>();
        fileDetails fD;
        blob blb_data;
        for(ContentVersion  cv:[SELECT Id,ContentBodyId,ContentDocumentId, FileExtension, Title,VersionData  FROM ContentVersion WHERE ContentDocumentId IN : fileIDs AND FileExtension IN ('pdf', 'docx', 'doc', 'html')])
        {
             fD=new fileDetails();
             fD.contentDocumentId=cv.ContentDocumentId;
             fD.versionId=cv.Id;
             if(cv.FileExtension=='html') {
                blb_data=cv.VersionData; // assign this blob variable. So that it would give readable format data.
                fD.versionData=blb_data.tostring();
             }
             else
                fD.versionData=null;
             fD.title=cv.Title;
             fD.fileExtension=cv.FileExtension;
             fD.contentBodyId=cv.ContentBodyId;
             lstfD.add(fD);

        }
       return JSON.serialize(lstfD);
    }
    public class fileDetails{
        public Id contentDocumentId {get; set;}
        public Id versionId  {get; set;}
        public Id contentBodyId {get;set;}
        public string versionData {get;set;}
        public string title {get;set;}
        public string fileExtension {get;set;}
     }
     @future(callout=true)
    Private static void callout(String jobJSON, Boolean isArchive) {
        apiCallout(jobJSON,isArchive);
    }
   
    public static void apiCallout(String jobJSON, Boolean isArchive) {
        System.debug('isArchive '+isArchive);
        SFDC_Job__c job = (SFDC_Job__c) Json.deserialize(jobJSON, System.Type.forName('SFDC_Job__c'));
        System.debug('job '+job);
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        try {
            String upsertJobPayload = upsertJobPayload(job, isArchive);
            system.debug('upsertJobPayload: '+upsertJobPayload);
            HttpRequest request = new HttpRequest();
            request.setHeader('X-VERIFY-CLIENT-GROUP-ID', settings.get('Username').Value__c);
            request.setHeader('X-VERIFY-CLIENT-GROUP-PSWD', settings.get('Password').Value__c);
            request.setHeader('Accept', 'application/xml');
            request.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            request.setHeader('X-VERIFY-API-INFO', 'genericats');
            system.debug('path_attachmentsAPI: '+settings.get('Endpoint').Value__c+settings.get('path_attachmentsAPI').Value__c);
            HttpResponse response_upsertJob = callout(request, upsertJobPayload, settings.get('Endpoint').Value__c+settings.get('path_attachmentsAPI').Value__c);
            Talemetry_Logger__c joblog = TalemetryParseResponseUtil.getLogging('upsertJob',upsertJobPayload,response_upsertJob.getBody());
            taleLoggerList.add(joblog);
            
            //System.debug('response_upsertJob..>>>. '+response_upsertJob.getBody());
            Map<String, String> upsertJobResponseMap = parseResponse_upsertJob(response_upsertJob);
            system.debug('response_upsertJob: '+response_upsertJob);
            if(upsertJobResponseMap.containsKey('status') && upsertJobResponseMap.containsKey('key') && upsertJobResponseMap.get('status') == 'success' && !String.isBlank(upsertJobResponseMap.get('key'))){
                String jobStatus = isArchive ? 'DEL' : 'ADD';
                String processOrderPayload = processOrderPayload(upsertJobResponseMap.get('key'), jobStatus, 'transform_jobs');
                HttpResponse response_processOrder = callout(new HttpRequest(), processOrderPayload, settings.get('Endpoint').Value__c+settings.get('path_ProcessOrderAPI').Value__c);
                //System.debug('response_processOrder body for test class.>> '+response_processOrder.getBody());
                taleLoggerList.add(TalemetryParseResponseUtil.getLogging('processOrderPay',processOrderPayload,response_processOrder.getBody()));
                Map<String, String> processOrderResponseMap = parseResponse_processOrder(response_processOrder);     
                system.debug('processOrderResponseMap: '+processOrderResponseMap);
                if(processOrderResponseMap.containsKey('OrderId') && !String.isBlank(processOrderResponseMap.get('OrderId'))) {
                    job.Last_Talemetry_TxnId__c = processOrderResponseMap.get('OrderId');
                    job.Last_Synced_with_Talemetry__c = system.now();
                    job.Last_Talemetry_Response__c = processOrderResponseMap+'';
                    Id queueId = system.enqueueJob(new TalemetryGateway(job));
                    system.debug('queueId: '+queueId);
                }       
            }
        } catch(Exception e) {
            job.Last_Talemetry_Response__c = e.getTypeName()+'\n'+e.getStackTraceString()+'\n'+e.getMessage();
            for(TalemetryErrorMessage__mdt message : [select id, masterlabel, Value__c from TalemetryErrorMessage__mdt]) {
                if(e.getStackTraceString().contains(message.masterlabel)) {
                    job.Talemetry_Error_Description__c = message.value__c;
                }
            }
            job.LastTalemetrySyncStatus__c = 'Error';
            job.Last_Synced_with_Talemetry__c = system.now();
            update job;
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('upsertJob catch','JobName-'+ job.Name+' : Exception catch during callout @line '+e.getLineNumber(),e.getMessage());
            tl.Status__c = 'Error';
            
            taleLoggerList.add(tl);
        	
        }finally{
            if(!taleLoggerList.isEmpty())
                Database.upsert(taleLoggerList,false);
        }
    }

    /**Callout */
    public static HttpResponse callout(HttpRequest request, String payLoad, String endpoint){
        
        Http http = new Http();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(payLoad);
        HttpResponse response;
        try {
            response = http.send(request);
            return response;
            //loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('Gateway',payLoad,endpoint+'\n'+response.getBody()))));
            //TalemetryParseResponseUtil.createLogger('Gateway callout',payLoad,endpoint+'\n'+response.getBody());
        } catch(Exception e) {
            //loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('Gateway',payLoad,endpoint+'\n'+'Exception Occured: '+e))));
            //TalemetryParseResponseUtil.createLogger('Gateway callout',payLoad,endpoint+'\n'+'Exception Occured: '+e);
            System.debug('Exception Occured at line ..>> '+e.getLineNumber() + ' and error message is : '+e.getMessage());
            response = new HttpResponse();
            response.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            response.setBody('<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><SOAP-ENV:Body><SOAP-ENV:Fault><faultcode xsi:type = "xsd:string">INVALID_RESPONSE</faultcode><faultstring xsi:type = "xsd:string">Exception Occured at line ..>> '+e.getLineNumber() + ' and error message is : '+e.getMessage()+'</faultstring></SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>');
            response.setStatusCode(500);
            return response;
        }        
    }

    //callout to retrieve result
    public void execute(QueueableContext qc) {
        String orderId = jobRecord.Last_Talemetry_TxnId__c;
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        String retrieveOrderPayload = retrieveResultPayload(orderId);
        system.debug('retrieveOrderPayload: '+retrieveOrderPayload);
        HttpResponse response = callout(new HttpRequest(), retrieveOrderPayload, settings.get('Endpoint').Value__c+settings.get('path_retrieveOrderAPI').Value__c);
        System.debug('response for test class..>> '+response.getBody());
        Map<String, String> retrieveOrderResponseMap = parseRespose_retrieveResult(response);
        system.debug('retrieveOrderResponseMap: '+retrieveOrderResponseMap);
        jobRecord.Last_Talemetry_Response__c = '';
        jobRecord.Last_Talemetry_TxnId__c = '';          
        if(retrieveOrderResponseMap.containsKey('TxnId') && !String.isBlank(retrieveOrderResponseMap.get('TxnId'))) 
        jobRecord.Last_Talemetry_TxnId__c = retrieveOrderResponseMap.get('TxnId');
        if(retrieveOrderResponseMap != null && retrieveOrderResponseMap.containsKey('results')){
            if(Integer.valueOf(retrieveOrderResponseMap.get('results')) == 0) jobRecord.LastTalemetrySyncStatus__c = 'Pending';
            else if(Integer.valueOf(retrieveOrderResponseMap.get('results')) > 0) jobRecord.LastTalemetrySyncStatus__c = 'Completed';
        } 
        jobRecord.Last_Talemetry_Response__c = retrieveOrderResponseMap + '';
        jobRecord.Last_Synced_with_Talemetry__c = system.now();
        update jobRecord;
    }

    /**Prepare payloads for integration */
    public static String upsertJobPayload(SFDC_Job__c job, Boolean isArchive){

        String userEmail = '';
        if(job.Recruiter_Assigned__c != null){
            User UserEmail1 = [Select Id, email from user where Id =: job.Recruiter_Assigned__c];
            userEmail = UserEmail1.email;
        }
		System.debug('userEmail '+userEmail);
        String upsertJobPayload = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();

        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null,'PositionOpenings', null);
                xmlW.writeStartElement(null,'PositionOpening', null);
                    xmlW.writeStartElement(null,'UserArea', null);
                        xmlW.writeStartElement(null,'IntegrationExternalID', null);
                            xmlW.writeCharacters(job.Name);
                        xmlW.writeEndElement();
                        if(!isArchive){
                            xmlW.writeStartElement(null,'IntegrationFields', null);
                                xmlW.writeStartElement(null,'PositionOpening', null);
                                    xmlW.writeStartElement(null,'PositionPostings', null);
                                        xmlW.writeStartElement(null,'PositionPosting', null);
                                            xmlW.writeStartElement(null,'Id', null);
                                                xmlW.writeStartElement(null,'IdValue', null);
                                                    xmlW.writeCharacters(job.Name);
                                                xmlW.writeEndElement();	//IdValue                                        
                                            xmlW.writeEndElement();	//Id
                                            if(NULL != job.Link_to_Career_Site_Posting__c) {
                                                xmlW.writeStartElement(null,'Link', null);
                                                    xmlW.writeCharacters(job.Link_to_Career_Site_Posting__c);
                                                xmlW.writeEndElement();	//Link   
                                            }                                 
                                        xmlW.writeEndElement(); //PositionPosting
                                    xmlW.writeEndElement();//PositionPostings
                                    xmlW.writeStartElement(null,'PositionProfile', null);
                                    if(!String.isBlank(job.Career_Site_Language__c)) xmlW.writeAttribute(null,null,'languageCode',job.Career_Site_Language__c);
                                        xmlW.writeStartElement(null,'PositionDetail', null);
                                            xmlW.writeStartElement(null,'PositionTitle', null);
                                                xmlW.writeCharacters(job.Job_Title__c);
                                            xmlW.writeEndElement();	//PositionTitle
                                            xmlW.writeStartElement(null,'PhysicalLocation', null);
                                                if(!String.isBlank(job.Job_Owner_Alias__c)){
                                                    xmlW.writeStartElement(null,'Name', null);
                                                        xmlW.writeCharacters(job.Job_Owner_Alias__c);
                                                    xmlW.writeEndElement();	//Name   
                                                }                                           
                                                xmlW.writeStartElement(null,'PostalAddress', null);
                                                    if(!String.isBlank(job.Location_Store_Country__c)) {
                                                        xmlW.writeStartElement(null,'CountryCode', null);
                                                            xmlW.writeCharacters(job.Location_Store_Country__c);
                                                        xmlW.writeEndElement();                                                    
                                                    }
                                                    if(!String.isBlank(job.Location_Store_Postal_Code_Zip_Code__c)) {
                                                        xmlW.writeStartElement(null,'PostalCode', null);
                                                            xmlW.writeCharacters(job.Location_Store_Postal_Code_Zip_Code__c);
                                                        xmlW.writeEndElement();                                                    
                                                    }     
                                                    if(!String.isBlank(job.Location_Store_Province_State__c)) {
                                                        xmlW.writeStartElement(null,'Region', null);
                                                            xmlW.writeCharacters(job.Location_Store_Province_State__c);
                                                        xmlW.writeEndElement();                                                    
                                                    } 
                                                    if(!String.isBlank(job.Location_Store_City__c)) {
                                                        xmlW.writeStartElement(null,'Municipality', null);
                                                            xmlW.writeCharacters(job.Location_Store_City__c);
                                                        xmlW.writeEndElement();                                                    
                                                    }                                                                                                                                              
                                                    if(!String.isBlank(job.Location_Store_Address__c)) {
                                                        xmlW.writeStartElement(null,'DeliveryAddress', null);
                                                            xmlW.writeStartElement(null,'AddressLine', null);
                                                                xmlW.writeCharacters(job.Location_Store_Address__c);
                                                            xmlW.writeEndElement();
                                                        xmlW.writeEndElement();                                                     
                                                    }
                                                xmlW.writeEndElement();                                        
                                            xmlW.writeEndElement();
                                            xmlW.writeStartElement(null,'PositionSchedule', null);
                                                xmlW.writeCharacters(job.FT_or_PT__c);
                                            xmlW.writeEndElement();                                                                        
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement(null,'FormattedPositionDescription', null);
                                            //xmlW.writeStartElement(null,'Name', null);
                                                //xmlW.writeCharacters('Desciption');
                                            //xmlW.writeEndElement();
                                            xmlW.writeStartElement(null,'Value', null);
                                                xmlW.writeCData(job.Job_Description__c);
                                            xmlW.writeEndElement();                                    	
                                        xmlW.writeEndElement();
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement(null,'UserArea', null);
                                        xmlW.writeStartElement(null,'RecruitmentTeam', null);
                                            xmlW.writeStartElement(null,'UnflagMode', null);
                                                xmlW.writeCharacters('api');
                                            xmlW.writeEndElement(); //UnflagMode
                                            if(!String.isBlank(userEmail)) {
                                                xmlW.writeStartElement(null,'Members', null);
                                                    xmlW.writeStartElement(null,'Member', null);
                                                        xmlW.writeStartElement(null,'MemberEmail', null);
                                                            xmlW.writeCharacters(userEmail);
                                                        xmlW.writeEndElement();//MemberEmail
                                                    xmlW.writeEndElement();//Member  
                                                xmlW.writeEndElement();//Members 
                                            }                                      
                                        xmlW.writeEndElement(); //RecruitmentTeam
                                        xmlW.writeStartElement(null,'Hot_Job__c', null);
                                            xmlW.writeCharacters(String.valueOf(job.Hot_Job__c));
                                        xmlW.writeEndElement();
                                        if(!String.isBlank(job.Job_Role__c)) {
                                            xmlW.writeStartElement(null,'Job_Role__c', null);
                                                xmlW.writeCharacters(job.Job_Role__c);
                                            xmlW.writeEndElement();
                                        }
                                        if(!String.isBlank(job.Job_Category__c)) {
                                            xmlW.writeStartElement(null,'Job_Category__c', null);
                                                xmlW.writeCharacters(job.Job_Category__c);
                                            xmlW.writeEndElement();
                                        }
                                        if(!String.isBlank(job.Career_Site_Language__c)) {
                                            xmlW.writeStartElement(null,'Career_Site_Language__c', null);
                                                xmlW.writeCharacters(job.Career_Site_Language__c);
                                            xmlW.writeEndElement(); 
                                        }
                                        if(!String.isBlank(job.Client_Career_Site__c)){
                                            xmlW.writeStartElement(null,'Client_Career_Site__c', null);
                                                xmlW.writeCharacters(job.Client_Career_Site__c);
                                            xmlW.writeEndElement();  
                                        }   
                                        if(!String.isBlank(job.Online_Posting__c)) {
                                            xmlW.writeStartElement(null,'Online_Posting__c', null);
                                                xmlW.writeCharacters(job.Online_Posting__c);
                                            xmlW.writeEndElement();  
                                        }                                                                                                                                  
                                    xmlW.writeEndElement();
                                xmlW.writeEndElement(); 
                            xmlW.writeEndElement();         
                        }           
                    xmlW.writeEndElement();
                xmlW.writeEndElement();
            xmlW.writeEndElement();
        xmlW.writeEndDocument();
        upsertJobPayload = xmlW.getXmlString();
        xmlW.close();
        return upsertJobPayload;
    }

    public static String processOrderPayload(String attachmentId, String action, String service){
        String processOrderPayload = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();

        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null, 'SOAP-ENV:Envelope', null);
            xmlW.writeAttribute(null,null,'xmlns:SOAP-ENV','http://schemas.xmlsoap.org/soap/envelope/');
            xmlW.writeAttribute(null,null,'xmlns:SOAP-ENC','http://schemas.xmlsoap.org/soap/encoding/');
            xmlW.writeAttribute(null,null,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
            xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');                
                xmlW.writeStartElement(null, 'SOAP-ENV:Header', null);
                xmlW.writeAttribute(null,null,'xmlns:SOAP-ENV','http://schemas.xmlsoap.org/soap/envelope/');     
                xmlW.writeEndElement();//SOAP-ENV:Header
                xmlW.writeStartElement(null, 'SOAP-ENV:Body', null);
                    xmlW.writeStartElement(null, 'ProductOrder', null);
                    xmlW.writeAttribute(null,null,'apiInfo','genericats');
                        xmlW.writeStartElement(null, 'ProcessingInformation', null);
                            xmlW.writeStartElement(null, 'AccessCredential', null);
                            xmlW.writeAttribute(null,null,'type','Account');
                                xmlW.writeCharacters(settings.get('Username').Value__c);
                            xmlW.writeEndElement();//AccessCredential - Username
                            xmlW.writeStartElement(null, 'AccessCredential', null);
                            xmlW.writeAttribute(null,null,'type','AccountPassword');
                                xmlW.writeCharacters(settings.get('Password').Value__c);
                            xmlW.writeEndElement();//AccessCredential - Password
                        xmlW.writeEndElement();//ProcessingInformation
                        xmlW.writeStartElement(null, 'Providers', null);
                            xmlW.writeStartElement(null, 'Provider', null);
                            xmlW.writeAttribute(null,null,'id','ttc_api_gateway');
                                xmlW.writeStartElement(null, 'Services', null);
                                    xmlW.writeStartElement(null, 'Service', null);
                                    xmlW.writeAttribute(null,null,'id',service);
                                        xmlW.writeStartElement(null, 'Fields', null);
                                            xmlW.writeStartElement(null, 'Field', null);
                                            xmlW.writeAttribute(null,null,'id','integration_attachment_id');
                                            xmlW.writeCharacters(attachmentId);
                                            xmlW.writeEndElement();//Field  - integration_attachment_id         
                                            xmlW.writeStartElement(null, 'Field', null);
                                            xmlW.writeAttribute(null,null,'id','integration_action');
                                            xmlW.writeCharacters(action);
                                            xmlW.writeEndElement();//Field  - integration_action  
                                            xmlW.writeStartElement(null, 'Field', null);
                                            xmlW.writeAttribute(null,null,'id','integration_variable_name');
                                            xmlW.writeCharacters('job_feed_id');
                                            xmlW.writeEndElement();//Field  - integration_variable_name  
                                            xmlW.writeStartElement(null, 'Field', null);
                                            xmlW.writeAttribute(null,null,'id','integration_variable_value');
                                            xmlW.writeCharacters(settings.get('IntegrationExternalID').Value__c);
                                            xmlW.writeEndElement();//Field  - integration_variable_value                                                                                                                                                 
                                        xmlW.writeEndElement();//Fields
                                    xmlW.writeEndElement();//Service
                                xmlW.writeEndElement();//Services  
                            xmlW.writeEndElement();//Provider                            
                        xmlW.writeEndElement();//Providers
                    xmlW.writeEndElement();//ProductOrder
                xmlW.writeEndElement();//SOAP-ENV:Body
            xmlW.writeEndElement();//SOAP-ENV:Envelope
        xmlW.writeEndDocument();
        processOrderPayload = xmlW.getXmlString();
        xmlW.close();
        return processOrderPayload;
    } 

    public static String retrieveResultPayload(String orderId){
        String processOrderPayload = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();

        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null, 'SOAP-ENV:Envelope', null);
            xmlW.writeAttribute(null,null,'xmlns:SOAP-ENV','http://schemas.xmlsoap.org/soap/envelope/');
            xmlW.writeAttribute(null,null,'xmlns:SOAP-ENC','http://schemas.xmlsoap.org/soap/encoding/');
            xmlW.writeAttribute(null,null,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
            xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');                
                xmlW.writeStartElement(null, 'SOAP-ENV:Header', null);
                xmlW.writeAttribute(null,null,'xmlns:SOAP-ENV','http://schemas.xmlsoap.org/soap/envelope/');     
                xmlW.writeEndElement();//SOAP-ENV:Header
                xmlW.writeStartElement(null, 'SOAP-ENV:Body', null);
                    xmlW.writeStartElement(null, 'RetrieveHistoricResults', null);
                    xmlW.writeAttribute(null,null,'apiInfo','genericats');
                        xmlW.writeStartElement(null, 'ProcessingInformation', null);
                            xmlW.writeStartElement(null, 'AccessCredential', null);
                            xmlW.writeAttribute(null,null,'type','Account');
                                xmlW.writeCharacters(settings.get('Username').Value__c);
                            xmlW.writeEndElement();//AccessCredential - Username
                            xmlW.writeStartElement(null, 'AccessCredential', null);
                            xmlW.writeAttribute(null,null,'type','AccountPassword');
                                xmlW.writeCharacters(settings.get('Password').Value__c);
                            xmlW.writeEndElement();//AccessCredential - Password
                        xmlW.writeEndElement();//ProcessingInformation
                        xmlW.writeStartElement(null, 'Filter', null); 
                            xmlW.writeStartElement(null, 'TxnId', null);
                            xmlW.writeCharacters(orderId);
                            xmlW.writeEndElement();//Field - TxnId                                                                                                                                                                            
                        xmlW.writeEndElement();//Filter
                    xmlW.writeEndElement();//RetrieveHistoricResults
                xmlW.writeEndElement();//SOAP-ENV:Body
            xmlW.writeEndElement();//SOAP-ENV:Envelope
        xmlW.writeEndDocument();
        processOrderPayload = xmlW.getXmlString();
        xmlW.close();
        return processOrderPayload;        
    }

    /**Response Parsers */
    public static Map<String, String> parseResponse_upsertJob(HttpResponse response){
        Map<String, String> responseMap = new Map<String, String>();
        DOM.Document doc = response.getBodyDocument();
        for(Dom.XmlNode childNode: doc.getRootElement().getChildElements()) {
            if(childNode.getName() == 'status') {
                responseMap.put('status', childNode.getText());
            }  
            if(childNode.getName() == 'key') {
                responseMap.put('key', childNode.getText());
            }                        
        }
        return responseMap;
    }

    public static Map<String, String> parseResponse_processOrder(HttpResponse response) {
        Map<String, String> responseMap = new Map<String, String>();
        if(response!=null && String.isNotBlank(''+response)){
            DOM.Document root = response.getBodyDocument();
            for(DOM.XmlNode node : root.getRootElement().getChildren()) {
                for(DOM.XmlNode body : node.getChildElements()){
                    if(body.getName() == 'ProductResults'){
                        for(DOM.XmlNode result : body.getChildren()) {
                            if(result.getName() == 'OrderId') responseMap.put('OrderId', result.getText());
                        }
                    } 
                }    
            }
        }
        return responseMap;
    }

    public static Map<String, String> parseRespose_retrieveResult(HttpResponse response) {
        system.debug('retrieveOrderResponseMap:'+response.getbody());
        Map<String, String> responseMap = new Map<String, String>();
        DOM.Document root = response.getBodyDocument();
        for(DOM.XmlNode node : root.getRootElement().getChildren()) {
            for(DOM.XmlNode body : node.getChildElements()){
                if(body.getName() == 'RetrieveHistoricResultsResponse'){
                    for(DOM.XmlNode result : body.getChildren()) {
                        if(result.getName() == 'Filter') {
                            for(DOM.XmlNode filter : result.getChildren()) {
                                if(filter.getName() == 'TxnId'){
                                    responseMap.put('TxnId', filter.getText());
                                }
                            }
                        }
                        if(result.getName() == 'Results') {
                            responseMap.put('results', result.getChildren().size()+'');
                            for(DOM.XmlNode results : result.getChildren()) {
                                if(results.getName() == 'ProductResults') {
                                    for(DOM.XmlNode productResults : results.getChildren()) {
                                        if(productResults.getName() == 'OrderStatus') {
                                            responseMap.put('OrderStatus', productResults.getText());
                                        }
                                        if(productResults.getName() == 'OrderId') {
                                            responseMap.put('OrderId', productResults.getText());
                                        }                                        
                                        if(productResults.getName() == 'Product') {
                                            for(DOM.XmlNode product : productResults.getChildren()) {
                                                if(product.getName() == 'VendorOrderSummaryResult') {
                                                    for(DOM.XmlNode summaryResult : product.getChildren()) {
                                                        if(summaryResult.getName() == 'job') {
                                                            for(DOM.XmlNode job : summaryResult.getChildren()) {
                                                                system.debug('job: '+job.getText());
                                                                if(NULL != job.getName()) responseMap.put(job.getName(), job.getText());
                                                            }
                                                        }
                                                        if(summaryResult.getName() == 'candidate') {
                                                            for(DOM.XmlNode job : summaryResult.getChildren()) {
                                                                system.debug('job: '+job.getText());
                                                                if(NULL != job.getName()) responseMap.put(job.getName(), job.getText());
                                                            }
                                                        }

                                                    } 
                                                }
                                            } 
                                        }
                                    }                                    
                                }
                            }                            
                        }
                    }
                } 
            }    
        }
        system.debug('responseMap: '+responseMap);
        return responseMap;        
    }


}