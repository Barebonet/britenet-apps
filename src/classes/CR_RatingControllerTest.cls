@IsTest
public with sharing class CR_RatingControllerTest {
    @IsTest
    static void testGetCarRatings() {
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;

        List<Rating__c> ratings = CR_RatingController.getCarRatings(prod.Id);

        System.assert(true, ratings.isEmpty());
    }

    @IsTest
    static void testGetAverageRating() {
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;
        Rating__c rating = new Rating__c();
        rating.ProductId__c = prod.Id;
        rating.Rating__c = '6';
        rating.Description__c = 'Insane car.';
        insert rating;

        Double ratin = CR_RatingController.getAverageRating(prod.Id);

        System.assert(true, ratin > 0);
    }

    @IsTest
    static void testAddRating() {
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;
        String id = prod.Id;

        CR_RatingController.addRating(UserInfo.getUserId(), id, 'Cool car', 6);
    }
}