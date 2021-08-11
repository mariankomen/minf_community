({
    afterChartJsLoaded: function (component, event, helper) {
        helper.createGraph(component, event, helper);
    },

    upadateInterviewAv: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/interviews-availability"
        });
        urlEvent.fire();
    },
    SI_ViewMore: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/scheduledinterviews"
        });
        urlEvent.fire();
    },
    viewNotifications: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/notification/Notification__c"
        });
        urlEvent.fire();
    },
    goToJobs: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job/SFDC_Job__c/"
        });
        urlEvent.fire();
    },
    goToCandidates: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/SFDC_Job_Candidate__c/"
        });
        urlEvent.fire();
    },
    goToCandidate: function (cmp, event, helper) {

        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job-candidate/" + id_str
        });
        urlEvent.fire();
    },
    init: function (cmp, event, helper) {
        helper.get_ScheduledInterviews(cmp, event, helper);
        helper.get_LastNotification(cmp, event, helper);
        helper.get_JobSummury(cmp, event, helper);

        var action = cmp.get('c.sendEmailMethod');


        let action_get = cmp.get("c.getStaticUrl")
        let action_set = cmp.get("c.setStaticUrl")

        action_get.setCallback(this, function (response) {
            let res = JSON.parse(response.getReturnValue()).front_url__c
            let JobId = res.slice(0, 18)

            if (res.includes('sendEmail?=true')) {
                action.setParams({ createdJobId: JobId })
                action.setCallback(this, function (response) {
                })
                $A.enqueueAction(action);

                action_set.setParams({ url: "" })
                $A.enqueueAction(action_set);
            }
        })

        $A.enqueueAction(action_get);
    },

})