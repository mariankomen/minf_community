({
    filterJobCandidates: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        console.log(val);
        
        if(val && val=='Outstanding'){
            cmp.set('v.outstanding',true);
            cmp.set('v.accepted',false);
            cmp.set('v.rejected',false);
        }else if(val && val=='Accepted'){
            cmp.set('v.outstanding',false);
            cmp.set('v.accepted',true);
            cmp.set('v.rejected',false);            
        }else if(val && val=='Rejected'){
            cmp.set('v.outstanding',false);
            cmp.set('v.accepted',false);
            cmp.set('v.rejected',true);
        }
    },
    
    init: function(cmp, event, helper) {
        helper.getCandidateList(cmp, event, helper);
    },
    navigateToCandidate: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/"+val
        });
        urlEvent.fire();
        
    },
    editCandidateStatusRating: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/"+val+"?editStatus=true"
        });
        urlEvent.fire();
        
    },
    changeRowsPerPage: function(cmp, event, helper) {
        var maxResult = event.getParam("value");
        
        console.log(maxResult);
        cmp.set('v.maxResults',maxResult);
        
        var resp=cmp.get('v.candidates');
        var candidates={};
        var outstandingSet= helper.initTableSettings(cmp,resp.outstanding); 
        console.log(outstandingSet);
        var outstanding= resp.outstanding.slice(0, maxResult);
        console.log(outstanding);
        candidates.outstanding={'settings':outstandingSet,'outstanding':outstanding};
        
        var acceptedSet= helper.initTableSettings(cmp,resp.accepted); 
        var accepted= resp.accepted.slice(0, maxResult);
        candidates.accepted={'settings':acceptedSet,'accepted':accepted};
        
        var rejectedSet= helper.initTableSettings(cmp,resp.rejected); 
        var rejected= resp.rejected.slice(0, maxResult);
        candidates.rejected={'settings':rejectedSet,'rejected':rejected};
        console.log(candidates);
        cmp.set('v.fdcJobCandidates',candidates);
    },
    
    nextpage: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var tableName = ctarget.dataset.value;
        
        var jobCandidates= cmp.get('v.fdcJobCandidates');
        var candidates=cmp.get('v.candidates');
        if(tableName=='outstanding'){
            var pageSettings=jobCandidates.outstanding.settings;
            jobCandidates.outstanding.settings.curentpage=jobCandidates.outstanding.settings.curentpage+1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.outstanding.outstanding=[];
            jobCandidates.outstanding.outstanding= candidates.outstanding.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }else if(tableName=='accepted'){
            
            var pageSettings=jobCandidates.accepted.settings;
            jobCandidates.accepted.settings.curentpage=jobCandidates.accepted.settings.curentpage+1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.accepted.accepted=[];
            jobCandidates.accepted.accepted= candidates.accepted.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }else if(tableName=='rejected'){
            
            var pageSettings=jobCandidates.rejected.settings;
            jobCandidates.rejected.settings.curentpage=jobCandidates.rejected.settings.curentpage+1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.rejected.rejected=[];
            jobCandidates.rejected.rejected= candidates.rejected.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }
    },
    
    previouspage: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var tableName = ctarget.dataset.value;
        var jobCandidates= cmp.get('v.fdcJobCandidates');
        var candidates=cmp.get('v.candidates');
        if(tableName=='outstanding'){
            var pageSettings=jobCandidates.outstanding.settings;
            console.log(tableName);
            jobCandidates.outstanding.settings.curentpage=jobCandidates.outstanding.settings.curentpage-1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.outstanding.outstanding=[];
            jobCandidates.outstanding.outstanding= candidates.outstanding.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }else if(tableName=='accepted'){
            
            var pageSettings=jobCandidates.accepted.settings;
            jobCandidates.accepted.settings.curentpage=jobCandidates.accepted.settings.curentpage-1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.accepted.accepted=[];
            jobCandidates.accepted.accepted= candidates.accepted.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }else if(tableName=='rejected'){
            
            var pageSettings=jobCandidates.rejected.settings;
            jobCandidates.rejected.settings.curentpage=jobCandidates.rejected.settings.curentpage-1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobCandidates.rejected.rejected=[];
            jobCandidates.rejected.rejected= candidates.rejected.slice(settings.begin, settings.end);
            cmp.set('v.fdcJobCandidates',jobCandidates);
        }
    }
})