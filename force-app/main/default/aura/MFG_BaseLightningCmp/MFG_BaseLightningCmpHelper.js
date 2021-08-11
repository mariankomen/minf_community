({

    showNotification: function(cmp, config) {
        console.log('showNotification');
        cmp.getSuper().find('myNotification').show(cmp,config);
        
    },
    hideNotification: function(cmp) {
        console.log('hideNotification');
        cmp.getSuper().find('myNotification').hide();
    },
    showSpinner: function(cmp) {
        cmp.getSuper().set('v.isLoading', true);
    },
    hideSpinner: function(cmp) {
        cmp.getSuper().set('v.isLoading', false);
    },
    openModal: function(cmp, config) {
        var overlay;
        var sections;
        var content;
        var components;
        var params;

        function allFalse(els) {
            return els.reduce(function(acc, el) {
                return el ? false : acc;
            }, true);
        }

        overlay = cmp.getSuper().find('overlayLib');

        sections = ['header', 'body', 'footer'].filter(function(el) {
            return config[el];
        });

        content = sections.map(function(el) {
            return config[el];
        });

        components = content.map(function(el) {
            if (Array.isArray(el)) return el;
            if (el.startsWith('forceoft_jc:')) return [el, {}];
            return false;
        });

        if (allFalse(components)) {
            params = Object.assign(config, content);
            overlay.showCustomModal(params);
        } else {
            $A.createComponents(
                components.filter(function(el) { return el }),
                function(fragments, status) {
                    var hydratedContent = {};
                    var modalParams;
                    if (status === 'SUCCESS') {
                        sections.forEach(function(el, index) {
                            hydratedContent[el] =
                                components[index]
                                    ? fragments.shift()
                                    : content[index];
                        });

                        modalParams = Object.assign(config, hydratedContent);
                        overlay.showCustomModal(modalParams);
                    }
                }
            );
        }
    },
    
    
    closeModal: function(cmp) {
        cmp.getSuper().find('overlayLib').notifyClose();
    },
    

    
    
    
    
    
    
    showToast: function(config,context,cmp) {
        if(context != undefined) {
            if(context == 'Theme4t' || context == 'Theme4d') {
                var toastEvent = $A.get('e.force:showToast');
                var defaultConfig = {
                 //   mode: 'sticky'
                }
                
                toastEvent.setParams(Object.assign(defaultConfig, config));
                toastEvent.fire();
            } else {
                cmp.getSuper().find('myNotification').show(config);
            }
        } else {
            var toastEvent = $A.get('e.force:showToast');
            var defaultConfig = {
               // mode: 'sticky'
            }
            
            toastEvent.setParams(Object.assign(defaultConfig, config));
            toastEvent.fire();         
        } 
  
    },
    navigateTo: function(url, newTab) {
        var currentUrl = window.location.pathname.split('/');
        var external = url.substring(0, 4) === 'http';
        var prefix = (currentUrl[1] === 's' ? '' : '/' + currentUrl[1]) + '/s/';

        if (external || newTab) {
            window.open(external ? url : prefix + url);
        } else {
            window.location.href = prefix + url;
        }
    },

})