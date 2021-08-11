({
    initform: function (cmp, event, helper) {

        var action = cmp.get('c.initJobForm');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.job', resp);
                cmp.set('v.showSpinner', true);
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },

    getUserBannerOfStore: function (cmp, event, helper) {

        var action = cmp.get('c.getBannerOfStore');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.bannerOfStore', resp);

            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },

    checkHRAv: function (cmp, event, helper) {
        var action = cmp.get('c.chechInterviewAvailability');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.available', resp);
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);

    }
})