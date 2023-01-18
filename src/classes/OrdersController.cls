public with sharing class OrdersController {
    @AuraEnabled
    public static String makeNewOrder(List<CartItem__c> cartItems, Integer fullPrice) {
        try {
            Cart__c cart = [SELECT Id, UserId__c FROM Cart__c WHERE Id = :cartItems[0].CartId__c LIMIT 1];
            Account acc = [SELECT Id FROM Account WHERE Name = 'Customers' LIMIT 1];
            Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
            Order newOrder = new Order();
            newOrder.AccountId = acc.Id;
            newOrder.OwnerId = cart.UserId__c;
            newOrder.EffectiveDate = System.today();
            newOrder.TotalPrice__c = fullPrice;
            newOrder.Status = 'Draft';
            newOrder.Pricebook2Id = pricebook.Id;
            insert newOrder;
            List<OrderItem> orderItems = new List<OrderItem>();
            for(CartItem__c cartItem : cartItems) {
                PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id = :cartItem.ProductId__c AND Pricebook2Id = :pricebook.Id];
                OrderItem orderItem = new OrderItem();
                orderItem.Product2Id = cartItem.ProductId__c;
                orderItem.StartDate__c = cartItem.StartDate__c;
                orderItem.EndDate__c = cartItem.EndDate__c;
                orderItem.OrderId = newOrder.Id;
                orderItem.UnitPrice = cartItem.Totalprice__c;
                orderItem.PricebookEntryId = pbe.Id;
                orderItem.Quantity = 1;
                orderItems.add(orderItem);
            }
            insert orderItems;
            newOrder.Status = 'Activated';
            update newOrder;
            delete cart;
            delete cartItems;
            return 'SUCCESS';
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static List<Order> getUserOrders(String userId) {
        List<Order> userOrders = new List<Order>();
        try {
            userOrders = [SELECT Id, OrderNumber, TotalPrice__c, EffectiveDate FROM Order WHERE OwnerId = :userId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return userOrders;
    }

    @AuraEnabled
    public static List<OrderItem> getOrderItems(String orderId) {
        List<OrderItem> orderItems = new List<OrderItem>();
        try {
            orderItems = [SELECT Id, Product2.Name, Product2Id, StartDate__c, EndDate__c, UnitPrice FROM OrderItem WHERE OrderId = :orderId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return orderItems;
    }
}