/**
 * Created by bartosz.rozpara on 11.11.2022.
 */

trigger HA_HospitalTrigger on Hospital__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new HA_HospitalTriggerHandler().run();
}