/**
 * Created by klevc on 2018-11-17.
 */

public with sharing class SharingByAccountService {

    public static void giveAccessToUsers(List<Account> accounts) {
        List<TerrUser__c> terrUsers = getUsersRelatedToAccounts(accounts);
        SharingUtil.giveAccessToRelatedRecords(terrUsers);
    }

    public static void removeAccessToContacts(List<Account> accounts) {
        List<TerrUser__c> relatedUsers = getUsersRelatedToAccounts(accounts);
        List<Account_Contact__c> relatedAccountContacts = SharingUtil.getRelatedContacts(accounts);

        SharingUtil.removeAccessToContacts(CollectionsUtil.getUsersIds(relatedUsers), CollectionsUtil.getContactIds(relatedAccountContacts));
    }

    private static List<TerrUser__c> getUsersRelatedToAccounts(List<Account> accounts) {
        List<Territory__c> accTerrs = TerritoryUtil.getTerritoriesById(CollectionsUtil.getTerritoriesIds(accounts));
        Set<Territory__c> terrsWithParents = TerritoryUtil.getTerritoriesWithParents(accTerrs);
        List<TerrUser__c> terrUsers = TerritoryUtil.getTerrUsers(CollectionsUtil.getTerritoriesIds(terrsWithParents));
        return terrUsers;
    }
    public static void giveAccessToUsers(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        List<Account> changedAccounts = getChangedAccounts(accounts, oldAccountsMap);

        SharingUtil.removeAccessToRelatedRecords(getUsersRelatedToAccounts(changedAccounts));
    }

    public static void removeAccessToUsers(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        List<Account> changedAccounts = getChangedAccounts(accounts, oldAccountsMap);

        giveAccessToUsers(changedAccounts);
    }

    private static List<Account> getChangedAccounts(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        List<Account> result = new List<Account>();

        for (Account account : accounts) {
            if (isChanged(account, oldAccountsMap)) {
                result.add(account);
                result.add(oldAccountsMap.get(account.Id));
            }
        }
        return result;
    }

    private static Boolean isChanged(Account account, Map<Id, Account> oldAccountsMap) {
        return account.Territory__c != oldAccountsMap.get(account.Id).Territory__c;
    }

}