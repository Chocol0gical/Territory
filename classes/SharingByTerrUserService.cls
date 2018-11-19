/**
 * Created by klevc on 2018-11-02.
 */

public with sharing class SharingByTerrUserService {

    public static void giveAccessToRelatedRecords(List<TerrUser__c> terrUsers) {
        SharingUtil.giveAccessToRelatedRecords(terrUsers);

    }

    public static void removeAccessToRelatedRecords(List<TerrUser__c> terrUsers) {
        SharingUtil.removeAccessToRelatedRecords(terrUsers);
        SharingUtil.updateTheRestOfUsersTerritories(terrUsers);
    }

    public static void recountAccessToRelatedRecords(List<TerrUser__c> newRecords, Map<Id, TerrUser__c> oldRecords) {
        List<TerrUser__c> changedNewRecords = getChangedNewRecords(newRecords, oldRecords);
        List<TerrUser__c> changedOldRecords = getChangedOldRecords(newRecords, oldRecords);

        removeAccessToRelatedRecords(changedOldRecords);
        giveAccessToRelatedRecords(changedNewRecords);
    }

    private static List<TerrUser__c> getChangedNewRecords(List<TerrUser__c> newRecords, Map<Id, TerrUser__c> oldRecords) {
        List<TerrUser__c> changedTerrUsers = new List<TerrUser__c>();
        for (TerrUser__c terrUser : newRecords) {
            if (isChanged(terrUser, oldRecords)) {
                changedTerrUsers.add(terrUser);
            }
        }
        return changedTerrUsers;
    }

    private static List<TerrUser__c> getChangedOldRecords(List<TerrUser__c> newRecords, Map<Id, TerrUser__c> oldRecords) {
        List<TerrUser__c> changedTerrUsers = new List<TerrUser__c>();
        for (TerrUser__c terrUser : newRecords) {
            if (isChanged(terrUser, oldRecords)) {
                changedTerrUsers.add(oldRecords.get(terrUser.Id));
            }
        }
        return changedTerrUsers;
    }

    private static Boolean isChanged(TerrUser__c terrUser, Map<Id, TerrUser__c> oldRecords) {
        return terrUser.Territory__c != oldRecords.get(terrUser.Id).Territory__c || terrUser.User__c != oldRecords.get(terrUser.Id).User__c;
    }


}