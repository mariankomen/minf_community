({
    doInit: function (cmp, event, helper) {
        helper.getAccountId(cmp, event, helper);
        var sPageURL = window.location.search.substring(1);
        var hasAvailability = (sPageURL.includes('JobId'));
        cmp.set('v.hasAvailability', !hasAvailability);
        cmp.set('v.JobId', sPageURL.substring(sPageURL.indexOf('JobId=') + 6, sPageURL.indexOf('&')))
        cmp.set('v.job_is_for_Store_if_applicable', sPageURL.substring(sPageURL.indexOf('&JobisforStore=') + 15))
        if (hasAvailability) {
            var action1 = cmp.get('c.getUserLanguage');
            action1.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.language', response.getReturnValue());
                } else if (state === 'ERROR') {
                    console.log('ERROR');
                }
            });
            $A.enqueueAction(action1);


            cmp.set('v.newHRAv', true);
            var jobId = sPageURL.substring(sPageURL.indexOf('=') + 1, sPageURL.indexOf('&'));
            cmp.set('v.jobId', jobId);
            var action = cmp.get('c.getMinimumInterviewHours');
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.minimumNumbersOfHour', response.getReturnValue());
                } else if (state === 'ERROR') {
                    console.log('ERROR');
                }
            });
            $A.enqueueAction(action);
            var action2 = cmp.get('c.getMinimumInterviewDays');
            action2.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.minimumNumbersOfDay', response.getReturnValue());
                } else if (state === 'ERROR') {
                    console.log('ERROR');
                }
            });
            $A.enqueueAction(action2);
            var action3 = cmp.get('c.getMaxAmountOfDays');
            action3.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.maxNumbersOfDay', response.getReturnValue());
                } else if (state === 'ERROR') {
                    console.log('ERROR');
                }
            });
            $A.enqueueAction(action3);

        }
    },
    hasAvailabilityOk: function (cmp, event, helper) {
        cmp.set('v.hasAvailability', true);
    },
    changeValue: function (cmp, event, helper) {
        var start = cmp.find("Interview_Start_Date").get("v.value");
        var repet = cmp.find("Repeat_for_x_Weeks").get("v.value");
        var end = cmp.find("Recurrence_Ends_On").get("v.value");
        var addDays = repet * 7;
        var startDate = new Date($A.localizationService.formatDate(start, "yyyy-MM-dd"));
        startDate.setDate(startDate.getDate() + addDays);
        cmp.find("Recurrence_Ends_On").set("v.value", $A.localizationService.formatDate(startDate, "yyyy-MM-dd"));

        if (event.getSource().get("v.fieldName") == 'Repeat_for_x_Weeks__c') {
            if (event.getParam('value') > 0) {
                cmp.set('v.reOccur', true);
            } else {
                cmp.set('v.reOccur', false);
            }

        }
        if (event.getSource().get("v.fieldName") == 'Interview_Start_Date__c') {
            var start = cmp.find("Interview_Start_Date").get("v.value");
            var weekDays = cmp.find("Recurs_every_week_on").get("v.value");
            cmp.find("Recurs_every_week_on").set("v.value", $A.localizationService.formatDateTime(start, "EEEE", "en_US"));



        }
    },

    changetimevalue: function (cmp, event, helper) {
        var startTime = cmp.get('v.startTime');
        var endTime = cmp.get('v.endTime');
        var inputCmp = cmp.find('endTime');
        if (endTime) {

            if (startTime > endTime) {
                inputCmp.setCustomValidity("End time should be greater than start time");
            } else {
                inputCmp.setCustomValidity("");
            }
            inputCmp.reportValidity();
        }
    },

    validate: function (cmp, event, helper) {
        if (event.getSource().get("v.name") == 'saveAndNew') {
            cmp.set('v.saveAndNew', true);
        } else {
            cmp.set('v.saveAndNew', false);
        }

        // document.location.reload();
        var inputstartTime = cmp.find("startTime");
        var inputendTime = cmp.find("endTime");
        inputstartTime.reportValidity();
        inputendTime.reportValidity();
    },


    handleSubmitEdit: function (cmp, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.Hiring_Managers_Store__c = cmp.get('v.accountId');


        fields.Start_Time__c = cmp.get('v.startTime');
        fields.End_Time__c = cmp.get('v.endTime');

        var inputstartTime = cmp.find("startTime");
        var inputendTime = cmp.find("endTime");
        inputstartTime.reportValidity();
        inputendTime.reportValidity();
        if (inputstartTime.get("v.value") && inputendTime.get("v.value")) {
            cmp.find('newHrAvailability').submit(fields);
        } else {
            inputstartTime.reportValidity();
            inputendTime.reportValidity();
        }


    },

    handleSuccessEdit: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        if (cmp.get('v.saveAndNew')) {
            urlEvent.setParams({
                "url": "/new-interview-availability"
            });
        } else {
            if (cmp.get('v.minimumNumbersOfHour') != null) {
                urlEvent.setParams({
                    "url": "/interviews-availability?JobId=" + cmp.get('v.JobId') + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable')
                });
            } else {
                urlEvent.setParams({
                    "url": "/interviews-availability"
                });
            }
        }
        urlEvent.fire();

    },
    handleLoadEdit: function (cmp, event, helper) {
        var start = cmp.find("Interview_Start_Date").get("v.value");
        var end = cmp.find("Recurrence_Ends_On").get("v.value");
        cmp.find("Recurs_every_week_on").set("v.value", $A.localizationService.formatDateTime(start, "EEEE", "en_US"));
    },
    update: function (component, event, helper) {
        // Get the new hash from the event
        var loc = event.getParam("token");
        if (component.get('v.minimumNumbersOfHour') != null) {

        }
    }
    ,
    cancelEditMode: function (cmp, event, helper) {
        if (cmp.get('v.minimumNumbersOfHour') != null) {

            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/interviews-availability?JobId=" + cmp.get('v.JobId') + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable')
            });
            urlEvent.fire();
        } else {

            window.history.back();
        }
    }


})