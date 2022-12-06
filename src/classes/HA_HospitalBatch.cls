/**
 * Created by bartosz.rozpara on 14.11.2022.
 */

public with sharing class HA_HospitalBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private final String action;
    private final HA_RestDoctorController service;
    private final Set<Id> hospitalIds;

    public HA_HospitalBatch(String action) {
        this.action = action;
        service = new HA_RestDoctorController();
    }

    public HA_HospitalBatch(String action, Set<Id> ids) {
        this.action = action;
        service = new HA_RestDoctorController();
        hospitalIds = ids;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(action.equals('DELETE')) {
            return Database.getQueryLocator([SELECT Id, Name, TelephoneNumber__c, Country__c, City__c,
                    Street_Address__c, Post_Code__c, ExternalId__c FROM Hospital__c WHERE Id IN :hospitalIds ALL ROWS]);
        }
        return Database.getQueryLocator([SELECT Id, Name, TelephoneNumber__c, Country__c, City__c,
                Street_Address__c, Post_Code__c, ExternalId__c FROM Hospital__c WHERE Id IN :hospitalIds]);
    }

    public void execute(Database.BatchableContext bc, List<Hospital__c> scope) {
        List<HA_RestDoctorController.HospitalDTO> hospitalDtoList = new List<HA_RestDoctorController.HospitalDTO>();
        if(action.equals('POST')) {
            List<HospitalLog__c> logs = new List<HospitalLog__c>();
            try {
                for(Hospital__c hospital : scope) {
                    if(hospital.ExternalId__c == null) {
                        HA_RestDoctorController.HospitalDTO hospitalDTO = mapToSobject(hospital);
                        hospitalDtoList.add(hospitalDTO);

                        HospitalLog__c log = new HospitalLog__c();
                        log = service.addHospital(hospitalDtoList);
                        log.HospitalId__c = hospital.Id;
                        logs.add(log);
                    }
                }
            } catch (Exception e) {
                throw e;
            }
            insert logs;
        } else if(action.equals('DELETE')) {
            for(Integer i=0; i<scope.size(); i++) {
                if(scope.get(i).ExternalId__c != null) {
                    HospitalLog__c hospLog = HA_RestDoctorController.deleteHospital(scope.get(i).ExternalId__c);
                    hospLog.HospitalId__c = scope[0].Id;
                    insert hospLog;
                }
            }
        } else if(action.equals('PUT')) {
            for(Hospital__c hospital : scope) {
                if(hospital.ExternalId__c != null) {
                    HA_RestDoctorController.HospitalDTO hospitalDTO = mapToSobject(hospital);
                    String tempId = hospitalDTO.externalId;
                    hospitalDTO.externalId = hospitalDTO.hospId;
                    hospitalDTO.hospId = tempId;
                    hospitalDtoList.add(hospitalDTO);
                }
            }
            if(hospitalDtoList.size() > 0) {
                HospitalLog__c hospLog = HA_RestDoctorController.updateHospital(hospitalDtoList);
                for(Integer i=0; i<scope.size(); i++) {
                    hospLog.HospitalId__c = scope.get(i).Id;
                }
                insert hospLog;
            }
        }
    }

    public void finish(Database.BatchableContext bc) {}

    public HA_RestDoctorController.HospitalDTO mapToSobject(Hospital__c hospital) {
        HA_RestDoctorController.HospitalDTO hospitalDTO = new HA_RestDoctorController.HospitalDTO();
        hospitalDTO.hospId = hospital.Id;
        hospitalDTO.hospName = hospital.Name;
        hospitalDTO.phoneNum = hospital.TelephoneNumber__c;
        hospitalDTO.country = hospital.Country__c;
        hospitalDTO.city = hospital.City__c;
        hospitalDTO.streetAddress = hospital.Street_Address__c;
        hospitalDTO.postalCode = hospital.Post_Code__c;
        hospitalDTO.externalId = hospital.ExternalId__c;
        return hospitalDTO;
    }
}