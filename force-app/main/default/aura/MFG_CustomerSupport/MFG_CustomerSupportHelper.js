({
	getHelpFaq : function(cmp, event, helper) {
        var action = cmp.get('c.getFAQ');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.helpFaq',resp);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
	},
    getSuppCases: function(cmp, event, helper) {
        var action = cmp.get('c.getSupport');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.supportCases',resp);
            } else if (state === 'ERROR') {
                  console.log('ERROR');
            }
        });
       // $A.enqueueAction(action);
	},
})