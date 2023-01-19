({
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        var fileCount=component.find("fileId").get("v.files").length;
        var files='';
        if (fileCount > 0) {
            for (var i = 0; i < fileCount; i++) 
            {
                fileName = component.find("fileId").get("v.files")[i]["name"];
                files=files+','+fileName;
            }
        }
        else
        {
            files=fileName;
        }
        component.set("v.fileName", files);
    },

    insertNewProduct: function(component, event, helper) {

    }
})