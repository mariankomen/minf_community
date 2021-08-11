({
    createGraph: function (component, event, helper) {

        var action = component.get('c.getChart');

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                let element = component.find('chart').getElement();
                let context2d = element.getContext('2d');
                var myChat = new Chart(context2d, {
                    type: 'bar',

                    data: {
                        labels: resp.labels.reverse(),
                        datasets: [{
                            label: '',
                            data: resp.data.reverse(),
                            backgroundColor: [
                                '#002b6b',
                                '#0047ad',
                                '#1466c7',
                                '#234788',
                                '#3e64a5',
                                '#5884c3'
                            ],
                            borderColor: [
                                '#002b6b',
                                '#0047ad',
                                '#1466c7',
                                '#234788',
                                '#3e64a5',
                                '#5884c3'
                            ],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,


                        legend: {
                            display: false
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    callback: function (value) { if (value % 1 === 0) { return value; } }
                                },
                                gridLines: {
                                    display: false,
                                    drawBorder: false,
                                }
                            }],
                            xAxes: [{
                                gridLines: {
                                    display: false,
                                    drawBorder: false,
                                }
                            }]
                        }
                    },
                });
                window.addEventListener('resize', $A.getCallback(function () {
                    if (component.isValid()) {
                        myChat.resize();

                    }
                }));
            } else if (state === 'ERROR') {

            }
        });
        $A.enqueueAction(action);
    },



    get_ScheduledInterviews: function (cmp, event, helper) {
        var action = cmp.get('c.getScheduledInterviews');

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.scheduledInterviews', resp);
            } else if (state === 'ERROR') {

            }
        });
        $A.enqueueAction(action);
    },
    get_LastNotification: function (cmp, event, helper) {
        var action = cmp.get('c.getLastNotification');

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.notification', resp);
            } else if (state === 'ERROR') {

            }
        });
        $A.enqueueAction(action);
    },
    get_JobSummury: function (cmp, event, helper) {
        var action = cmp.get('c.getJobSummury');

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp = response.getReturnValue();
                cmp.set('v.jobSummury', resp);
            } else if (state === 'ERROR') {

            }
        });
        $A.enqueueAction(action);
    },
})