({
    getCaseComments: function(cmp, event, helper) {
        var action = cmp.get('c.getPublicCaseComments');
        console.log(cmp.get("v.caseId"));
        action.setParams({
            caseId :cmp.get("v.caseId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.caseComments',resp);

            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
})