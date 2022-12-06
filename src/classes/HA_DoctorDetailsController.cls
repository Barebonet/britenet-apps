public with sharing class HA_DoctorDetailsController {
    public Doctor__c doctor { get; set; }
    public Id doctorId { get; set; }
    public String status { get; set; }
    public Contract__c contract { get; set; }
    public List<Contract__c> contracts { get; set; }
    public Boolean popupVisible { get; set; }
    public String fileName { get; set; }
    public Blob file { get; set; }
    public Id currentPicture { get; set; }
    public Boolean isMapVisible { get; set; }
    public Decimal doctorLatitude { get; set; }
    public Decimal doctorLongitude { get; set; }
    private static final String fixedFileName = 'anons.jpg';
    public String defaultPhotoURL { get{
            String imageURL = URL.getSalesforceBaseUrl().toExternalForm() + PageReference.forResource('DefaultPhoto').getUrl();
            return imageURL;
        }set;
    }
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public Boolean displayLast { get; set; }
    public Boolean displayModal { get; set; }
    public String tempHospId { get; set; }
    public Hospital__c tempHosp { get; set; }

    public HA_DoctorDetailsController(ApexPages.StandardController controller) {
        String docId = ApexPages.currentPage().getParameters().get('Id');
        doctor = [
                SELECT Id, FirstName__c, LastName__c, FullName__c, Birth_Date__c, Email__c, Country__c, City__c, Street_Address__c, PhoneNumber__c, Post_Code__c
                FROM Doctor__c
                WHERE Id = :docId
        ];
        contracts = [
                SELECT Start_Date__c, End_Date__c, Doc__c, Hosp__r.Name, Name
                FROM Contract__c
                WHERE Doc__c = :doctor.Id
                ORDER BY Name
        ];
        contract = new Contract__c();
        status = ApexPages.currentPage().getParameters().get('status');
        if (status == null) {
            status = 'view';
        }
        this.hospital = new Hospital__c();
        this.hospitals = new List<Hospital__c>();
        List<Attachment> currentPic = [SELECT Id FROM Attachment WHERE ParentId = :docId];
        if (currentPic.size() > 0) {
            currentPicture = currentPic[0].Id;
        }
        popupVisible = false;
        isMapVisible = false;

        if (doctor.Country__c != null && doctor.City__c != null && doctor.Street_Address__c != null) {
            HttpRequest req = new HttpRequest();
            String urlLocationParameters = '';

            if (String.isNotBlank(doctor.Country__c)) {
                urlLocationParameters += '&country=' + EncodingUtil.urlEncode(doctor.Country__c, 'UTF-8');
            }

            if (String.isNotBlank(doctor.City__c)) {
                urlLocationParameters += '&city=' + EncodingUtil.urlEncode(doctor.City__c, 'UTF-8');
            }

            if (String.isNotBlank(doctor.Street_Address__c)) {
                String addressDoctor = doctor.Street_Address__c.replace(' ', '+');
                urlLocationParameters += '&street=' + addressDoctor;
            }

            String url = 'https://nominatim.openstreetmap.org/search.php?format=json' + urlLocationParameters;

            req.setEndpoint(
                    url
            );

            req.setMethod('GET');
            Http http = new Http();
            HttpResponse response = http.send(req);
            List<GeoLocation> geoLocations = new List<GeoLocation>();

            try {
                geoLocations = (List<GeoLocation>) JSON.deserialize(
                        response.getBody(), List<GeoLocation>.class
                );
            } catch (Exception e) {
                System.debug('Error: ' + e);
            }

            if (geoLocations != null && geoLocations.size() > 0) {
                this.doctorLatitude = Decimal.valueOf(geoLocations[0].lat);
                this.doctorLongitude = Decimal.valueOf(geoLocations[0].lon);
                isMapVisible = true;
            }

        } else {
            isMapVisible = false;
        }
    }

    public PageReference saveFile() {
        List<Attachment> savedPicture = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :this.doctor.Id];
        if (fileName.contains('.jpg') || fileName.contains('.png')) {
            if(savedPicture.size() > 0) {
                delete savedPicture;
            }
            Attachment attach = new Attachment(ParentId = this.doctor.Id, Name = fixedFileName, Body = file);
            insert attach;
            currentPicture = attach.Id;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'File extension wrong'));
        }
        return null;
    }

    public void setDefaultPhoto() {
        List<Attachment> att = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :this.doctor.Id];
        if (att.size() > 0) {
            delete att;
        }
    }

    public PageReference saveEdit() {
        update doctor;
        status = 'view';
        directToDoctorDetails();
        return null;
    }

    public PageReference deleteDoctor() {
        Doctor__c doc = new Doctor__c(Id = doctorId);
        hidePopup();
        PageReference prf = new PageReference('/a08/o');
        delete doc;
        return prf.setRedirect(true);
    }

    public void showPopup() {
        popupVisible = true;
    }

    public void hidePopup() {
        popupVisible = false;
    }

    public PageReference directToDoctorDetails() {
        PageReference pg = new PageReference('/apex/HA_DoctorDetails?id=' + doctorId);
        Map<String, String> params = new Map<String, String>{
                'Id' => doctorId, 'status' => status
        };
        pg.getParameters().putAll(params);
        return pg.setRedirect(true);
    }

    public class GeoLocation {
        public String lat { get; set; }
        public String lon { get; set; }
    }

    public String getHospitalQuery(Doctor__c doctor) {
        String query = 'SELECT Id, Name, Country__c, City__c, Post_Code__c FROM Hospital__c WHERE Name LIKE \'%' + hospital.Name + '%\'';
        if(hospital.Country__c != null) {
            query += ' AND Country__c = \'' + hospital.Country__c + '\'';
        }
        return query;
    }

    public PageReference searchHospital() {
        String query = getHospitalQuery(doctor);
        hospitals = (List<Hospital__c>) Database.query(query);
        return null;
    }

    public PageReference clearSearch() {
        hospital = new Hospital__c();
        hospitals = new List<Hospital__c>();
        return null;
    }

    public void displayLastBlock() {
        displayLast = true;
        tempHosp = [SELECT Id, Name FROM Hospital__c WHERE Id = :tempHospId];
    }

    public void hideLastBlock() {
        displayLast = false;
    }

    public void showModal() {
        displayModal = true;
    }

    public void closeModal() {
        displayModal = false;
        clearSearch();
        contract = new Contract__c();
        hideLastBlock();
    }

    public void insertNewContract() {
        contract.Doc__c = doctor.Id;
        contract.Hosp__c = tempHospId;
        insert contract;
        contracts = [
                SELECT Start_Date__c, End_Date__c, Doc__c, Hosp__r.Name, Name
                FROM Contract__c
                WHERE Doc__c = :doctor.Id
                ORDER BY Name
        ];
        closeModal();
    }
}