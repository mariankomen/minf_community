({
    hideeeeeee: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/jobs"
        });
        urlEvent.fire();

    },
    hide: function (cmp, event, helper) {
        cmp.set('v.showMenu', !cmp.get('v.showMenu'));

    },
    init: function (cmp, event, helper) {
        /*
            ! Getting url parametr from localstorage, and taking from him the JobId
            ! Checking does &sendEmail parametr is equal to true, if is it then we call apex method for sending emails.
        */
        // const JobId = localStorage.getItem('url').slice(localStorage.getItem('url').indexOf("=") + 1, localStorage.getItem('url').indexOf("&Job"))
        // var action = cmp.get('c.sentEmail');


        // let action_get = cmp.get("c.getStaticUrl")
        // let action_set = cmp.get("c.setStaticUrl")

        // action_get.setCallback(this, function (response) {
        //     let res = JSON.parse(response.getReturnValue()).front_url__c
        //     let JobId = res.slice(0, 18)

        //     if (res.includes('sendEmail?=true')) {
        //         action.setParams({ createdJobId: JobId })
        //         action.setCallback(this, function (response) {
        //         })
        //         $A.enqueueAction(action);

        //         action_set.setParams({ url: "" })
        //         $A.enqueueAction(action_set);
        //     }
        //     console.log(JobId)

        // })

        // $A.enqueueAction(action_get);

        helper.getUserLanguage(cmp, event, helper);
        var language = $A.get("$Locale.language");

    },
    onRender: function (cmp, event, helper) {
        let action_get = cmp.get("c.getStaticUrl")
        action_get.setCallback(this, function (response) {
            let res = JSON.parse(response.getReturnValue()).front_url__c
            let JobId = res.slice(0, 18)
            console.log(">>>>>>>>>>>>>", res)
        })
        $A.enqueueAction(action_get);
    },
    showAddMenu: function (cmp, event, helper) {
        cmp.set('v.showAddMenu', !cmp.get('v.showAddMenu'));


    },
    showProfileMenu: function (cmp, event, helper) {
        cmp.set('v.showProfileMenu', !cmp.get('v.showProfileMenu'));


    },


    OpenMenuItem: function (cmp, event, helper) {

        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        // console.log(id_str);





        var urlEvent = $A.get("e.force:navigateToURL");
        switch (id_str) {
            case 'NewJob':
                urlEvent.setParams({
                    "url": "/new-job"
                });
                break;
            case 'NewInterviewAvailability':
                urlEvent.setParams({
                    "url": "/new-interview-availability"
                });
                break;
            case 'NewCustomerSupportCase':
                urlEvent.setParams({
                    "url": "/new-customer-support-case"
                });
                break;
            case 'Profile':
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                urlEvent.setParams({
                    "url": "/profile/" + userId
                });
                break;
            case 'Sign Out':
                urlEvent.setParams({
                    "url": '/mindfield/secur/logout.jsp'
                });
                break;

        }

        urlEvent.fire();
    },
    SignOut: function (cmp, event, helper) {
        window.location.replace("/mindfield/secur/logout.jsp");
    },

    navigateToUrl: function (cmp, event, helper) {
        var windowWidth = window.innerWidth
            || document.documentElement.clientWidth
            || document.body.clientWidth;
        // console.log(windowWidth);

        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;

        var tabindexes = cmp.get('v.tabindexes');
        for (let index in tabindexes) {
            tabindexes[index] = '-1';
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        switch (id_str) {
            case 'home':
                urlEvent.setParams({
                    "url": "/"
                });
                tabindexes[0] = '0'
                break;
            case 'jobs':

                //sfdc-job/SFDC_Job__c/
                urlEvent.setParams({
                    "url": "/sfdc-job/SFDC_Job__c/"
                });
                tabindexes[1] = '0'
                break;

            case 'candidates':

                urlEvent.setParams({
                    "url": "/sfdc-job-candidate/SFDC_Job_Candidate__c/"
                });
                tabindexes[2] = '0'
                break;
            case 'scheduledInterviews':
                urlEvent.setParams({
                    "url": "/scheduledinterviews"
                });
                tabindexes[3] = '0'
                break;
            case 'customerSupport':
                urlEvent.setParams({
                    "url": "/customersupport"
                });
                tabindexes[4] = '0'
                break;
            case 'notifications':
                urlEvent.setParams({
                    "url": "/notification/Notification__c"
                });
                tabindexes[5] = '0'
                break;
        }
        cmp.set('v.tabindexes', tabindexes);
        if (windowWidth < 600) {
            cmp.set('v.showMenu', false);
        }
        urlEvent.fire();

    },
    goHome: function (cmp, event, helper) {
        // console.log('HOME');
        var tabindexes = cmp.get('v.tabindexes');
        for (let index in tabindexes) {
            tabindexes[index] = '-1';
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        tabindexes[0] = '0';
        cmp.set('v.tabindexes', tabindexes);
        urlEvent.fire();
    }

})