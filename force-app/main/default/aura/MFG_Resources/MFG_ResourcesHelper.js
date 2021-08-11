({
    getResources : function(component, event, helper) {
        var action = component.get('c.getResouces');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let resp = response.getReturnValue();
                component.set("v.isNSMEnabled", resp.isNSMEnabled);
                
                let attachmentsMapObj = this.getAttachmentsObject(component, resp.attachments);
                let attachmentsMap = this.getAttachmentsMap(attachmentsMapObj);
                component.set("v.attachments", attachmentsMap);
            } else if (state === 'ERROR') {
                console.log('getResources() failed');
            }
        });
        $A.enqueueAction(action);
    },
    getAttachmentsObject : function(component, attachments) {        
        if(attachments && attachments.length > 0) {
            return attachments.reduce((result, currentAtt) => {
                let titleArr = currentAtt.Name.split("-");
                
                if(titleArr.length > 1) {
                    let key = titleArr[0].trim();
                    currentAtt.Name = titleArr[1].trim();
                    
                    (result[key] = result[key] || []).push(currentAtt);
                }
                return result;
  			}, {}); // empty object is the initial value for result object
        }
	},
    getAttachmentsMap : function(mapObject) {
        let result = [];
        for (var key in mapObject) {
            result.push({key : key, value : mapObject[key]});
        }
        return result;
    }
})