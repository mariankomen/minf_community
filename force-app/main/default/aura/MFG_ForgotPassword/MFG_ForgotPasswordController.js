({
    handleForgotPassword: function (component, event, helpler) {
        console.log('handleForgotPassword');
        helpler.handleForgotPassword(component, event, helpler);
    },
    onKeyUp: function(component, event, helpler){
        console.log('onKeyUp');
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleForgotPassword(component, event, helpler);
        }
    },
    
    setExpId: function (component, event, helper) {
        console.log('setExpId');
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
    
    initialize: function(component, event, helper) {
        console.log('initialize');
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
    },
    logacase: function(cmp, event, helper) {
         window.location.replace("https://www.mindfieldgroup.com/logacase.php");
       // $A.get("e.force:navigateToURL").setParams( { url: 'https://www.mindfieldgroup.com/logacase.php' }).fire();
    }
})