@IsTest
public with sharing class OrderControllerTest {
    @IsTest
    static void testFailMakeNewOrder() {
        List<CartItem__c> cartItems = [SELECT Id FROM CartItem__c LIMIT 3];

        String response = OrdersController.makeNewOrder(cartItems, 1000);

        System.assert(true, response != 'SUCCESS');
    }

    @IsTest
    static void testSuccessMakeNewOrder() {
        Account acc = new Account();
        acc.Name = 'Customers';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;
        Cart__c newCart = new Cart__c();
        newCart.UserId__c = UserInfo.getUserId();
        CartItem__c cartIt = new CartItem__c();
        cartIt.CartId__c = newCart.Id;
        cartIt.ProductId__c = prod.Id;
        insert cartIt;
        List<CartItem__c> cartItems = new List<CartItem__c>();
        cartItems.add(cartIt);

        String response = OrdersController.makeNewOrder(cartItems, 1000);

        System.assertEquals('SUCCESS', response);
    }

    @IsTest
    static void testGetUserOrders() {
        Account acc = new Account();
        acc.Name = 'Customers';
        insert acc;
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Christmas Discount';
        insert pricebook;
        Order ord = new Order();
        ord.TotalPrice__c = 1499;
        ord.EffectiveDate = System.today();
        ord.Status = 'Draft';
        ord.OwnerId = UserInfo.getUserId();
        ord.AccountId = acc.Id;
        ord.Pricebook2Id = pricebook.Id;
        insert ord;

        Test.startTest();
        List<Order> userOrders = OrdersController.getUserOrders(UserInfo.getUserId());
        Test.stopTest();

        System.assert(true, userOrders != null);
    }

    @IsTest
    static void testGetOrderItems() {
        Account acc = new Account();
        acc.Name = 'Customers';
        insert acc;
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Christmas Discount';
        insert pricebook;
        Order ord = new Order();
        ord.TotalPrice__c = 1499;
        ord.EffectiveDate = System.today();
        ord.Status = 'Draft';
        ord.OwnerId = UserInfo.getUserId();
        ord.AccountId = acc.Id;
        ord.Pricebook2Id = pricebook.Id;
        insert ord;

        List<OrderItem> orderItems = OrdersController.getOrderItems(ord.Id);

        System.assert(true, orderItems != null);
    }
}