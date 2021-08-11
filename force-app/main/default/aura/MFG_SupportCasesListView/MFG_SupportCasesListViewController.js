({
    init: function(cmp, event, helper) {
        helper.getSuppCases(cmp, event, helper);
    },
    
    changeList: function(cmp, event, helper) {
        
        var open=  cmp.get('v.open');
        cmp.set('v.open',!open);
        helper.getSuppCases(cmp, event, helper);
    },
    openCaseDetails: function(cmp, event, helper) {
        /*
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        console.log(val);
        var name = ctarget.dataset.name;
        console.log(name);
        cmp.set('v.viewCase', true);
        cmp.set('v.caseId', val);
        cmp.set('v.title', name);*/
                var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/case/"+val 
        });
        urlEvent.fire();
        
    },
    
    cancel: function(cmp, event, helper) {
        cmp.set('v.viewCase', false);
        cmp.set('v.caseId','');
        cmp.set('v.title', '');
    },
    
    changeRowsPerPage: function(cmp, event, helper) {
        var maxResult = event.getParam("value");
        cmp.set('v.maxResults',maxResult);
        var resp=cmp.get('v.allCases');
        var settings= helper.initTableSettings(cmp,resp,maxResult); 
        var cases= resp.slice(0, maxResult);
        
        cmp.set('v.cases',cases);
    },
    
    nextpage: function(cmp, event, helper) {
        var cases= cmp.get('v.cases');
        var allCases=cmp.get('v.allCases');
        var pageSettings=cmp.get('v.settings');
        pageSettings.curentpage=pageSettings.curentpage+1;
        var settings = pageSettings.slice.find(obj => {
            return obj.pageNo === pageSettings.curentpage
        });
        cases= allCases.slice(settings.begin, settings.end);
        cmp.set('v.cases',cases);
        cmp.set('v.settings',pageSettings);
        
    },
    
    previouspage: function(cmp, event, helper) {
        var cases= cmp.get('v.cases');
        var allCases=cmp.get('v.allCases');
        var pageSettings=cmp.get('v.settings');
        pageSettings.curentpage=pageSettings.curentpage-1;
        var settings = pageSettings.slice.find(obj => {
            return obj.pageNo === pageSettings.curentpage
        });
        cases= allCases.slice(settings.begin, settings.end);
        cmp.set('v.cases',cases);
        cmp.set('v.settings',pageSettings);
        
    },
})