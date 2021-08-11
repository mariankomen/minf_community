({
    addNewJob: function (cmp, event, helper) {
        // console.log('addNewJob');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/new-job"
        });
        urlEvent.fire();
    },
    init: function (cmp, event, helper) {
        helper.getJobs(cmp, event, helper);
        // window.onload = function () {
        //     if (!window.location.hash) {
        //         window.location = window.location + '#loaded';
        //         window.location.reload();
        //     }
        // }
    },
    openJobDetails: function (cmp, event, helper) {

        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        // console.log(id_str);


        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/sfdc-job/" + id_str
        });
        urlEvent.fire();
    },
    changeList: function (cmp, event, helper) {

        var open = cmp.get('v.open');
        cmp.set('v.open', !open);
        helper.getJobs(cmp, event, helper);
    },




    changeRowsPerPage: function (cmp, event, helper) {
        var maxResult = event.getParam("value");

        // console.log(maxResult);
        cmp.set('v.maxResults', maxResult);

        var resp = cmp.get('v.Alljobs');
        var jobs = {};

        var openSet = helper.initTableSettings(cmp, resp.open);
        var open = resp.open.slice(0, maxResult);
        jobs.open = { 'settings': openSet, 'open': open };

        var completedSet = helper.initTableSettings(cmp, resp.completed);
        var completed = resp.completed.slice(0, maxResult);
        jobs.completed = { 'settings': completedSet, 'completed': completed };


        cmp.set('v.jobs', jobs);
    },

    nextpage: function (cmp, event, helper) {
        var ctarget = event.currentTarget;
        var tableName = ctarget.dataset.value;

        var jobs = cmp.get('v.jobs');
        var Alljobs = cmp.get('v.Alljobs');
        if (tableName == 'open') {
            var pageSettings = jobs.open.settings;
            jobs.open.settings.curentpage = jobs.open.settings.curentpage + 1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobs.open.open = [];
            jobs.open.open = Alljobs.open.slice(settings.begin, settings.end);
            cmp.set('v.jobs', jobs);

        } else if (tableName == 'completed') {

            var pageSettings = jobs.completed.settings;
            jobs.completed.settings.curentpage = jobs.completed.settings.curentpage + 1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobs.completed.completed = [];
            jobs.completed.completed = Alljobs.completed.slice(settings.begin, settings.end);
            cmp.set('v.jobs', jobs);
        }
    },

    previouspage: function (cmp, event, helper) {
        var ctarget = event.currentTarget;
        var tableName = ctarget.dataset.value;

        var jobs = cmp.get('v.jobs');
        var Alljobs = cmp.get('v.Alljobs');
        if (tableName == 'open') {
            var pageSettings = jobs.open.settings;
            jobs.open.settings.curentpage = jobs.open.settings.curentpage - 1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobs.open.open = [];
            jobs.open.open = Alljobs.open.slice(settings.begin, settings.end);
            cmp.set('v.jobs', jobs);

        } else if (tableName == 'completed') {

            var pageSettings = jobs.completed.settings;
            jobs.completed.settings.curentpage = jobs.completed.settings.curentpage - 1;
            var settings = pageSettings.slice.find(obj => {
                return obj.pageNo === pageSettings.curentpage
            });
            jobs.completed.completed = [];
            jobs.completed.completed = Alljobs.completed.slice(settings.begin, settings.end);
            cmp.set('v.jobs', jobs);
        }

    },
})