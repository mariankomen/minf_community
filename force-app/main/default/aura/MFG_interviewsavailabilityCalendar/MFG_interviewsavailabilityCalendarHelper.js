({

    getCalendar: function(cmp, event, helper) {
        var action = cmp.get('c.initCalendar');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.calendar',resp);
                       
        
                var jobId = this.getParameterByName(cmp , event,helper, 'JobId');
                var jobisforStore=this.getParameterByName(cmp , event,helper, 'JobisforStore');
                console.log(jobId);
                console.log(jobisforStore);
                
                if(jobId && (jobisforStore=='' || jobisforStore=='undefined')){
                    cmp.set('v.monthly',false);
                    var viewWeekly=cmp.find('MFG_interviewsavailabilityWeekly');
                    var today = new Date();
                    var calendar=cmp.get('v.calendar');
                    viewWeekly.set('v.calendar', calendar);
                    viewWeekly.set('v.currentdate', new Date().toISOString().slice(0,10));
                    viewWeekly.set('v.jobId', jobId);
                    viewWeekly.set('v.checkNext2Weeks',true);
 
                }
                
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
  
    getParameterByName: function(component, event,helper, name) {

        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
        
        
        

    },
})