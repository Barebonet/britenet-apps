/**
 * Created by bartosz.rozpara on 17.10.2022.
 */

public with sharing class HA_ContractTriggerHandler extends HA_TriggerHandler {
    public List<Contract__c> newContracts;
    public List<Contract__c> oldContracts;

    public HA_ContractTriggerHandler() {
        this.newContracts = (List<Contract__c>) Trigger.New;
        this.oldContracts = (List<Contract__c>) Trigger.Old;
    }

    public override void beforeInsert() {
        HA_ContractController.searchEverything(newContracts);
    }

    public override void beforeUpdate() {
        HA_ContractController.searchEverything(newContracts);
    }
}