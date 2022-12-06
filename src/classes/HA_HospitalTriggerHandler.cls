/**
 * Created by bartosz.rozpara on 11.11.2022.
 */

global with sharing class HA_HospitalTriggerHandler extends HA_TriggerHandler {
    global List<Hospital__c> newHospitals = Trigger.new;
    global List<Hospital__c> oldHospitals = Trigger.old;
    Set<Id> hospIds = new Set<Id>();

    public override void afterInsert() {
        if(HospitalTrigger__c.getInstance().IsActive__c) {
            hospIds = Trigger.newMap.keySet();
            Database.executeBatch(new HA_HospitalBatch('POST', hospIds));
        }
    }

    public override void afterUpdate() {
        if(HA_StaticValues.IsExecuting) {
            if(HospitalTrigger__c.getInstance().IsActive__c) {
                hospIds = Trigger.newMap.keySet();
                Database.executeBatch(new HA_HospitalBatch('PUT', hospIds));
            }
        }
    }

    public override void beforeDelete() {
        if(HospitalTrigger__c.getInstance().IsActive__c) {
            hospIds = Trigger.oldMap.keySet();
            Database.executeBatch(new HA_HospitalBatch('DELETE', hospIds));
        }
    }
}