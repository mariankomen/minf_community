({
    returnToListView : function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/customersupport?support=true"
        });
        urlEvent.fire();
    },
    init : function(cmp, event, helper) {
        console.log('init');
        helper.initform(cmp, event, helper);
    },
})