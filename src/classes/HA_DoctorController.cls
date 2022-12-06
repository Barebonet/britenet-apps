public with sharing class HA_DoctorController {
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get{
            return (List<Doctor__c>) setCon.getRecords();
        } set;
    }
    public List<Doctor__c> doctorsToExport { get{
        String query = getQuery(doctor);
        return (List<Doctor__c>) Database.query(query);
    } set; }
    public Id doctorId { get; set; }
    private String sortOrder = 'FullName__c';
    private String orderSorting = 'ASC';
    public Integer numOfRecordsPerPage { get; set; }
    private Integer numberOfResults;
    public Decimal pageLast { get; set; }
    public String status { get; set; }
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                String query = 'SELECT FullName__c, Email__c, Country__c '+
                        'FROM Doctor__c LIMIT 0';
                setCon = new ApexPages.StandardSetController(Database.query(query));
                setCon.setPageSize(numOfRecordsPerPage);
                numberOfResults = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    public String orderingFullName { get; set; }
    public String orderingEmail { get; set; }
    public String orderingCountry { get; set; }
    public Integer currentPage { get; set; }
    public Boolean popupVisible { get; set; }

    public HA_DoctorController() {
        this.doctor = new Doctor__c();
        numOfRecordsPerPage = 5;
        orderingFullName = '▼';
        orderingEmail = '';
        orderingCountry = '';
        currentPage = 1;
        popupVisible = false;
    }

    public String getQuery(Doctor__c doctor) {
        String query = 'SELECT FullName__c, Email__c, Country__c, PhoneNumber__c, Birth_Date__c FROM Doctor__c WHERE LastName__c LIKE \''
                + doctor.LastName__c + '%\'';
        if (doctor.FirstName__c != null) {
            query += ' AND FirstName__c LIKE \'' + doctor.FirstName__c + '%\'';
        }
        if (doctor.Email__c != null) {
            query += ' AND Email__c LIKE \'' + doctor.Email__c + '%\'';
        }
        if (doctor.Country__c != null) {
            query += ' AND Country__c = \'' + doctor.Country__c + '\'';
        }
        query += ' ORDER BY ' + sortOrder + ' ' + orderSorting;
        return query;
    }

    public PageReference searchDoctor() {
        setCon = new ApexPages.StandardSetController(new List<Doctor__c>());
        String query = getQuery(doctor);
        setCon = new ApexPages.StandardSetController(Database.query(query));
        setCon.setPageSize(numOfRecordsPerPage);
        pageLast = getLastPage();
        setCon.first();
        return null;
    }

    public void clearSearch() {
        doctor = new Doctor__c();
        setCon = new ApexPages.StandardSetController(new List<Doctor__c>());
    }

    public PageReference deleteDoctor() {
        Doctor__c doc = [SELECT Id, FullName__c FROM Doctor__c WHERE Id = :doctorId];
        delete doc;
        hidePopup();
        searchDoctor();
        return null;
    }

    public void refreshPageSize() {
        setCon.setPageSize(numOfRecordsPerPage);
        searchDoctor();
    }

    public Integer getLastPage() {
        setCon.last();
        Integer last = setCon.getPageNumber();
        return last;
    }

    public void sortByFullName() {
        this.sortOrder = 'FullName__c';
        if(orderSorting.equals('ASC')) {
            this.orderSorting = 'DESC';
            orderingFullName = '▲';
        }
        else {
            this.orderSorting = 'ASC';
            orderingFullName = '▼';
        }
        orderingEmail = '';
        orderingCountry = '';
        searchDoctor();
    }

    public void sortByEmail() {
        this.sortOrder = 'Email__c';
        if(orderSorting.equals('ASC')) {
            this.orderSorting = 'DESC';
            orderingEmail = '▲';
        }
        else {
            this.orderSorting = 'ASC';
            orderingEmail = '▼';
        }
        orderingFullName = '';
        orderingCountry = '';
        searchDoctor();
    }

    public void sortByCountry() {
        this.sortOrder = 'Country__c';
        if(orderSorting.equals('ASC')) {
            this.orderSorting = 'DESC';
            orderingCountry = '▲';
        }
        else {
            this.orderSorting = 'ASC';
            orderingCountry = '▼';
        }
        orderingEmail = '';
        orderingFullName = '';
        searchDoctor();
    }

    public PageReference directToDoctorDetails() {
        PageReference pg = new PageReference('/apex/HA_DoctorDetails?id=' + doctorId);
        Map<String, String> params = new Map<String, String>{'Id' => doctorId, 'status' => status};
        pg.getParameters().putAll(params);
        return pg.setRedirect(true);
    }

    public void showPopup() {
        popupVisible = true;
    }

    public void hidePopup() {
        popupVisible = false;
    }

    public PageReference exportSearchingToCSV() {
        PageReference pg = new PageReference('/apex/HA_ExportToCSV');
        return pg.setRedirect(false);
    }

    public PageReference exportSearchingToXSL() {
        PageReference pgr = new PageReference('/apex/HA_ExportToXLS');
        return pgr.setRedirect(false);
    }
}