({

    options : {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric',
          timeZone: 'America/Vancouver',
          timeZoneName: 'long'
    },
    
    unrender: function(cmp, helper) {

        console.log('unrender');
    },
     afterRender: function(cmp) {
          console.log('afterRender');
     },
     rerender: function(cmp) {
          console.log('rerender');
     },
    render: function(cmp) {
        console.log('render');
    },
    
    // gethasAvailability: function(cmp, event,helper) {
        
    //     if(cmp.get('v.handlecheckNext2Weeks')){
    //       console.log('cmp.get(v.handlecheckNext2Weeks)'+cmp.get('v.handlecheckNext2Weeks'))
    //         var calendar =cmp.get('v.weeks');
    //         var currentWeek=  cmp.get('v.currentWeek');
    //         var currentWeekN=currentWeek.weekNum;
    //         var next2Weekss =cmp.get('v.next2Weeks');
    //         var next2Weeks=[];
           
            
            
    //         for(let week of calendar){
    //             if(week.weekNum===next2Weekss[0].weekNum || week.weekNum===next2Weekss[1].weekNum){
    //                 next2Weeks.push(week);
    //             }
    //         } 
         
    //         var hasAvailability=false;
            
    //         for(let week of next2Weeks){
    //             for(let day of week.week.days){
    //                 if(day.HRAvailability.length>0){
    //                     hasAvailability=true;
    //                 }
    //             }
    //         }  
            
    //         return hasAvailability;
            

    //     }else{
    //         return null;
    //     }
  

    // },

    // deleteJob: function(cmp, event, helper) {
    //     var action = cmp.get('c.deletejob');
    //     var jobId=cmp.get('v.jobId');
    //     action.setParams({
    //         jobId : jobId
    //     });
    //     action.setCallback(this, function(response) {
    //         var state = response.getState();

    //         if (state === 'SUCCESS') {
                

    //         } else if (state === 'ERROR') {
    //               this.scrolltop(cmp, event, helper) ;
    //             console.log(response.getError()[0].message);
    //         }
    //     });
    //     action.setBackground();

    //     $A.enqueueAction(action);
    // },
    
    removeHRAvailability: function(cmp, event, helper) {
        var action = cmp.get('c.deleteInterviewAvailability');
        var hraId=cmp.get('v.hraId');
        action.setParams({
            hraId : hraId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set('v.hraId','');
            cmp.set('v.prompt',false);
            if (state === 'SUCCESS') {
                var  currentWeek =cmp.get('v.currentWeek');
                var calendar =cmp.get('v.calendar');
                
                for(let day of currentWeek.week.days){
                    
                    for(let hra in day.HRAvailability){
                        
                        if(day.HRAvailability[hra].Id==hraId){
                            console.log('currentWeek remove',hra);
                            day.HRAvailability.splice(hra, 1);
                            break;
                        }
                    }
                }
                
                for(let month of calendar.months){
                    for(let week of month.weeks ){
                        for(let day of week.days ){
                            for(let hra in day.HRAvailability){
                                if(day.HRAvailability[hra].Id==hraId){
                                    console.log('calendar remove ', hra);
                                    day.HRAvailability.splice(hra, 1);
                                    break;
                                }
                            }
                            
                        }
                        
                    }
                }
                cmp.set('v.currentWeek',currentWeek);
                cmp.set('v.calendar',calendar);
                var setEvent = cmp.getEvent("setAttribute");
                setEvent.setParams({"calendar":calendar});
                setEvent.fire();
                
            } else if (state === 'ERROR') {
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    getAccountId: function(cmp, event, helper) {
        
        var action = cmp.get('c.getUserAccountId');
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue())
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.accountId',resp);
            } else if (state === 'ERROR') {
                  this.scrolltop(cmp, event, helper) ;
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);

    },
    
    getEditedHRAv: function(cmp, event, helper) {
        var params = event.getParams();
        var action = cmp.get('c.getCreatedHRAvailability');
        action.setParams({
            hraId : params.response.id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                var  currentWeek =cmp.get('v.currentWeek');
                var calendar =cmp.get('v.calendar'); 
                
                
                for(let month of calendar.months){
                    for(let week of month.weeks ){
                        for(let day of week.days ){
                            if(day.sdate===resp.currentDate){
                                console.log(day);
                                for(let hra in day.HRAvailability){
                                    if(day.HRAvailability[hra].Id==params.response.id) {
                                        day.HRAvailability.splice(hra, 1,resp.hra);
                                        break;
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
                
                cmp.set('v.hraEditId','');
                cmp.set('v.editMode',false);
                var setEvent = cmp.getEvent("setAttribute");
                setEvent.setParams({"calendar":calendar});
                setEvent.fire();
            } else if (state === 'ERROR') {
                console.log(response.getError()[0].message);
                  this.scrolltop(cmp, event, helper) ;
            }
        });
        $A.enqueueAction(action);
    },    
    
    
    
    
    getCreatedHRAv: function(cmp, event, helper) {
        var params = event.getParams();
        var action = cmp.get('c.getCreatedHRAvailability');
        action.setParams({
            hraId : params.response.id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                var  currentWeek =cmp.get('v.currentWeek');
                var calendar =cmp.get('v.calendar'); 
                
                /*  var settings = currentWeek.week.days.find(obj => {
                    return obj.sdate === resp.currentDate
                });
                if(settings){
                    settings.HRAvailability.push(resp.hra);
                }
                
                cmp.set('v.currentWeek',currentWeek);
                
                cmp.set('v.newHRAv',!cmp.get('v.newHRAv'));
                */
                for(let month of calendar.months){
                    for(let week of month.weeks ){
                        for(let day of week.days ){
                            if(day.sdate===resp.currentDate){
                                console.log(day);
                                day.HRAvailability.push(resp.hra);
                                break;
                            }
                        }
                        
                    }
                }
                
                cmp.set('v.newHRAv',!cmp.get('v.newHRAv'));
                
                var setEvent = cmp.getEvent("setAttribute");
                setEvent.setParams({"calendar":calendar});
                setEvent.fire();
            } else if (state === 'ERROR') {
                this.scrolltop(cmp, event, helper) ;
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    scrolltop: function(cmp, event, helper) {
        window.scrollTo(0,0);
    },
    
})