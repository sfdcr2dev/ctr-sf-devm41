({
    show: function (component) {
        if (component.get("v.isOpen")) {
            this.expandSection(component);

        } else {
            this.colapseSection(component);
        }
    },
    expandSection: function (component) {

        let search = component.find("search");
        let chevron = component.find("chevron");
        let searchTop = component.find("searchTop");

        $A.util.addClass(searchTop, "preventOverflow");
        $A.util.removeClass(search, "hideBar");
        $A.util.addClass(search, "showBar");


        setTimeout(function () {

            $A.util.removeClass(searchTop, "preventOverflow");
            $A.util.removeClass(search, "showBar");

        }, 400);
    },
    colapseSection: function (component) {

        let search = component.find("search");
        let chevron = component.find("chevron");
        let searchTop = component.find("searchTop");

        $A.util.addClass(searchTop, "preventOverflow");
        $A.util.addClass(search, "hideBar");
    }
})