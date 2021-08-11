({

    getOptions: function (cmp, event, helper){
         console.log('SELECT getOptions');
        var action = cmp.get('c.getPicklistValueBasedonRecordType');
        action.setParams({ 
            objectApiName: cmp.get('v.objectApiName'),
            fieldApiName: cmp.get('v.fieldApiName'),
            recordTypeId: cmp.get('v.recordTypeId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.options',resp);
                  cmp.set('v.filteredoptions',resp);
              
            } else if (state === 'ERROR') {
                console.log('ERROR');
                var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log(errors[0].message);
                }
            }
            }
        });
        $A.enqueueAction(action); 
    },
})