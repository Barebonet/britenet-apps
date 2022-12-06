/**
 * Created by bartosz.rozpara on 18.10.2022.
 */

public with sharing class HA_ImportFromCSV {
    public Blob file { get; set; }
    public String fileName { get; set; }
    public String[] csvRows { get; set; }
    public List<DoctorWrapper> doctors { get; set; }
    public List<DoctorWrapper> wrapperMess { get; set; }
    public Boolean viewResults { get; set; }
    public Boolean processButton { get; set; }
    public Boolean insertButton { get; set; }
    public String exampleCSV { get {
            String exampleFileURL = URL.getSalesforceBaseUrl().toExternalForm() + PageReference.forResource('ExampleCSV').getUrl();
            return exampleFileURL;
        } set;
    }

    public HA_ImportFromCSV() {
        doctors = new List<DoctorWrapper>();
        wrapperMess = new List<DoctorWrapper>();
        viewResults = false;
        this.processButton = true;
        insertButton = true;
    }

    public void enableProcessButton() {
        processButton = false;
    }

    public void checkCheckboxes() {
        for(DoctorWrapper docWrap : doctors) {
            if(docWrap.checkToImport) {
                insertButton = false;
                return;
            } else {
                insertButton = true;
            }
        }
    }

    public void selectAll() {
        for(DoctorWrapper doctorWrap : doctors) {
            doctorWrap.checkDoctor();
        }
    }

    public void deselectAll() {
        for(DoctorWrapper doctorWrap : doctors) {
            doctorWrap.uncheckDoctor();
        }
    }

    public void reverseSelect() {
        for(DoctorWrapper doctorWrap : doctors) {
            doctorWrap.checkToImport = !doctorWrap.checkToImport;
        }
    }

    public void insertDoctors() {
        viewResults = false;
        List<Doctor__c> listWrap = new List<Doctor__c>();
        for(DoctorWrapper doctorWrap : doctors) {
            doctorWrap.isError = false;
            doctorWrap.isSuccess = false;
            if(doctorWrap.checkToImport) {
                listWrap.add(doctorWrap.doctor);
                wrapperMess.add(doctorWrap);
            }
        }
        Database.SaveResult[] results = Database.insert(listWrap,false);
        for(Integer i=0; i<results.size(); i++) {
            if(results[i].isSuccess()) {
                wrapperMess.get(i).isSuccess = true;
            } else {
                wrapperMess.get(i).isError = true;
                wrapperMess.get(i).error = results[i].getErrors()[0].getMessage();
            }
        }
        viewResults = true;
    }

    public void processFile() {
        String encodedFile = blobEncode(file, 'UTF-8');
        csvRows = encodedFile.split('\n');
        for(Integer i=1; i<csvRows.size(); i++) {
            String[] csvRecordData = csvRows[i].split('","');
            Doctor__c doc = new Doctor__c();
            DoctorWrapper docWrap = new DoctorWrapper(doc);
            docWrap.doctor.FirstName__c = csvRecordData[0];
            docWrap.doctor.LastName__c = csvRecordData[1];
            docWrap.doctor.Email__c = csvRecordData[2];
            docWrap.doctor.PhoneNumber__c = csvRecordData[3];
            docWrap.doctor.Country__c = csvRecordData[4];
            docWrap.doctor.City__c = csvRecordData[5];
            docWrap.doctor.Street_Address__c = csvRecordData[6];
            docWrap.doctor.Post_Code__c = csvRecordData[7];
            docWrap.doctor.Name = csvRecordData[0] + ' ' + csvRecordData[1];
            doctors.add(docWrap);
        }
    }

    public PageReference downloadFile() {
        PageReference pg = new PageReference(exampleCSV);
        return pg.setRedirect(false);
    }

    public class DoctorWrapper {
        public Doctor__c doctor { get; set; }
        public Boolean checkToImport { get; set; }
        public Boolean isSuccess { get; set; }
        public Boolean isError { get; set; }
        public String error { get; set; }

        public DoctorWrapper(Doctor__c doc) {
            this.doctor = doc;
            this.checkToImport = false;
            this.isError = false;
            this.isSuccess = false;
        }

        public void checkDoctor() {
            checkToImport = true;
        }

        public void uncheckDoctor() {
            checkToImport = false;
        }
    }

    public String blobEncode(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for (Integer i = 0; i < bytesCount; ++i) {
            bytes[i] = hex.mid(i << 1, 2);
        }
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
}