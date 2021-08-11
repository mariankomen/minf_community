({
    tabSelect : function(cmp, event, helper) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        console.log(val);
        if(val && val=='help'){
            cmp.set('v.help',true);
            cmp.set('v.support',false);
            cmp.set('v.resources',false);
        }else if(val && val=='support'){
            cmp.set('v.help',false);
            cmp.set('v.support',true);
            cmp.set('v.resources',false);            
        }else if(val && val=='resources'){
            cmp.set('v.help',false);
            cmp.set('v.support',false);
            cmp.set('v.resources',true);
        }	
        
        
        console.log(cmp.get('v.column1'));
    },
    
    init: function(cmp, event, helper) {
      console.log('value');
        var value = helper.getParameterByName(cmp , event,helper, 'support');
        console.log(value);
        if(value && value=='true'){
            cmp.set('v.help',false);
            cmp.set('v.support',true);
            cmp.set('v.resources',false); 
        } 

        
        //helper.getHelpFaq(cmp, event, helper);
      //  helper.getSuppCases(cmp, event, helper);
    },
    newSupportCase: function(cmp, event, helper) {

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/new-customer-support-case"
        });
        urlEvent.fire();
    }
})