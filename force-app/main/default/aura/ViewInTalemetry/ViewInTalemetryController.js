({
	doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var sObjectType = component.get("v.sobjecttype");
        component.set("v.showSpinner", true);
        var action = component.get("c.getProfileURL");
        action.setParams({ recordId : component.get("v.recordId"), sobjectName : component.get("v.sobjecttype") });
        action.setCallback(this, function(response){
            component.set("v.showSpinner", true);
            var state = response.getState();
            if (state === "SUCCESS" && typeof response.getReturnValue() !='undefined') {
                if(response.getReturnValue()['pass'] == undefined && response.getReturnValue()['fail'] != undefined) this.showToast("Error","error",response.getReturnValue()['fail']);  
                if(response.getReturnValue()['fail'] == undefined && response.getReturnValue()['pass'] != undefined) {
                	var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": response.getReturnValue()['pass']
                    });
                    component.set("v.showSpinner", false);
                    urlEvent.fire();                      
                }
                else this.showToast("Error","error","Error Occured");               
            } else this.showToast("Error","error","Error Occured: "+response.getError());
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);	   
        $A.get("e.force:closeQuickAction").fire();        
	},
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();  
    }
    
})