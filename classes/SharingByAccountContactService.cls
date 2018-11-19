/**
 * Created by klevc on 2018-11-16.
 */

public with sharing class SharingByAccountContactService {

    public static void giveAccessToUsers(List<Account_Contact__c> accountContacts) {
        List<TerrUser__c> terrUsers = getRelatedUsers(accountContacts);

        SharingUtil.giveAccessToRelatedRecords(terrUsers);
    }

    public static void removeAccessFromUsers(List<Account_Contact__c> accountContacts) {
        List<TerrUser__c> terrUsers = getRelatedUsers(accountContacts);

        SharingUtil.removeAccessToContacts(CollectionsUtil.getUsersIds(terrUsers), CollectionsUtil.getContactIds(accountContacts));
    }

    private static List<TerrUser__c> getRelatedUsers(List<Account_Contact__c> accountContacts) {
        List<Account> accounts = TerritoryUtil.getAccountsById(CollectionsUtil.getAccountIds(accountContacts));
        List<Territory__c> territories = TerritoryUtil.getTerritoriesById(CollectionsUtil.getTerritoriesIds(accounts));
        Set<Territory__c> territoriesWithParents = TerritoryUtil.getTerritoriesWithParents(territories);
        List<TerrUser__c> terrUsers = TerritoryUtil.getTerrUsers(CollectionsUtil.getTerritoriesIds(territoriesWithParents));
        return terrUsers;
    }

    public static void recountAccess(List<Account_Contact__c> accountContacts, Map<Id, Account_Contact__c> accountContactMap) {
        List<Account_Contact__c> changedNewAccountContacts = getChangedNewRecords(accountContacts, accountContactMap);
        List<Account_Contact__c> changedOldAccountContacts = getChangedOldRecords(accountContacts, accountContactMap);

        removeAccessFromUsers(changedOldAccountContacts);
        giveAccessToUsers(changedNewAccountContacts);

    }

    private static List<Account_Contact__c> getChangedNewRecords(List<Account_Contact__c> accountContacts, Map<Id, Account_Contact__c> accountContactMap) {
        List<Account_Contact__c> result = new List<Account_Contact__c>();

        for (Account_Contact__c accountContact : accountContacts) {
            Account_Contact__c oldAccountContact = accountContactMap.get(accountContact.Id);
            if (isChanged(accountContact, oldAccountContact)) {
                result.add(accountContact);
            }
        }
        return result;
    }

    private static List<Account_Contact__c> getChangedOldRecords(List<Account_Contact__c> accountContacts, Map<Id, Account_Contact__c> accountContactMap) {
        List<Account_Contact__c> result = new List<Account_Contact__c>();
        for (Account_Contact__c accountContact : accountContacts) {
            Account_Contact__c oldAccountContact = accountContactMap.get(accountContact.Id);
            if (isChanged(accountContact, oldAccountContact)) {
                result.add(oldAccountContact);
            }
        }
        return result;
    }

    private static Boolean isChanged(Account_Contact__c accountContact, Account_Contact__c oldAccountContact) {
        return accountContact.Account__c != oldAccountContact.Account__c || accountContact.Contact__c != oldAccountContact.Contact__c;
    }

}