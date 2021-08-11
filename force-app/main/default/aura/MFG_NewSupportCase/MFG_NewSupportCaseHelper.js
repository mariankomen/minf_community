({
	initform : function(cmp, event, helper) {
		
        var action = cmp.get('c.initCaseForm');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
               cmp.set('v.fields',resp);
                
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
	}
})