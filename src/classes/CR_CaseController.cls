public with sharing class CR_CaseController {
    @AuraEnabled
    public static String submitNewCase(String productId, String orderId, String subject, String reason, String description) {
        try {
            String strToRet = '';
            List<Case> checkCases = [SELECT Id FROM Case WHERE Order__c = :orderId];
            if(checkCases.isEmpty()) {
                Account acc = [SELECT Id FROM Account WHERE Name = 'Customers' LIMIT 1];
                Case newCase = new Case();
                newCase.AccountId = acc.Id;
                newCase.Description = description;
                newCase.Reason = reason;
                newCase.ProductId = productId;
                newCase.Subject = subject;
                newCase.Order__c = orderId;
                insert newCase;
                strToRet = 'SUCCESS';
            } else {
                strToRet = 'Issue already created, please wait for it to get resolved.';
            }
            return strToRet;
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}