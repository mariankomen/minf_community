({
    handleShowSpinner: function(cmp, event, helper) {
        cmp.set('v.isLoading', true);
    },
    handleHideSpinner: function(cmp, event, helper) {
        cmp.set('v.isLoading', false);
    },

    handleShowToast: function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var config = params.config ? params.config : {};

        helper.showToast(config,params.context,params.cmp);
    },
    handleNavigateTo: function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var url = params.url ? params.url : '';
        var newTab = params.newTab ? params.newTab : false;

        helper.navigateTo(url, newTab);
    }
})