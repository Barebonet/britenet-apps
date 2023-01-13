({
    getProducts: function(component) {
        let action = component.get("c.getAllProducts");
        action.setCallback(this, function(response) {
            let productList = response.getReturnValue();
            let array = [];
            productList.forEach(element => {
                array.push({
                    label: element.Name,
                    value: element.Id
                })
            });
            component.set("v.productList", array);
        });
        $A.enqueueAction(action);
    }
})