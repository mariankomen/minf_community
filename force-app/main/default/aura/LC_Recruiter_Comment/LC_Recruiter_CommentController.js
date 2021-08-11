({
	doInit : function(component, event, helper) {
		var jobId = component.get("v.recordId");
        
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({"url": "/apex/RecruiterCommentNew?retURL=/" + jobId + "&jid=" + jobId});
        eUrl.fire();
	}
})