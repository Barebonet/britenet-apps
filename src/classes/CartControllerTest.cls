@IsTest
public with sharing class CartControllerTest {

    @IsTest
    static void testSuccessAddToCart() {
        Date date1 = Date.newInstance(2023, 01, 30);
        Date date2 = Date.newInstance(2023, 01, 31);
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;

        Test.startTest();
        String response = CartController.addToCart(date1, date2, UserInfo.getUserId(), 900, prod.Id);
        Test.stopTest();

        System.assertEquals('SUCCESS', response);
    }

    @IsTest
    static void testSuccessGetUserCart() {
        Cart__c newCart = new Cart__c();
        newCart.UserId__c = UserInfo.getUserId();
        insert newCart;

        List<CartItem__c> cartItems = CartController.getUserCart(UserInfo.getUserId());

        System.assert(true, cartItems.isEmpty());
    }

    @IsTest
    static void testFailGetUserCart() {
        try {
            List<CartItem__c> cartItems = CartController.getUserCart('');
        } catch(Exception e) {
            System.assert(true, e.getMessage() != null);
        }
    }

    @IsTest
    static void testFailDeleteFromCart() {
        try {
            CartController.deleteFromCart('');
        } catch(Exception e) {
            System.assert(true, e.getMessage() != null);
        }
    }
}