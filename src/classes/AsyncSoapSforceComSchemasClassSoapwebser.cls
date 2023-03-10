//Generated by wsdl2apex

public class AsyncSoapSforceComSchemasClassSoapwebser {
    public class deleteDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.MessageDeleteDTO getValue() {
            soapSforceComSchemasClassSoapwebser.deleteDoctorResponse_element response = (soapSforceComSchemasClassSoapwebser.deleteDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class getPickListValuesIntoListResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String[] getValue() {
            soapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_element response = (soapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class searchDoctorsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.MessageSearchDTO getValue() {
            soapSforceComSchemasClassSoapwebser.searchDoctorsResponse_element response = (soapSforceComSchemasClassSoapwebser.searchDoctorsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class updateDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.MessageUpdateDTO getValue() {
            soapSforceComSchemasClassSoapwebser.updateDoctorResponse_element response = (soapSforceComSchemasClassSoapwebser.updateDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class insertDoctorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassSoapwebser.MessageInsertDTO getValue() {
            soapSforceComSchemasClassSoapwebser.insertDoctorResponse_element response = (soapSforceComSchemasClassSoapwebser.insertDoctorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncSoapWebService {
        public String endpoint_x = 'https://eu46.salesforce.com/services/Soap/class/SoapWebService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public soapSforceComSchemasClassSoapwebser.SessionHeader_element SessionHeader;
        public soapSforceComSchemasClassSoapwebser.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public soapSforceComSchemasClassSoapwebser.DebuggingInfo_element DebuggingInfo;
        public soapSforceComSchemasClassSoapwebser.CallOptions_element CallOptions;
        public soapSforceComSchemasClassSoapwebser.DebuggingHeader_element DebuggingHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/SoapWebService';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/SoapWebService';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/SoapWebService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/SoapWebService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/SoapWebService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/SoapWebService', 'soapSforceComSchemasClassSoapwebser'};
        public AsyncSoapSforceComSchemasClassSoapwebser.deleteDoctorResponse_elementFuture beginDeleteDoctor(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO) {
            soapSforceComSchemasClassSoapwebser.deleteDoctor_element request_x = new soapSforceComSchemasClassSoapwebser.deleteDoctor_element();
            request_x.doctorDTO = doctorDTO;
            return (AsyncSoapSforceComSchemasClassSoapwebser.deleteDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.deleteDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'deleteDoctor',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'deleteDoctorResponse',
              'soapSforceComSchemasClassSoapwebser.deleteDoctorResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_elementFuture beginGetPickListValuesIntoList(System.Continuation continuation) {
            soapSforceComSchemasClassSoapwebser.getPickListValuesIntoList_element request_x = new soapSforceComSchemasClassSoapwebser.getPickListValuesIntoList_element();
            return (AsyncSoapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'getPickListValuesIntoList',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'getPickListValuesIntoListResponse',
              'soapSforceComSchemasClassSoapwebser.getPickListValuesIntoListResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.searchDoctorsResponse_elementFuture beginSearchDoctors(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.DoctorDTO docWrap) {
            soapSforceComSchemasClassSoapwebser.searchDoctors_element request_x = new soapSforceComSchemasClassSoapwebser.searchDoctors_element();
            request_x.docWrap = docWrap;
            return (AsyncSoapSforceComSchemasClassSoapwebser.searchDoctorsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.searchDoctorsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'searchDoctors',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'searchDoctorsResponse',
              'soapSforceComSchemasClassSoapwebser.searchDoctorsResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.updateDoctorResponse_elementFuture beginUpdateDoctor(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDto) {
            soapSforceComSchemasClassSoapwebser.updateDoctor_element request_x = new soapSforceComSchemasClassSoapwebser.updateDoctor_element();
            request_x.doctorDto = doctorDto;
            return (AsyncSoapSforceComSchemasClassSoapwebser.updateDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.updateDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'updateDoctor',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'updateDoctorResponse',
              'soapSforceComSchemasClassSoapwebser.updateDoctorResponse_element'}
            );
        }
        public AsyncSoapSforceComSchemasClassSoapwebser.insertDoctorResponse_elementFuture beginInsertDoctor(System.Continuation continuation,soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO) {
            soapSforceComSchemasClassSoapwebser.insertDoctor_element request_x = new soapSforceComSchemasClassSoapwebser.insertDoctor_element();
            request_x.doctorDTO = doctorDTO;
            return (AsyncSoapSforceComSchemasClassSoapwebser.insertDoctorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceComSchemasClassSoapwebser.insertDoctorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'insertDoctor',
              'http://soap.sforce.com/schemas/class/SoapWebService',
              'insertDoctorResponse',
              'soapSforceComSchemasClassSoapwebser.insertDoctorResponse_element'}
            );
        }
    }
}