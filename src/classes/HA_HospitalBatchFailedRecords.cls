/**
 * Created by bartosz.rozpara on 14.11.2022.
 */

public with sharing class HA_HospitalBatchFailedRecords implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    public List<Doctor__c> doctors = new List<Doctor__c>();
    public HA_BatchFailedRecordsController service;

    public HA_HospitalBatchFailedRecords() {
        service = new HA_BatchFailedRecordsController();
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT MethodType__c, RequestBody__c, ResponseBody__c, IsSuccess__c,
            StatusCode__c, Name, Counter__c, HospitalId__c FROM HospitalLog__c WHERE IsSuccess__c = 'false']);
    }

    public void execute(Database.BatchableContext bc, List<HospitalLog__c> logs) {
        List<HospitalLog__c> hospitals = service.recreateHospitals(logs);
        update hospitals;
    }

    public void finish(Database.BatchableContext BC) {}
}