/**
 * Created by bartosz.rozpara on 12.10.2022.
 */

public with sharing class HA_ContractController {

    public static List<Id> doctorsIds(List<Contract__c> contracts) {
        List<Id> Ids = new List<Id>();
        for (Contract__c c : contracts) {
            Ids.add(c.Doc__c);
        }
        return Ids;
    }

    public static List<Id> hospitalsIds(List<Contract__c> contracts) {
        List<Id> Ids = new List<Id>();
        for (Contract__c c : contracts) {
            Ids.add(c.Hosp__c);
        }
        return Ids;
    }

    public static Contract__c checkDates(Contract__c newContract, List<Contract__c> oldContracts, String errors) {
        for (Contract__c oldContract : oldContracts) {
            if ((newContract.Start_Date__c >= oldContract.Start_Date__c && newContract.Start_Date__c <= oldContract.End_Date__c) ||
                    (newContract.Start_Date__c <= oldContract.Start_Date__c && newContract.End_Date__c <= oldContract.End_Date__c) ||
                    (newContract.Start_Date__c <= oldContract.Start_Date__c && newContract.End_Date__c >= oldContract.End_Date__c)) {
                errors += 'This doctor cannot have another ' + oldContract.Name + ' contract within ' + oldContract.Start_Date__c + ' and ' + oldContract.End_Date__c + '. ';
            } else if ((newContract.Start_Date__c >= oldContract.Start_Date__c && oldContract.End_Date__c == null) ||
                    (newContract.End_Date__c >= oldContract.Start_Date__c && oldContract.End_Date__c == null) ||
                    (oldContract.End_Date__c == null && newContract.End_Date__c == null)) {
                errors += 'This doctor cannot have another ' + oldContract.Name + ' contract with this hospital, because they have a permanent contract since ' + oldContract.Start_Date__c + '. ';
            }
        }
        if(String.isNotBlank(errors)) {
            newContract.addError(errors);
        }
        return newContract;
    }

    public static void searchEverything(List<Contract__c> newContracts) {
        List<Id> doctorsIds = doctorsIds(newContracts);
        List<Id> hospitalIds = hospitalsIds(newContracts);
        String errors = '';
        Map<String, List<Contract__c>> correctContracts = new Map<String, List<Contract__c>>();
        List<Contract__c> existingContracts = [
                SELECT Name, Start_Date__c, End_Date__c, Hosp__c, Doc__c
                FROM Contract__c
                WHERE Doc__c = :doctorsIds AND Hosp__c = :hospitalIds
        ];
        Contract__c contractToAdd = new Contract__c();

        if(!existingContracts.isEmpty()) {
            for (Contract__c item : existingContracts) {
                if (correctContracts.containsKey((String) item.Doc__c + (String) item.Hosp__c)) {
                    correctContracts.get((String) item.Doc__c + (String) item.Hosp__c).add(item);
                } else {
                    correctContracts.put((String) item.Doc__c + (String) item.Hosp__c, new List<Contract__c>{
                            item
                    });
                }
            }
        }

        for (Contract__c newContract : newContracts) {
            if(correctContracts.containsKey((String) newContract.Doc__c + (String) newContract.Hosp__c)) {
                contractToAdd = checkDates(newContract, existingContracts, errors);
                if(contractToAdd != null) {
                    correctContracts.get((String) newContract.Doc__c + (String) newContract.Hosp__c).add(newContract);
                }
            } else {
                correctContracts.put((String) newContract.Doc__c + (String) newContract.Hosp__c, new List<Contract__c>{
                        newContract
                });
            }
        }
    }
}