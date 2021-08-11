({
    getUser: function(cmp, event, helper) {
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
})