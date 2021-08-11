({
    updateInterviewAvailability : function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/interviews-availability"
        });
        urlEvent.fire();
    },
        init: function(cmp, event, helper) {
            helper.getScheduledInterviews(cmp, event, helper);
    },
    getInterviews: function(cmp, event, helper) {

        cmp.set('v.upcoming',false);
        helper.getScheduledInterviews(cmp, event, helper);
    },
    
    geUpcomingtInterviews: function(cmp, event, helper) {

        cmp.set('v.upcoming',true);
        helper.getScheduledInterviews(cmp, event, helper);
    },
    goToCandidate: function(cmp, event, helper) {
              
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log(id_str);
  
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/"+id_str
        });
        urlEvent.fire();
    },
})