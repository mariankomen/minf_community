({
    getSuppCases: function(cmp, event, helper) {
        var action = cmp.get('c.getSupport');
        
        action.setParams({
            open :cmp.get('v.open')
        });
        console.log(cmp.get('v.open'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.allCases',resp);
                if(resp!=null){
                    var maxResult=cmp.get('v.maxResults');
                    cmp.set('v.cases',resp.slice(0, maxResult));
                    
                    this.initTableSettings(cmp,resp,maxResult);    
                }
            } else if (state === 'ERROR') {
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    
    initTableSettings: function(cmp,resp,maxResult) {
        var pageSettings=new Object();
        pageSettings.pages= Math.ceil(resp.length/maxResult); 
        pageSettings.curentpage=1;
        var pagebeginSlice=[];
        for(var i=0; i<pageSettings.pages; i++){
            var slice=new Object();
            slice.pageNo=i+1;
            slice.begin=i*maxResult;
            if((i*Number(maxResult)+Number(maxResult))<resp.length){
                slice.end=i*Number(maxResult)+Number(maxResult);
            }
            pagebeginSlice.push(slice);
        }
        pageSettings.slice=  pagebeginSlice;
        console.log(pageSettings);
        cmp.set('v.settings',pageSettings);
    },
})