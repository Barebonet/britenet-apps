/**
 * Created by bartosz.rozpara on 01.11.2022.
 */

trigger HA_DoctorTrigger on Doctor__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new HA_DoctorTriggerController().run();
}