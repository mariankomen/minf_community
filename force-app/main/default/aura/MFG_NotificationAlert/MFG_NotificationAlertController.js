({
    showToast: function (component, event, helper) {
        var action = component.get("c.getLastNot");
        var action_get = component.get("c.getNotificationState");
        var action_set = component.get("c.setNotificationState");
        var profile_get = component.get("c.getUserProfile");

        profile_get.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                component.set("v.userProfileTitle", JSON.parse(response.getReturnValue()).Name)
                if (component.get("v.userProfileTitle")) {
                    /*START */
                    action.setCallback(this, function (response) {
                        let state2 = response.getState();
                        if (state2 = "SUCCESS") {
                            if (JSON.parse(response.getReturnValue()) == null) {
                                console.error("Something were wrong.")
                            } else {
                                action_get.setCallback(this, function (response) {
                                    var state = response.getState();
                                    if (state == 'SUCCESS') {
                                        if (JSON.parse(response.getReturnValue()) == null) {
                                            action.setCallback(this, function (response) {
                                                var state = response.getState();
                                                if (state == 'SUCCESS') {

                                                    let backBody = JSON.parse(response.getReturnValue())[0].Body__c;
                                                    let parseBody = backBody.slice(backBody.indexOf('>') + 1, backBody.indexOf('/p') - 1)
                                                    component.set("v.notificationTitle", JSON.parse(response.getReturnValue())[0].Title__c)
                                                    component.set("v.notificationBody", JSON.parse(response.getReturnValue())[0].Body__c)
                                                } else {
                                                    let errors = response.getError();
                                                    let message = 'Unknown error';
                                                    if (errors && Array.isArray(errors) && errors.length > 0) {
                                                        message = errors[0].message;
                                                    }
                                                    console.error(message);
                                                }
                                            });
                                            $A.enqueueAction(action);
                                            component.set("v.showAlert", true)
                                            action_setT.setParams({ data: "false" })
                                            action_setT.setCallback(this, function (response) {
                                            })
                                            $A.enqueueAction(action_setT);
                                        } else if (JSON.parse(response.getReturnValue()).needShow__c == 'true') {
                                            action.setCallback(this, function (response) {
                                                var state = response.getState();
                                                if (state == 'SUCCESS') {

                                                    let backBody = JSON.parse(response.getReturnValue())[0].Body__c;
                                                    let parseBody = backBody.slice(backBody.indexOf('>') + 1, backBody.indexOf('/p') - 1)
                                                    component.set("v.notificationTitle", JSON.parse(response.getReturnValue())[0].Title__c)
                                                    component.set("v.notificationBody", JSON.parse(response.getReturnValue())[0].Body__c)
                                                } else {
                                                    let errors = response.getError();
                                                    let message = 'Unknown error';
                                                    if (errors && Array.isArray(errors) && errors.length > 0) {
                                                        message = errors[0].message;
                                                    }
                                                    console.error(message);
                                                }
                                            });
                                            $A.enqueueAction(action);
                                            component.set("v.showAlert", true)

                                        } else if (JSON.parse(response.getReturnValue()).needShow__c == 'false') {
                                            component.set('v.showAlert', false)
                                        } else {
                                            console.error('Unknown error. ')
                                        }
                                    } else {
                                        let errors = response.getError();
                                        let message = 'Unknown error';
                                        if (errors && Array.isArray(errors) && errors.length > 0) {
                                            message = errors[0].message;
                                        }
                                        console.error(message);
                                    }
                                })
                                $A.enqueueAction(action_get);
                            }
                        } else {
                            let errors = response.getError();
                            let message = 'Unknown error';
                            if (errors && Array.isArray(errors) && errors.length > 0) {
                                message = errors[0].message;
                            }
                            console.error(message);
                        }
                    });
                    $A.enqueueAction(action);
                    /*END */
                } else {
                    console.error("PROFILE IS NOT SYTEM ADMIN")
                }
            } else {
                let errors = response.getError();
                let message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        })
        $A.enqueueAction(profile_get);
    },
    handleChangeT: function (component, event, helper) {
        event.preventDefault();
        component.set('v.showAlert', false)
    },
    handleSubmitChangeT: function (component, event, helper) {
        event.preventDefault();
        component.set('v.showAlert', false);
        var action_setT = component.get("c.setNotificationState");
        action_setT.setParams({ data: "false" })
        action_setT.setCallback(this, function (response) {
        })
        $A.enqueueAction(action_setT);
    }
})