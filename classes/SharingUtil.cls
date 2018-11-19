/**
 * Created by klevc on 2018-11-15.
 */

public with sharing class SharingUtil {
    private static final String ACCESS_LEVEL_EDIT = 'Edit';
    private static final String RAW_CAUSE = 'Manual';

    public static void giveAccessToRelatedRecords(List<TerrUser__c> terrUsers) {
        Set<Territory__c> relatedTerritories = TerritoryUtil.getTerritoriesWithChildren(terrUsers);
        List<Account> relatedAccounts = SharingUtil.getRelatedAccounts(relatedTerritories);
        List<Account_Contact__c> relatedContacts = SharingUtil.getRelatedContacts(relatedAccounts);

        List<AccountShare> accountShares = new List<AccountShare>();
        List<ContactShare> contactShares = new List<ContactShare>();

        for (TerrUser__c terrUser : terrUsers) {
            Set<Id> userTerritories = TerritoryUtil.getUserTerritoriesIds(terrUser, relatedTerritories);
            Set<Id> userAccounts = SharingUtil.getUserAccountsIds(userTerritories, relatedAccounts);
            SharingUtil.addAccountsToShares(terrUser.User__c, accountShares, userAccounts);
            Set<Id> userContacts = SharingUtil.getUserContactIds(userAccounts, relatedContacts);
            SharingUtil.addContactsToShares(terrUser.User__c, contactShares, userContacts);
        }

        insert accountShares;
        insert contactShares;
    }

    public static void removeAccessToRelatedRecords(List<TerrUser__c> terrUsers) {
        Set<Territory__c> relatedTerritories = TerritoryUtil.getTerritoriesWithChildren(terrUsers);
        List<Account> relatedAccounts = SharingUtil.getRelatedAccounts(relatedTerritories);
        List<Account_Contact__c> relatedContacts = SharingUtil.getRelatedContacts(relatedAccounts);

        SharingUtil.removeAccessToAccounts(CollectionsUtil.getUsersIds(terrUsers), CollectionsUtil.getIds(relatedAccounts));
        SharingUtil.removeAccessToContacts(CollectionsUtil.getUsersIds(terrUsers), CollectionsUtil.getContactIds(relatedContacts));
    }

    public static void addAccountsToShares(Id userId, List<AccountShare> accountShares, Set<Id> userAccounts) {
        for (Id accountId : userAccounts) {
            accountShares.add(new AccountShare(AccountId = accountId,
                    UserOrGroupId = userId,
                    AccountAccessLevel = ACCESS_LEVEL_EDIT,
                    OpportunityAccessLevel = ACCESS_LEVEL_EDIT));
        }
    }

    public static void addContactsToShares(Id userId, List<ContactShare> accountShares, Set<Id> userContacts) {
        for (Id contactId : userContacts) {
            accountShares.add(new ContactShare(ContactId = contactId,
                    UserOrGroupId = userId,
                    ContactAccessLevel = ACCESS_LEVEL_EDIT));
        }
    }

    public static Set<Id> getUserContactIds(Set<Id> accounts, List<Account_Contact__c> relatedContacts) {
        Set<Id> userContacts = new Set<Id>();
        for (Account_Contact__c contact : relatedContacts) {
            if (accounts.contains(contact.Account__c)) userContacts.add(contact.Contact__c);
        }
        return userContacts;
    }

    public static Set<Id> getUserAccountsIds(Set<Id> terrs, List<Account> relatedAccounts) {
        Set<Id> userAccounts = new Set<Id>();
        for (Account account : relatedAccounts) {
            if (terrs.contains(account.Territory__c)) userAccounts.add(account.Id);
        }
        return userAccounts;
    }

    public static void updateTheRestOfUsersTerritories(List<TerrUser__c> terrUsers) {
        List<TerrUser__c> restOfTerrUsers = [
                SELECT User__c, Territory__c
                FROM TerrUser__c
                WHERE User__c IN:CollectionsUtil.getUsersIds(terrUsers)
        ];

        if (!restOfTerrUsers.isEmpty()) {
            giveAccessToRelatedRecords(restOfTerrUsers);
        }
    }


    public static List<TerrUser__c> getRelatedUsers(Set<Id> territoryIds) {
        return [
                SELECT Territory__c, User__c
                FROM TerrUser__c
                WHERE Territory__c IN:territoryIds
        ];
    }

    public static void removeAccessToAccounts(Set<Id> userIds, Set<Id> accIds) {
        List<AccountShare> accountShares = [
                SELECT Id
                FROM AccountShare
                WHERE UserOrGroupId IN :userIds
                AND AccountId IN :accIds
                AND RowCause = :RAW_CAUSE
        ];

        if (!accountShares.isEmpty()) {
            delete accountShares;
        }
    }


    public static void removeAccessToContacts(Set<Id> userIds, Set<Id> contactIds) {
        List<ContactShare> contactShares = [
                SELECT Id
                FROM ContactShare
                WHERE UserOrGroupId IN :userIds
                AND ContactId IN :contactIds
                AND RowCause = :RAW_CAUSE
        ];

        if (!contactShares.isEmpty()) {
            delete contactShares;
        }
    }


    public static List<Account> getRelatedAccounts(Set<Territory__c> territories) {
        Set<Id> territoriesIds = CollectionsUtil.getTerritoriesIds(territories);
        return [
                SELECT Territory__c, Name
                FROM Account
                WHERE Territory__c IN :territoriesIds
        ];
    }

    public static List<Account_Contact__c> getRelatedContacts(List<Account> accounts) {
        Set<Id> ids = CollectionsUtil.getIds(accounts);
        return [
                SELECT Account__c, Contact__c
                FROM Account_Contact__c
                WHERE Account__c IN :ids
        ];
    }
}