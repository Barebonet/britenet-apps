public with sharing class CR_CaseController {
    @AuraEnabled
    public static String submitNewCase(String productId, String orderId, String subject, String reason, String description) {
        try {
            String strToRet = 'SUCCESS';
            Account acc = [SELECT Id FROM Account WHERE Name = 'Customers' LIMIT 1];
            Case newCase = new Case();
            newCase.AccountId = acc.Id;
            newCase.Description = description;
            newCase.Reason = reason;
            newCase.ProductId = productId;
            newCase.Subject = subject;
            newCase.Order__c = orderId;
            insert newCase;
            return strToRet;
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static Boolean checkCaseForOrder(String orderId) {
        Boolean caseCreated = false;
        try {
            List<Case> cases = [SELECT Id FROM Case WHERE Order__c = :orderId];
            if(!cases.isEmpty()) {
                caseCreated = true;
            }
            return caseCreated;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}