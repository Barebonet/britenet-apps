({
    handleUploadFinished: function (cmp, event) {
        let uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(file => console.log(file.name));
        cmp.set('v.fileInput', false);
        cmp.set('v.priceInput', true);
    },

    handleInsertProduct: function(component, event, helper) {
        let product = component.get('v.prodInsert');
        helper.insertNewProduct(component, product);
    },

    handleAddPrice: function(component, event, helper) {
        let newPricebookEntry = component.get('v.newPbe');
        newPricebookEntry.Product2Id = component.get('v.productId');
        helper.insertStandardPrice(component, newPricebookEntry);
    }
});