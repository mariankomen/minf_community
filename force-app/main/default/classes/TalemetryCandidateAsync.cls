public with sharing class TalemetryCandidateAsync implements Queueable,Database.AllowsCallouts  {
    //public static List<Talemetry_Logger__c> taleLoggerList = new List<Talemetry_Logger__c>();
    public static List<Logger__e> loggerEvents = new List<Logger__e>();
    Public Static List<Talemetry_Logger__c >   loggerList= new List<Talemetry_Logger__c > ();
    Talemetry_Logger__c log = new Talemetry_Logger__c();
    Map<String, Integer> resumeIds;
    public TalemetryCandidateAsync(Map<String, Integer> resumeIds) {
        this.resumeIds = resumeIds;
    }
    Public String resumeId = '';
    Public String appId='';
    Public Boolean isprocessCanddidateAsync= false;
    public TalemetryCandidateAsync() {
        
    } 
    public TalemetryCandidateAsync(Boolean isprocessCanddidateAsync, String resumeId ,String appId ) {
        this.isprocessCanddidateAsync =isprocessCanddidateAsync;
        this.resumeId = resumeId;
        this.appId =appId;
    } 
    public static Talemetry_Logger__c processCanddidateAsync(Talemetry_Logger__c log)
    {
        Integer status = Integer.valueOf(log.StatusNumber__c);
        String appId = '1';
        String resumeId = log.Transaction_Id__c;
         Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        String payload_retrieveResume = payload_retrieveResume(resumeId);
        //process first resume in the list (Retrieve details), remove this from the list and call the queueable again
        HttpRequest request = new HttpRequest();
        request.setHeader('SOAPAction','http://resumemirror.com/RetrieveResume');
        request.setHeader('Content-Type','text/xml; charset=utf-8');            
        HttpResponse response = TalemetryGateway.callout(request, payload_retrieveResume, settings.get('ResumeProcessingEndpoint').Value__c+settings.get('path_RetrieveResume').Value__c);
        if(response != null && NULL != response.getBody()) loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync',payload_retrieveResume,response.getBody()))));
        else loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync',payload_retrieveResume,response+''))));
        
        System.debug('response retrieveResume :'+response);
        System.debug('response response.getStatusCode() :'+response.getStatusCode());
        
        /**process response to multiple objects if status is zero */
        if(status == 0 && response != null && response.getStatusCode() == 200){ 
            Integer safeSize = Integer.valueOf(response.getBodyAsBlob().size()/1048576);
            System.debug('safeSize : '+safeSize);
            if(safeSize < Integer.valueof(System.Label.SafeSize)){
                TalemetryParseResponseUtil tpr = new TalemetryParseResponseUtil();
                
                if(safeSize < Integer.valueof(System.Label.SafeSizeResume)) appId = tpr.parseNode(response.getBody(), true);
                else if(safeSize < Integer.valueof(System.Label.SafeSize)) appId = tpr.parseNode(response.getBody(), false);
                System.debug('appId @>'+appId);
                if(String.isNotBlank(appId) && (appId.length() == 15 || appId.length() == 18)) {
                  /*  removeResumeCallout(resumeId);
                    if(((Id)appId).getSobjectType() == Applicant__c.getsObjectType()){
                        //callout to Talemetry to create Candidate (source - salesforce_ats)
                        String upsertCandidatePayload = TalemetryParseResponseUtil.upsertCandidatePayload(appId);
                        asyncUpsertCandidate(upsertCandidatePayload, appId);
                    }
					*/
                    log.Applicant_Id__c = appId;
                    Id queueId1 = system.enqueueJob(new TalemetryCandidateAsync(true,resumeId,appId)); 
                    system.debug('queueId1: '+queueId1);      
                }
            } else {
                log.Exceed_Safe_Size_Limit__c = true;
                log.Status__c = 'Error';
                loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync',payload_retrieveResume,resumeId+' --> size too big to parse. Skipping'))));
            }        
        }
        return log;
    }
    public static List<Talemetry_Logger__c > createLogger(Map<String, Integer> resumeIds)
    {
        List<Talemetry_Logger__c > loggerList= new List<Talemetry_Logger__c >();
        for(String resumeId : resumeIds.keySet()){
            Talemetry_Logger__c tl = new Talemetry_Logger__c();
            tl.Transaction_Id__c = resumeId;
            tl.StatusNumber__c  = resumeIds.get(resumeId) <> null ? String.valueOf(resumeIds.get(resumeId)) : '';
            tl.Type__c= 'CanddidateAsync';  
            tl.Status__c = 'Processing';
            loggerList.add(tl);
        }
        return loggerList;
    }    
    public void execute(QueueableContext qc) {
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
         Map<String, Integer> resumeIds = new  Map<String, Integer> ();
        try {
            
            if(isprocessCanddidateAsync == true) {
                
                 removeResumeCallout(resumeId);
                    if(((Id)appId).getSobjectType() == Applicant__c.getsObjectType()){
                        //callout to Talemetry to create Candidate (source - salesforce_ats)
                        String upsertCandidatePayload = TalemetryParseResponseUtil.upsertCandidatePayload(appId);
                        asyncUpsertCandidate(upsertCandidatePayload, appId);
                    }

            }
            else{
                String payload = payload_listResume();
                HttpRequest request = new HttpRequest();
                request.setHeader('SOAPAction','http://resumemirror.com/ListResumes');
                request.setHeader('Content-Type','text/xml; charset=utf-8');
                HttpResponse response = TalemetryGateway.callout(request, payload, settings.get('ResumeProcessingEndpoint').Value__c+settings.get('path_ListResumes').Value__c);
                
                loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsyncInit',payLoad,response.getBody()))));
                
                System.debug('response>>'+response.getBody());
                loggerList = new List<Talemetry_Logger__c > ();
                resumeIds = parseResponse_Resume(response);
            System.debug('resumeIds>>'+resumeIds);
            // loggerList = createLogger(resumeIds);
            System.debug('loggerList>>'+loggerList);
                if(!loggerList.isEmpty()){
                    Database.UpsertResult[] results = Database.upsert( loggerList, Talemetry_Logger__c.Transaction_Id__c.getDescribe().getSObjectField() ,false ) ;
                    //upsert loggerList Transaction_Id__c;
                }
            }
               
            
        } catch (Exception e) {
            System.debug('Exception : '+e.getMessage()+' @Line : '+e.getLineNumber());
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync catch','exception catch during callout @line '+e.getLineNumber(),e.getMessage());
            tl.Status__c = 'Error';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
        }finally{
            
           //Database.insert(taleLoggerList,false);
            
            //After collecting all logs, to publish:
            System.debug('loggerEvents >> '+loggerEvents);
            System.debug('loggerEvents >> '+loggerEvents.size());
           
            List<Database.SaveResult> results = EventBus.publish(loggerEvents);
            System.debug('results >> '+results.size());
            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                     err.getStatusCode() +
                                     ' - ' +
                                     err.getMessage());
                    }
                }       
            }
        }
        
        
    }
    public static void asyncUpsertCandidate(String upsertCandidatePayload, String candidateId){
        
        Applicant__c candidate = new Applicant__c(Id = candidateId);
        //taleLoggerList = new List<Talemetry_Logger__c>();
        //loggerEvents = new List<Logger__e>();
        try{
            TriggerFactory.isTriggerExecuted = true;
            Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
            HttpRequest request = new HttpRequest();
            request.setHeader('X-VERIFY-CLIENT-GROUP-ID', settings.get('Username').Value__c);
            request.setHeader('X-VERIFY-CLIENT-GROUP-PSWD', settings.get('Password').Value__c);
            request.setHeader('Accept', 'application/xml');
            request.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            request.setHeader('X-VERIFY-API-INFO', 'genericats');
            HttpResponse response_upsertCandidate = TalemetryGateway.callout(request, upsertCandidatePayload, settings.get('Endpoint').Value__c+settings.get('path_attachmentsAPI').Value__c);
            Map<String, String> upsertCandidateResponseMap = TalemetryGateway.parseResponse_upsertJob(response_upsertCandidate);
            system.debug(upsertCandidateResponseMap);
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('upsertCandidatePayload : ',upsertCandidatePayload,''+response_upsertCandidate))));
            if(upsertCandidateResponseMap.containsKey('status') && upsertCandidateResponseMap.containsKey('key') && upsertCandidateResponseMap.get('status') == 'success' && !String.isBlank(upsertCandidateResponseMap.get('key'))){
                String processOrderPayload = TalemetryGateway.processOrderPayload(upsertCandidateResponseMap.get('key'), 'ADD', 'transform_candidates');
                HttpResponse response_processOrder = TalemetryGateway.callout(new HttpRequest(), processOrderPayload, settings.get('Endpoint').Value__c+settings.get('path_ProcessOrderAPI').Value__c);           
                Map<String, String> processOrderResponseMap = TalemetryGateway.parseResponse_processOrder(response_processOrder);     
                system.debug('processOrderResponseMap: '+processOrderResponseMap);
                if(processOrderResponseMap.containsKey('OrderId') && !String.isBlank(processOrderResponseMap.get('OrderId'))) {
                    candidate.Last_Talemetry_TxnId__c = processOrderResponseMap.get('OrderId');
                    candidate.Last_Synced_with_Talemetry__c = system.now();
                    candidate.Last_Talemetry_Response__c = 'processOrderResponseMap: '+processOrderResponseMap+'\n';
                    //retrieve result for create order
                    String retrieveOrderPayload = TalemetryGateway.retrieveResultPayload(processOrderResponseMap.get('OrderId'));
                    system.debug('retrieveOrderPayload: '+retrieveOrderPayload);
                    HttpResponse response = TalemetryGateway.callout(new HttpRequest(), retrieveOrderPayload, settings.get('Endpoint').Value__c+settings.get('path_retrieveOrderAPI').Value__c);
                    Map<String, String> retrieveOrderResponseMap = TalemetryGateway.parseRespose_retrieveResult(response);
                    system.debug('retrieveOrderResponseMap: '+retrieveOrderResponseMap);
                    candidate.Last_Talemetry_Response__c += 'retrieveOrderResponseMap:'+retrieveOrderResponseMap;
                    //candidate.RetrieveProfileIdPending__c = true;
                    update candidate;
                    loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('upsertCandidatePayload : ',retrieveOrderPayload,candidate.Last_Talemetry_Response__c))));
                }             
            }  
        } catch(Exception e) {
            candidate.Last_Talemetry_Response__c = e.getTypeName()+'\n'+e.getStackTraceString()+'\n'+e.getMessage();
            candidate.Last_Synced_with_Talemetry__c = system.now();
            if(String.isNotBlank(candidateId) && candidateId.startsWithIgnoreCase('a1q'))update candidate;
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync catch','exception catch during callout @line '+e.getLineNumber(),e.getTypeName()+'\n'+e.getStackTraceString()+'\n'+e.getMessage());
            tl.Status__c = 'Error';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
        }finally{
            //Database.insert(taleLoggerList,false);
         /*   List<Database.SaveResult> results = EventBus.publish(loggerEvents);
            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                     err.getStatusCode() +
                                     ' - ' +
                                     err.getMessage());
                    }
                }       
            }
		*/
        }   
    }
    @future(callout=true)
    public static void upsertCandidate(String upsertCandidatePayload, String candidateId){
        asyncUpsertCandidate(upsertCandidatePayload,candidateId);    
    }
    
    @future(callout = true)
    public static void removeResume(String resumeId) {
      /*  Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        String payload_removeResume = payload_removeResume(resumeId);
        system.debug(payload_removeResume);
        HttpRequest request1 = new HttpRequest();
        request1.setHeader('SOAPAction','http://resumemirror.com/RemoveResume');
        request1.setHeader('Content-Type','text/xml; charset=utf-8');
        HttpResponse response1 = TalemetryGateway.callout(request1, payload_removeResume, settings.get('ResumeProcessingEndpoint').Value__c+settings.get('path_RemoveResume').Value__c);
        system.debug(response1);
        system.debug(response1.getBody()); 
        loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('TalemetryCandidateAsync',payload_removeResume,response1.getBody())))); 
        Integer removeResumeStatus = parseResponse_RemoveResume(response1);   
        system.debug(removeResumeStatus);  
	*/
        removeResumeCallout(resumeId);
    }
    public static void removeResumeCallout(String resumeId) {
         Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        String payload_removeResume = payload_removeResume(resumeId);
        system.debug(payload_removeResume);
        HttpRequest request1 = new HttpRequest();
        request1.setHeader('SOAPAction','http://resumemirror.com/RemoveResume');
        request1.setHeader('Content-Type','text/xml; charset=utf-8');
        HttpResponse response1 = TalemetryGateway.callout(request1, payload_removeResume, settings.get('ResumeProcessingEndpoint').Value__c+settings.get('path_RemoveResume').Value__c);
        system.debug(response1);
        system.debug('removeResume Response Body>> ' +response1.getBody()); 
        if(response1.getStatusCode() == 200){
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('RemoveResume Success-'+resumeId,payload_removeResume,response1.getBody());
            tl.Status__c = 'Processed';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
            //loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('RemoveResume Success - '+resumeId,payload_removeResume,response1.getBody())))); 
        }
        else{
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('RemoveResume Error-'+resumeId,payload_removeResume,response1.getBody());
            tl.Status__c = 'Error';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
            //loggerEvents.add(new Logger__e(Body__c= JSON.serialize(TalemetryParseResponseUtil.getLogging('RemoveResume Fail - '+resumeId,payload_removeResume,response1.getBody())))); 
        }
        
        Integer removeResumeStatus = parseResponse_RemoveResume(response1);   
        system.debug(removeResumeStatus);  
        
    }
    /**Prepare payloads */
    
    /**List Resume */
    private static String payload_listResume() {
        String payload_listResume = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null, 'soap:Envelope', null);
        xmlW.writeAttribute(null,null,'xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
        xmlW.writeAttribute(null,null,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
        xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');                
        xmlW.writeStartElement(null, 'soap:Header', null);
        xmlW.writeStartElement(null, 'AuthenticationHeader', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'company', null);
        xmlW.writeCharacters(settings.get('RP_Company').Value__c);
        xmlW.writeEndElement();//company
        xmlW.writeStartElement(null, 'Login', null);
        xmlW.writeCharacters(settings.get('RP_Login').Value__c);
        xmlW.writeEndElement();//Login
        xmlW.writeStartElement(null, 'Password', null);
        xmlW.writeCharacters(settings.get('RP_Password').Value__c);
        xmlW.writeEndElement();//Password  
        xmlW.writeEndElement();//AuthenticationHeader
        xmlW.writeEndElement();//soap:Header
        xmlW.writeStartElement(null, 'soap:Body', null);
        xmlW.writeStartElement(null, 'ListResumes', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'resumeProcessingAccount', null);
        xmlW.writeCharacters(settings.get('RP_Account').Value__c);
        xmlW.writeEndElement();//resumeProcessingAccount
        xmlW.writeStartElement(null, 'retrievecount', null);
        xmlW.writeCharacters('100');
        xmlW.writeEndElement();//retrievecount
        xmlW.writeStartElement(null, 'status', null);
        xmlW.writeCharacters('Confirmed');
        xmlW.writeEndElement();//status                                                
        xmlW.writeEndElement();//soap:Body
        xmlW.writeEndElement();//soap:Envelope
        xmlW.writeEndDocument();
        payload_listResume = xmlW.getXmlString();
        xmlW.close();
        return payload_listResume;          
    }
    
    /**Retrieve Resume */
    private static String payload_retrieveResume(String resumeId) {
        String payload_retrieveResume = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null, 'soap:Envelope', null);
        xmlW.writeAttribute(null,null,'xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
        xmlW.writeAttribute(null,null,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
        xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');                
        xmlW.writeStartElement(null, 'soap:Header', null);
        xmlW.writeStartElement(null, 'AuthenticationHeader', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'company', null);
        xmlW.writeCharacters(settings.get('RP_Company').Value__c);
        xmlW.writeEndElement();//company
        xmlW.writeStartElement(null, 'Login', null);
        xmlW.writeCharacters(settings.get('RP_Login').Value__c);
        xmlW.writeEndElement();//Login
        xmlW.writeStartElement(null, 'Password', null);
        xmlW.writeCharacters(settings.get('RP_Password').Value__c);
        xmlW.writeEndElement();//Password  
        xmlW.writeEndElement();//AuthenticationHeader                                                      
        xmlW.writeEndElement();//soap:Header
        xmlW.writeStartElement(null, 'soap:Body', null);
        xmlW.writeStartElement(null, 'RetrieveResume', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'transid', null);
        xmlW.writeCharacters(resumeId);
        xmlW.writeEndElement();//transid                                                
        xmlW.writeEndElement();//soap:Body
        xmlW.writeEndElement();//soap:Envelope
        xmlW.writeEndDocument();
        payload_retrieveResume = xmlW.getXmlString();
        xmlW.close();
        return payload_retrieveResume;  
    }
    
    /**Remove Resume */
    private static String payload_removeResume(String transactionid) {
        String payload_removeResume = '';
        Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
        
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null, 'soap:Envelope', null);
        xmlW.writeAttribute(null,null,'xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
        xmlW.writeAttribute(null,null,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
        xmlW.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');                
        xmlW.writeStartElement(null, 'soap:Header', null);
        xmlW.writeStartElement(null, 'AuthenticationHeader', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'company', null);
        xmlW.writeCharacters(settings.get('RP_Company').Value__c);
        xmlW.writeEndElement();//company
        xmlW.writeStartElement(null, 'Login', null);
        xmlW.writeCharacters(settings.get('RP_Login').Value__c);
        xmlW.writeEndElement();//Login
        xmlW.writeStartElement(null, 'Password', null);
        xmlW.writeCharacters(settings.get('RP_Password').Value__c);
        xmlW.writeEndElement();//Password  
        xmlW.writeEndElement();//AuthenticationHeader
        xmlW.writeEndElement();//soap:Header
        xmlW.writeStartElement(null, 'soap:Body', null);
        xmlW.writeStartElement(null, 'RemoveResume', null);
        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com/');                
        xmlW.writeStartElement(null, 'transactionid', null);
        xmlW.writeCharacters(transactionid);
        xmlW.writeEndElement();//transactionid                                              
        xmlW.writeEndElement();//soap:Body
        xmlW.writeEndElement();//soap:Envelope
        xmlW.writeEndDocument();
        payload_removeResume = xmlW.getXmlString();
        xmlW.close();
        return payload_removeResume;          
    }    
    
    
    /**Parse Response */
    
    /**List Resume */
    private static Map<String, Integer> parseResponse_Resume(HttpResponse response) {
        Map<String, Integer> returnMap = new Map<String, Integer>();
        if(response.getBody().contains('<soap:Fault>')){
            system.debug('Error Occured: '+response.getBody());
        } else {
            DOM.Document doc = response.getBodyDocument();
            //system.debug('entered');
            for(Dom.XmlNode childNode: doc.getRootElement().getChildElements()) {
                //system.debug('entered');
                for(Dom.XmlNode body : childNode.getChildElements()) {
                    //system.debug('entered');
                    for(Dom.XmlNode ListResumesResponse : body.getChildElements()) {
                        //system.debug('entered');
                        for(Dom.XmlNode ListResumesResult : ListResumesResponse.getChildElements()) {
                            //system.debug('entered');
                            if(ListResumesResult.getName() == 'Results') {
                                //system.debug('entered');
                                for(Dom.XmlNode TransactionsList : ListResumesResult.getChildElements()) {
                                    //system.debug('entered');
                                    for(Dom.XmlNode Transactions : TransactionsList.getChildElements()) {
                                        //system.debug('entered: '+Transactions.getName());
                                        for(Dom.XmlNode TransactionNode : Transactions.getChildElements()) {
                                            //system.debug('entered');
                                            String TransactionID;
                                            Integer StatusNumber; 
                                            DateTime TransactionDateTime;
                                            
                                            for(Dom.XmlNode TransactionDetail : TransactionNode.getChildElements()) {
                                                system.debug(TransactionDetail.getName());
                                                if(TransactionDetail.getName() == 'TransactionID') TransactionID = TransactionDetail.getText();
                                                if(TransactionDetail.getName() == 'StatusNumber') StatusNumber = Integer.valueOf(TransactionDetail.getText());
                                                if(TransactionDetail.getName() == 'TransactionDateTime') TransactionDateTime = getDateTime(TransactionDetail.getText());
                                               // System.debug('TransactionDateTime >>'+TransactionDateTime);
                                                returnMap.put(TransactionID, StatusNumber);
                                            }
                                            Talemetry_Logger__c tl = new Talemetry_Logger__c();
                                            tl.Transaction_Id__c = TransactionID;
                                            tl.StatusNumber__c  = StatusNumber <> null ? String.valueOf(StatusNumber) : '';
                                            tl.Type__c= 'CanddidateAsync';  
                                            tl.Status__c = 'Processing';
                                            tl.Transaction_DateTime__c= TransactionDateTime;
                                            loggerList.add(tl);
       
                                        }
                                    }                       
                                }
                            }
                        }       
                    }
                }
            }  
        }
        return returnMap;
    }
    public static DateTime getDateTime(String datestring){
        System.debug('datestring>> '+datestring);
        List<String> signature = datestring.split (' ');
        List<String> dateList = signature[0].split('/');
        List<String> timeList = signature[1].split(':');
        Integer hour= Integer.valueOf(timeList[0]);
        if('PM'.equals(signature[2])){
            if(hour!=12){
            hour =hour+12;
            }
        }
        else if('AM'.equals(signature[2])){
            if(hour==12){
               hour=0; 
            }
        }
        String dateTimeString = dateList[2]+'-'+dateList[0]+'-'+dateList[1]+' '+hour+':'+timeList[1]+':'+timeList[2];
        System.debug('dateTimeString >>' +dateTimeString);
        DateTime d = DateTime.valueOf(dateTimeString);
        System.debug('dateTimeValue >>' +d);
        return d;
    }
    /**Remove Resume */
    private static Integer parseResponse_RemoveResume(HttpResponse response) {
        Integer returnVar = 1;
        if(response.getBody().contains('<soap:Fault>')){
            system.debug('Error Occured: '+response.getBody());
        } else {
            DOM.Document doc = response.getBodyDocument();
            //system.debug('entered');
            for(Dom.XmlNode childNode: doc.getRootElement().getChildElements()) {
                //system.debug('entered');
                for(Dom.XmlNode body : childNode.getChildElements()) {
                    //system.debug('entered');
                    for(Dom.XmlNode RemoveResumeResponse : body.getChildElements()) {
                        //system.debug('entered');
                        for(Dom.XmlNode RemoveResumeResult : RemoveResumeResponse.getChildElements()) {
                            //system.debug('entered');
                            if(RemoveResumeResult.getName() == 'StatusNumber') {
                                //system.debug('entered');
                                returnVar = Integer.valueOf(RemoveResumeResult.getText());
                            }       
                        }
                    }
                }  
            }
        }
        return returnVar;
    }
    
    
    
}