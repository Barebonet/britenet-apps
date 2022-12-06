/**
 * Created by bartosz.rozpara on 27.10.2022.
 */

@IsTest
public with sharing class SoapServiceTest {

    @IsTest
    static void testSearchZeroDoctors() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.country = 'Poland';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock());

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.searchDoctor();
        Test.stopTest();

        System.assertEquals('0 records found.', soapDoctorController.messageSearchDTO.message);
        System.assert(true, soapDoctorController.messageSearchDTO.doctorsList.size() == 0);
    }

    @IsTest
    static void testSearchManyDoctors() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.country = 'Poland';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock().addOption('searchDoctors', new SoapServiceMock.SearchDoctorsOptions(2)));

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.searchDoctor();
        Test.stopTest();

        System.assertEquals('2 records found.', soapDoctorController.messageSearchDTO.message);
        System.assert(true, soapDoctorController.messageSearchDTO.doctorsList.size() >= 2);
    }

    @IsTest
    static void testFailInsertDoctor() {
        HA_SoapDoctorController.DoctorToInsert doctorToInsert = new HA_SoapDoctorController.DoctorToInsert();
        doctorToInsert.firstName = 'Alfons';
        doctorToInsert.lastName = 'Alfonsowski';
        doctorToInsert.country = 'Poland';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock());

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.insertDoctor();
        Test.stopTest();

        System.assertEquals('Error while inserting.', soapDoctorController.messageInsertDTO.message);
    }

    @IsTest
    static void testSuccessInsertDoctor() {
        HA_SoapDoctorController.DoctorToInsert doctorToInsert = new HA_SoapDoctorController.DoctorToInsert();
        doctorToInsert.firstName = 'Alfons';
        doctorToInsert.lastName = 'Alfonsowski';
        doctorToInsert.country = 'Poland';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock().addOption('insertDoctors', new SoapServiceMock.InsertDoctorsOptions(1)));

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.insertDoctor();
        Test.stopTest();

        System.assert(true, soapDoctorController.messageInsertDTO.message != null);
        System.assertEquals('Inserted.', soapDoctorController.messageInsertDTO.message);
    }

    @IsTest
    static void testFailUpdateDoctor() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.email = 'alfons';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock());

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.selectedDoctor = new HA_SoapDoctorController.HM_DoctorDTO(doctorDTO);
        soapDoctorController.updateDoctor();
        Test.stopTest();

        System.assertEquals('Error while updating.', soapDoctorController.messageUpdateDTO.message);
    }

    @IsTest
    static void testSuccessUpdateDoctor() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.email = 'alfons';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock().addOption('updateDoctors', new SoapServiceMock.UpdateDoctorsOptions(1)));

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.selectedDoctor = new HA_SoapDoctorController.HM_DoctorDTO(doctorDTO);
        soapDoctorController.updateDoctor();
        Test.stopTest();

        System.assertEquals('1 records updated.', soapDoctorController.messageUpdateDTO.message);
    }

    @IsTest
    static void testFailDeleteDoctor() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.doctorId = 'a087Q00000SiTWC';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock());

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.deleteDoctor();
        Test.stopTest();

        System.assertEquals('Error while deleting.', soapDoctorController.messageDeleteDTO.message);

    }

        @IsTest
        static void testSuccessDeleteDoctor() {
        soapSforceComSchemasClassSoapwebser.DoctorDTO doctorDTO = new soapSforceComSchemasClassSoapwebser.DoctorDTO();
        doctorDTO.doctorId = 'a087Q00000SiTWC';
        Credentials__c credentials = new Credentials__c(Username__c = 'michal.drago@gmail.com', Password__c = '*****');
        insert credentials;
        Test.setMock(WebServiceMock.class, new SoapServiceMock().addOption('deleteDoctors', new SoapServiceMock.DeleteDoctorsOptions(1)));

        Test.startTest();
        HA_SoapDoctorController soapDoctorController = new HA_SoapDoctorController();
        soapDoctorController.deleteDoctor();
        Test.stopTest();

        System.assertEquals('1 records deleted.', soapDoctorController.messageDeleteDTO.message);
    }
}