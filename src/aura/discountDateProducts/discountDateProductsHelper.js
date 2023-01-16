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
    },

    addDiscount: function(component, startDate, endDate, productList, discount) {
        let action = component.get("c.addDiscount");
        action.setParams({
            startDate: startDate,
            endDate: endDate,
            productList: productList,
            discount: discount
        });
        action.setCallback(this, function(response) {
            let respValue = response.getReturnValue();
            console.log(respValue);
            let toastEvent = $A.get("e.force:showToast");
            if (respValue === 'SUCCESS') {
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Discount added."
                });
                toastEvent.fire();

                pushToParent.closeModalAddPricebook(cmpClose);
            } else {
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "Something went wrong."
                });
                toastEvent.fire();
                pushToParent.closeModalAddPricebook(cmpClose);
            }
        })
        $A.enqueueAction(action);
    }
})