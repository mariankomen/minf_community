({
    fetchJobAppsHelper : function(component, event) {
        component.set('v.jobAppColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text', hideDefaultActions: true},
            {label: 'Status', fieldName: 'Status__c', type: 'text', hideDefaultActions: true},
            {label: 'Applicant', fieldName: 'Applicant_Name__c', type: 'text', hideDefaultActions: true},
            {label: 'Job', fieldName: 'Job_Name__c', type: 'text ', hideDefaultActions: true}
        ]);
        component.set('v.jobColumns', [
		    {label: 'Job ID', fieldName: 'jobName', type: 'text', hideDefaultActions: true},
            {label: 'Job Title', fieldName: 'jobTitle', type: 'text', hideDefaultActions: true},
            {label: 'FGL Department', fieldName: 'department', type: 'text', hideDefaultActions: true},          
            {label: 'Full Time/ Part Time', fieldName: 'fullTimePartTime', type: 'text', hideDefaultActions: true},
            {label: 'Days Open', fieldName: 'daysOpen', type: 'number', hideDefaultActions: true},
            {label: 'Banner', fieldName: 'banner', type: 'text', hideDefaultActions: true}
        ]);
        
        var action = component.get("c.getApplicantJobApps");
        action.setParams({
            parentId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let applicantJobs = response.getReturnValue();
                console.log('applicantJobs @>'+applicantJobs);
                if(applicantJobs != ''){
                	component.set("v.jobAppList", applicantJobs);
                    
                    if(applicantJobs.length === 1){
                        component.set("v.hideSelectColumn",true);
                        for(let i=0; i< applicantJobs.length; i++){
                            component.set('v.selectedJobAppId',applicantJobs[i].Id);
                            component.set('v.currentJobAppJobId',applicantJobs[i].Job__c);
                            component.set('v.currentJobAppJobTitle',applicantJobs[i].Job__r.Job_Title__c);
                            component.set('v.currentJobAppJobStore',applicantJobs[i].Job__r.Store__c);

                            
                        }
                        this.searchJobsHelper(component, event);
                    }
                    
                } else {
                    $A.get("e.force:closeQuickAction").fire();
                    this.showToast("Error","error","No Associated Applicants to Move");
                }
            }
            component.set('v.isLoading',false);
        });
        $A.enqueueAction(action);
    },
    
    searchJobsHelper : function(component, event) {
		// Calling Apex Method
    	var action = component.get('c.getJobs');
        action.setParams({
            jobName : component.get('v.jobName'),
            currentJobId : component.get('v.currentJobAppJobId'),
            currentJobTitle : component.get('v.currentJobAppJobTitle'),
            currentJobStore : component.get('v.currentJobAppJobStore'),
            
        });
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
        	if(response.getState() === 'SUCCESS') {
                component.set("v.jobList", response.getReturnValue());
        	}
            component.set('v.isLoading',false);
        });
        $A.enqueueAction(action);
	},
    
    moveAppJobHelper : function(component, event) {
        // Calling Apex Method
    	var action = component.get('c.moveApplicantJob');
        action.setParams({
            appId : component.get('v.selectedJobAppId'),
            job_Id : component.get('v.selectedJobId')
        });
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
        	if(response.getState() === 'SUCCESS' && result==='SUCCESS') {
                this.showToast("Success","success","Record moved successfully");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.selectedJobId'),
                    "slideDevName": "related"
                });
                navEvt.fire();
            } else {
                this.showToast("Error","error",result);  
                
            }
            $A.get("e.force:closeQuickAction").fire();
            component.set('v.isLoading',false);
        });
        $A.enqueueAction(action);
	},
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();  
    }
})