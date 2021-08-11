/*
Project: Chequed - LMP Report (Phase 1)
Date: Jan 2017
Description: When we get candidate record from Hiredesk, we want to make a webservice call 
to HRNX to retireve the URL to the LMP. 
Called from trigger, CandidateRec_Before_Insert.
*/


//WEB SERVICE EXAMPLE
//https://resources.docs.salesforce.com/sfdc/pdf/salesforce_apex_language_reference.pdf
public class HNRX_Webservice {

    //get HRNX end point
    private static Vendor_Webservice__c vws = Vendor_Webservice__c.getInstance('HRNX_Webservice');
 
    @Future(callout=true)
    public static void retieveLMPURL(string sHD_Candidate_GUID, id cId) {
    
        string sReturnURL = '';
        string sReturnURLPDF = '';
        string sReturnError = '';
        
        if(!String.isBlank(sHD_Candidate_GUID)) { //check if we have guid from Hiredesk
    
            String username = vws.User_Name__c;
            String password = vws.Password__c;
                
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(vws.End_Point__c);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            req.setBody('{"hrnx_txn_id":"' + sHD_Candidate_GUID + '"}');
            
            //Example....            
            //req.setBody('{"hrnx_txn_id":"44529a56-c3e6-11e6-9da2-005056951cca"}');
                
            HttpResponse res;
            
            try {
                res = h.send(req);
                JSONParser parser = JSON.createParser(res.getBody());
                    
                while (parser.nextToken() != null) {
                    //find URL field
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'resultURL')) {
                        parser.nextToken();
                        string sTemp = parser.getText();
                        
                        //Three resultURL cases
                        //1. resultURL: "Not Found"
                        //2. resultURL: "System Error"
                        //3. resultURL: "LMP URL Returned"
                        
                        if(sTemp.Contains('http')) { //got back LMP, 3
                            //we get URL in different ways...
                            //EG
                            //1. http://mfg.chequed.com/candidate/78x86pWELUDcSfeF99BJbw--
                            //2. https://mfg.chequed.com/report/LWJ.2XhzNxXZI6WkukPaKA--np
                           
                           //manipulate URL to build PDF url
                           if(sTemp.Contains('candidate')) { 
                                sReturnURL = sTemp;
                                sReturnURLPDF = sTemp.replace('candidate', 'report');
                            }
                            //manipulate URL to build report url
                            else if(sTemp.Contains('report')) { 
                                sReturnURLPDF = sTemp;
                                sReturnURL = sTemp.replace('report', 'candidate');
                            }
                            else { //shouldn't get here but just in case
                                sReturnURL = sTemp;
                                sReturnURLPDF = 'unavailable';
                            }
                        }
                        else {
                            sReturnError = 'HRNX Message: ' + sTemp; //1 or 2 occured
                        }
                    }
                }
            }     
            catch (Exception e) {
                sReturnError = 'Error: Try/Catch Exception - ' + e.getMessage();            
            }   
        }
        else {
            sReturnError = 'Hiredesk guid not provided.';
        }
        
        //retrieve and update record --------------------------------------------------------------------------------------------- 
        SFDC_Candidate__c c = [SELECT id, LMP_Report_URL__c, LMP_Report_URL_PDF__c, LMP_Report_URL_Exception__c FROM SFDC_Candidate__c WHERE id =: cId];
        c.LMP_Report_URL__c=sReturnURL;
        c.LMP_Report_URL_PDF__c=sReturnURLPDF;
        c.LMP_Report_URL_Exception__c=sReturnError;
        update c;
        //------------------------------------------------------------------------------------------------------------------------
    }
    
}