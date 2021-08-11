({
    editProfile : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(userId);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/user-profile-edit?userId="+userId
        });
        urlEvent.fire();
    }
})