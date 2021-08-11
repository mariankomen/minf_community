({

    getAccountId: function (cmp, event, helper) {

        var action = cmp.get('c.getUserAccountId');

        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.accountId', resp)
            } else if (state === 'ERROR') {
                console.error(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    saveHRAv: function (cmp, event, helper) {

        var startDate = cmp.get('v.start');
        var endDate = cmp.get('v.end');
        var interviewDuration = cmp.get('v.Duration');
        var interviewerAvailable = cmp.get('v.interviewerAvailable');
        var repeat = cmp.get('v.repeat');
        var repeatDate = cmp.get('v.repeatDate');


        var action = cmp.get('c.saveHiringManagerAvailability');

        action.setParams({
            startDate: startDate,
            endDate: endDate,
            interviewDuration: interviewDuration,
            interviewerAvailable: interviewerAvailable,
            repeat: repeat,
            repeatDate: repeatDate

        });

        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/interviews-availability"
                });
                urlEvent.fire();
            } else if (state === 'ERROR') {
                console.error(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

})