({
    init: function(cmp, event, helper) {
         var value = helper.getParameterByName(cmp , event,helper, 'userId');
        console.log(value);
        if(value){
            cmp.set('v.userId',value);
            helper.getDetails(cmp , event,helper);
             helper.getOptions(cmp , event,helper);
           
        }
    },
    
    cancel: function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        urlEvent.setParams({
            "url": "/profile/"+userId
        });
        urlEvent.fire();
    },
    save: function(cmp, event, helper) {



          helper.saveDetails(cmp, event, helper);
    },
    LastName: function(cmp, event, helper) {
console.log('dsfsdfsdf');
     
    },
        handleKeyUp: function (cmp, evt) {
            console.log('sdfsdf');
        var isEnterKey = evt.keyCode === 13;
       
            var queryTerm = cmp.find('LastName').get('value');
            console.log('Searched for "' + queryTerm + '"!');
        
    }
})