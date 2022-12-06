/**
 * Created by bartosz.rozpara on 25.10.2022.
 */

public with sharing class HA_SoapDoctorController {
    public static soapSforceComSchemasClassSoapwebser.SoapWebService soapWebService { get; set; }
    public DoctorNewDTO doctorNewDTO { get; set; }
    public soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO { get; set; }
    public DoctorToInsert doctorToInsert { get; set; }
    public HM_DoctorDTO selectedDoctor { get; set; }
    public List<HM_DoctorDTO> doctors { get; set; }
    public Boolean popupVisible { get; set; }
    public String[] countries { get; set; }
    public List<SelectOption> selectOptions { get; set; }
    public String tempDoctorId { get; set; }
    public soapSforceComSchemasClassSoapwebser.MessageSearchDTO messageSearchDTO { get; set; }
    public soapSforceComSchemasClassSoapwebser.MessageInsertDTO messageInsertDTO { get; set; }
    public soapSforceComSchemasClassSoapwebser.MessageUpdateDTO messageUpdateDTO { get; set; }
    public soapSforceComSchemasClassSoapwebser.MessageDeleteDTO messageDeleteDTO { get; set; }
    public String username = 'michal.drago@gmail.com';

    public HA_SoapDoctorController() {
        tempDoctorId = '';
        soapWebService = HA_LoginSoap.login(username);
        popupVisible = false;
        doctors = new List<HM_DoctorDTO>();
        doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorNewDTO = new DoctorNewDTO();
        doctorToInsert = new DoctorToInsert();
        selectOptions = new List<SelectOption>();
        countries = soapWebService.getPickListValuesIntoList();
        for(String country : countries) {
            selectOptions.add(new SelectOption(country, country));
        }
    }

    public void getSelectedDoctor() {
        for(HM_DoctorDTO tempDoctorDTO : doctors) {
            if(tempDoctorDTO.doctorId == tempDoctorId) {
                selectedDoctor = tempDoctorDTO;
            }
        }
    }

    public void showPopup() {
        popupVisible = true;
    }

    public void hidePopup() {
        popupVisible = false;
    }

    public void searchDoctor() {
        messageSearchDTO = new soapSforceComSchemasClassSoapwebser.MessageSearchDTO();
        soapWebService = HA_LoginSoap.login(username);
        doctorDTO.country = doctorNewDTO.country;
        doctorDTO.firstName = doctorNewDTO.firstName;
        doctorDTO.lastName = doctorNewDTO.lastName;
        messageSearchDTO = soapWebService.searchDoctors(doctorDTO);
        if(messageSearchDTO.message != null) {
            doctors = convertSoapResponseWrappers(messageSearchDTO);
        }
    }

    public void updateDoctor() {
        messageUpdateDTO = new soapSforceComSchemasClassSoapwebser.MessageUpdateDTO();
        soapWebService = HA_LoginSoap.login(username);
        doctorDTO.doctorId = selectedDoctor.doctorId;
        doctorDTO.firstName = selectedDoctor.firstName;
        doctorDTO.lastName = selectedDoctor.lastName;
        doctorDTO.email = selectedDoctor.email;
        doctorDTO.country = selectedDoctor.country;
        doctorDTO.city = selectedDoctor.city;
        doctorDTO.streetAddress = selectedDoctor.streetAddress;
        doctorDTO.postCode = selectedDoctor.postCode;
        doctorDTO.birthDate = selectedDoctor.birthDate;
        doctorDTO.phoneNum = selectedDoctor.phoneNum;

        messageUpdateDTO = soapWebService.updateDoctor(doctorDTO);

        if (messageUpdateDTO.message != null) {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.severity.INFO, messageUpdateDTO.message));
        }
        searchDoctor();
    }

    public void insertDoctor() {
        soapWebService = HA_LoginSoap.login(username);
        messageInsertDTO = new soapSforceComSchemasClassSoapwebser.MessageInsertDTO();
        doctorDTO.firstName = doctorToInsert.firstName;
        doctorDTO.lastName = doctorToInsert.lastName;
        doctorDTO.email = doctorToInsert.email;
        doctorDTO.country = doctorToInsert.country;
        doctorDTO.city = doctorToInsert.city;
        doctorDTO.streetAddress = doctorToInsert.streetAddress;
        doctorDTO.postCode = doctorToInsert.postCode;
        doctorDTO.birthDate = doctorToInsert.birthDate;
        doctorDTO.phoneNum = doctorToInsert.phoneNum;

        messageInsertDTO = soapWebService.insertDoctor(doctorDTO);
        if (messageInsertDTO.message != null) {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.severity.INFO, messageInsertDTO.message));
        }
        doctorToInsert = new DoctorToInsert();
        searchDoctor();
    }

    public void deleteDoctor() {
        soapWebService = HA_LoginSoap.login(username);
        messageDeleteDTO = new soapSforceComSchemasClassSoapwebser.MessageDeleteDTO();
        doctorDTO.doctorId = tempDoctorId;
        messageDeleteDTO = soapWebService.deleteDoctor(doctorDTO);
        hidePopup();
        searchDoctor();
    }

    public List<HM_DoctorDTO> convertSoapResponseWrappers(soapSforceComSchemasClassSoapwebser.MessageSearchDTO soapMessageDTO) {
        List<HM_DoctorDTO> wrappers = new List<HA_SoapDoctorController.HM_DoctorDTO>();
        if (soapMessageDTO.doctorsList == null) {
            wrappers = null;
            return wrappers;
        }

        for (soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO : soapMessageDTO.doctorsList) {
            HM_DoctorDTO nDoctorWrapper = new HM_DoctorDTO(doctorDTO);
            wrappers.add(nDoctorWrapper);
        }
        return wrappers;
    }

    public void clearSearch() {
        doctorNewDTO = new DoctorNewDTO();
        doctors = new List<HA_SoapDoctorController.HM_DoctorDTO>();
    }

    public class DoctorNewDTO {
        public String country { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
    }

    public class DoctorToInsert {
        public String doctorId { get; set; }
        public String country { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String email { get; set; }
        public Date birthDate { get; set; }
        public String phoneNum { get; set; }
        public String city { get; set; }
        public String streetAddress { get; set; }
        public String postCode { get; set; }
    }

    public class HM_DoctorDTO {
        public String doctorId { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String email { get; set; }
        public String country { get; set; }
        public Date birthDate { get; set; }
        public String phoneNum { get; set; }
        public String city { get; set; }
        public String streetAddress { get; set; }
        public String postCode { get; set; }

        public HM_DoctorDTO(soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO) {
            this.doctorId = doctorDTO.doctorId;
            this.lastName = doctorDTO.lastName;
            this.firstName = doctorDTO.firstName;
            this.birthDate = doctorDTO.birthDate;
            this.email = doctorDTO.email;
            this.country = doctorDTO.country;
            this.city = doctorDTO.city;
            this.streetAddress = doctorDTO.streetAddress;
            this.postCode = doctorDTO.postCode;
            this.phoneNum = doctorDTO.phoneNum;
        }
    }
}