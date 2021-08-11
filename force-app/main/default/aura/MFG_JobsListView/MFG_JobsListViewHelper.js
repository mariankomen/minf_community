({
    getJobs: function(cmp, event, helper) {
        var action = cmp.get('c.getCurrentUserJobs');
         var equal='=';
        var ctarget = event.currentTarget;
        if(ctarget){
            var id_str = ctarget.dataset.value;
            if(id_str=='open'){
                equal='=';
            }else{
                equal='!=';
            }    
        }

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                
               // console.log(resp);
                cmp.set('v.Alljobs',resp);
                
                var jobs={};
                var maxResult=cmp.get('v.maxResults');
                
                var openSet= this.initTableSettings(cmp,resp.open); 
                var open= resp.open.slice(0, maxResult);
                jobs.open={'settings':openSet,'open':open};
                
                var completedSet= this.initTableSettings(cmp,resp.completed); 
                var completed= resp.completed.slice(0, maxResult);
                jobs.completed={'settings':completedSet,'completed':completed};
                

               // console.log(jobs);
                cmp.set('v.jobs',jobs);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
        
    initTableSettings: function(cmp,jobs) {
        var maxResult=cmp.get('v.maxResults');
        var total=jobs.length;
        var pageSettings=new Object();
        pageSettings.pages= Math.ceil(total/maxResult); 
        pageSettings.curentpage=1;
        var pagebeginSlice=[];
        for(var i=0; i<pageSettings.pages; i++){
            var slice=new Object();
            slice.pageNo=i+1;
            slice.begin=i*maxResult;
            if((i*Number(maxResult)+Number(maxResult))<total){
                slice.end=i*Number(maxResult)+Number(maxResult);
            }
            pagebeginSlice.push(slice);
        }
        pageSettings.slice=  pagebeginSlice;
       return pageSettings;
    },
})