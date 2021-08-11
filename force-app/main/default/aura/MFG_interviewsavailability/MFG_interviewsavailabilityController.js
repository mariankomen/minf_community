({
    init: function(cmp, event, helper) {
        console.log('getCalendar');
        helper.getCalendar(cmp, event, helper);
    },
    monthly: function(cmp, event, helper) {
        cmp.set('v.monthly',true);
        
        
       // var WeeklyView = cmp.find('WeeklyView');
        //if(WeeklyView){
       //     WeeklyView.destroy();
       // }
    },
    weekly: function(cmp, event, helper) {
        cmp.set('v.monthly',false);
        
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
    
   


})