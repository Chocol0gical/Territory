/**
 * Created by klevc on 2018-11-02.
 */


public with sharing class TerritoryUtil {
    private static final Integer TERRITORY_HIERARCHY_LIMIT = 3;

    public static Set<Territory__c> getTerritoriesWithChildren(List<TerrUser__c> terrUsers) {
        Set<Id> terrIds = CollectionsUtil.getTerritoriesIds(terrUsers);
        Set<Territory__c> relatedTerritories = new Set<Territory__c>();
        relatedTerritories.addAll(getTerritoriesById(terrIds));
        relatedTerritories.addAll(getChildTerritories(terrIds));
        return relatedTerritories;
    }

    public static Set<Territory__c> getTerritoriesWithChildren(List<Territory__c> territories) {
        Set<Territory__c> relatedTerritories = new Set<Territory__c>(territories);
        relatedTerritories.addAll(getChildTerritories(CollectionsUtil.getTerritoriesIds(relatedTerritories)));
        return relatedTerritories;
    }

    public static Set<Territory__c> getTerritoriesWithParents(List<Territory__c> territories) {
        Set<Territory__c> relatedTerritories = new Set<Territory__c>(territories);
        relatedTerritories.addAll(getParentTerritories(relatedTerritories));

        return relatedTerritories;
    }

    public static List<Territory__c> getTerritoriesById(Set<Id> terrIds) {
        return [
                SELECT Name, Territory__c
                FROM Territory__c
                WHERE Id IN :terrIds
        ];
    }

    public static List<TerrUser__c> getTerrUsers(Set<Id> terrIds) {
        return [
                SELECT Territory__c, User__c
                FROM TerrUser__c
                WHERE Territory__c IN:terrIds
        ];
    }

    public static Set<Territory__c> getChildTerritories(Set<Id> parentIds) {
        Set<Id> terrIds = new Set<Id>(parentIds);
        Set<Territory__c> childTerritories = new Set<Territory__c>();

        for (Integer i = 0; i < TERRITORY_HIERARCHY_LIMIT; i++) {
            List<Territory__c> territories = [
                    SELECT Name, Territory__c
                    FROM Territory__c
                    WHERE Territory__c IN :terrIds
            ];
            terrIds.addAll(new Map<Id, Territory__c>(territories).keySet());
            childTerritories.addAll(territories);
        }
        return childTerritories;
    }

    public static Set<Territory__c> getParentTerritories(Set<Territory__c> childTerrs) {
        Set<Id> terrIds = new Set<Id>(CollectionsUtil.getParentTerritoriesIds(childTerrs));

        Set<Territory__c> territories = new Set<Territory__c>();

        for (Integer i = 0; i < TERRITORY_HIERARCHY_LIMIT; i++) {
            List<Territory__c> terrs = [
                    SELECT Id, Territory__c
                    FROM Territory__c
                    WHERE Id IN :terrIds
            ];
            terrIds.addAll(CollectionsUtil.getParentTerritoriesIds(new Set<Territory__c>(terrs)));
            territories.addAll(terrs);
        }

        return territories;
    }

    public static Set<Id> getUserTerritoriesIds(TerrUser__c terrUser, Set<Territory__c> relatedTerritories) {
        Set<Id> terrIds = new Set<Id>();
        terrIds.add(terrUser.Territory__c);

        for (Integer i = 0; i < TERRITORY_HIERARCHY_LIMIT; i++) {
            for (Territory__c territory : relatedTerritories) {
                if (terrIds.contains(territory.Territory__c)) terrIds.add(territory.Id);
            }
        }
        return terrIds;
    }

    public static List<Account> getAccountsById(Set<Id> accIds) {
        return [
                SELECT Territory__c
                FROM Account
                WHERE Id IN :accIds
        ];
    }
}