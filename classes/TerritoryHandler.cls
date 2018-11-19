/**
 * Created by klevc on 2018-11-04.
 */

public with sharing class TerritoryHandler {

    public static void onBeforeInsert(List<Territory__c> newRecords) {
        TerritoryUniqueNameCheckService.checkNameForUniqueValue(newRecords);
    }

    public static void onBeforeUpdate(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        TerritoryUniqueNameCheckService.checkNameForUniqueValue(newRecords, oldRecordsMap);
        SharingByTerritoryService.removeAccessToRelatedUsers(newRecords, oldRecordsMap);
    }

    public static void onBeforeDelete(List<Territory__c> territories) {
        SharingByTerritoryService.removeAccessToRelatedUsers(territories);
    }

    public static void onAfterInsert(List<Territory__c> territories) {
        SharingByTerritoryService.giveAccessToRelatedUsers(territories);
    }

    public static void onAfterDelete(List<Territory__c> territories) {
        SharingByTerritoryService.giveAccessToRelatedUsers(territories);
    }

    public static void onAfterUpdate(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        SharingByTerritoryService.giveAccessToRelatedUsers(newRecords, oldRecordsMap);
    }

    public static void onAfterUndelete(List<Territory__c> newRecords) {
       // TerritoryUniqueNameCheckService.checkNameForUniqueValue(newRecords);
        SharingByTerritoryService.giveAccessToRelatedUsers(newRecords);
    }
}