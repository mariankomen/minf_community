({

    // handleDestroy : function (cmp, event, helper) {

    //     if(cmp.get('v.handlecheckNext2Weeks')){

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
    //         console.log(next2Weeks);
    //         var hasAvailability=false;

    //         for(let week of next2Weeks){
    //             for(let day of week.week.days){
    //                 if(day.HRAvailability.length>0){
    //                     hasAvailability=true;
    //                 }
    //             }
    //         }  
    //         if(!hasAvailability){
    //               helper.deleteJob(cmp, event, helper);
    //         }
    //     }
    // },


    init: function (cmp, event, helper) {

        helper.getAccountId(cmp, event, helper);
        var today = new Date();
        cmp.set('v.nextYear', (today.getFullYear() + 1) + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var sPageURL = window.location.search.substring(1);
        var hasAvailability = (sPageURL.includes('JobId'));
        // cmp.set('v.hasAvailability',!hasAvailability);
        // console.log(hasAvailability)
        // console.log(cmp.get('v.newHRAv'))
        // console.log(cmp.get('v.editMode'))


        // if( hasAvailability){
        //     var action1 = cmp.get('c.getUserLanguage');
        //     action1.setCallback(this, function(response) {
        //         var state = response.getState();
        //         if (state === 'SUCCESS') {
        //             cmp.set('v.language', response.getReturnValue());
        //         } else if (state === 'ERROR') {
        //             console.log('ERROR');
        //         }
        //     });
        //     $A.enqueueAction(action1);

        //       cmp.set('v.newHRAv',true);
        //       console.log('newHRAv'+ cmp.get('v.newHRAv'));
        //     var jobId = sPageURL.substring(sPageURL.indexOf('=')+1,sPageURL.indexOf('&'));
        //     console.log('jobId'+jobId)
        //     cmp.set('v.jobId', jobId);
        //     var action = cmp.get('c.getMinimumInterviewHours');
        //     action.setCallback(this, function(response) {
        //         var state = response.getState();
        //         if (state === 'SUCCESS') {
        //             cmp.set('v.minimumNumbersOfHour', response.getReturnValue());
        //         } else if (state === 'ERROR') {
        //             console.log('ERROR');
        //         }
        //     });
        //     $A.enqueueAction(action);
        //     var action2 = cmp.get('c.getMinimumInterviewDays');
        //     action2.setCallback(this, function(response) {
        //         var state = response.getState();
        //         if (state === 'SUCCESS') {
        //             cmp.set('v.minimumNumbersOfDay', response.getReturnValue());
        //             console.log( 'gggggggggggggggggggg')
        //             console.log( cmp.get('v.minimumNumbersOfDay'))
        //         } else if (state === 'ERROR') {
        //             console.log('ERROR');
        //         }
        //     });
        //     $A.enqueueAction(action2);
        //     var action3 = cmp.get('c.getMaxAmountOfDays');
        //     action3.setCallback(this, function(response) {
        //         var state = response.getState();
        //         if (state === 'SUCCESS') {
        //             cmp.set('v.maxNumbersOfDay', response.getReturnValue());
        //         } else if (state === 'ERROR') {
        //             console.log('ERROR');
        //         }
        //     });
        //     $A.enqueueAction(action3);
        //     console.log('language'+cmp.get('v.language'))
        //     console.log('minimumNumbersOfHour'+cmp.get('v.minimumNumbersOfHour'))
        //     console.log('minimumNumbersOfDay'+cmp.get('v.minimumNumbersOfDay'))
        //     console.log('maxNumbersOfDay'+cmp.get('v.maxNumbersOfDay'))
        // }

    },

    // onNo: function(cmp, event, helper){
    //       cmp.set('v.unsavedChangesPrompt',false);  
    // },
    // onYes: function(cmp, event, helper){

    //     cmp.set('v.unsavedChangesPrompt',false);  
    //     helper.deleteJob(cmp, event, helper);
    //     cmp.set('v.deleteJob',true);
    //     var urlEvent = $A.get("e.force:navigateToURL");  
    //     urlEvent.setParams({
    //         "url": "/sfdc-job/SFDC_Job__c/"
    //     });    
    //     urlEvent.fire();

    // },
    handlecheckNext2Weeks: function (cmp, event, helper) {

        if (!cmp.get('v.hasAvailability')) {
            var runOnce = true;
            if (runOnce) {
                runOnce = false;
                window.onpopstate = function (event) {
                    var hasAvailabilitySecondCheck = true;
                    var action = cmp.get('c.chechInterviewAvailability');
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === 'SUCCESS') {
                            hasAvailabilitySecondCheck = response.getReturnValue();
                            if (!hasAvailabilitySecondCheck) {
                                var action = cmp.get('c.sentEmail');

                                action.setParams({ createdJobId: cmp.get('v.jobId') });
                                action.setCallback(this, function (response) {
                                    var state = response.getState();
                                    if (state === 'SUCCESS') {
                                        console.error('ERROR');
                                    } else
                                        if (state === 'ERROR') {
                                            console.error('ERROR');
                                        }
                                });
                                $A.enqueueAction(action);
                            }
                        } else if (state === 'ERROR') {
                            console.error('ERROR');
                        }
                    });
                    $A.enqueueAction(action);

                    window.location.reload(true);
                }


            }
        }



        //         if(event.getParam("value")){

        //             var calendar =cmp.get('v.weeks');
        //             var currentWeek=  cmp.get('v.currentWeek');
        //             var currentWeekN=currentWeek.weekNum;

        //             var next2Weeks=[];
        //             for(let week of calendar){
        //                 if(week.weekNum===currentWeekN+1 || week.weekNum===currentWeekN+2){
        //                     next2Weeks.push(week);
        //                 }
        //             } 
        //             console.log(next2Weeks);
        //             var hasAvailability=false;




        //             for(let week of next2Weeks){

        //                 for(let day of week.week.days){
        //                     if(day.HRAvailability.length>0){
        //                         hasAvailability=true;
        //                     }
        //                 }
        //             }

        //             console.log('hasAvailability',hasAvailability);
        //              cmp.set('v.next2Weeks',next2Weeks);
        //             cmp.set('v.handlecheckNext2Weeks',!hasAvailability);
        //             cmp.set('v.hasAvailability',hasAvailability);
        //         }

        //   //https://commtest-mindfield.cs62.force.com/mindfield/s/interviews-availability?JobId=a0P5C000000bkmaUAA&JobisforStore=undefined       
        //         if(cmp.get('v.handlecheckNext2Weeks')){
        //            var  runOnce=true;
        //             console.log("HEREEEEEEEE")

        //             if(runOnce){
        //                  runOnce=false;
        //                 window.onpopstate = function(event) {

        //                     var hasAvailability=  helper.gethasAvailability(cmp, event,helper);

        //                     if(hasAvailability!=null){
        //                         if(hasAvailability){
        //                              window.location.reload(true);
        //                         }else{
        //                             if(event){
        //                                 event.preventDefault();
        //                                 event.stopImmediatePropagation();
        //                                 event.stopPropagation();
        //                                 history.replaceState({}, "", "/mindfield/s/interviews-availability");

        //                                 cmp.set('v.unsavedChangesPrompt',true);  
        //                             }else{

        //                                 // if(cmp.get('v.deleteJob')){
        //                                     history.replaceState({}, "", "/mindfield/s/sfdc-job/SFDC_Job__c/");
        //                                     history.go();
        //                                 }
        //                                 // else{
        //                                 //     console.log(window.location.href);
        //                                 //     history.replaceState({}, "", "/mindfield/s/interviews-availability");
        //                                 //     cmp.set('v.unsavedChangesPrompt',true);    
        //                                 // }

        //                             // }

        //                         }
        //                     }else{

        //                     }




        //             };      

        //             }

        //         }

    },

    hasAvailabilityOk: function (cmp, event, helper) {
        cmp.set('v.hasAvailability', true);
    },
    handlecalendarChange: function (cmp, event, helper) {
        var calendar = cmp.get('v.calendar');
        if (calendar) {
            var weeks = new Array();
            var weekNum = 1;
            for (let month of calendar.months) {
                for (let week of month.weeks) {
                    weeks.push({ week: week, mothName: month.monthName, weekNum: weekNum });
                    weekNum++;
                }
            }

            cmp.set('v.weeks', weeks);
        }
    },

    handleValueChange: function (cmp, event, helper) {

        var forDate = event.getParam("value");
        var calendar = cmp.get('v.weeks');

        for (let week of calendar) {
            for (let day of week.week.days) {
                if (day.sdate == forDate) {
                    cmp.set('v.currentWeek', week);
                    return;

                }
            }

        }
    },
    previousWeek: function (cmp, event, helper) {
        var calendar = cmp.get('v.weeks');
        var currentWeek = cmp.get('v.currentWeek');
        var currentWeekN = currentWeek.weekNum;
        currentWeekN = currentWeekN - 1;
        for (let week of calendar) {
            if (week.weekNum === currentWeekN) {
                cmp.set('v.currentWeek', week);
                return;
            }
        }


    },
    nextWeek: function (cmp, event, helper) {
        var calendar = cmp.get('v.weeks');
        var currentWeek = cmp.get('v.currentWeek');
        var currentWeekN = currentWeek.weekNum;
        currentWeekN = currentWeekN + 1;
        for (let week of calendar) {
            if (week.weekNum === currentWeekN) {
                cmp.set('v.currentWeek', week);
                return;
            }
        }
    },

    editHRA: function (cmp, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        cmp.set('v.hraEditId', id_str);
        cmp.set('v.editMode', !cmp.get('v.editMode'));

    },

    changeFieldEditMode: function (cmp, event, helper) {
        if (event.getParam('checked')) {
            cmp.set('v.reOccur', true);
        } else {
            cmp.set('v.reOccur', false);
        }
    },

    cancelEditMode: function (cmp, event, helper) {
        cmp.set('v.hraEditId', '');
        cmp.set('v.editMode', !cmp.get('v.editMode'));
    },




    addNewAvailability: function (cmp, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        cmp.set('v.dateAvailability', id_str);
        cmp.set('v.newHRAv', !cmp.get('v.newHRAv'));
    },
    cancelNewHrA: function (cmp, event, helper) {
        cmp.set('v.newHRAv', !cmp.get('v.newHRAv'));
        cmp.set('v.dateAvailability', null);
    },
    remove: function (cmp, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        cmp.set('v.prompt', true);
        cmp.set('v.hraId', id_str);

    },

    cancelHRA: function (cmp, event, helper) {
        cmp.set('v.hraId', '');
        cmp.set('v.prompt', false);
    },
    deleteHRA: function (cmp, event, helper) {
        helper.removeHRAvailability(cmp, event, helper);
    },

    /**********************Edit Availability start**********************/
    handleLoadEdit: function (cmp, event, helper) {
        var startTime = cmp.find("startTimeField").get("v.value");
        var endTime = cmp.find("endTimeField").get("v.value");
        cmp.set("v.startTime", startTime);
        cmp.set("v.endTime", endTime);



    },

    handleSubmitEdit: function (cmp, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.Hiring_Managers_Store__c = cmp.get('v.accountId');


        fields.MFG_Start_Time__c = cmp.get('v.startTime');
        fields.MFG_End_Time__c = cmp.get('v.endTime');

        var inputstartTime = cmp.find("startTime");
        var inputendTime = cmp.find("endTime");
        inputstartTime.reportValidity();
        inputendTime.reportValidity();
        if (inputstartTime.get("v.value") && inputendTime.get("v.value")) {
            cmp.find('editHrAvailability').submit(fields);
        } else {
            inputstartTime.reportValidity();
            inputendTime.reportValidity();
        }
    },

    handleSuccessEdit: function (cmp, event, helper) {
        helper.getEditedHRAv(cmp, event, helper);

    },
    changeValue: function (cmp, event, helper) {
        var start = cmp.find("Interview_Start_Date").get("v.value");
        var end = cmp.find("Recurrence_Ends_On").get("v.value");
        var startDate = new Date($A.localizationService.formatDate(start, "yyyy-MM-dd"));
        cmp.find("Recurrence_Ends_On").set("v.value", $A.localizationService.formatDate(startDate, "yyyy-MM-dd"));
    },
    changetimevalue: function (cmp, event, helper) {
        var startTime = cmp.get('v.startTime');
        var endTime = cmp.get('v.endTime');

        var inputCmp = cmp.find('endTime');
        if (endTime) {

            if (startTime > endTime) {
                inputCmp.setCustomValidity("End time should be greater than start time");
            } else {
                inputCmp.setCustomValidity("");
            }
            inputCmp.reportValidity();
        }

    },
    validate: function (cmp, event, helper) {
        var inputstartTime = cmp.find("startTime");
        var inputendTime = cmp.find("endTime");
        inputstartTime.reportValidity();
        inputendTime.reportValidity();
    },
    /**********************Edit Availability end**********************/


    /**********************Create Availability start**********************/
    handleLoad: function (cmp, event, helper) {
        var dateString = cmp.get('v.dateAvailability');
        if (!cmp.get('v.hasAvailability')) {
            var dateString = new Date();
        }
        cmp.find("New_Interview_Start_Date").set("v.value", $A.localizationService.formatDate(dateString, "yyyy-MM-dd"));
        cmp.find("New_Recurrence_Ends_On").set("v.value", $A.localizationService.formatDate(dateString, "yyyy-MM-dd"));
    },

    handleSubmit: function (cmp, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.Hiring_Managers_Store__c = cmp.get('v.accountId').accountId;
        fields.MFG_Start_Time__c = cmp.get('v.newstartTime');
        fields.MFG_End_Time__c = cmp.get('v.newendTime');

        cmp.find('newHrAvailability').submit(fields);

    },
    handleError: function (cmp, event, helper) {

    },

    handleSuccess: function (cmp, event, helper) {
        var payload = event.getParams();
        helper.getCreatedHRAv(cmp, event, helper);
        cmp.set('v.newstartTime', null);
        cmp.set('v.newendTime', null);
    },
    changenewHRAvValue: function (cmp, event, helper) {

        var start = cmp.find("New_Interview_Start_Date").get("v.value");
        var end = cmp.find("New_Recurrence_Ends_On").get("v.value");
        var startDate = new Date($A.localizationService.formatDate(start, "yyyy-MM-dd"));
        cmp.find("New_Recurrence_Ends_On").set("v.value", $A.localizationService.formatDate(startDate, "yyyy-MM-dd"));
    },
    changenewtimevalue: function (cmp, event, helper) {

        var startTime = cmp.get('v.newstartTime');
        var endTime = cmp.get('v.newendTime');
        var inputCmp = cmp.find('newendTime');
        if (endTime) {

            if (startTime > endTime) {
                inputCmp.setCustomValidity("End time should be greater than start time");
            } else {
                inputCmp.setCustomValidity("");
            }
            inputCmp.reportValidity();
        }

    },
    validatenew: function (cmp, event, helper) {
        var inputstartTime = cmp.find("newstartTime");
        var inputendTime = cmp.find("newendTime");
        inputstartTime.reportValidity();
        inputendTime.reportValidity();
    },
    /**********************Create Availability end**********************/
    changeField: function (cmp, event, helper) {
        var form = cmp.find('newHrAvailability');
        if (event.getParam('checked')) {
            cmp.set('v.repeat', true);
        } else {
            cmp.set('v.repeat', false);
        }

    }
})