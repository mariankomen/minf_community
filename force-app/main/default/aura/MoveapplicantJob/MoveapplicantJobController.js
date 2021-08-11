({
	doInit : function(component, event, helper) {
        component.set('v.isLoading',true);
		helper.fetchJobAppsHelper(component, event);
	},
    
    onJobAppselected: function (component, event, helper) {
        component.set('v.isLoading',true);
        var selectedRows = event.getParam('selectedRows');
        for(let i=0; i< selectedRows.length; i++){
            component.set('v.selectedJobAppId',selectedRows[i].Id);
            component.set('v.currentJobAppJobId',selectedRows[i].Job__c);
            component.set('v.currentJobAppJobTitle',selectedRows[i].Job__r.Job_Title__c);
            component.set('v.currentJobAppJobStore',selectedRows[i].Job__r.Store__c);

            
        }
        helper.searchJobsHelper(component, event);
    },
    
    searchRecords: function (component, event, helper){
        component.set('v.isLoading',true);
        helper.searchJobsHelper( component, event);
    },
    
    onJobselected: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        for(let i=0; i< selectedRows.length; i++){
            component.set('v.selectedJobId',selectedRows[i].jobId);
        }
    },
    
    saveRecord: function (component, event, helper){
        component.set('v.isLoading',true);
        helper.moveAppJobHelper( component, event);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
})