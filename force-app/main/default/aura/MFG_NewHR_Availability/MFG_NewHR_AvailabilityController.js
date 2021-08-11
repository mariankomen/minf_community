({
    init : function(cmp, event, helper) {
      
      //  helper.initform(cmp, event, helper);
    },
    handleLoad: function(cmp, event, helper) {
      //  console.log(event);
      //  cmp.set('v.showSpinner', false);
    },
    
    handleSubmit: function(cmp, event, helper) {
      //  console.log('fsdfsdfsdf');
      //  cmp.set('v.disabled', true);
      //  cmp.set('v.showSpinner', true);
    },
    
    handleError: function(cmp, event, helper) {

     //   cmp.set('v.showSpinner', false);
    },
    
    handleSuccess: function(cmp, event, helper) {
      //  var params = event.getParams();
      //  console.log('v.recordId', params.response.id);
     //  cmp.set('v.recordId', params.response.id);
//cmp.set('v.showSpinner', false);
      //  cmp.set('v.saved', true);
        
        
        
        
        
        
    },
    changeField: function(cmp, event, helper) {
         console.log(event.getSource().get("v.fieldName"));
        console.log(event.getParam('value'));
        if(event.getSource().get("v.fieldName")=='Specific_Candidate_Required__c' && event.getParam('value')=='Yes'){
            cmp.set('v.show',true);
        }
        if(event.getSource().get("v.fieldName")=='Specific_Candidate_Required__c' &&( event.getParam('value')=='' || event.getParam('value')=='No') ){
            cmp.set('v.show',false);
        }
    }
})