/**
 * Created by bartosz.rozpara on 12.10.2022.
 */

trigger HA_ContractTrigger on Contract__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new HA_ContractTriggerHandler().run();
}