({
    init: function(cmp, event, helper) {
        var language = $A.get("$Locale.language");
        cmp.set('v.language',language);   
        
        var value = helper.getParameterByName(cmp , event,helper, 'editStatus');
        console.log(value);
        if(value && value=='true'){
            cmp.set('v.updateStatusRating',true);
             cmp.set('v.historyback',true);
        }
        
        
        
        helper.getCandDet(cmp, event, helper);
    },
    updateStatusRating: function(cmp, event, helper) {
        cmp.set('v.updateStatusRating',true);
    },
    
    
    handleStatusChange: function(cmp, event, helper) {
    	cmp.set("v.candidate.Rejection_Reason_for__c", "");
        cmp.set("v.candidate.Rejection_Comments__c", "");
        cmp.set("v.candidate.Candidate_Rating__c", "");   
    },
    
    
    updateUpdateStatusRating: function(cmp, event, helper) {
        let fieldAuraIds = ['MFG_Status', 'MFG_Rating', 'MFG_Reason', 'statusFields'];		
        let isValid = helper.validateStatusUpdateRequest(cmp, fieldAuraIds);

        if(isValid) helper.updateCandidate(cmp, event, helper);
    },

     closeModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set("v.hasModalOpen", false);        
    },
    
    cancelUpdateStatusRating: function(cmp, event, helper) {
        
        if(cmp.get("v.historyback")){
            window.history.back();
        }else{
            cmp.set('v.updateStatusRating',false);
            $A.get('e.force:refreshView').fire();                  
        }

        
    },
    goToJob: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job/"+val
        });
        
        urlEvent.fire();  
    },
    viewResume: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        console.log(val);
        if(val!=null && val!='null'){
              console.log('val');
            reportWindow = window.open(val,
                                       'View Resume',
                                       'height=600,width=800,toolbar=no,directories=no,status=no, linemenubar=no,scrollbars=no,resizable=no ,modal=yes');   
        }

        
    },
    viewPhoneScreen: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        //val = cmp.get('v.candidate').Candidate__r.Phone_Screen_Content_URL__c;
        console.log(val);
        if(val!=null && val!='null'){
            reportWindow = window.open(val,
                                       'View Phone Screen',
                                       'height=600,width=800,toolbar=no,directories=no,status=no, linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
        }
        
        
    },
    
    recruiterSummShow: function(cmp, event, helper) {
        cmp.set('v.recruiterSumm', !cmp.get('v.recruiterSumm'));
    },
    workHistoryShow: function(cmp, event, helper) {
        cmp.set('v.workHistory', !cmp.get('v.workHistory'));
    },
    handleCandidateLoad: function(cmp, event, helper) {
        cmp.set('v.candidateIsLoaded',true);
    },
    returnToListView: function(cmp, event, helper) {
        console.log('returnToCandidateList');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/SFDC_Job_Candidate__c/"
        });
        
        urlEvent.fire();  
    }

})