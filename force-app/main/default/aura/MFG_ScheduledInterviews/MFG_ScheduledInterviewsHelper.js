({
    getScheduledInterviews: function (cmp, event, helper){
        var action = cmp.get('c.getSchInterviews');
        action.setParams({ 
            upcoming : cmp.get('v.upcoming')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log('scheduledInterviews',resp);
              cmp.set('v.scheduledInterviews',resp);
                
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action); 
    },
})