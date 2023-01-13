@IsTest
public with sharing class CR_TestGalleryController {

    // @IsTest
    // static void shouldCatchErrorForProductsPhoto() {
    //     List<String> cdlList = CR_GalleryController.getPhotosForProduct('', -1);
    //     System.assertEquals(0, cdlList.size());
    // }

    @IsTest
    static void shouldReturnListForProductsPhoto() {
        Product2 prod = new Product2();
        prod.Name = 'Some random sheesh';
        insert prod;
        ContentVersion content = new ContentVersion(); 
        content.Title = 'Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob;
        content.origin = 'H';
        insert content;
        List<String> cdlList = CR_GalleryController.getPhotosForProduct(prod.Id, 0);
        System.assertEquals(0, cdlList.size());
    }

    @IsTest
    static void shouldreturnPhotoForTile() {
        Product2 prod = new Product2();
        prod.Name = 'Some random sheesh';
        insert prod;
        ContentVersion content = new ContentVersion(); 
        content.Title = 'Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob;
        content.origin = 'H';
        insert content;

        String url = CR_GalleryController.getPhotoForTile(prod.Id);

        System.assert(String.isNotBlank(url), true);
    }
}