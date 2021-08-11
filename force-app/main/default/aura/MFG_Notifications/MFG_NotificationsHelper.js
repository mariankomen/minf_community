({
    getNotificationsList: function(cmp, event, helper) {
        var action = cmp.get('c.getNotifications');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resp=response.getReturnValue();
                console.log(resp);
              
                
                var recordId=cmp.get('v.recordId');
                if(recordId){
                    for(let note of resp){
                        if(note.Id.search(new RegExp(recordId, "i"))){
                            note.collapsed=true;
                        }else{
                             note.collapsed=false;
                        }
                    }
                }else{
                    for(let note of resp){
                        note.collapsed=true;
                    } 
                }
                
                  cmp.set('v.notifications',resp);
            } else if (state === 'ERROR') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
})