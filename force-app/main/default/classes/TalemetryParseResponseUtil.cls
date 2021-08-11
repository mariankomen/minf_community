public class TalemetryParseResponseUtil {
    Applicant__c applicant;
    Applicant_Employment__c appEmp;
    List<Applicant_Employment__c> applicantEmpList; 
    Applicant_Education__c appEdu;
    List<Applicant_Education__c> appEduList;
    Applicant_Job_Apps__c  appJobApp;
    String resumeName='',jobName='',jobAppStatus='', tempVariable;
    public static List<Logger__e> loggerEvents;
    public TalemetryParseResponseUtil(){ 
        loggerEvents = new List<Logger__e>();
        //String req = [Select id,response__c from Account where id = '0015C00000VPr9W'].response__c;
        //System.debug('req..>> '+req);  
        //parseNode(req); 
    } 

    public static Map<string,Applicant_Job_Status__c > getPPJobStatus(){
        return  Applicant_Job_Status__c.getAll();
    }
    public String parseNode(String resp, Boolean processFile){
        Integer returnVar = 1; //1 is non success and 0 is success
        Set<String> jobIds = new Set<String>();
        List<Applicant_Job_Apps__c> appJobApps = new List<Applicant_Job_Apps__c>();
        try{
            applicant = new Applicant__c();
            applicantEmpList = new List<Applicant_Employment__c>();
            appEduList = new List<Applicant_Education__c>();
            
            DOM.Document doc = new DOM.Document();
            doc.load(resp); 
            DOM.XmlNode root = doc.getRootElement();
    
            getApplicant(root);

            if(applicant.Email__c!=null){
                applicant.Id = getCandidateId(applicant.Email__c);
            }

            if(applicant.name <> null) {

                /*if(applicant.Phone_Personal__c <> null){
                    applicant.Name = applicant.Phone_Personal__c + ' - ' +applicant.Name;
                }else if(applicant.Phone_Mobile__c  <> null){
                    applicant.Name = applicant.Phone_Mobile__c + ' - ' +applicant.Name;
                }*/
                if(applicant.Name.length() > 80 ){
                    applicant.Name = applicant.Name.substring(0,75) + '...';
                }

                applicant.Last_Synced_with_Talemetry__c = System.now();
                upsert applicant;
    
                System.debug('applicant..>>> '+applicant);
                
                if(String.isNotBlank(jobName)){
                    System.debug('jobName..>>> '+jobName);
                    jobIds = getJobId(jobName.split(','));
                    System.debug('jobId.>>> '+jobIds);
                    Map<string,Applicant_Job_Status__c > mapJobStatus = getPPJobStatus();
                    Map<String,String> mapDispositionStatusName = new Map<String,String>();
                    for(String ss : mapJobStatus.keySet()){
                        mapDispositionStatusName.put(mapJobStatus.get(ss).Status__c,ss);
                    }

                    if(!jobIds.isEmpty()){
                        for(String jobId : jobIds){
                            appJobApp = new Applicant_Job_Apps__c();
                            appJobApp.Name = jobName + ' - ' + applicant.First_Name__c + ' ' + applicant.Last_Name__c;
                            appJobApp.Applicant__c = applicant.Id;
                            appJobApp.Job__c = jobId;
                            appJobApp.ExternalId__c = jobId+applicant.Id;
                            appJobApp.Talemetry_Source__c = applicant.Talemetry_Source__c;
                            appJobApp.Talemetry_Sub_Source__c = applicant.Talemetry_Sub_Source__c;
                            if(mapDispositionStatusName.containsKey(jobAppStatus)) appJobApp.Status__c = mapDispositionStatusName.get(jobAppStatus);
                            appJobApps.add(appJobApp);
                        }
                        Schema.SObjectField f = Applicant_Job_Apps__c.Fields.ExternalId__c;
                        if(!appJobApps.isEmpty()) Database.upsert(appJobApps, f, true);
                    }
                   
                }
                
                parseXML(root, applicant.Id, processFile);
                if(!applicantEmpList.isEmpty()){
                    insert applicantEmpList;
                }
                if(!appEduList.isEmpty()){
                    insert appEduList;
                }
    
                
            }
            return applicant.Id; 
         }catch(Exception e){
            loggerEvents = new List<Logger__e>();
            System.debug('Exception > '+e.getMessage()+' at line no >'+e.getLineNumber());
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('TalemetryParseResponseUtil catch','exception catch during Parsing the response @line '+e.getLineNumber(),e.getMessage());
            tl.Status__c = 'Error';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
            List<Database.SaveResult> results = EventBus.publish(loggerEvents);
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
            return '1';
        }
    }
    
    public String use ='',customField='',UserTags='';
    public String getApplicant(DOM.XMLNode node){
        if(node == null) return '';
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            //system.debug(node.getName());
            if(node.getName()=='TransactionID'){
                //System.debug('Applicant Name..>>> '+node.getText().trim());
                applicant.TransactionID__c = node.getText().trim();
            }
            if(node.getName()=='GivenName'){
                applicant.First_Name__c = node.getText().trim();
                applicant.Name = node.getText().trim();
            }
            if(node.getName()=='MiddleName'){
                applicant.Middle_Name__c = node.getText().trim();
            }
            if(node.getName()=='FamilyName'){
                applicant.Last_Name__c = node.getText().trim();
                applicant.Name += ' '+node.getText().trim();
            }
            if(node.getName()=='InternetEmailAddress'){
                applicant.Email__c = node.getText().trim();
                //applicant.Web_Profile__c = node.getText().trim();
            }
            if(node.getName()=='InternetWebAddress'){
                applicant.Web_Profile__c = node.getText().trim();
            }
            if(node.getName()=='PostalCode'){
                applicant.Postal_Code_Zip__c = node.getText().trim();
            }
            if(node.getName()=='CountryCode'){
                applicant.Country__c = node.getText().trim();
            }
            if(node.getName()=='Municipality'){
                applicant.City__c = node.getText().trim();
            }
            if(node.getName()=='AddressLine'){
                applicant.Street__c = node.getText().trim();
            }
            if(node.getName()=='Region'){
                applicant.Province_State__c = node.getText().trim();
            }

            if(node.getName()=='DispositionStatusName'){
                jobAppStatus = node.getText().trim();
            }

            if(node.getName().containsIgnoreCase('UserTag') && node.getParent().getName().containsIgnoreCase('UserTags')){
                if(applicant.Tags__c <> null){
                    applicant.Tags__c += ';'+node.getText().trim();    
                }else{
                    applicant.Tags__c = node.getText().trim(); 
                }
                
            }
            if(node.getName()=='InternationalCountryCode' && node.getParent().getName()=='Mobile'){
                applicant.Phone_Mobile__c = node.getText().trim();
            }
            if(node.getName()=='AreaCityCode' && node.getParent().getName()=='Mobile'){
                applicant.Phone_Mobile__c += node.getText().trim();
            }
            if(node.getName()=='SubscriberNumber' && node.getParent().getName()=='Mobile'){
                applicant.Phone_Mobile__c += node.getText().trim();
            }

            if(node.getName()=='Use' && node.getParent().getName()=='ContactMethod'){
                use = node.getText().trim();
            }

            if(node.getName()=='InternationalCountryCode' && use.containsIgnoreCase('personal') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Personal__c = node.getText().trim();
            }
            if(node.getName()=='AreaCityCode' && use.containsIgnoreCase('personal') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Personal__c += node.getText().trim();
            }
            if(node.getName()=='SubscriberNumber' && use.containsIgnoreCase('personal') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Personal__c += node.getText().trim();
                //applicant.Name += ' - '+ applicant.Phone_Personal__c;
            }

            

            if(node.getName()=='InternationalCountryCode' && use.containsIgnoreCase('business') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Business__c = node.getText().trim();
            }
            if(node.getName()=='AreaCityCode' && use.containsIgnoreCase('business') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Business__c += node.getText().trim();
            }
            if(node.getName()=='SubscriberNumber' && use.containsIgnoreCase('business') && node.getParent().getName()=='Telephone'){
                applicant.Phone_Business__c += node.getText().trim();
            }


            if(node.getName()=='name' && node.getParent().getName()=='CustomField'){
                customField = node.getText().trim();
            }

            if(node.getName()=='value' && node.getParent().getName()=='CustomField'){
                if(customField.containsIgnoreCase('SubSource')){
                    Map<String, Talemetry_Candidate_Subsource_Mapping__c> subSourceMap = Talemetry_Candidate_Subsource_Mapping__c.getall();
                    String subSource = node.getText().trim();
                    String subsourceVal = subSource;
                    if(subSource.isNumeric() && subSourceMap.containsKey(subSource)){
                        subsourceVal = subSourceMap.get(subSource).Value__c;
                    }
                    applicant.Talemetry_Sub_Source__c = subsourceVal;
                }else if(customField.containsIgnoreCase('Source')){
                    applicant.Talemetry_Source__c = node.getText().trim();
                }
                
            }

            if(node.getName()=='JobCode'){
                jobName = node.getText().trim();
            }
            if(node.getName()=='Objective'){
                applicant.Employment_Objectives__c = node.getText().trim();
            }
            if(node.getName()=='HtmlResume'){
                //System.debug('node.getText().trim()..>> '+node.getText().trim());
                applicant.Resume_Text__c = node.getText().trim().length() > 131072 ? node.getText().trim().substring(0,131070): node.getText().trim();
            }
                
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            //System.debug('child.getName().>>>  '+child.getName());
            if(child.getName() == 'EmploymentHistory'){
                //System.debug('applicant @>'+applicant);
                return null;
            }
            //System.debug('continue loop');
            getApplicant(child);
        }
        return '';
    }

    
    public String parseXML(DOM.XMLNode node, Id appId, Boolean processFile) {
        if(node == null) return '';
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            Integer i=0;
            if(node.getName() == 'EmploymentHistory'){
                for(Dom.XMLNode childNode: node.getChildElements()){
                    i++;
                    appEmp = new Applicant_Employment__c();
                    System.debug('EmployerOrg...>>> '+ i +'  '+childNode.getName());
                    appEmp.Applicant__c = appId;
                    getEmployerOrg(childNode);
                    if(String.isNotBlank(appEmp.name)) applicantEmpList.add(appEmp);
                    
                }
            }
            if(node.getName() == 'EducationHistory'){
                for(Dom.XMLNode childNode: node.getChildElements()){
                    i++;
                    appEdu = new Applicant_Education__c();
                    //System.debug('EmployerOrg...>>> '+ i +'  '+EmployerOrg.getName());
                    appEdu.Applicant__c = appId;
                    getEducation(childNode);
                    if(String.isNotBlank(appEdu.name) && String.isNotBlank(appEdu.School_Name__c))appEduList.add(appEdu);
                    
                }
            }
            if(node.getName() == 'Base64BinaryResume'){
                if(processFile) {
                    resumeName = node.getAttributeValue('filename',null);
                    if(String.isNotBlank(resumeName)) createFile(node.getText().trim(),resumeName,applicant.id);  
                } else createFile('Error parsing resume. Content too Large','ERROR.txt',applicant.id);
              
                /*try {
                    resumeName = node.getAttributeValue('filename',null);
                    if(String.isNotBlank(resumeName)) createFile(node.getText().trim(),resumeName,applicant.id);
                } catch (Exception e) {
                    if(String.isNotBlank(resumeName))
                }*/
            }
            
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            parseXML(child,appId, processFile);
        }
        return null;
    }

    
    private void getEmployerOrg(DOM.XMLNode node) {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if(node.getName()=='EmployerOrgName'){

                if(node.getText() <> null && node.getText().trim().length() > 80 ){
                    appEmp.Name = node.getText().trim().substring(0,75) + '...';
                    
                }else{
                    appEmp.Name = node.getText().trim();
                } 
            }
            if(node.getName()=='Title'){
                appEmp.Title__c = (String.isNotBlank(node.getText()) ? ((node.getText()).length() > 255 ? (node.getText()).subString(0,253) : node.getText()) : '').trim();
            }
            if(node.getName()=='OrganizationName'){
                if(node.getText() <> null && node.getText().trim().length() > 255 ){
                	appEmp.Company_Name__c  = node.getText().trim().substring(0,250) + '...';
                }else{
                    appEmp.Company_Name__c  = node.getText().trim();
                } 
            }
            if(node.getName()=='Municipality'){
                appEmp.City__c = node.getText().trim();
            }
            if(node.getName()=='Region'){
                appEmp.Province_State__c = node.getText().trim();
            }

            if(node.getName()=='StringDate' && node.getParent().getName()=='EndDate' && node.getText().trim().containsIgnoreCase('current')){
                appEmp.Current__c = true;
            }

            if(node.getName()=='CountryCode'){
                appEmp.Country__c  = node.getText().trim();
            }
            if(node.getName()=='Description'){
                appEmp.Description__c = node.getText().trim();
            }
            String year, month; 
            if(node.getName()=='YearMonth' && node.getParent().getName()=='EndDate'){

                year = node.getText().trim().split('-')[0];
                month = node.getText().trim().split('-')[1];
                appEmp.End_Date__c = Date.newInstance(Integer.valueOf(year),Integer.valueOf(month),1);
            }
            if(node.getName()=='YearMonth' && node.getParent().getName()=='StartDate'){
                //appEmp.Start_Date__c = Date.valueOf(node.getText().trim());
                year = node.getText().trim().split('-')[0];
                month = node.getText().trim().split('-')[1];
                appEmp.Start_Date__c = Date.newInstance(Integer.valueOf(year),Integer.valueOf(month),1);
            }
            appEmp.Last_Sync_with_Talemetry__c = System.now();
            for (Dom.XMLNode child: node.getChildElements()) {
                getEmployerOrg(child);
            }
        }
    }
    
    private void getEducation(DOM.XMLNode node) {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if(node.getName()=='SchoolName'){
                if(node.getText() <> null && node.getText().trim().length() > 80 ){
                    appEdu.Name = node.getText().trim().substring(0,75) + '...';
                    
                }else{
                    appEdu.Name = node.getText().trim();
                }

                appEdu.School_Name__c = appEdu.Name;
                
            }
            if(node.getName()=='CountryCode'){
                appEdu.Country__c  = node.getText().trim();
            }
            if(node.getName()=='StringDate' && node.getText().trim().containsIgnoreCase('current')){
                appEdu.Current__c = true;
            }
            if(node.getName()=='Municipality'){
                appEdu.City__c = node.getText().trim();
            }
            if(node.getName()=='Region'){
                appEdu.Province_State__c  = node.getText().trim();
            }
            if(node.getName()=='DegreeName'){
                appEdu.Degree_Name__c  = node.getText().trim();
            }
            if(node.getName()=='DegreeDate' && string.isNotBlank(node.getText())){
                appEdu.Degree_Date__c = Date.newInstance(Integer.valueOf(node.getText().trim()),1,1);
            }
            if(node.getName()=='Name' && node.getParent().getName()=='DegreeMajor'){
                tempVariable = node.getText().trim();
                appEdu.Degree_Major_V2__c = (String.isNotBlank(tempVariable) && tempVariable.length() > 255) ? tempVariable.subString(0,255) : tempVariable;
            }
            if(node.getName()=='Year' && node.getParent().getName()=='StartDate'){
                appEdu.Start_Date__c = Date.newInstance(Integer.valueOf(node.getText().trim()),1,1);
            }
            if(node.getName()=='Year' && node.getParent().getName()=='EndDate'){
                appEdu.End_Date__c = Date.newInstance(Integer.valueOf(node.getText().trim()),1,1);
            }
            String year, month; 
            if(node.getName()=='YearMonth' && node.getParent().getName()=='EndDate'){
                year = node.getText().trim().split('-')[0];
                month = node.getText().trim().split('-')[1];
                appEdu.End_Date__c = Date.newInstance(Integer.valueOf(year),Integer.valueOf(month),1);
            }
            if(node.getName()=='YearMonth' && node.getParent().getName()=='StartDate'){
                year = node.getText().trim().split('-')[0];
                month = node.getText().trim().split('-')[1];
                appEdu.Start_Date__c = Date.newInstance(Integer.valueOf(year),Integer.valueOf(month),1);
            }

            appEdu.Last_Sync_with_Talemetry__c = System.now();
            for (Dom.XMLNode child: node.getChildElements()) {
                getEducation(child);
            }
        }
    }
    
    
    private void createFile(String filesContent, String fileName, Id applicantId){
        String fName = '';
        if(fileName.endsWithIgnoreCase('.docx')){
            system.debug('fileName: '+fileName);
            fName = fileName.split('\\.')[0]; //for word documents, exclude the file extention
        } else {
            fName = fileName; // Display name of the files
        }

        if([SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: applicantId AND ContentDocument.Title =: fName] > 0)
        return;

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = fName; 
        if(!fName.containsIgnoreCase('ERROR')){
            conVer.VersionData = EncodingUtil.base64Decode(filesContent); // converting your binary string to Blog
        }else{
            conVer.VersionData = Blob.valueOf(filesContent); // converting your binary string to Blog
        }
        insert conVer;    //Insert ContentVersion
        
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = applicantId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
    }   

    
    
    String returnText='';
    public String getNodeValue(DOM.XMLNode node,String text){
        if (node == null) return '';
        System.debug('getNodeValue node.getName()..>>>>>  '+node.getName());
        if(node.getName() == text){
            returnText = node.getText().trim();
            return returnText;
        }
        for(Dom.XMLNode child: node.getChildElements()){
            getNodeValue(child,text);
        }
        
        return returnText;
    }

    public Id getCandidateId(String email){
        List<Applicant__c> appList = [SELECT Id FROM Applicant__c WHERE Email__c=:email];
        if(!appList.isEmpty())
            return appList[0].Id;
        return null;
    }

    public Set<String> getJobId(List<String> jobName){
        Set<String> jobIds=new Set<String>();
        for(SFDC_Job__c job:[Select id from SFDC_Job__c where name IN: jobName]){
            System.debug('job..>>>>> '+job.Id);
            jobIds.add(job.Id);
        }

        return jobIds;
    }
    
    public static Talemetry_Logger__c getLogging(string webServiceName, string request, string response){
        Map<String,Talemetry_Replace_String__c> trs = Talemetry_Replace_String__c.getall();
        for(String nodeName : trs.keyset()){
            if(response <> null && response.contains(nodeName)){
                
                response = response.replace(response.substringBetween(nodeName),trs.get(nodeName).Node_Value__c);  
            }else if(request <> null && request.contains(nodeName)){
                request = request.replace(request.substringBetween(nodeName),trs.get(nodeName).Node_Value__c);  
            }
            
        }

        Talemetry_Logger__c tl = new Talemetry_Logger__c(Webservice__c = webServiceName,Request__c = request);
        if(response <> null && response.length() > 131071){
            tl.response__c = response.substring(0, 131070);
            String str =  response.substring(131071, response.length()-1);
            tl.response2__c = str.length() > 131070 ? str.substring(0, 131070) : str;
        }else{
            tl.response__c = response;
        }
        tl.Status__c = 'Completed';
        return tl;       
    }

    public static XmlStreamWriter createResponse(XmlStreamWriter w,String startElmnt, String chartrs){
        w.writeStartElement(null, startElmnt, null); 
        w.writeCharacters(!String.isBlank(chartrs)  ? chartrs : 'NOT AVAILABLE');
        w.writeEndElement(); 
        return w;
    }

    /**Prepare Canditate payloads for integration */
    Public static String upsertCandidatePayload(String appId){
        try{

            Applicant__c app = getApplicantData(appId).get(0);
            String upsertCandidatePayload = '';
            Map<String, TalemetrySettings__c> settings = TalemetrySettings__c.getall();
            list<Applicant_Employment__c> appEmploymentList = getAppEmployment(app.Id);
            list<Applicant_Education__c> appEducationList = getAppEducation(app.Id);
            list<Applicant_Job_Apps__c> appAppJobList = getAppJobs(app.Id);
            List<ContentDocumentLink> clinkList = getBlobData(app.Id);
            ContentDocumentLink cdlink = new ContentDocumentLink();
            cdlink  =  clinkList.size() > 0 ? clinkList.get(0):null;
            
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
                xmlW.writeStartElement(null,'Candidates', null);
                    xmlW.writeStartElement(null,'Candidate', null);
                        xmlW.writeStartElement(null,'UserArea', null);
                            
                            xmlW.writeStartElement(null,'IntegrationExternalID', null);
                                //xmlW.writeCharacters(settings.get('IntegrationExternalID').Value__c);
                                xmlW.writeCharacters(app.Id);
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'IntegrationFields', null);
                                xmlW.writeStartElement(null,'Candidate', null);
                                    xmlW.writeAttribute(null,null,'xmlns','http://ns.hr-xml.org/2007-04-15');
                                    xmlW.writeStartElement(null,'Resume', null);
                                        xmlW.writeStartElement(null,'StructuredXMLResume', null);
                                            xmlW.writeStartElement(null,'ContactInfo', null);
                                                xmlW.writeStartElement(null,'PersonName', null);
                                                    if(app.First_Name__c <> null)xmlW = createResponse(xmlW,'GivenName',app.First_Name__c);
                                                    if(app.Middle_Name__c <> null)xmlW = createResponse(xmlW,'MiddleName',app.Middle_Name__c);
                                                    if(app.Last_Name__c <> null)xmlW = createResponse(xmlW,'FamilyName',app.Last_Name__c);             
                                                xmlW.writeEndElement();
                                                xmlW.writeStartElement(null,'ContactMethod', null);
                                                    xmlW = createResponse(xmlW,'Use','personal'); 
                                                    
                                                    if(app.Phone_Personal__c <> null){
                                                        xmlW.writeStartElement(null,'Telephone', null);
                                                            xmlW = createResponse(xmlW,'FormattedNumber',app.Phone_Personal__c);
                                                        xmlW.writeEndElement();
                                                    }
                                                    
                                                    if(app.Phone_Mobile__c <> null){
                                                        xmlW.writeStartElement(null,'Mobile', null);
                                                            xmlW = createResponse(xmlW,'FormattedNumber',app.Phone_Mobile__c);
                                                        xmlW.writeEndElement();
                                                    }
                                                    
                                                    if(app.Email__c <> null)xmlW = createResponse(xmlW,'InternetEmailAddress',app.Email__c);
                                                    if(app.Web_Profile__c <> null)xmlW = createResponse(xmlW,'InternetWebAddress',app.Web_Profile__c);
                                                    
                                                    xmlW.writeStartElement(null,'PostalAddress', null);
                                                        if(app.Country__c <> null)xmlW = createResponse(xmlW,'CountryCode',app.Country__c);
                                                        if(app.Postal_Code_Zip__c <> null)xmlW = createResponse(xmlW,'PostalCode',app.Postal_Code_Zip__c);
                                                        if(app.Province_State__c <> null)xmlW = createResponse(xmlW,'Region',app.Province_State__c);
                                                        if(app.City__c <> null)xmlW = createResponse(xmlW,'Municipality',app.City__c);
                                                        if(app.Street__c <> null){
                                                            xmlW.writeStartElement(null,'DeliveryAddress', null);
                                                                xmlW = createResponse(xmlW,'AddressLine',app.Street__c);
                                                            xmlW.writeEndElement();
                                                        }
                                                        
                                                    xmlW.writeEndElement();
                                                xmlW.writeEndElement();
                                                xmlW.writeStartElement(null,'ContactMethod', null);
                                                    xmlW = createResponse(xmlW,'Use','business');
                                                    if(app.Phone_Business__c <> null){
                                                        xmlW.writeStartElement(null,'Telephone', null);
                                                            xmlW = createResponse(xmlW,'FormattedNumber',app.Phone_Business__c);
                                                        xmlW.writeEndElement();
                                                    } 
                                                    
                                                xmlW.writeEndElement();
                                            xmlW.writeEndElement();
                                            xmlW.writeStartElement(null,'ExecutiveSummary', null);
                                            xmlW.writeEndElement();
                                            if(app.Employment_Objectives__c <> null){
                                                xmlW = createResponse(xmlW,'Objective',app.Employment_Objectives__c);
                                            }
                                            
                                            if(!appEmploymentList.isEmpty()){
                                                xmlW.writeStartElement(null,'EmploymentHistory', null);
                                            
                                                //for loop start
                                                for(Applicant_Employment__c appEmp : appEmploymentList){
                                                    xmlW.writeStartElement(null,'EmployerOrg', null);
                                                        xmlW = createResponse(xmlW,'EmployerOrgName',appEmp.Name);
                                                        
                                                        xmlW.writeStartElement(null,'PositionHistory', null);
                                                            if(appEmp.Title__c <> null)xmlW = createResponse(xmlW,'Title',appEmp.Title__c);
                                                            String orgname = 'Default organization';
                                                            if(appEmp.Company_Name__c <> null) orgname = appEmp.Company_Name__c;
                                                                
                                                                xmlW.writeStartElement(null,'OrgName', null);
                                                                    xmlW = createResponse(xmlW,'OrganizationName',orgname);
                                                                xmlW.writeEndElement();
                                                            
                                                            
                                                            if(appEmp.City__c <> null || appEmp.Province_State__c <> null || appEmp.Country__c <> null){
                                                                xmlW.writeStartElement(null,'OrgInfo', null);
                                                                    xmlW.writeStartElement(null,'LocationSummary', null);
                                                                        if(appEmp.City__c <> null)xmlW = createResponse(xmlW,'Municipality',appEmp.City__c);
                                                                        if(appEmp.Province_State__c <> null)xmlW = createResponse(xmlW,'Region',appEmp.Province_State__c);
                                                                        if(appEmp.Country__c <> null)xmlW = createResponse(xmlW,'CountryCode',appEmp.Country__c); 
                                                                    xmlW.writeEndElement();
                                                                xmlW.writeEndElement();
                                                            }
                                                            
                                                            xmlW = createResponse(xmlW,'Description',appEmp.Description__c); 
                                                            
                                                            String startDate = ''+Datetime.now().format('YYYY-MM'),endDate = ''+Datetime.now().addYears(1).format('YYYY-MM');
                                                            if(appEmp.Start_Date__c <> null) startDate = ((Datetime)appEmp.Start_Date__c).format('YYYY-MM');
                                                                xmlW.writeStartElement(null,'StartDate', null);
                                                                    xmlW = createResponse(xmlW,'YearMonth', startDate);
                                                                xmlW.writeEndElement();
                                                            
                                                            
                                                            if(appEmp.End_Date__c <> null ) endDate = ((Datetime)appEmp.End_Date__c).format('YYYY-MM');
                                                            xmlW.writeStartElement(null,'EndDate', null);
                                                                if(appEmp.Current__c){
                                                                    xmlW = createResponse(xmlW,'StringDate','current'); 
                                                                }else{
                                                                    xmlW = createResponse(xmlW,'StringDate',endDate); 
                                                                }
                                                            xmlW.writeEndElement();
                                                            
                                                        xmlW.writeEndElement();
                                                    xmlW.writeEndElement();
                                                }
                                                    
                                                //for loop end

                                                xmlW.writeEndElement();
                                            }
                                            
                                            if(!appEducationList.isEmpty()){
                                                xmlW.writeStartElement(null,'EducationHistory', null);
                                                //for loop start
                                            
                                                for(Applicant_Education__c appEdu : appEducationList){
                                                    xmlW.writeStartElement(null,'SchoolOrInstitution', null);
                                                    xmlW.writeAttribute(null,null,'schoolType','');
                                                    
                                                        if(appEdu.School_Name__c <> null){
                                                            xmlW.writeStartElement(null,'School', null);
                                                                xmlW = createResponse(xmlW,'SchoolName',appEdu.School_Name__c);
                                                            xmlW.writeEndElement();
                                                        }
                                                        

                                                        if(appEdu.City__c <> null || appEdu.Province_State__c <> null || appEdu.Country__c <> null){
                                                            xmlW.writeStartElement(null,'LocationSummary', null);
                                                                if(appEdu.City__c <> null)xmlW = createResponse(xmlW,'Municipality',appEdu.City__c);
                                                                if(appEdu.Province_State__c <> null)xmlW = createResponse(xmlW,'Region',appEdu.Province_State__c);
                                                                if(appEdu.Country__c <> null)xmlW = createResponse(xmlW,'CountryCode',appEdu.Country__c);
                                                            xmlW.writeEndElement();
                                                        }
                                                        
                                                        String startDate = ''+Datetime.now().format('YYYY-MM'),endDate = ''+Datetime.now().addYears(1).format('YYYY-MM');
                                                        

                                                        xmlW.writeStartElement(null,'Degree', null);
                                                            if(appEdu.Degree_Name__c <> null)xmlW = createResponse(xmlW,'DegreeName',appEdu.Degree_Name__c);
                                                        
                                                            if(appEdu.Degree_Date__c <> null) startDate = ((Datetime)appEdu.Degree_Date__c).format('YYYY-MM');
                                                                xmlW.writeStartElement(null,'DegreeDate', null);
                                                                    xmlW = createResponse(xmlW,'YearMonth',startDate);
                                                                xmlW.writeEndElement();
                                                            
                                                            
                                                            if(appEdu.Degree_Major_V2__c <> null){
                                                                xmlW.writeStartElement(null,'DegreeMajor', null);
                                                                    xmlW = createResponse(xmlW,'Name',appEdu.Degree_Major_V2__c);
                                                                xmlW.writeEndElement();
                                                            }
                                                            

                                                            xmlW.writeStartElement(null,'DatesOfAttendance', null);
                                                                
                                                                if(appEdu.Start_Date__c <> null)startDate = ((Datetime)appEdu.Start_Date__c).format('YYYY-MM');
                                                                    xmlW.writeStartElement(null,'StartDate', null);
                                                                        xmlW = createResponse(xmlW,'YearMonth',startDate); 
                                                                    xmlW.writeEndElement();
                                                                
                                                                
                                                                if(appEdu.End_Date__c <> null)endDate = ((Datetime)appEdu.End_Date__c).format('YYYY-MM');
                                                                    xmlW.writeStartElement(null,'EndDate', null);
                                                                        xmlW = createResponse(xmlW,'YearMonth',endDate);
                                                                    xmlW.writeEndElement();
                                                                
                                                                

                                                            xmlW.writeEndElement();
                                                        xmlW.writeEndElement();
                                                    xmlW.writeEndElement();
                                                    //for loop end
                                                }                                       
                                                    

                                                xmlW.writeEndElement();
                                            }
                                            
                                        xmlW.writeEndElement();
                                        if(app.Resume_Text__c <> null){
                                            xmlW.writeStartElement(null,'NonXMLResume', null);
                                                xmlW = createResponse(xmlW,'TextResume',app.Resume_Text__c); 
                                            xmlW.writeEndElement();
                                        }
                                        

                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement(null,'UserArea', null);

                                        xmlW = createNotePayload(xmlW,app.Id);

                                        xmlW.writeStartElement(null,'CustomFields', null);
                                        xmlW.writeAttribute(null,null,'xmlns','');
                                            xmlW.writeStartElement(null,'CustomField', null);
                                                xmlW = createResponse(xmlW,'name','CandidateSource'); 
                                                xmlW = createResponse(xmlW,'value','salesforce_ats');  
                                            xmlW.writeEndElement();
                                        xmlW.writeEndElement();
                                        
                                        //appAppJobList
                                        if(!appAppJobList.isEmpty()){
                                            Map<string,Applicant_Job_Status__c > mapJobStatus = getPPJobStatus();
                                            xmlW.writeStartElement(null,'RelatedPositionPostings', null);
                                            for(Applicant_Job_Apps__c appJob : appAppJobList){
                                                //for loop start
                                                xmlW.writeStartElement(null,'RelatedPositionPosting', null);
                                                    xmlW = createResponse(xmlW,'Id',appJob.Job__r.Name);

                                                    if(appJob.Job_Title__c <> null )xmlW = createResponse(xmlW,'PostingTitle',appJob.Job_Title__c);

                                                    if(appJob.Accepted_Date__c <> null)xmlW = createResponse(xmlW,'JODate',''+appJob.Accepted_Date__c);

                                                    if(appJob.Applicant__r.CreatedDate <> null)xmlW = createResponse(xmlW,'DispositionDate',(''+appJob.Applicant__r.CreatedDate).split(' ').get(0));
                                                    String status = 'New';
                                                    if(appJob.Status__c <> null){
                                                        if(mapJobStatus.containsKey(appJob.Status__c)) status = mapJobStatus.get(appJob.Status__c).Status__c;
                                                        xmlW = createResponse(xmlW,'DispositionStatusName',status);
                                                    }

                                                    if(appJob.Disposition_Reason__c <> null)xmlW = createResponse(xmlW,'DispositionReasonName',appJob.Disposition_Reason__c);
                                                    
                                                    xmlW.writeStartElement(null,'DispositionStatusCode', null);
                                                        xmlW.writeCharacters('');//field mapping
                                                    xmlW.writeEndElement();

                                                xmlW.writeEndElement();
                                                //for loop end
                                            }
                                            xmlW.writeEndElement();
                                        }
                                        

                                           

                                        

                                        xmlW.writeStartElement(null,'Base64BinaryResume', null);
                                        xmlW.writeAttribute(null,null,'xmlns','http://resumemirror.com');
                                        if(cdlink <> null )xmlW.writeAttribute(null,null,'filename',cdlink.ContentDocument.Title);//field mapping
                                        if(cdlink <> null )xmlW.writeAttribute(null,null,'filetype',cdlink.ContentDocument.FileExtension);//field mapping
                                            if(cdlink <> null )xmlW.writeCharacters(EncodingUtil.base64Encode(cdlink.ContentDocument.LatestPublishedVersion.VersionData));//field mapping BASE64ENCODED
                                            //xmlW.writeCharacters(cdlink.ContentDocument.LatestPublishedVersion.VersionData.tostring());//field mapping BASE64ENCODED
                                        xmlW.writeEndElement();
                                        
                                        /*
                                        xmlW.writeStartElement(null,'UserFieldName001', null);
                                            xmlW.writeCharacters('');//field mapping
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement(null,'UserFieldName002', null);
                                            xmlW.writeCharacters('');//field mapping
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement(null,'UserFieldName003', null);
                                            xmlW.writeCharacters('');//field mapping
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement(null,'UserFieldName004', null);
                                            xmlW.writeCharacters('');//field mapping
                                        xmlW.writeEndElement();*/
                                    xmlW.writeEndElement();
                                xmlW.writeEndElement();
                            xmlW.writeEndElement();
                        xmlW.writeEndElement();
                    xmlW.writeEndElement();
                xmlW.writeEndElement();
            xmlW.writeEndDocument();
            upsertCandidatePayload = xmlW.getXmlString();
            xmlW.close();
            System.debug('upsertCandidatePayload..>>> '+upsertCandidatePayload);
            return upsertCandidatePayload; 
            
        }catch(Exception e){
            loggerEvents = new List<Logger__e>();
            System.debug('Exception > '+e.getMessage()+' at line no >'+e.getLineNumber());
            Talemetry_Logger__c tl  = TalemetryParseResponseUtil.getLogging('TalemetryParseResponseUtil catch','exception catch during Parsing the response @line '+e.getLineNumber(),e.getMessage());
            tl.Status__c = 'Error';
            loggerEvents.add(new Logger__e(Body__c= JSON.serialize(tl)));
            List<Database.SaveResult> results = EventBus.publish(loggerEvents);
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
            return '';
        }
    }
    

    public static list<Applicant_Job_Apps__c> getAppJobs(String appId){
        return [Select id,Name,Job_Title__c,Status__c,Applicant__r.CreatedDate,Disposition_Reason__c,Job__r.Name,Accepted_Date__c from Applicant_Job_Apps__c where Applicant__c =: appId Limit 10];
    }

    public static list<Applicant_Employment__c> getAppEmployment(String appId){
        return [SELECT Applicant__c,City__c,Company_Name__c,Country__c,CreatedById,CreatedDate,Current__c,Description__c,End_Date_Formatted__c,End_Date__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Last_Sync_with_Talemetry__c,Name,Province_State__c,Start_Date_Formatted__c,Start_Date__c,SystemModstamp,Title__c FROM Applicant_Employment__c where Applicant__c =: appId Limit 10];
    }
    
    public static list<Applicant_Education__c> getAppEducation(String appId){
        return [SELECT Applicant__c,City__c,Country__c,CreatedById,CreatedDate,Current__c,Degree_Date__c,Degree_Major_V2__c,Degree_Minor__c,Degree_Name__c,Degree_Type_Major__c,Description__c,End_Date_Formatted__c,End_Date__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Last_Sync_with_Talemetry__c,Name,Province_State__c,School_Name__c,Start_Date_Formatted__c,Start_Date__c FROM Applicant_Education__c where Applicant__c =:appId Limit 10];
    }

    public static list<Applicant__c> getApplicantData(String appId){
        return [SELECT Biography_Summary__c,City__c,Company__c,Country__c,CreatedById,CreatedDate,Do_Not_Contact__c,Do_Not_Hire__c,Email__c,Employment_Objectives__c,First_Name__c,Id,Industry__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Last_Name__c,Last_Synced_with_Talemetry__c,Middle_Name__c,Name,OwnerId,Phone_Business__c,Phone_Mobile__c,Phone_Personal__c,Postal_Code_Zip__c,Province_State__c,Resume_Text__c,Street_2__c,Street_3__c,Street_Joined__c,Street__c,SystemModstamp,Tags__c,Talemetry_Source__c,Talemetry_Sub_Source__c,TransactionID__c,Web_Profile__c FROM Applicant__c where id =:appId Limit 10];
    }
    
    public static List<ContentDocumentLink> getBlobData(String appId){
        return [SELECT Id,ContentDocumentId,ContentDocument.FileExtension,ContentDocument.Title, ContentDocument.LatestPublishedVersion.VersionData FROM ContentDocumentLink WHERE LinkedEntityId =: appId Limit 10];
    }

    public static XmlStreamWriter createNotePayload(XmlStreamWriter w,String appId){
        Map<Id,Applicant_Job_Apps__c> jobAppsMap = new Map<Id,Applicant_Job_Apps__c>(getAppJobs(appId));
        
        Map<ContentNote,Id> applicantNotesMap = getContentNotes(new Set<Id>{appId});
        Map<ContentNote,Id> jobAppsNotesMap = getContentNotes(jobAppsMap.keySet());
        List<Task> applicantTaskList = getTasks(new Set<Id>{appId});
        List<Task> jobAppsTaskList = getTasks(jobAppsMap.keySet());
        List<EmailMessage> applicantEmailList = getEmails(new Set<Id>{appId});
        List<EmailMessage> jobAppsEmailList = getEmails(jobAppsMap.keySet());
        
        String temp;

        //if(!jobAppsMap.isEmpty() || !applicantNotesMap.isEmpty() || !jobAppsNotesMap.isEmpty() || !applicantTaskList.isEmpty() || !jobAppsTaskList.isEmpty() || !applicantEmailList.isEmpty() || !jobAppsEmailList.isEmpty()){
            w.writeStartElement(null,'notes', null);
                for(ContentNote cn: applicantNotesMap.keySet()){
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',cn.Id);
                        w = createResponse(w,'date_time',''+cn.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Note on Applicant Created On '+cn.CreatedDate+' Note Details: '+cn.TextPreview;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }
            
                for(ContentNote cn: jobAppsNotesMap.keySet()){
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',cn.Id);
                        w = createResponse(w,'date_time',''+cn.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Note on Application '+(jobAppsMap.get(jobAppsNotesMap.get(cn))).Name+' Created On '+cn.CreatedDate+' Note Details: '+cn.TextPreview;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }
            
                for(Task tsk: applicantTaskList){
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',tsk.Id);
                        w = createResponse(w,'date_time',''+tsk.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Task on Applicant with Due Date on '+tsk.ActivityDate+' Task Subject: '+tsk.Subject+' Comments: '+tsk.Description;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }

                for(Task tsk: jobAppsTaskList){
                    String duedate = ''+tsk.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
                    if(tsk.ActivityDate <> null )duedate = ''+tsk.ActivityDate;
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',tsk.Id);
                        w = createResponse(w,'date_time',''+tsk.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Task on Application '+(jobAppsMap.get(tsk.WhatId)).Name+' with Due Date on '+duedate+' Task Subject: '+tsk.Subject+' Comments: '+tsk.Description;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }

                System.debug('email size..>> '+applicantEmailList.size());
                for(EmailMessage em: applicantEmailList){
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',em.Id);
                        w = createResponse(w,'date_time',''+em.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Email on Applicant Sent On '+em.MessageDate+' Email Subject: '+em.Subject;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }

                for(EmailMessage em: jobAppsEmailList){
                    w.writeStartElement(null,'note', null);
                        w = createResponse(w,'id',em.Id);
                        w = createResponse(w,'date_time',''+em.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                        temp = 'Salesfroce Email on Application '+(jobAppsMap.get(em.RelatedToId)).Name+' Sent On '+em.MessageDate+' Email Subject: '+em.Subject;
                        w = createResponse(w,'text',temp);
                        w = createResponse(w,'author_email',UserInfo.getUserEmail());
                        w = createResponse(w,'author_name',UserInfo.getUserName());
                    w.writeEndElement();
                }
            w.writeEndElement();
        //}
        
        
        return w;
    }
    /*
    public static list<Applicant__c> getApplicantNotes(String appId){
        return [ id =:appId];
    }

    public static list<Applicant__c> getApplicantJobNotes(String appId){
        return [ id =:appId];
    } 
    */
    
    public static Map<ContentNote,Id> getContentNotes(Set<Id> parentIds){
        Map<ContentNote,Id> contentNoteParentIdMap = new Map<ContentNote,Id>();
        if(!parentIds.isEmpty()){
            Map<Id,Id> contentLinkedEntityMap = new Map<Id,Id>();
            for(ContentDocumentLink cdl:[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:parentIds]){
                contentLinkedEntityMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
            }
            
            if(!contentLinkedEntityMap.isEmpty()){
                for(ContentNote cn:[SELECT Id, TextPreview, CreatedDate FROM ContentNote WHERE Id IN: contentLinkedEntityMap.keySet() Limit 10]){
                    contentNoteParentIdMap.put(cn,contentLinkedEntityMap.get(cn.Id));
                }
            }
        }
        return contentNoteParentIdMap;
    }
    
    public static list<Task> getTasks(Set<Id> appId){
        return [SELECT Id, Subject, CreatedDate, ActivityDate, Description, WhatId FROM Task WHERE WhatId IN: appId and type NOT IN ('Outbound Email','Inbound Email') Limit 10];
    }

    public static list<EmailMessage> getEmails(Set<Id> appId){
        return [SELECT Id, Subject, CreatedDate, MessageDate, RelatedToId FROM EmailMessage WHERE RelatedToId IN: appId Limit 10];
    }

    public static string getDateString(DateTime d){
        if(d <> null){
           return (''+d).split(' ').get(0); 
        }
        return '';
    }

    public String stripCDATA(String str) {
        Pattern p = Pattern.compile('<!\\[CDATA\\[(.*?)\\]\\]>');
        Matcher m = p.matcher(str);
        while(m.find()) {
            str = str.replace(m.group(), m.group(1).escapeXml());
        }
        return str;
    }    
    @future
    public Static void createLogger(String webServiceName,String request, String response){
        Talemetry_Logger__c tl  = getLogging(webServiceName,request,response);
        insert tl;
    } 
}