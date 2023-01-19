public with sharing class CR_CaseController {
    @AuraEnabled
    public static String submitNewCase(String productId, String subject, String reason, String description){
        try {
            Account acc = [SELECT Id FROM Account WHERE Name = 'Customers' LIMIT 1];
            Case newCase = new Case();
            newCase.AccountId = acc.Id;
            newCase.Description = description;
            newCase.Reason = reason;
            newCase.ProductId = productId;
            newCase.Subject = subject;
            insert newCase;
            return 'SUCCESS';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}