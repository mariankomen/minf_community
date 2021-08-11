({
    getJobDeails: function(cmp, event, helper) {
        var action = cmp.get('c.initJobDeails');
        
        action.setParams({
            jobId :cmp.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.job',resp);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
    }
})