/**
 * Created by bartosz.rozpara on 02.11.2022.
 */

@RestResource(UrlMapping='/Hospitals/*')
global with sharing class HA_RestService {
    @HttpGet
    global static void searchHospital() {
        String hospitalName = RestContext.request.params.get('hospName');
        String hospitalCountry = RestContext.request.params.get('country');
        Response response;

        if(String.isBlank(hospitalName)) {
            ResponseError responseError = new ResponseError();

            response = responseError;
        } else {
            ResponseGet responseGet = new ResponseGet();
            String query = getQuery(hospitalName, hospitalCountry);
            List<Hospital__c> hospitals = Database.query(query);
            for(Hospital__c hospital : hospitals) {
                HospitalDTO hospitalDTO = mapToWrapper(hospital);
                responseGet.hospitals.add(hospitalDTO);
            }
            if(responseGet.hospitals.isEmpty()) {
                responseGet.message = '0 records found.';
            }
            response = responseGet;
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
    }

    @HttpPost
    global static void insertHospital(List<HospitalDTO> hospitalDtoList) {
        Response response;
        List<Hospital__c> hospitalsToInsert = new List<Hospital__c>();
        for (HospitalDto hosp : hospitalDtoList) {
            hosp.externalId = hosp.hospId;
            hosp.hospId = null;
            Hospital__c hospital = mapToObject(hosp);
            hospitalsToInsert.add(hospital);
        }

        if(hospitalsToInsert.size() == 0) {
            ResponseError responseError = new ResponseError();

            response = responseError;
        } else {
            try {
                insert hospitalsToInsert;
                hospitalDtoList = new List<HospitalDto>();
                for(Hospital__c hospital : hospitalsToInsert) {
                    HospitalDTO hospitalDto = mapToWrapper(hospital);
                    hospitalDtoList.add(hospitalDto);
                }
            } catch (Exception e) {
                throw e;
            }
            ResponseInsert responseInsert = new ResponseInsert(hospitalDtoList);
            response = responseInsert;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
        }
    }

    @HttpDelete
    global static void deleteHospital() {
        RestRequest request = RestContext.request;
        String hospitalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Response response;

        if(String.isBlank(hospitalId)) {
            ResponseError responseError = new ResponseError();
            responseError.errorMessage += ' No such ID.';

            response = responseError;
        } else {
            try {
                Database.delete(hospitalId);
            } catch (Exception e) {
                throw e;
            }
            ResponseDelete responseDelete = new ResponseDelete();
            response = responseDelete;
        }
    }

    @HttpPut
    global static void updateHospital(List<HospitalDTO> hospitalDtoList) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        for(HospitalDTO hospitalDTO : hospitalDtoList) {
            Hospital__c hospital = mapToObject(hospitalDTO);
            hospitals.add(hospital);
        }
        String errMessage = '';
        Response response;

        if(hospitals.size() == 0) {
            ResponseError responseError = new ResponseError();
            responseError.errorMessage += ' Some fields are missing.';
            response = responseError;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
        } else {
            try {
                update hospitals;
                ResponseUpdate responseUpdate = new ResponseUpdate();
                response = responseUpdate;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            } catch (Exception e) {
                ResponseError responseError = new ResponseError();
                responseError.errorMessage += e.getMessage();
                response = responseError;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(response));
            }
        }
    }

    global static HospitalDTO mapToWrapper(Hospital__c hospital) {
        HospitalDTO hospitalDTO = new HospitalDTO();
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

    global static Hospital__c mapToObject(HospitalDTO hospitalDTO) {
        Hospital__c hospital = new Hospital__c();
        hospital.Id = hospitalDTO.hospId;
        hospital.Name = hospitalDTO.hospName;
        hospital.TelephoneNumber__c = hospitalDTO.phoneNum;
        hospital.Country__c = hospitalDTO.country;
        hospital.City__c = hospitalDTO.city;
        hospital.Street_Address__c = hospitalDTO.streetAddress;
        hospital.Post_Code__c = hospitalDTO.postalCode;
        hospital.ExternalId__c = hospitalDTO.externalId;
        return hospital;
    }

    global static String getQuery(String hospitalName, String hospitalCountry) {
        String query = 'SELECT Id, Name, Street_Address__c, Post_Code__c, Country__c, City__c, TelephoneNumber__c, ExternalId__c FROM Hospital__c WHERE Name LIKE \'%'+ hospitalName + '%\'';
        if(String.isNotBlank(hospitalCountry)) {
            query += ' AND Country__c = \'' + hospitalCountry + '\'';
        }
        return query;
    }

    global class HospitalDTO {
        global String hospId;
        global String hospName;
        global String phoneNum;
        global String country;
        global String city;
        global String streetAddress;
        global String postalCode;
        global String externalId;
    }

    global abstract class Response {
    }

    global class ResponseError extends Response {
        private String errorMessage { get; set; }

        global ResponseError() {
            RestContext.response.statusCode = 404;
            this.errorMessage = 'Bad request.';
        }
    }

    global class ResponseGet extends Response {
        global List<HospitalDTO> hospitals = new List<HospitalDTO>();
        global String message { get; set; }

        global ResponseGet() {
            RestContext.response.statusCode = 200;
        }
    }

    global class ResponseInsert extends Response {
        global String message { get; set; }
        global List<HospitalDTO> hospitalDtoList = new List<HospitalDTO>();

        global ResponseInsert(List<HospitalDTO> hospitalDtoList) {
            RestContext.response.statusCode = 200;
            this.message = 'Inserted.';
            this.hospitalDtoList = hospitalDtoList;
        }
    }

    global class ResponseUpdate extends Response {
        global String message { get; set; }

        global ResponseUpdate() {
            RestContext.response.statusCode = 200;
            this.message = 'Updated.';
        }
    }

    global class ResponseDelete extends Response {
        global String message { get; set; }

        global ResponseDelete() {
            RestContext.response.statusCode = 200;
            this.message = 'Deleted.';
        }
    }
}