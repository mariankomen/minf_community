({
    handleKeyUp: function (cmp, evt) {
        var term=cmp.find('enter-search').get('v.value');
        if(term && term.length>0){
            var data = cmp.get("v.options"),
                results = data, regex;
            try {
                regex = new RegExp(term, "i");
                results = data.filter(row => regex.test(row.label_fr) || regex.test(row.label) || regex.test(row.value));
                console.log(results);
                cmp.set("v.filteredoptions", results);
                if(results && results.length==0){
                    cmp.set('v.noMatchesFind',true);
                }else{
                    cmp.set('v.noMatchesFind',false);
                }
            }
            catch (e) {
                
                console.log(e);
            }
        }else if(term.length==0){
            cmp.set("v.filteredoptions",cmp.get("v.options"));
        }
        
    },
    
    init : function(cmp, event, helper) {
        console.log('SELECT INIT');
        var language = $A.get("$Locale.language");
        console.log(language);
        cmp.set('v.language',language);
        helper.getOptions(cmp, event, helper);
        
    },
    setInputValue: function (cmp, event) {
        var ctarget = event.currentTarget;
        var val = ctarget.dataset.value;
        console.log(val);
        cmp.set('v.value',val);
        cmp.set('v.listboxOpen',false);
        
    },
    
    
    
    onfocus: function(cmp, event, helper) {
        console.log('onfocus');
        cmp.set('v.listboxOpen',true);
    },
    onblur: function(cmp, event, helper) {
        // cmp.set('v.listboxOpen',false);
        console.log('onblur');
    }
    
    
})