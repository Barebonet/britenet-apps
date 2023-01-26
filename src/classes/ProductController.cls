public with sharing class ProductController {
    @AuraEnabled
    public static List<Product2> getTrendingProducts(){
        List<Product2> trendingProducts = new List<Product2>();
        try {
            List<Rating__c> rating = [SELECT ProductId__c FROM Rating__c ORDER BY Rating__c DESC LIMIT 4];
            List<Id> productIds = new List<Id>();
            for(Rating__c rat : rating) {
                productIds.add(rat.ProductId__c);
            }
            trendingProducts = [SELECT Id, Name, Power__c, Capacity__c FROM Product2 WHERE Id IN :productIds LIMIT 4];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return trendingProducts;
    }

    @AuraEnabled
    public static List<Product2> getProducts(String carName, Integer minPower, Integer maxPower, Integer minCapacity, Integer maxCapacity, String productFamily) {
        List<Product2> products = new List<Product2>();
        String query = 'SELECT Id, Name, Power__c, Capacity__c FROM Product2 WHERE Id != null';
        try {
            if(String.isNotBlank(carName)) {
                query += ' AND Name LIKE \'%' + carName + '%\'';
            }
            if(minPower != 0) {
                query += ' AND Power__c >= ' + minPower;
            }
            if(maxPower != 0) {
                query += ' AND Power__c <=' + maxPower;
            }
            if(minCapacity != 0) {
                query += ' AND Capacity__c >= ' + minCapacity;
            }
            if(maxCapacity != 0) {
                query += ' AND Capacity__c <= ' + maxCapacity;
            }
            if(String.isNotBlank(productFamily) && productFamily != 'None') {
                query += ' AND Family = \'' + productFamily + '\'';
            }
            products = Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return products;
    }

    @AuraEnabled
    public static Product2 getProductDetails(String carId) {
        Product2 car = new Product2();
        try {
            car = [SELECT Id, Name, Capacity__c, ProductionYear__c, Power__c, Torque__c, Description, Doors__c, Gearbox__c, Seats__c FROM Product2 WHERE Id = :carId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return car;
    }

    @AuraEnabled
    public static List<Product2> getAllProducts() {
        List<Product2> products = new List<Product2>();
        try {
            products = [SELECT Id, Name, Capacity__c, ProductionYear__c, Power__c, Torque__c, Description, Doors__c, Gearbox__c, Seats__c FROM Product2];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return products;
    }

    @AuraEnabled
    public static Decimal getPriceForProduct(String carId) {
        List<PricebookEntry> pricebookEntry = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntryStandard = new List<PricebookEntry>();
        Decimal price = 10000;
        try {
            List<Pricebook2> restOfPricebooks = [SELECT Id FROM Pricebook2 WHERE IsActive = true];
            pricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id IN :restOfPricebooks AND Product2Id = :carId];
            for(PricebookEntry pbe : pricebookEntry) {
                if(pbe.UnitPrice < price) {
                    price = pbe.UnitPrice;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return price;
    }

    @AuraEnabled
    public static PricebookEntry getStandardPrice(String carId) {
        List<PricebookEntry> pricebookEntry = new List<PricebookEntry>();
        try {
            pricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2.IsStandard = true AND Product2Id = :carId];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return pricebookEntry[0];
    }

    @AuraEnabled
    public static String addPercentDiscount(Date startDate, Date endDate, List<String> productList, Double percentDiscount) {
        Pricebook2 newPricebook = new Pricebook2();
        String returnVar = '';
        Double discountPercent = percentDiscount / 100.0;
        discountPercent = 1.0 - discountPercent;
        try {
            newPricebook.ValidFrom = startDate;
            newPricebook.ValidTo = endDate;
            newPricebook.Name = 'Pricebook';
            insert newPricebook;
    
            List<PricebookEntry> listToPush = new List<PricebookEntry>();
            for(String prod : productList) {
                PricebookEntry pbEntry = new PricebookEntry();
                PricebookEntry pbe = getStandardPrice(prod);
                pbEntry.Pricebook2Id = newPricebook.Id;
                pbEntry.Product2Id = prod;
                pbEntry.UnitPrice = pbe.UnitPrice * discountPercent;
                listToPush.add(pbEntry);
            }
            insert listToPush;
            return 'SUCCESS';
        } catch (Exception e) {
            delete newPricebook;
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static String addCurrencyDiscount(Date startDate, Date endDate, List<String> productList, Double currencyDiscount) {
        Pricebook2 newPricebook = new Pricebook2();
        try {
            newPricebook.ValidFrom = startDate;
            newPricebook.ValidTo = endDate;
            newPricebook.Name = 'Pricebook';
            insert newPricebook;
    
            List<PricebookEntry> listToPush = new List<PricebookEntry>();
            for(String prod : productList) {
                PricebookEntry pbEntry = new PricebookEntry();
                PricebookEntry pbe = getStandardPrice(prod);
                pbEntry.Pricebook2Id = newPricebook.Id;
                pbEntry.Product2Id = prod;
                pbEntry.UnitPrice = pbe.UnitPrice - currencyDiscount;
                listToPush.add(pbEntry);
            }
            insert listToPush;
            return 'SUCCESS';
        } catch (Exception e) {
            delete newPricebook;
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static String addNewProduct(Product2 product) {
        try {
            Database.saveResult result = Database.insert(product, false);
            System.debug(result);
            return product.Id;
        } catch (Exception e) {
            return 'FAIL';
        }
    }
}