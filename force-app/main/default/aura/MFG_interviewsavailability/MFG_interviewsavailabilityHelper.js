({

    getCalendar: function(cmp, event, helper) {
        var action = cmp.get('c.initCalendar');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.calendar',resp);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
})