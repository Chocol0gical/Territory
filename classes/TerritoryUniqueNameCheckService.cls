/**
 * Created by klevc on 2018-11-04.
 */

public with sharing class TerritoryUniqueNameCheckService {
    private final static String MESSAGE = 'Territory with name {0} already exists!';

    public static void checkNameForUniqueValue(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        List<Territory__c> changedTerritories = getChangedTerritories(newRecords, oldRecordsMap);
        if (!changedTerritories.isEmpty()) {
            checkNameForUniqueValue(changedTerritories);
        }
    }

    public static void checkNameForUniqueValue(List<Territory__c> newRecords) {
        if (newRecords.size() > 1) checkIncomingData(newRecords);
        checkStoredData(newRecords);
    }

    private static void checkIncomingData(List<Territory__c> newRecords) {
        System.debug(newRecords);
        for (Integer i = 0; i < newRecords.size() - 1; i++) {
            for (Integer j = i + 1; j < newRecords.size(); j++) {
                validateTerritories(newRecords[i], newRecords[j]);
            }
        }
    }

    private static List<Territory__c> getChangedTerritories(List<Territory__c> newRecords, Map<Id, Territory__c> oldRecordsMap) {
        List<Territory__c> changedTerritories = new List<Territory__c>();
        for (Territory__c territory : newRecords) {
            if (isNameChanged(territory, oldRecordsMap) || isTerritoryChanged(territory, oldRecordsMap)) {
                changedTerritories.add(territory);
            }
        }
        return changedTerritories;
    }

    private static void checkStoredData(List<Territory__c> newRecords) {
        for (Territory__c existedTerritory : getSameLevelHierarchyTerritories(newRecords)) {
            for (Territory__c territory : newRecords) {
                System.debug(existedTerritory);
                System.debug(territory);
                validateTerritories(existedTerritory, territory);
            }
        }
    }

    private static void validateTerritories(Territory__c territory1, Territory__c territory2) {
        if (existsWithSameName(territory1, territory2)) {
            addErrorMessage(territory2);
        }
    }

    private static Boolean isTerritoryChanged(Territory__c territory, Map<Id, Territory__c> oldRecordsMap) {
        return territory.Territory__c != oldRecordsMap.get(territory.Id).Territory__c;
    }

    private static Boolean isNameChanged(Territory__c territory, Map<Id, Territory__c> oldRecordsMap) {
        return territory.Name != oldRecordsMap.get(territory.Id).Name;
    }

    private static void addErrorMessage(Territory__c territory) {
        territory.addError(String.format(MESSAGE, new String[]{
                territory.Name
        }));
    }

    private static Boolean existsWithSameName(Territory__c existedTerritory, Territory__c territory) {
        return existedTerritory.Territory__c == territory.Territory__c
                && territory.Name.equalsIgnoreCase(existedTerritory.Name);
    }

    public static List<Territory__c> getSameLevelHierarchyTerritories(List<Territory__c> territories) {
        Set<Id> ids = getParentIds(territories);
        return [
                SELECT Id, Name, Territory__c
                FROM Territory__c
                WHERE Territory__c IN :ids
        ];
    }

    private static Set<Id> getParentIds(List<Territory__c> territory) {
        Set<Id> territoriesIds = new Set<Id>();
        for (Territory__c terr : territory) {
            territoriesIds.add(terr.Territory__c);
        }
        return territoriesIds;
    }
}