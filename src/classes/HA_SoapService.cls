/**
 * Created by bartosz.rozpara on 20.10.2022.
 */

global with sharing class HA_SoapService {
    webService static DoctorDTO getDoctors(DoctorDTO docWrap) {
        try {
            Doctor__c doctor = [
                    SELECT Id, FirstName__c, LastName__c, Email__c, Birth_Date__c,
                            Country__c, City__c, Street_Address__c, Post_Code__c, PhoneNumber__c
                    FROM Doctor__c
                    WHERE Id = :docWrap.doctorId
            ];
            docWrap = mapToWrapper(doctor);
        } catch (Exception e) {
            throw e;
        }
        return docWrap;
    }

    webService static DoctorDTO insertDoctor(DoctorDTO docWrap) {
        try {
            Doctor__c doctor = mapToSObject(docWrap);
            insert doctor;
            docWrap = mapToWrapper(doctor);
        } catch (Exception e) {
            throw e;
        }
        return docWrap;
    }

    webService static DoctorDTO updateDoctor(DoctorDTO docWrap) {
        Doctor__c doctorToCheck = mapToSObject(docWrap);
        Map<String, Object> doctorMap = new Map<String, Object>(doctorToCheck.getPopulatedFieldsAsMap());
        try {
            for (String keyJsonMap : doctorMap.keySet()) {
                if (doctorMap.get(keyJsonMap) == null) {
                    doctorMap.remove(keyJsonMap);
                }
            }
            Doctor__c doctorToUpdate = (Doctor__c) JSON.deserialize(JSON.serialize(doctorMap), Doctor__c.class);
            update doctorToUpdate;
        } catch (Exception e) {
            throw e;
        }
        return docWrap;
    }

    webService static DoctorDTO deleteDoctor(DoctorDTO doctorDTO) {
        try {
            Database.delete(doctorDTO.doctorId);
        } catch (Exception e) {
            throw e;
        }
        return doctorDTO;
    }

    webService static DoctorDTO mapToWrapper(Doctor__c doctor) {
        DoctorDTO docWrap = new DoctorDTO();
        docWrap.doctorId = doctor.Id;
        docWrap.firstName = doctor.FirstName__c;
        docWrap.lastName = doctor.LastName__c;
        docWrap.email = doctor.Email__c;
        docWrap.birthDate = doctor.Birth_Date__c;
        docWrap.country = doctor.Country__c;
        docWrap.phoneNum = doctor.PhoneNumber__c;
        docWrap.city = doctor.City__c;
        docWrap.streetAddress = doctor.Street_Address__c;
        docWrap.postCode = doctor.Post_Code__c;
        return docWrap;
    }

    webService static Doctor__c mapToSObject(DoctorDTO docWrap) {
        Doctor__c doc = new Doctor__c();
        doc.Id = docWrap.doctorId;
        doc.FirstName__c = docWrap.firstName;
        doc.LastName__c = docWrap.lastName;
        doc.Email__c = docWrap.email;
        doc.Birth_Date__c = docWrap.birthDate;
        doc.Country__c = docWrap.country;
        doc.PhoneNumber__c = docWrap.phoneNum;
        doc.City__c = docWrap.city;
        doc.Street_Address__c = docWrap.streetAddress;
        doc.Post_Code__c = docWrap.postCode;
        return doc;
    }

    global with sharing class DoctorDTO {
        webService String doctorId { get; set; }
        webService String firstName { get; set; }
        webService String lastName { get; set; }
        webService String email { get; set; }
        webService String country { get; set; }
        webService Date birthDate { get; set; }
        webService String phoneNum { get; set; }
        webService String city { get; set; }
        webService String streetAddress { get; set; }
        webService String postCode { get; set; }
    }
}