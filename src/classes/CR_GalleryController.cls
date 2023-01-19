public with sharing class CR_GalleryController {
    public final static string URL = '/sfc/servlet.shepherd/document/download/';
    
    @AuraEnabled
    public static List<String> getPhotosForProduct(String carId, Integer offset) {
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<String> listOfLinks = new List<String>();
        try {
            cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :carId LIMIT 1 OFFSET :offset];
            for(ContentDocumentLink cdl : cdlList) {
                listOfLinks.add(URL + cdl.ContentDocumentId);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listOfLinks;
    }

    @AuraEnabled
    public static String getPhotoForTile(String carId) {
        String newURL = '';
        try {
            ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :carId LIMIT 1];
            newURL = URL + cdl.ContentDocumentId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return newURL;
    }

    @AuraEnabled
    public static Integer getPhotoListSize(String carId) {
        try {
            List<ContentDocumentLink> cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :carId];
            Integer listSize = cdl.size();
            return listSize;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}