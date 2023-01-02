/**
 * Created by bartosz.rozpara on 06.11.2022.
 */

public with sharing class HA_RestDoctorController {
    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;
    public List<Hospital__c> hospitals;

    public HospitalLog__c addHospital(List<HospitalDTO> hospitalDtoList) {
        hospitals = new List<Hospital__c>();
        String success = 'false';
        String responseBody = '';
        request = new HttpRequest();
        http = new Http();
        request.setMethod('POST');
        WrapperForHospital wrapperForHospital = new WrapperForHospital(hospitalDtoList);
        HospitalLog__c newLog = new HospitalLog__c();
        WrapperForInsert wrapperForInsert = new WrapperForInsert();

        request.setEndpoint('callout:RestIntegration/services/apexrest/hospitals/');
        request.setHeader('Content-Type','application/json;charset=UTF-8');

        request.setBody(JSON.serialize(wrapperForHospital));
        try {
            response = http.send(request);
            responseBody = response.getBody();
            if(response.getStatusCode() == 200) {
                success = 'true';
                wrapperForInsert = (WrapperForInsert) JSON.deserialize(response.getBody(), WrapperForInsert.class);
                for(HospitalDTO hospitalDTO : wrapperForInsert.hospitalDtoList) {
                    String tempId = hospitalDTO.hospId;
                    hospitalDTO.hospId = hospitalDTO.externalId;
                    hospitalDTO.externalId = tempId;
                }
                for(HospitalDTO hospitalDTO : wrapperForInsert.hospitalDtoList) {
                    Hospital__c hospital = mapDTOToObject(hospitalDTO);
                    hospitals.add(hospital);
                }
                HA_StaticValues.IsExecuting = false;
                for(Hospital__c hospital : hospitals) {
                    if(hospital.Id != null) {
                        update hospital;
                    }
                }
            } else {
                HA_ScheduleFailedCallouts.scheduleBatch();
            }
        } catch (CalloutException e) {
            throw e;
        } finally {
            newLog.MethodType__c = request.getMethod();
            newLog.RequestBody__c = request.getBody();
            newLog.ResponseBody__c = responseBody;
            newLog.IsSuccess__c = success;
            newLog.Name = 'Michał';
        }
        return newLog;
    }

    public static ResponseGet getHospital(String hospitalName, String hospitalCountry) {
        response = new HttpResponse();
        request = new HttpRequest();
        String responseBody = '';
        String success = 'false';
        request.setEndpoint('callout:RestIntegration/services/apexrest/hospitals/?HospitalName=' + hospitalName + '&Country=' + hospitalCountry);
        request.setMethod('GET');
        http = new Http();
        try {
            response = http.send(request);
            responseBody = response.getBody();
            if(response.getStatusCode() == 200) {
                success = 'true';
            }
        } catch (CalloutException e) {
            throw e;
        }

        ResponseGet responseGet = (ResponseGet) JSON.deserialize(response.getBody(), ResponseGet.class);
        return responseGet;
    }

    public static HospitalLog__c updateHospital(List<HospitalDTO> hospitalDtoList) {
        response = new HttpResponse();
        request = new HttpRequest();
        http = new Http();
        String responseBody = '';
        String success = 'false';
        HospitalLog__c newLog = new HospitalLog__c();
        WrapperForHospital wrapperForHospital = new WrapperForHospital(hospitalDtoList);
        request.setEndpoint('callout:RestIntegration/services/apexrest/hospitals/');
        request.setMethod('PUT');
        request.setHeader('Content-Type','application/json;charset=UTF-8');

        request.setBody(JSON.serialize(wrapperForHospital));
        try {
            response = http.send(request);
            responseBody = response.getBody();
            if(response.getStatusCode() == 200) {
                success = 'true';
            } else {
                HA_ScheduleFailedCallouts.scheduleBatch();
            }
        } catch (CalloutException e) {
            throw e;
        } finally {
            newLog.MethodType__c = request.getMethod();
            newLog.RequestBody__c = request.getBody();
            newLog.ResponseBody__c = responseBody;
            newLog.IsSuccess__c = success;
            newLog.Name = 'Michał';
        }
        return newLog;
    }

    public static HospitalLog__c deleteHospital(String hospId) {
        request = new HttpRequest();
        HospitalLog__c newLog = new HospitalLog__c();
        http = new Http();
        String responseBody = '';
        String success = 'false';
        request.setMethod('DELETE');
        request.setEndpoint('callout:RestIntegration/services/apexrest/hospitals/' + hospId);

        try {
            response = http.send(request);
            responseBody = response.getBody();
            if(response.getStatusCode() == 200) {
                success = 'true';
            } else {
                HA_ScheduleFailedCallouts.scheduleBatch();
            }
        } catch (CalloutException e) {
            throw e;
        } finally {
            newLog.MethodType__c = request.getMethod();
            newLog.RequestBody__c = request.getBody();
            newLog.ResponseBody__c = responseBody;
            newLog.IsSuccess__c = success;
            newLog.Name = 'Michał';
        }
        return newLog;
    }

    public static List<String> getCountries() {
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('callout:RestIntegration/services/apexrest/countries/');
        response = http.send(request);
        List<String> countries = (List<String>)JSON.deserialize(response.getBody(), List<String>.class);
        return countries;
    }

    public static Hospital__c mapDTOToObject(HospitalDTO hospitalDTO) {
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

    public class HospitalDTO {
        public String hospId { get; set; }
        public String hospName { get; set; }
        public String phoneNum { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String streetAddress { get; set; }
        public String postalCode { get; set; }
        public String externalId { get; set; }
    }

    public class WrapperForHospital {
        public List<HospitalDTO> hospitalDtoList { get; set; }

        public WrapperForHospital(List<HospitalDTO> hospitalDtoList)  {
            this.hospitalDtoList = hospitalDtoList;
        }
    }

    public class WrapperForInsert {
        public String message { get; set; }
        public List<HospitalDTO> hospitalDtoList { get; set; }
    }

    public class ResponseGet {
        public String message { get; set; }
        public List<HospitalDTO> hospitals { get; set; }
    }
}