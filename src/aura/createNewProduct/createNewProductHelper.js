({
    insertNewProduct: function(component, product) {
        let action = component.get('c.addNewProduct');
        action.setParams({
            product: product
        });
        action.setCallback(this, function(response) {
            if(response !== 'FAIL') {
                component.set('v.productId', response.getReturnValue());
                component.set('v.productInput', false);
                component.set('v.fileInput', true);
            }
        });
        $A.enqueueAction(action);
    },

    insertStandardPrice: function (component, pbe) {
        let action = component.get('c.addStandardPrice');
        action.setParams({
            pbe: pbe
        });
        action.setCallback(this, function () {
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "success",
                "title": "Success!",
                "message": "Product has been sent to approval!"
            });
            toastEvent.fire();
        })
    }
});