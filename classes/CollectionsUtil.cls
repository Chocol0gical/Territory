/**
 * Created by klevc on 2018-11-17.
 */

public with sharing class CollectionsUtil {

    public static Set<Id> getIds(sObject[] sObjects) {
        return new Map<Id, sObject>(sObjects).keySet();
    }

    public static Set<Id> getTerritoriesIds(List<TerrUser__c> terrUsers) {
        Set<Id> territoriesIds = new Set<Id>();

        for (TerrUser__c terrUser : terrUsers) {
            territoriesIds.add(terrUser.Territory__c);
        }
        return territoriesIds;
    }

    public static Set<Id> getTerritoriesIds(Set<Territory__c> territory) {
        return new Map<Id, Territory__c>(new List<Territory__c>(territory)).keySet();
    }

    public static Set<Id> getTerritoriesIds(List<Account> accounts) {
        Set<Id> terrIds = new Set<Id>();
        for (Account account : accounts) {
            terrIds.add(account.Territory__c);
        }
        return terrIds;
    }

    public static Set<Id> getParentTerritoriesIds(Set<Territory__c> territory) {
        Set<Id> parentIds = new Set<Id>();
        for (Territory__c terr : territory) {
            parentIds.add(terr.Territory__c);
        }
        return parentIds;
    }

    public static Set<Id> getUsersIds(List<TerrUser__c> terrUsers) {
        Set<Id> userIds = new Set<Id>();

        for (TerrUser__c terrUser : terrUsers) {
            userIds.add(terrUser.User__c);
        }
        return userIds;
    }

    public static Set<Id> getAccountIds(Set<Account> accounts) {
        Set<Id> Ids = new Set<Id>();

        for (Account a : accounts) {
            Ids.add(a.Id);
        }
        return Ids;
    }

    public static Set<Id> getAccountIds(List<Account_Contact__c> accountsContacts) {
        Set<Id> Ids = new Set<Id>();

        for (Account_Contact__c a : accountsContacts) {
            Ids.add(a.Account__c);
        }
        return Ids;
    }

    public static Set<Id> getContactIds(List<Account_Contact__c> accountContacts) {
        Set<Id> result = new Set<Id>();
        for (Account_Contact__c accountContact : accountContacts) {
            result.add(accountContact.Contact__c);
        }

        return result;
    }
}