/**
 * Created by bartosz.rozpara on 07.11.2022.
 */

public with sharing class HA_RestSearchDoctorController {
    public String hospitalName { get; set; }
    public String hospitalCountry { get; set; }
    public HA_RestDoctorController.ResponseGet responseGet { get; set; }
    public List<HospitalDTO> hospitals { get; set; }
    public List<HA_RestDoctorController.HospitalDTO> hospitalsToInsert { get; set; }
    public HA_RestDoctorController insertService { get; set; }
    public String tempHospitalId { get; set; }
    public HA_RestDoctorController.HospitalDTO finalHospitalDTO { get; set; }
    public List<HA_RestDoctorController.HospitalDTO> hospitalDTOS { get; set; }
    public List<String> countries { get; set; }
    public List<SelectOption> selectOptions { get; set; }
    public HospitalPostPut hospitalToInsert { get; set; }
    public HospitalPostPut hospitalToUpdate { get; set; }

    public HA_RestSearchDoctorController() {
        insertService = new HA_RestDoctorController();
        countries = HA_RestDoctorController.getCountries();
        selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('None', 'None'));
        for(String country : countries) {
            selectOptions.add(new SelectOption(country, country));
        }
        hospitalsToInsert = new List<HA_RestDoctorController.HospitalDTO>();
        hospitalDTOS = new List<HA_RestDoctorController.HospitalDTO>();
        hospitals = new List<HospitalDTO>();
        finalHospitalDTO = new HA_RestDoctorController.HospitalDTO();
        hospitalToInsert = new HospitalPostPut();
        hospitalToUpdate = new HospitalPostPut();
    }

    public void getCurrentHospital() {
        hospitalToUpdate = new HospitalPostPut();
        for(HospitalDTO tempHospital : hospitals) {
            if(tempHospital.hospId == tempHospitalId) {
                hospitalToUpdate.hospId = tempHospital.hospId;
                hospitalToUpdate.hospName = tempHospital.hospName;
                hospitalToUpdate.phoneNum = tempHospital.phoneNum;
                hospitalToUpdate.country = tempHospital.country;
                hospitalToUpdate.city = tempHospital.city;
                hospitalToUpdate.streetAddress = tempHospital.streetAddress;
                hospitalToUpdate.postalCode = tempHospital.postalCode;
                hospitalToUpdate.externalId = tempHospital.externalId;
            }
        }
    }

    public void searchHospital() {
        hospitals = new List<HA_RestSearchDoctorController.HospitalDTO>();
        if(!hospitalName.equals('')) {
            if (hospitalCountry == 'None') {
                hospitalCountry = '';
                responseGet = HA_RestDoctorController.getHospital(hospitalName, hospitalCountry);
            } else {
                responseGet = HA_RestDoctorController.getHospital(hospitalName, hospitalCountry);
            }
            if (!responseGet.message.equals('0 records found - list is empty')) {
                for (HA_RestDoctorController.HospitalDTO hospital : responseGet.hospitals) {
                    HospitalDTO hospitalDTO = new HospitalDTO(hospital);
                    hospitals.add(hospitalDTO);
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.INFO, responseGet.message));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.INFO, 'Required field: Hospital Name is missing!'));
        }
    }

    public void deleteHospital() {
        List<Hospital__c> checkIfEmptyHospitals = [SELECT Id, Name FROM Hospital__c WHERE Id = :hospitalToUpdate.externalId];
        if(checkIfEmptyHospitals.isEmpty()) {
            HA_RestDoctorController.deleteHospital(hospitalToUpdate.hospId);
        } else {
            Hospital__c hospital = new Hospital__c();
            hospital.Id = hospitalToUpdate.externalId;
            delete hospital;
        }
    }

    public void clearSearch() {
        hospitalName = '';
        hospitalCountry = 'None';
        hospitals = new List<HA_RestSearchDoctorController.HospitalDTO>();
    }

    public void clearHospital() {
        hospitalToInsert = new HospitalPostPut();
    }

    public void insertHospital() {
        hospitalsToInsert = new List<HA_RestDoctorController.HospitalDTO>();
        if(hospitalToInsert.country.equals('None')) {
            hospitalToInsert.country = null;
        }
        Hospital__c hospital = new Hospital__c();
        hospital.Name = hospitalToInsert.hospName;
        hospital.TelephoneNumber__c = hospitalToInsert.phoneNum;
        hospital.Country__c = hospitalToInsert.country;
        hospital.City__c = hospitalToInsert.city;
        hospital.Street_Address__c = hospitalToInsert.streetAddress;
        hospital.Post_Code__c = hospitalToInsert.postalCode;
        insert hospital;
        hospitalToInsert = new HospitalPostPut();
        if(hospitals.size() > 0) {
            searchHospital();
        }
    }

    public void updateHospital() {
        hospitalsToInsert = new List<HA_RestDoctorController.HospitalDTO>();
        List<Hospital__c> checkIfEmptyHospitals = [SELECT Id, Name FROM Hospital__c WHERE Id = :hospitalToUpdate.externalId];
        if(hospitalToUpdate.country.equals('None')) {
            hospitalToUpdate.country = null;
        }
        if(checkIfEmptyHospitals.isEmpty()) {
            finalHospitalDTO.hospId = hospitalToUpdate.hospId;
            finalHospitalDTO.hospName = hospitalToUpdate.hospName;
            finalHospitalDTO.phoneNum = hospitalToUpdate.phoneNum;
            finalHospitalDTO.country = hospitalToUpdate.country;
            finalHospitalDTO.city = hospitalToUpdate.city;
            finalHospitalDTO.streetAddress = hospitalToUpdate.streetAddress;
            finalHospitalDTO.postalCode = hospitalToUpdate.postalCode;
            finalHospitalDTO.externalId = hospitalToUpdate.externalId;
            hospitalsToInsert.add(finalHospitalDTO);
            HA_RestDoctorController.updateHospital(hospitalsToInsert);
            finalHospitalDTO = new HA_RestDoctorController.HospitalDTO();
            hospitalToUpdate = new HospitalPostPut();
            hospitals = new List<HA_RestSearchDoctorController.HospitalDTO>();
        } else {
            Hospital__c hospital = new Hospital__c();
            hospital.Id = hospitalToUpdate.externalId;
            hospital.Name = hospitalToUpdate.hospName;
            hospital.TelephoneNumber__c = hospitalToUpdate.phoneNum;
            hospital.Country__c = hospitalToUpdate.country;
            hospital.City__c = hospitalToUpdate.city;
            hospital.Street_Address__c = hospitalToUpdate.streetAddress;
            hospital.Post_Code__c = hospitalToUpdate.postalCode;
            hospital.ExternalId__c = hospitalToUpdate.hospId;
            update hospital;
        }
    }

    public class HospitalDTO {
        public String hospId { get; set; }
        public String hospName { get; set; }
        public String phoneNum { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String streetAddress { get; set; }
        public String postalCode { get; set; }
        public String externalId { get; set; }

        public HospitalDTO(HA_RestDoctorController.HospitalDTO hospital) {
            this.hospId = hospital.hospId;
            this.hospName = hospital.hospName;
            this.phoneNum = hospital.phoneNum;
            this.country = hospital.country;
            this.city = hospital.city;
            this.streetAddress = hospital.streetAddress;
            this.postalCode = hospital.postalCode;
            this.externalId = hospital.externalId;
        }
    }

    public class HospitalPostPut {
        public String hospId { get; set; }
        public String hospName { get; set; }
        public String phoneNum { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String streetAddress { get; set; }
        public String postalCode { get; set; }
        public String externalId { get; set; }
    }

    public class ResponseGet {
        public String message { get; set; }
        public List<HospitalDTO> hospitals { get; set; }
    }
}