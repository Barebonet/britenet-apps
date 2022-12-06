/**
 * Created by bartosz.rozpara on 25.10.2022.
 */

public with sharing class HA_LoginSoap {
    public static soapSforceComSchemasClassSoapwebser.SoapWebService soapWebService { get; set; }

    public static soapSforceComSchemasClassSoapwebser.SoapWebService login(String username) {
        partnerSoapSforceCom.Soap partnerSoap = new partnerSoapSforceCom.Soap();

        Credentials__c credential = [SELECT Username__c, Password__c FROM Credentials__c WHERE Username__c = :username];
        partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login(credential.Username__c, credential.Password__c);
        soapSforceComSchemasClassSoapwebser.SessionHeader_element sessionHeaderElement = new soapSforceComSchemasClassSoapwebser.SessionHeader_element();
        sessionHeaderElement.sessionId = loginResult.sessionId;

        soapWebService = new soapSforceComSchemasClassSoapwebser.SoapWebService();
        soapWebService.SessionHeader = sessionHeaderElement;
        return soapWebService;
    }
}