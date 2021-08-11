({
    qsToEventMap: {
        'expid'  : 'e.c:setExpId'
    },
    
    
  /*  handleForgotPassword: function (component, event, helpler) {
        console.log('handleForgotPassword');
        var action = component.get("c.forgotPassowrdTest");
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
       });
        $A.enqueueAction(action);
    },*/
    
    
    
    handleForgotPassword: function (component, event, helpler) {
      
        var username = component.find("username").get("v.value");
        var checkEmailUrl = component.get("v.checkEmailUrl");
        
        console.log(username);
         console.log(checkEmailUrl);
        var action = component.get("c.forgotPassword");
       
        action.setParams({username:username, checkEmailUrl:checkEmailUrl});
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            var rtnValue = a.getReturnValue();
            if (rtnValue != null) {
               component.set("v.errorMessage",rtnValue);
               component.set("v.showError",true);
            }
       });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helpler) {
          console.log('setBrandingCookie');
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})