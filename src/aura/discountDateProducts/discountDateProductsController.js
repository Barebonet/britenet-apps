({
    onInit : function(component, event, helper) {
        helper.getProducts(component);
    },

    handleChangeProductList: function(component, event) {
        let selectedOptionValue = event.getParam("value");
    },

    handleAddDiscount: function(component, event, helper) {
        let startDate = component.get("v.startDate");
        let endDate = component.get("v.endDate");
        let productList = component.get("v.defaultOptions");
        let discountPercent = component.get("v.discountPercent");
        let discountCurrency = component.get("v.currencyDiscount");
        if(discountPercent !== 0 && discountCurrency !== 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "One type of discount has to be 0!"
            });
            toastEvent.fire();
        } else if(discountPercent === 0 && discountCurrency === 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "One type of discount has to be greater than 0!"
            });
            toastEvent.fire();
        } else {
            helper.addDiscount(component, startDate, endDate, productList, discountPercent, discountCurrency);
        }
    }
})