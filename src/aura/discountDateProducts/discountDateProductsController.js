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
        let discount = component.get("v.discountPercent");
        helper.addDiscount(component, startDate, endDate, productList, discount);
    }
})