({
	expandCollaps : function(cmp, event, helper) {
		cmp.set('v.collapsed', !cmp.get('v.collapsed'));
	},
    
    filterJobCandidates: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        // console.log(val);

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
    returnToJobList: function(cmp, event, helper) {
        // console.log('returnToJobList');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job/SFDC_Job__c/"
        });
       
        urlEvent.fire();
    },
    init: function(cmp, event, helper) {
        helper.getJobDeails(cmp, event, helper);
    },
    
    navigateToCandidate: function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/"+val
        });
        
        urlEvent.fire();
    }
})