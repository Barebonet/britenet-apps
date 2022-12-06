/**
 * Created by bartosz.rozpara on 15.11.2022.
 */

public with sharing class HA_BatchFailedRecordsController {
    public HttpResponse response;
    public HttpRequest request;

    public List<HospitalLog__c> recreateHospitals(List<HospitalLog__c> logs) {
        for(HospitalLog__c hospLog : logs) {
            List<HospitalDTO> hospitalDtoList = new List<HospitalDTO>();
            List<Hospital__c> hospitals = [SELECT Id, Name, TelephoneNumber__c, Country__c, City__c, Street_Address__c, Post_Code__c, ExternalId__c
                                            FROM Hospital__c WHERE Id = :hospLog.HospitalId__c];
            for(Hospital__c hospital : hospitals) {
                HospitalDTO hospitalDto = new HospitalDTO(hospital);
                hospitalDtoList.add(hospitalDto);
            }

            WrapperForHospital hospWrap = new WrapperForHospital(hospitalDtoList);

            hospLog.IsSuccess__c = 'true';
            Http myHttp = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint('callout:RestIntegration/services/apexrest/hospitals/');
            request.setMethod(hospLog.MethodType__c);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(JSON.serialize(hospWrap));

            HttpResponse response = myHttp.send(request);
            String responseBody = response.getBody();
            List<Hospital__c> resBody = (List<Hospital__c>) JSON.deserialize(responseBody, List<Hospital__c>.class);
            if(hospLog.Counter__c == null) {
                hospLog.Counter__c = 1;
            }
            if (resBody.size() == 0 || response.getStatusCode() != 200) {
                hospLog.IsSuccess__c = 'false';
            } else if (hospLog.Counter__c >= 2) {
                hospLog.IsSuccess__c = 'true';
            }
            hospLog.Counter__c = hospLog.Counter__c + 1;
        }
        return logs;
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

        public HospitalDTO(Hospital__c hospital) {
            this.hospId = hospital.Id;
            this.hospName = hospital.Name;
            this.phoneNum = hospital.TelephoneNumber__c;
            this.country = hospital.Country__c;
            this.city = hospital.City__c;
            this.streetAddress = hospital.Street_Address__c;
            this.postalCode = hospital.Post_Code__c;
            this.externalId = hospital.ExternalId__c;
        }
    }

    public class WrapperForHospital {
        public List<HospitalDTO> hospitalDtoList { get; set; }

        public WrapperForHospital(List<HospitalDTO> hospitalDtoList)  {
            this.hospitalDtoList = hospitalDtoList;
        }
    }
}