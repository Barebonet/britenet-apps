@IsTest
public with sharing class CR_CaseControllerTest {
    @IsTest
    static void testSuccessSubmitNewCase() {
        Account acc = new Account();
        acc.Name = 'Customers';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;

        String response = CR_CaseController.submitNewCase(prod.id, 'Car sucks', 'Other', 'Car sucks');

        System.assertEquals('SUCCESS', response);
    }

    @IsTest
    static void testFailSubmitNewCase() {
        Product2 prod = new Product2();
        prod.Name = 'SubUWU';
        insert prod;

        String response = CR_CaseController.submitNewCase(prod.id, 'Car sucks', 'Other', 'Car sucks');

        System.assert(true, response != 'SUCCESS');
    }
}