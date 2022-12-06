/**
 * Created by bartosz.rozpara on 01.11.2022.
 */

public with sharing class HA_DoctorTriggerController extends HA_TriggerHandler {
    public List<Doctor__c> newContracts;
    public List<Doctor__c> oldContracts;

    public HA_DoctorTriggerController() {
        this.newContracts = (List<Doctor__c>) Trigger.New;
        this.oldContracts = (List<Doctor__c>) Trigger.Old;
    }

    public override void beforeInsert() {
        for(Doctor__c doctor : newContracts) {
            doctor.Name = doctor.FirstName__c + ' ' + doctor.LastName__c;
        }
    }

    public override void beforeUpdate() {
        for(Doctor__c doctor : newContracts) {
            doctor.Name = doctor.FirstName__c + ' ' + doctor.LastName__c;
        }
    }
}