/**
 * Created by klevc on 2018-11-04.
 */

public with sharing class SharingByTerritoryService {

    public static void giveAccessToRelatedUsers(List<Territory__c> territories) {
        List<TerrUser__c> terrUsers = getRelatedUsers(territories);
        SharingUtil.giveAccessToRelatedRecords(terrUsers);

    }

    public static void removeAccessToRelatedUsers(List<Territory__c> territories) {
        List<TerrUser__c> terrUsers = getRelatedUsers(territories);

        SharingUtil.removeAccessToRelatedRecords(terrUsers);
    }
    public static void giveAccessToRelatedUsers(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        giveAccessToRelatedUsers(getChangedNewTerritories(newRecords, oldRecordsMap));
        giveAccessToRelatedUsers(getChangedOldTerritories(newRecords, oldRecordsMap));
    }
    public static void removeAccessToRelatedUsers(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        removeAccessToRelatedUsers(getChangedOldTerritories(newRecords, oldRecordsMap));
    }

    private static List<TerrUser__c> getRelatedUsers(List<Territory__c> territories) {
        Set<Territory__c> parentTerritories = TerritoryUtil.getTerritoriesWithParents(territories);
        List<TerrUser__c> terrUsers = SharingUtil.getRelatedUsers(CollectionsUtil.getTerritoriesIds(parentTerritories));
        return terrUsers;
    }


    private static List<Territory__c> getChangedNewTerritories(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        List<Territory__c> changedTerritories = new List<Territory__c>();
        for (Territory__c territory : newRecords) {
            if (isChanged(territory, oldRecordsMap)) {
                changedTerritories.add(territory);
            }
        }
        return changedTerritories;
    }

    private static List<Territory__c> getChangedOldTerritories(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        List<Territory__c> changedTerritories = new List<Territory__c>();
        for (Territory__c territory : newRecords) {
            if (isChanged(territory, oldRecordsMap)) {
                changedTerritories.add(oldRecordsMap.get(territory.Id));
            }
        }
        return changedTerritories;
    }

    private static Boolean isChanged(Territory__c territory, Map<Id, Territory__c> oldRecordsMap) {
        return territory.Territory__c != oldRecordsMap.get(territory.Id).Territory__c;
    }


}