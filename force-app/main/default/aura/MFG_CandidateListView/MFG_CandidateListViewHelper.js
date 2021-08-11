({
    getCandidateList: function(cmp, event, helper) {
        var action = cmp.get('c.getCandidates');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                cmp.set('v.candidates',resp);
             //   accepted
              //  outstanding
             //   rejected
                var candidates={};
                 var maxResult=cmp.get('v.maxResults');
                var outstandingSet= this.initTableSettings(cmp,resp.outstanding); 
                console.log(outstandingSet);
                var outstanding= resp.outstanding.slice(0, maxResult);
                console.log(outstanding);
                candidates.outstanding={'settings':outstandingSet,'outstanding':outstanding};
                
                var acceptedSet= this.initTableSettings(cmp,resp.accepted); 
                var accepted= resp.accepted.slice(0, maxResult);
                 candidates.accepted={'settings':acceptedSet,'accepted':accepted};
                
                var rejectedSet= this.initTableSettings(cmp,resp.rejected); 
                var rejected= resp.rejected.slice(0, maxResult);
                candidates.rejected={'settings':rejectedSet,'rejected':rejected};
                console.log(candidates);
                cmp.set('v.fdcJobCandidates',candidates);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    initTableSettings: function(cmp,candidates) {
        var maxResult=cmp.get('v.maxResults');
        var total=candidates.length;
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