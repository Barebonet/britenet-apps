global class HA_SoapServiceIntegration {
    global class DoctorDTO {
        webService String doctorId;
        webService String firstName;
        webService String lastName;
        webService String email;
        webService String country;
        webService Date birthDate;
        webService String phoneNum;
        webService String city;
        webService String streetAddress;
        webService String postCode;

        public DoctorDTO(Doctor__c doctor) {
            this.doctorId = doctor.Id;
            this.lastName = doctor.LastName__c;
            this.firstName = doctor.FirstName__c;
            this.birthDate = doctor.Birth_Date__c;
            this.email = doctor.Email__c;
            this.country = doctor.Country__c;
            this.city = doctor.City__c;
            this.streetAddress = doctor.Street_Address__c;
            this.postCode = doctor.Post_Code__c;
            this.phoneNum = doctor.PhoneNumber__c;
        }


        public Doctor__c mapToSObjectDoctor(DoctorDTO doctorDTO) {
            Doctor__c doc = new Doctor__c();
            doc.Id = doctorDTO.doctorId;
            doc.FirstName__c = doctorDTO.firstName;
            doc.LastName__c = doctorDTO.lastName;
            doc.Email__c = doctorDTO.email;
            doc.Birth_Date__c = doctorDTO.birthDate;
            doc.Country__c = doctorDTO.country;
            doc.PhoneNumber__c = doctorDTO.phoneNum;
            doc.City__c = doctorDTO.city;
            doc.Street_Address__c = doctorDTO.streetAddress;
            doc.Post_Code__c = doctorDTO.postCode;
            return doc;
        }


        public String getQuery(DoctorDTO doctorDTO) {
            String query = 'SELECT FirstName__c, LastName__c,  Email__c, Country__c, PhoneNumber__c, Birth_Date__c, City__c, Street_Address__c, Post_Code__c FROM Doctor__c WHERE Country__c = \''
                    + doctorDTO.country + '\'';
            if (String.isNotBlank(doctorDTO.firstName)) {
                query += ' AND FirstName__c LIKE \'%' + doctorDTO.firstName + '%\'';
            }
            if (String.isNotBlank(doctorDTO.lastName)) {
                query += ' AND LastName__c = \'%' + doctorDTO.lastName + '%\'';
            }
            return query;
        }
    }

    global class MessageSearchDTO {
        webService List<DoctorDTO> doctorsList;
        webService String message;

        public MessageSearchDTO(List<DoctorDTO> doctors, String errMess) {
            if(doctors.size() > 0) {
                doctorsList = doctors;
                message = errMess;
            } else {
                message = errMess;
            }
        }
    }

    global class MessageInsertDTO {
        webService DoctorDTO doctorDTO;
        webService String message;

        public MessageInsertDTO(Boolean isSuccess, DoctorDTO newDoctor, String errorMessage) {
            if(isSuccess) {
                doctorDTO = newDoctor;
            } else {
                message = 'Could not add that doctor: ' + errorMessage;
            }
        }
    }

    global class MessageUpdateDTO {
        webService DoctorDTO doctorDTO;
        webService String message;

        public MessageUpdateDTO(String editMessage, DoctorDTO docToEdit) {
            if(String.isBlank(editMessage)) {
                doctorDTO = docToEdit;
            } else {
                message = 'Cannot edit this doctor: ' + editMessage;
            }
        }
    }

    global class MessageDeleteDTO {
        webService DoctorDTO doctorDTO;
        webService String message;

        public MessageDeleteDTO(String deleteMessage, DoctorDTO docToDelete) {
            if (deleteMessage.length() > 0) {
                doctorDTO = docToDelete;
                message = 'You cannot delete doctor: ' + deleteMessage;
            } else {
                message = 'Deleted.';
            }
        }
    }


    webService static MessageSearchDTO searchDoctors(DoctorDTO docWrap) {
        String query = docWrap.getQuery(docWrap);
        String errorMessage = '';
        List<Doctor__c> docs = new List<Doctor__c>();
        List<DoctorDTO> doctors = new List<DoctorDTO>();
        try {
            if(String.isNotBlank(query)) {
                docs = Database.query(query);
            }
            for(Doctor__c doc : docs) {
                DoctorDTO doctorDTO = new DoctorDTO(doc);
                doctors.add(doctorDTO);
            }
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        return new MessageSearchDTO(doctors, errorMessage);
    }

    webService static MessageInsertDTO insertDoctor(DoctorDTO doctorDTO) {
        String errorMessage = '';
        Boolean isInsertSucceed = false;
        try {
            Doctor__c doctor = doctorDTO.mapToSObjectDoctor(doctorDTO);
            insert doctor;
            isInsertSucceed = true;
        } catch (Exception e) {
            isInsertSucceed = false;
            errorMessage += e.getMessage();
        }
        return new MessageInsertDTO(isInsertSucceed, doctorDTO, errorMessage);
    }



    webService static MessageUpdateDTO updateDoctor(DoctorDTO doctorDto) {
        Doctor__c doctorToCheck = new Doctor__c();

        Map<String, Object> doctorMap = new Map<String, Object>();

        String errMessage = '';
        try {
            doctorToCheck = doctorDTO.mapToSObjectDoctor(doctorDto);
            for (String key : doctorToCheck.getPopulatedFieldsAsMap().keySet()){
                doctorMap.put(key,doctorToCheck.getPopulatedFieldsAsMap().get(key));
            }
            for (String keyJsonMap : doctorMap.keySet()) {
                if (doctorMap.get(keyJsonMap) == null) {
                    doctorMap.remove(keyJsonMap);
                }
            }
        } catch (Exception e) {
            errMessage = e.getMessage();
        }

        Doctor__c doctorToUpdate = (Doctor__c) JSON.deserialize(JSON.serialize(doctorMap), Doctor__c.class);
        doctorToUpdate.Id = doctorDto.doctorId;

        try {
            update doctorToUpdate;
        } catch (Exception e) {
            errMessage += e.getMessage();
        }

        return new MessageUpdateDTO(errMessage, doctorDto);
    }

    webService static MessageDeleteDTO deleteDoctor(DoctorDTO doctorDTO) {
        String errMessage = '';
        try {
            Database.delete(doctorDTO.doctorId);
        } catch (Exception e) {
            errMessage = e.getMessage();
        }
        return new MessageDeleteDTO(errMessage, doctorDTO);
    }

    webService static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Doctor__c.Country__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
}