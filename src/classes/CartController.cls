public with sharing class CartController {
    @AuraEnabled
    public static String addToCart(Date startDate, Date endDate, String userId, 
                                    Integer totalPrice, String productId) {
        try {
            List<Cart__c> userCart = [SELECT 
                                        Id 
                                        FROM Cart__c 
                                        WHERE UserId__c = :userId LIMIT 1];
            if(userCart.isEmpty()) {
                Cart__c newCart = new Cart__c();
                newCart.UserId__c = userId;
                insert newCart;  
            }
            userCart = [SELECT 
                            Id 
                            FROM Cart__c 
                            WHERE UserId__c = :userId LIMIT 1];
            CartItem__c cartItem = new CartItem__c();
            cartItem.CartId__c = userCart[0].Id;
            cartItem.ProductId__c = productId;
            cartItem.StartDate__c = startDate;
            cartItem.EndDate__c = endDate;
            cartItem.Totalprice__c = totalPrice;
            return 'SUCCESS';
        } catch (Exception e) {
            return 'FAILURE';
        }
    }

    @AuraEnabled
    public static List<CartItem__c> getUserCart(String userId) {
        List<CartItem__c> cartItems = new List<CartItem__c>();
        try {
            cartItems = [SELECT Id, StartDate__c, EndDate__c, Totalprice__c, ProductId__c, CartId__c FROM CartItem__c WHERE CartId__r.UserId__c = :userId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return cartItems;
    }
}