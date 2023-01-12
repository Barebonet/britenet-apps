public with sharing class CR_RatingController {
    @AuraEnabled
    public static List<Rating__c> getCarRatings(String carId){
        List<Rating__c> ratings = new List<Rating__c>();
        try {
            ratings = [SELECT Id, Description__c, Name, Rating__c, CreatedBy.Name FROM Rating__c WHERE ProductId__c = :carId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug(ratings);
        return ratings;
    }

    @AuraEnabled
    public static Double getAverageRating(String carId){
        List<Rating__c> ratings = new List<Rating__c>();
        Double avg = 0;
        Double sum = 0;
        try {
            ratings = [SELECT Id, Description__c, Name, Rating__c FROM Rating__c WHERE ProductId__c = :carId];
            System.debug(!ratings.isEmpty());
            System.debug(ratings != null);
            System.debug(ratings);
            if(!ratings.isEmpty()) {
                for(Rating__c rating : ratings) {
                    sum += Double.valueOf(rating.Rating__c);
                }
                avg = sum / ratings.size();
            }
            System.debug(avg);
            return avg;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addRating(String ownerId, String id, String description, Double rating) {
        List<Rating__c> checkRatings = [SELECT Id FROM Rating__c WHERE ProductId__c = :id AND OwnerId = :UserInfo.getUserId()];
        if(checkRatings.isEmpty()) {
            Rating__c ratingToInsert = new Rating__c();
            ratingToInsert.OwnerId = ownerId;
            ratingToInsert.Rating__c = String.valueOf(rating);
            ratingToInsert.Description__c = description;
            ratingToInsert.ProductId__c = id;
            insert ratingToInsert;
        }
    }
}