({
	doInit : function(component, event, helper) {
		var caseId = component.get("v.recordId");
        
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({"url": "/apex/CaseJobNew?id=" + caseId + "&retURL=/" + caseId});
        eUrl.fire();
	}
})