/**
 * Created by bartosz.rozpara on 14.10.2022.
 */

public with sharing class HA_RandomDoctors {
    public List<Doctor__c> doctors { get; set; }
    public List<Doctor__c> randomDoctors { get; set; }
    public List<Integer> randomList { get; set; }
    public Integer listSize { get; set; }
    private Integer itemCounter { get; set; }

    public HA_RandomDoctors() {
        searchRandomDoctors();
    }

    public void searchRandomDoctors() {
        itemCounter = 5;
        Integer randomRecordNumber;
        randomList = new List<Integer>();
        randomDoctors = new List<Doctor__c>();

        doctors = [SELECT FullName__c, Country__c, Email__c, PhoneNumber__c, Birth_Date__c FROM Doctor__c];
        listSize = doctors.size() - 2;
        randomList.add(Math.round(Math.random() * listSize));
        do{
            randomRecordNumber = Math.round(Math.random() * listSize);
            if(!randomList.contains(randomRecordNumber)){
                randomList.add(randomRecordNumber);
            }

        }while(randomList.size() < 5 );

        for(Integer item : randomList) {
            randomDoctors.add(doctors[item]);
        }
    }
}