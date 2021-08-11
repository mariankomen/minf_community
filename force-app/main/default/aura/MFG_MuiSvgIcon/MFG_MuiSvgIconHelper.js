({
    renderIcon: function(component) {
        
        var svgns = "http://www.w3.org/2000/svg";
        var xlinkns = "http://www.w3.org/1999/xlink";
        var classname = component.get("v.class");
        var focusable= component.get("v.focusable");
        var ariahidden= component.get("v.ariahidden");
        var  viewBox= component.get("v.viewBox");
        var role= component.get("v.role");
        var style= component.get("v.style");
        var svgroot = document.createElementNS(svgns, "svg");
        
        svgroot.setAttribute("class", classname);
        svgroot.setAttribute("focusable", focusable);
        svgroot.setAttribute("aria-hidden", ariahidden);
        svgroot.setAttribute("viewBox", viewBox);
        svgroot.setAttribute("role", role);
        svgroot.setAttribute("style", style);
        
        

            var shape = document.createElementNS(svgns, "use");
            shape.setAttributeNS(xlinkns, "href", component.get("v.svgPath"));
            svgroot.appendChild(shape); 
   
        

        var container = component.find("container").getElement();
        container.insertBefore(svgroot, container.firstChild);
    }
})