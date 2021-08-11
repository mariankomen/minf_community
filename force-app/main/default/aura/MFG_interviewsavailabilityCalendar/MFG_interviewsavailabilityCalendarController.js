({

    init: function(cmp, event, helper) {
        var language = $A.get("$Locale.language");
        console.log(language);
        cmp.set('v.language',language);  
        console.log('getCalendar');
        helper.getCalendar(cmp, event, helper);
        
       
       
    },
    doneRendering: function(cmp, event, helper) {
        if(!cmp.get("v.isDoneRendering")){
          cmp.set("v.isDoneRendering", true);
          var sPageURL = window.location.search;
        console.log(sPageURL.includes('JobId'));
        if (sPageURL.includes('JobId')){
            // cmp.set('v.monthly',false);
             var a = cmp.get('c.weekly');
             console.log('Here');
        $A.enqueueAction(a);
        }
        }
      },
    monthly: function(cmp, event, helper) {
        cmp.set('v.monthly',true);
    },
    weekly: function(cmp, event, helper) {
        console.log('End1')
        cmp.set('v.monthly',false);
        console.log('End12')
        var viewWeekly=cmp.find('MFG_interviewsavailabilityWeekly');
           var today = new Date();
          
           console.log('End13')
        var calendar=cmp.get('v.calendar');
        console.log(  viewWeekly)
        console.log('End14')
        viewWeekly.set('v.calendar', calendar);
        console.log(  viewWeekly)
        console.log('End15')
        console.log(  viewWeekly)
        console.log(  viewWeekly.get('v.calendar'))
        viewWeekly.set('v.currentdate', new Date().toISOString().slice(0,10));
        console.log(  viewWeekly.get('v.currentdate'))
        console.log('End')
    },
    
    viewWeekly: function(cmp, event, helper) {
        cmp.set('v.monthly',false);
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log(id_str);
        
        var viewWeekly=cmp.find('MFG_interviewsavailabilityWeekly');
        
        var calendar=cmp.get('v.calendar');
        viewWeekly.set('v.calendar', calendar);
        viewWeekly.set('v.currentdate',id_str);
        
    },
    NewAvailabilityDate: function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/new-interview-availability"
        });
        urlEvent.fire();
    },
    setAttributeValue: function(component, event, helper){
        
        var eventValue= event.getParam("calendar");
      console.log('parent',eventValue);
    }
    
    
})