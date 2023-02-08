public with sharing class CR_ComparisonController {
    @AuraEnabled
    public static string addToCompare(String carId) {
        String returnValue = 'SUCCESS';
        try {
            List<Comparison__c> cmp = [SELECT Id FROM Comparison__c WHERE ProductId__c = :carId];
            if(cmp.isEmpty()) {
                
                Comparison__c comp = new Comparison__c();
                comp.OwnerId = UserInfo.getUserId();
                comp.ProductId__c = carId;
                insert comp;
            } else {
                returnValue = 'Product is already in comparison.';
            }
            return returnValue;
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static string deleteFromComparison(String cmpId) {
        String returnValue = 'SUCCESS';
        try {
            Database.delete(cmpId);
            return returnValue;
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static List<CarsComparison> getCarToCompare(String userId) {
        List<CarsComparison> carsToCompare = new List<CarsComparison>();
        try {
            List<Comparison__c> compare = [SELECT 
                                        Id, 
                                        ProductId__c,
                                        ProductId__r.Name, 
                                        ProductId__r.Capacity__c, 
                                        ProductId__r.Doors__c, 
                                        ProductId__r.Gearbox__c,
                                        ProductId__r.Power__c, 
                                        ProductId__r.ProductionYear__c,
                                        ProductId__r.Family,
                                        ProductId__r.Seats__c
                                        FROM Comparison__c WHERE OwnerId = :userId];
            for(Comparison__c cmp : compare) {
                CarsComparison car = new CarsComparison();
                car.Id = cmp.Id;
                car.carId = cmp.ProductId__c;
                car.carName = cmp.ProductId__r.Name;
                car.capacity = Integer.valueOf(cmp.ProductId__r.Capacity__c);
                car.power = Integer.valueOf(cmp.ProductId__r.Power__c);
                car.doors = Integer.valueOf(cmp.ProductId__r.Doors__c);
                car.gearbox = cmp.ProductId__r.Gearbox__c;
                car.prodYear = Integer.valueOf(cmp.ProductId__r.ProductionYear__c);
                car.seats = Integer.valueOf(cmp.ProductId__r.Seats__c);
                car.family = cmp.ProductId__r.Family;
                car.photoLink = CR_GalleryController.getPhotoForTile(cmp.ProductId__c);
                car.price = ProductController.getPriceForProduct(cmp.ProductId__c);
                carsToCompare.add(car);
            }
            return carsToCompare;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class CarsComparison {
        @AuraEnabled public Id Id;
        @AuraEnabled public Id carId;
        @AuraEnabled public String carName;
        @AuraEnabled public Integer capacity;
        @AuraEnabled public Integer power;
        @AuraEnabled public Integer doors;
        @AuraEnabled public String gearbox;
        @AuraEnabled public Integer prodYear;
        @AuraEnabled public Integer seats;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String photoLink;
        @AuraEnabled public String family;
    }
}