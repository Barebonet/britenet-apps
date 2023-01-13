({
    onInit : function(component, event, helper) {
        helper.getProducts(component);
    },

    handleChangeProductList: function(component, event) {
        let selectedOptionValue = event.getParam("value");
    },

    handleAddDiscount: function(component, event, helper) {
        
    }
})