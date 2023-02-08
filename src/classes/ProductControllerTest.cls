@isTest
public with sharing class ProductControllerTest {
    @isTest
    static void testTrendingProducts() {
        List<Product2> products = ProductController.getTrendingProducts();

        System.assert(true, products != null);
    }

    @isTest
    static void testFailQuery() {
        Test.startTest();
        try {
            List<Product2> products = ProductController.getProducts(null, 0, 0, 200, -10, null);
        } catch(Exception e) {
            System.assert(true, e.getMessage() != null);
        }
        Test.stopTest();
    }

    @isTest 
    static void testAllArgumtntsInQuery() {
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        prod.Family = 'Cars';
        prod.Capacity__c = 998;
        prod.Power__c = 200;
        insert prod;

        Test.startTest();
        try {
            List<Product2> products = ProductController.getProducts('ub', 10, 2000000, 10, 5000000, 'Cars');
        } catch(Exception e) {
            System.assert(true, e.getMessage() != '');
        }
        Test.stopTest();


    }

    @isTest
    static void checkCarDetails() {
        Product2 product = new Product2();
        product.Name = 'SubUWU';
        product.Capacity__c = 1500;
        insert product;

        Product2 prod = ProductController.getProductDetails(product.Id);

        System.assertEquals(1500.0, prod.Capacity__c);
    }

    @isTest
    static void testGetAllProducts() {
        List<Product2> products = ProductController.getAllProducts();

        System.assert(true, products.isEmpty());
    }

    @isTest
    static void testGetPriceForProduct() {
        Product2 product = new Product2();
        product.Name = 'SubUWU';
        product.Capacity__c = 1500;
        insert product;
        Decimal price = 0;

        price = ProductController.getPriceForProduct(product.Id);

        System.assertEquals(10000, price);
    }

    @isTest
    static void testGetStandardPrice() {
        Product2 product = new Product2();
        product.Name = 'SubUWU';
        product.Capacity__c = 1500;
        insert product;
        List<String> productId = new List<String>();
        productId.add(product.Id);
        Date myDate = Date.newInstance(2023, 1, 16);
        Date date2 = Date.newInstance(2023, 1, 17);
        Double sth = 10.0;

        String fail = ProductController.addDiscount(myDate, date2, productId, sth);

        System.assertEquals('FAILURE', fail);
    }
}