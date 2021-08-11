({
    getParameterByName: function(component, event,helper, name) {

        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
        
        
        

    },
    
    getCandDet: function (cmp, event, helper){
        var action = cmp.get('c.getjobDet');
        action.setParams({ 
            sid : cmp.get('v.recordId')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
               cmp.set('v.candidate',resp);
                JSON.stringify("candidate : " + resp);
                console.log(resp.RecordTypeId);
                this.getFieldOptions(cmp, event, helper,resp.RecordTypeId);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action); 
    },

    getFieldOptions: function (cmp, event, helper,recordTypeId){
        var action = cmp.get('c.getStatusRatingOptions');
        console.log(recordTypeId);
        action.setParams({ 
            recordTypeId : recordTypeId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
                
                var allowedFieldOptions=cmp.get('v.allowedFieldOptions');
                var optList=allowedFieldOptions.split(',');
                console.log(optList);
                var statusOptions=[];
                for(let staus of resp.statusOptions){
                    for(let allow of optList){
                        if(allow==staus.value){
                            statusOptions.push(staus)   ;
                        }
                    }
                }
                resp.statusOptions=statusOptions;
               cmp.set('v.fieldOptions',resp);
                
                
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    updateCandidate: function (cmp, event, helper){
        var action = cmp.get('c.updateCandidateStatusRating');
        var candidate=cmp.get('v.candidate');
        action.setParams({ 
            status: candidate.Status__c,
            rating:candidate.Candidate_Rating__c,
            rejectionReason:candidate.Rejection_Reason_for__c,
            rejectionComments:candidate.Rejection_Comments__c,
            cId:candidate.Id
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
              
                cmp.set('v.updateStatusRating',false);
               
                if(cmp.get("v.historyback")){
                     window.history.back();
                }else{
                    $A.get('e.force:refreshView').fire();                    
                }
            } else if (state === 'ERROR') {
                 console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action); 
    },
    
    validateStatusUpdateRequest : function (cmp, fieldAuraIds) {
        let isValid = true;
        if(fieldAuraIds.length > 0) {
            fieldAuraIds.forEach(element => {
                let field = cmp.find(element);
                if(field) {
                	if(!field.get("v.value")) isValid = false;
                }
            });
        }else {
            isValid = false;
        }
        
        return isValid;
	}
    
})