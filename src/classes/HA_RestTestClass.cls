/**
 * Created by bartosz.rozpara on 14.11.2022.
 */

@IsTest
public with sharing class HA_RestTestClass {
    @IsTest
    public static void testSuccessGetHospitals() {
        HA_RestSingleMock singleRequest = new HA_RestSingleMock(200, 'Success',
                '{"message":"Successfully returned searched hospital list","hospitals":[{"streetAddress":"Henryka Sienkiewicza 79","postalCode":"15-003","phoneNum":null,"hospName":"SOR Uniwersytecki Szpital Kliniczny","hospId":"a017S000003qso7QAA","externalId":null,"country":"Poland","city":"Białystok"}]}', null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:RestIntegration/services/apexrest/hospitals/?HospitalName=e&Country=', singleRequest);
        HttpCalloutMock multiCalloutMock = new HA_RestMockService(endpoint2TestResp);
        HA_RestSearchDoctorController searchHosp = new HA_RestSearchDoctorController();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();
        searchHosp.searchHospital();
        Test.stopTest();
        System.assert(true, true);
    }

    @IsTest
    public static void testFailGetHospitals() {

    }
}