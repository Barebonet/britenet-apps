/**
 * Created by bartosz.rozpara on 27.10.2022.
 */

@IsTest
global with sharing class SoapServiceMock implements WebServiceMock {
    private final Map<String, Type> optionsByType = new Map<String, Type>{
            'searchDoctors' => SearchDoctorsOptions.class,
            'insertDoctors' => InsertDoctorsOptions.class,
            'updateDoctors' => UpdateDoctorsOptions.class,
            'deleteDoctors' => DeleteDoctorsOptions.class
    };
    private Map<String, RequestOptions> optionsByRequestType;

    public SoapServiceMock () {
        optionsByRequestType = new Map<String, RequestOptions>();
    }

    public SoapServiceMock addOption(String requestType, RequestOptions requestOptions) {
        if (!optionsByType.containsKey(requestType)) {
            throw new MissingRequestTypeException(requestType + ' not implemented in optionsByType Map');
        }
        if (!optionsByType.get(requestType).equals(requestOptions.getType())) {
            throw new WrongTypeAssignedException();
        }
        optionsByRequestType.put(requestType, requestOptions);
        return this;
    }

    public abstract class RequestOptions {
        public abstract Type getType();
    }

    public class InsertDoctorsOptions extends RequestOptions {
        public Integer recordsToInsert { get; private set; }
        public InsertDoctorsOptions(Integer recordsToInsert) {
            this.recordsToInsert = recordsToInsert;
        }
        public override Type getType() {
            return InsertDoctorsOptions.class;
        }
    }


    public class SearchDoctorsOptions extends RequestOptions {
        public Integer recordsToFind { get; private set; }
        public SearchDoctorsOptions(Integer recordsToFind) {
            this.recordsToFind = recordsToFind;
        }

        public override Type getType() {
            return SearchDoctorsOptions.class;
        }
    }

    public class UpdateDoctorsOptions extends RequestOptions {
        public Integer recordsToUpdate { get; private set; }
        public UpdateDoctorsOptions(Integer recordsToUpdate) {
            this.recordsToUpdate = recordsToUpdate;
        }

        public override Type getType() {
            return UpdateDoctorsOptions.class;
        }
    }

    public class DeleteDoctorsOptions extends RequestOptions {
        public Integer recordsToDelete { get; private set; }
        public DeleteDoctorsOptions(Integer recordsToDelete) {
            this.recordsToDelete = recordsToDelete;
        }

        public override Type getType() {
            return DeleteDoctorsOptions.class;
        }
    }

    public class WrongTypeAssignedException extends Exception {
    }

    public class MissingRequestTypeException extends Exception {
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
    ) {
        switch on requestName {
            when 'searchDoctors' {
                soapSforceComSchemasClassSoapwebser.searchDoctorsResponse_element addResponse = new soapSforceComSchemasClassSoapwebser.searchDoctorsResponse_element();
                addResponse.result = new soapSforceComSchemasClassSoapwebser.MessageSearchDTO();
                soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
                addResponse.result.doctorsList = new List<soapSforceComSchemasClassSoapwebser.DoctorDTO>();
                if(optionsByRequestType.containsKey('searchDoctors')) {
                    SearchDoctorsOptions options = (SearchDoctorsOptions) optionsByRequestType.get('searchDoctors');
                    for (Integer i = 0; i < options.recordsToFind; i++){
                        doctorDTO.lastName = 'Siuuu';
                        doctorDTO.email = 'siuuu' + i + '@gmail.com';
                        doctorDTO.country = 'Poland';
                        addResponse.result.doctorsList.add(doctorDTO);
                    }
                    addResponse.result.message = options.recordsToFind + ' records found.';
                } else {
                    addResponse.result.message = '0 records found.';
                }
                response.put('response_x', addResponse);
            }
            when 'insertDoctor' {
                soapSforceComSchemasClassSoapwebser.insertDoctorResponse_element insertResponse = new soapSforceComSchemasClassSoapwebser.insertDoctorResponse_element();
                insertResponse.result = new soapSforceComSchemasClassSoapwebser.MessageInsertDTO();
                if(optionsByRequestType.containsKey('insertDoctors')) {
                    InsertDoctorsOptions options = (InsertDoctorsOptions) optionsByRequestType.get('insertDoctors');
                    insertResponse.result.message = 'Inserted.';
                } else {
                    insertResponse.result.message = 'Error while inserting.';
                }
                response.put('response_x', insertResponse);
            }
            when 'updateDoctor' {
                soapSforceComSchemasClassSoapwebser.updateDoctorResponse_element updateResponse = new soapSforceComSchemasClassSoapwebser.updateDoctorResponse_element();
                updateResponse.result = new soapSforceComSchemasClassSoapwebser.MessageUpdateDTO();
                if(optionsByRequestType.containsKey('updateDoctors')) {
                    UpdateDoctorsOptions options = (UpdateDoctorsOptions) optionsByRequestType.get('updateDoctors');
                    updateResponse.result.message = options.recordsToUpdate + ' records updated.';
                } else {
                    updateResponse.result.message = 'Error while updating.';
                }
                response.put('response_x', updateResponse);
            }
            when 'deleteDoctor' {
                soapSforceComSchemasClassSoapwebser.deleteDoctorResponse_element deleteResponse = new soapSforceComSchemasClassSoapwebser.deleteDoctorResponse_element();
                deleteResponse.result = new soapSforceComSchemasClassSoapwebser.MessageDeleteDTO();
                if(optionsByRequestType.containsKey('deleteDoctors')) {
                    DeleteDoctorsOptions options = (DeleteDoctorsOptions) optionsByRequestType.get('deleteDoctors');
                    deleteResponse.result.message = options.recordsToDelete + ' records deleted.';
                } else {
                    deleteResponse.result.message = 'Error while deleting.';
                }
                response.put('response_x', deleteResponse);
            }
            when 'login' {
                partnerSoapSforceCom.loginResponse_element loginResponse = new partnerSoapSforceCom.loginResponse_element();
                loginResponse.result = new partnerSoapSforceCom.LoginResult();
                loginResponse.result.sessionId = 'randomString';
                response.put('response_x', loginResponse);
            }
            when 'getPickListValuesIntoList' {
                soapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_element countryPicklist = new soapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_element();
                countryPicklist.result = new List<String>();
                countryPicklist.result.add('Poland');
                countryPicklist.result.add('Germany');
                response.put('response_x', countryPicklist);
            }
        }
    }
}