({
    render : function(cmp, helper) {
        var ret = this.superRender();
        helper.render(cmp);
        return ret;
    },
    rerender : function(cmp, helper){
        this.superRerender();
        helper.rerender(cmp);
    },
    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.afterRender(cmp);
    },
    unrender: function (cmp, helper) {
        
        this.superUnrender();
        
        helper.unrender(cmp, helper);
    }
})