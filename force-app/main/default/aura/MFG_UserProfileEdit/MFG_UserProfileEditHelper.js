({
    getParameterByName: function(component, event,helper, name) {

        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    getDetails: function(cmp, event, helper) {
        var action = cmp.get('c.getUserDetails');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.user',resp);
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    getOptions: function(cmp, event, helper) {
        var action = cmp.get('c.getPiclistOptions');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.options',resp);
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    saveDetails: function(cmp, event, helper) {
        var action = cmp.get('c.saveUserDetails');
        console.log(cmp.get('v.user'));
        console.log(cmp.get('v.user').LastName);
        action.setParams({
            user : JSON.stringify(cmp.get('v.user'))  
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var urlEvent = $A.get("e.force:navigateToURL");
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                urlEvent.setParams({
                    "url": "/profile/"+userId
                });
                urlEvent.fire();
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
})