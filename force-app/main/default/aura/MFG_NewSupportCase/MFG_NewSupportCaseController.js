({
    init : function(cmp, event, helper) {
        console.log('init');
        helper.initform(cmp, event, helper);
    },
    handleLoad: function(cmp, event, helper) {
      //  console.log(event);
      //  cmp.set('v.showSpinner', false);
    },
    
    handleSubmit: function(cmp, event, helper) {

        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },
    
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:messages
        // so this just hides the spinner
        cmp.set('v.showSpinner', false);
    },
    
    handleSuccess: function(cmp, event, helper) {
        var params = event.getParams();
        console.log('v.recordId', params.response.id);
        cmp.set('v.recordId', params.response.id);
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
        
             var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/customersupport?support=true"
        });
        urlEvent.fire();   
        
        
    },
    
    goToCaseList: function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/customersupport?support=true"
        });
        urlEvent.fire();
    }

})