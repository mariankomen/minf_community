/*==============================================================================
 * Author       : Henry Caballero | floatintotheclouds
 * Date         : 5/6/2020
 * Description  : Jira Issue => MFG-149
 * Changes      : HC | 6/30/2020 | MFG-210
 * ===========================================================================*/
public class ContentDocumentLinkTriggerHandler 
{
    @testVisible
    final static String CONTENT_DISTRIBUTION_NAME = 'New distribution';

    public static void run(List<ContentDocumentLink  > docs_link,  map<id, ContentDocumentLink> docs_linksOld,  System.TriggerOperation triggerEvent ) 
    {                          
        switch on triggerEvent 
        {         
            when AFTER_INSERT
            {
                // this logic apply only for files related to an Applicant_Job_Apps__c record               
                shareFileAppJobApps(docs_link);
                updateDocIDFields(docs_link);
            }                                       
        }
    }
    
    // the buttons "View Candidates Resume" and "View Candidate Phone Screen" require this to preview the attached files
    public static void updateDocIDFields(List<ContentDocumentLink> docs_link)
    {
        set<id> setOfiles = new set<id> ();        
        list<ContentDocumentLink> validDocs = new list<ContentDocumentLink>(); 
        
        for (ContentDocumentLink cdl : docs_link)
        {
            string objectName =  cdl.LinkedEntityId.getSObjectType().getDescribe().getName().toLowerCase();
            if (objectName!= 'sfdc_candidate__c')
                continue;       
            setOfiles.add(cdl.ContentDocumentId);
            validDocs.add(cdl);
        }
        
        if (setOfiles.isEmpty())
            return;

        // this map is used to filter only those files that contains "Resume" or "Mindfield Candidate Screening" in theirs name.
        map<id,ContentVersion> filesMAP = new map<id,ContentVersion> ();        
        for (ContentVersion cv : [select id, ContentDocumentId, title from ContentVersion where ContentDocumentId in : setOfiles order by createddate asc ] )
        {
            filesMAP.put(cv.ContentDocumentId, cv);            
        }
        
        
        
        map<id,ContentDistribution> urlMAP = new map<id,ContentDistribution> ();  
        
         for (ContentDistribution dist : [Select ContentDownloadUrl , ContentDocumentId , DistributionPublicUrl                                       
                                         From Contentdistribution
                                         Where ContentDocumentId IN :setOfiles
                                         ])
        {
            urlMAP.put(dist.ContentDocumentId, dist);
        }
        
        
        map<id, sfdc_candidate__c> candidatesMAP = new map<id, sfdc_candidate__c>();
        for (ContentDocumentLink cdl : validDocs)
        {
            if ( !filesMAP.containskey(cdl.ContentDocumentId) )
                continue;
            
            sfdc_candidate__c candidate = new sfdc_candidate__c (id = cdl.LinkedEntityId);
            if (candidatesMAP.containskey(cdl.LinkedEntityId) )
                candidate = candidatesMAP.get(cdl.LinkedEntityId);
            
            ContentVersion file= filesMAP.get(cdl.ContentDocumentId);
            ContentDistribution url = urlMAP.get(cdl.ContentDocumentId);
            
            if ( file.title.containsIgnoreCase('Phone Screen'))
            {
                candidate.Phone_Screen_Doc_ID__c = file.id;//cdl.ContentDocumentId ; // 
                candidate.Phone_Screen_Content_URL__c = url!=null ? url.DistributionPublicUrl :  candidate.Phone_Screen_Content_URL__c;
            } else
            {
                candidate.Resume_Doc_ID__c = file.id; // cdl.ContentDocumentId;
                candidate.Resume_Content_URL__c = url!=null ? url.DistributionPublicUrl : candidate.Resume_Content_URL__c;
            }            
            candidatesMAP.put(cdl.LinkedEntityId, candidate);            
        }            
        
        update candidatesMAP.values();
                
      //  createContentDistribution(filesMAP.values() );
    }
        
