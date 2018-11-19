/**
 * Created by klevc on 2018-11-09.
 */

public with sharing class TerritoryUserHandler {

    public static void onAfterInsert(List<TerrUser__c> newRecords) {
        SharingByTerrUserService.giveAccessToRelatedRecords(newRecords);
    }

    public static void onAfterUpdate(List<TerrUser__c> newRecords, Map<Id, TerrUser__c> oldRecords) {
        SharingByTerrUserService.recountAccessToRelatedRecords(newRecords, oldRecords);
    }

    public static void onAfterDelete(List<TerrUser__c> terrUsers) {
        SharingByTerrUserService.removeAccessToRelatedRecords(terrUsers);
    }

    public static void onAfterUndelete(List<TerrUser__c> newRecords) {
        SharingByTerrUserService.giveAccessToRelatedRecords(newRecords);
    }
}