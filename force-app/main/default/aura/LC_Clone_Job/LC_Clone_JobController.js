({
	doInit : function(component, event, helper) {
       
        var myQuery = 'SELECT Name, Field_Value__c FROM CloneJobFields__c'; //get fields to clone
        var action = component.get("c.executeQuery"); //execute query, apex class Apex_Clone_Job_Controller
        
        action.setParams({ "theQuery": myQuery }); //set query string
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state == "SUCCESS" && component.isValid()){ //success, built URL
                var queryResult = response.getReturnValue();
                var jobId = component.get("v.recordId");
                //var cloneURL = "/" + jobId + "/e?clone=1&00NU0000003Auge=Open/Active+Job&retURL=/" + jobId; 
                var cloneURL = "/" + jobId + "/e?clone=1&retURL=/" + jobId;
                
                for(var i = 0; i < queryResult.length; i++){
                	cloneURL = cloneURL+"&"+queryResult[i].Name+"="; 
					if (queryResult[i].Field_Value__c != null) { 
						cloneURL = cloneURL +queryResult[i].Field_Value__c; 
					} 
            	}
                
                var urlRedirect= $A.get("e.force:navigateToURL");
				urlRedirect.setParams({"url": cloneURL});
                urlRedirect.fire();
            }
            else { //error, display toast message
                let toastParams = {
             		title: "Error",
             		message: "An error has occured during the duplication process.", // Default error message
             		type: "error"
            	};
           		let toastEvent = $A.get("e.force:showToast");
           		toastEvent.setParams(toastParams);
           		toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action); //queue up action
        //$A.get("e.force:closeQuickAction").fire();   
	}
})