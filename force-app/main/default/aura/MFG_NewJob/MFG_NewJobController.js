({
    init: function (cmp, event, helper) {
        helper.initform(cmp, event, helper);
        helper.checkHRAv(cmp, event, helper);
        helper.getUserBannerOfStore(cmp, event, helper);

    },
    scrolltop: function (cmp, event, helper) {
        window.scroll({
            top: 0,
            left: 0,
            behavior: 'smooth'
        });
    },


    validateform: function (cmp, event, helper) {
        //  var jobform= cmp.find('SFDC_New_Job_Form');
        // console.log(jobform);
        //  var fields= jobform.submit();


    },

    handleLoad: function (cmp, event, helper) {
        // console.log(event);
        var bannerOfStore = cmp.get('v.bannerOfStore');

        // console.log(cmp.find('SFDC_New_Job_Form'));


        cmp.set('v.showSpinner', false);
    },

    handleSubmit: function (cmp, event, helper) {

        event.preventDefault();
        var fields = event.getParam('fields');
        // fields.Job_Title_for_Role__c = job_Title_for_Role_Value;
        fields.Force_First_Time_Update__c = true;
        fields.QCP_Acknowledgement__c = cmp.get('v.disclaimer');
        cmp.find('SFDC_New_Job_Form').submit(fields);

        cmp.set("v.buttondisabled", false);
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },

    handleError: function (cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function (cmp, event, helper) {
        var params = event.getParams();
        // console.log('v.recordId', params.response.id);
        cmp.set('v.recordId', params.response.id);
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
        let action_get = cmp.get("c.getStaticUrl")
        let action_set = cmp.get("c.setStaticUrl")



        var urlEvent = $A.get("e.force:navigateToURL");
        // console.log(0)
        if (cmp.get('v.available')) {
            // localStorage.setItem('url', "" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + '&sendEmail?=false')
            // document.location.reload()
            action_set.setParams({ url: "" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + '&sendEmail?=false' })
            action_set.setCallback(this, function (response) {

            })
            console.log("" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + '&sendEmail?=false')
            urlEvent.setParams({
                "url": "/sfdc-job/SFDC_Job__c/"
            });
            // window.location.href = 'https://qa-mindfield.cs44.force.com/mindfield/s/sfdc-job/SFDC_Job__c/Default';
            // window.location.reload()

            urlEvent.setParams({
                "url": "/sfdc-job/SFDC_Job__c/"
            });
            // console.log(localStorage.getItem('url'))
            /* 
                ! Setting url with JobID and "sendEmail" parameter (with two stages true or false) to localstorage, for checking do we need send email that user don't have enought hours or no.
                ! In this check we send sendEmail parameter with false because our method for checking CheckInterviewAvailibility return false.
            */

        } else {
            /*
                ! The same actions like from above, but in this situation we should send email, and we put &sendEmail parametr with true
                ! After putting data to localStorage we need to reload the page, for saving data. We do it after checking Available attribute.
            */

            // localStorage.setItem('url', "/new-interview-availability?JobId=" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + "&sendEmail?=true");
            // console.log(localStorage.getItem('url'))
            console.log("" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + '&sendEmail?=true')

            action_set.setParams({ url: "" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable') + '&sendEmail?=true' })
            action_set.setCallback(this, function (response) {

            })
            urlEvent.setParams({
                "url": "/new-interview-availability?JobId=" + params.response.id + "&JobisforStore=" + cmp.get('v.job_is_for_Store_if_applicable')
            });
            // document.location.reload()

        }
        $A.enqueueAction(action_set);

        urlEvent.fire();



    },

    onPageReferenceChange: function (cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");
        // console.log('myPageRef' + myPageRef)
    },
    changeField: function (cmp, event, helper) {
        if (event.getSource().get("v.fieldName") == 'Banner_of_Store__c' && event.getParam('value') == '' && !cmp.get('v.bannerSeted')) {
            var bannerOfStore = cmp.get('v.bannerOfStore');
            event.getSource().set('v.value', bannerOfStore);
            cmp.set('v.bannerSeted', true);

        }

        if (event.getSource().get("v.fieldName") == 'Specific_Candidate_Required__c' && event.getParam('value') == 'Yes') {
            cmp.set('v.show', true);
        }
        if (event.getSource().get("v.fieldName") == 'Specific_Candidate_Required__c' && (event.getParam('value') == '' || event.getParam('value') == 'No')) {
            cmp.set('v.show', false);
        }
        if (event.getSource().get("v.fieldName") == 'Job_is_for_Store_if_applicable__c') {
            cmp.set('v.job_is_for_Store_if_applicable', event.getParam('value'));
        }
    },
    cancel: function (cmp, event, helper) {
        window.history.back();
    }
})