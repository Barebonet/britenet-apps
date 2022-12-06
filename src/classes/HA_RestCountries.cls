/**
 * Created by bartosz.rozpara on 07.11.2022.
 */

@RestResource(UrlMapping='/countries/*')
global with sharing class HA_RestCountries {
    @HttpGet
    global static List<String> getPickListValuesIntoList() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Hospital__c.Country__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
}