     public static void createContentDistribution(List<ContentVersion> records)
     {
        List<ContentDistribution> newDistributions = new List<ContentDistribution>();
        
        set<id> existingContentDistribution = new set<id>();
        set<id> setOfFiles = new set<id>();
        for (ContentVersion cv : records) 
                setOfFiles.add(cv.id);
         
         for (ContentDistribution cd : [select contentVersionId from ContentDistribution where contentVersionId in : setOfFiles ] )
            existingContentDistribution.add(cd.contentVersionId);
             
        for(ContentVersion record : records)
        {                 
            if (existingContentDistribution.contains(record.Id) )            
                continue;
            
            newDistributions.add(new ContentDistribution(
                Name = CONTENT_DISTRIBUTION_NAME,
                contentVersionId = record.Id,
                PreferencesAllowViewInBrowser=true,
                PreferencesNotifyOnVisit=false
            ));                
        }
       
        insert newDistributions;            
    }
    
    
    public static void shareFileAppJobApps(List<ContentDocumentLink> docs_link  )
    {
        list<ContentDocumentLink> validDocs = new list<ContentDocumentLink>(); 
        set<id> setOfJobApps = new set<id> ();
        for (ContentDocumentLink cdl : docs_link)
        {
            string objectName =  cdl.LinkedEntityId.getSObjectType().getDescribe().getName().toLowerCase();
            if (objectName!= 'applicant_job_apps__c')
                continue;                       
            validDocs.add(cdl);
            setOfJobApps.add(cdl.LinkedEntityId);
        }
                        
        if (setOfJobApps.isEmpty() )
            return;

        // this map is used to know which is the SFDC_Candidate__c related to the Applicant_Job_Apps__c record
        map<id, id> JobAppsMAP = new map<id, id> ();
        for (Applicant_Job_Apps__c ja :[ select id, Candidate_Link_to_HirePortal_Record__r.candidate__c from Applicant_Job_Apps__c where id in :setOfJobApps and Candidate_Link_to_HirePortal_Record__c!=null]  )
        {
            JobAppsMAP.put(ja.id, ja.Candidate_Link_to_HirePortal_Record__r.candidate__c);                          
        }
        
        shareFile(validDocs,JobAppsMAP,'Phone Screen' );
        
    }
    
    
    public static void shareFileApplicants(List<ContentDocumentLink> docs_link, set<id> setOfJobApps )
    {                               
        if (setOfJobApps.isEmpty() )
            return;

        // this map is used to know which is the SFDC_Candidate__c related to the Applicant_Job_Apps__c record
        map<id, id> applicantsMAP = new map<id, id> ();
        for (Applicant_Job_Apps__c ja :[ select id, applicant__c, Candidate_Link_to_HirePortal_Record__r.candidate__c from Applicant_Job_Apps__c where id in :setOfJobApps and Candidate_Link_to_HirePortal_Record__c!=null and Candidate_Link_to_HirePortal_Record__r.candidate__c <> null]  )
        {
            applicantsMAP.put(ja.applicant__c, ja.Candidate_Link_to_HirePortal_Record__r.candidate__c);                         
        }
        
        shareFile(docs_link,applicantsMAP,null );        
    }
        
        
    public static void shareFile(List<ContentDocumentLink> docs_link, map<id, id> targetParentMAP, string fileNameFilter  )
    {   
        system.debug('targetParentMAP '+ targetParentMAP);
        
        if (docs_link.isEmpty())
            return;
        
        set<id> setOfiles = new set<id> ();       
        for (ContentDocumentLink cdl : docs_link)
        {                       
            setOfiles.add(cdl.ContentDocumentId);
        }
                       
        //and (title like '%resume%' or title like '%Mindfield Candidate Screening%')
        // this map is used to filter only those files that contains "Resume" or "Mindfield Candidate Screening" in theirs name.
        map<id,ContentVersion> filesMAP = new map<id,ContentVersion> ();        
        for (ContentVersion cv : [select id, ContentDocumentId, title from ContentVersion where ContentDocumentId in : setOfiles  ] )
        {
            filesMAP.put(cv.ContentDocumentId, cv);            
        }
        
        // get the existing document links
        map<id, set<id> > filesShares = new map<id, set<id> > ();
        for ( ContentDocumentLink cdl :  [select ContentDocumentId, LinkedEntityId from ContentDocumentLink where ContentDocumentId in : setOfiles ]  )
        {   set<id> document_links = new set<id> ();
            if (filesShares.containskey(cdl.ContentDocumentId))            
                document_links = filesShares.get(cdl.ContentDocumentId);
            document_links.add(cdl.LinkedEntityId);
            filesShares.put(cdl.ContentDocumentId,document_links );
        }
        
        list<ContentDocumentLink> cdls = new list<ContentDocumentLink>();
        for (ContentDocumentLink cdl : docs_link)
        {
            // there is not a SFDC_Candidate__c related record or the name of the file is not the name we expected.
            if ( !targetParentMAP.containskey(cdl.LinkedEntityId) || ( fileNameFilter!=null && !filesMAP.get(cdl.ContentDocumentId).title.containsIgnoreCase(fileNameFilter)  )  )                 
                continue;
            
            if (filesShares.containskey(cdl.ContentDocumentId) && filesShares.get(cdl.ContentDocumentId).contains(targetParentMAP.get(cdl.LinkedEntityId))  )    
                continue;
            
            // share the file with SFDC_Candidate__c related record
            ContentDocumentLink new_cdl = new ContentDocumentLink();
            new_cdl.ContentDocumentId   = cdl.ContentDocumentId;
            new_cdl.LinkedEntityId      = targetParentMAP.get(cdl.LinkedEntityId);
            new_cdl.ShareType           = 'V';
            new_cdl.Visibility          = 'AllUsers';
            cdls.add(new_cdl);
        }
        
        insert cdls;        
    }
    
    
}