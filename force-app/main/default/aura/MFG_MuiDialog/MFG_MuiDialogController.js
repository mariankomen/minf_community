({
    showNotification: function(cmp, event, helper) {

        var p = event.getParam('arguments');
        var config = (p && p.config) ? p.config : {};

        cmp.set('v.isShown', true);
        var sections;
        var content;
        var components;
        var params;

        function allFalse(els) {
            return els.reduce(function(acc, el) {
                return el ? false : acc;
            }, true);
        }
        
        sections = ['header', 'body', 'footer'].filter(function(el) {
            return config[el];
        });

        content = sections.map(function(el) {
            return config[el];
        });

        components = content.map(function(el) {
            if (Array.isArray(el)) return el;
            if (el.startsWith('c:')) return [el, {}];
            return false;
        });

        if (allFalse(components)) {
            console.log(config);
            console.log(content);
            params = Object.assign(config, content);
            console.log(JSON.stringify(params) );
            

        } else {
            $A.createComponents(

                components.filter(function(el) { return el }),
                function(fragments, status) {
                    var hydratedContent = {};
                    var modalParams;
                    if (status === 'SUCCESS') {
                        sections.forEach(function(el, index) {
                            console.log(el);
                            console.log(index);
                            hydratedContent[el] = components[index]? fragments.shift(): content[index];
                        });
                        var body = cmp.get("v.body");
                        body.push(hydratedContent.body);
                        cmp.set("v.body", body); 
   
                    }
                }
            );
        }
        
        
    
    },

    hideNotification: function(cmp, event, helper) {
       
       cmp.set('v.isShown', false);
         console.log('hideNotificationDialog');
        console.log( cmp.find('NotificationContent'));
     //  cmp.find('NotificationContent').destroy();
        
    }
})