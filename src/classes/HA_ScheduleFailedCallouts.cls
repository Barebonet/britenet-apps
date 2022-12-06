/**
 * Created by bartosz.rozpara on 20.11.2022.
 */

public with sharing class HA_ScheduleFailedCallouts implements Schedulable {
    public static String scheduleTime = '0 00 08 * * ?';

    public static String scheduleBatch() {
        HA_ScheduleFailedCallouts failedCallouts = new HA_ScheduleFailedCallouts();
        return System.schedule('Failed Records Scheduled!', scheduleTime, failedCallouts);
    }

    public void execute(SchedulableContext sc) {
        HA_HospitalBatchFailedRecords failedRecords = new HA_HospitalBatchFailedRecords();
        Id batchProcessId = Database.executeBatch(failedRecords, 50);
    }
}