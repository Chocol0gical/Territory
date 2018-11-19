/**
 * Created by klevc on 2018-11-16.
 */

public with sharing class AccountTriggerHandler {

    public static void onAfterInsert(List<Account> accounts) {
        SharingByAccountService.giveAccessToUsers(accounts);
    }

    public static void onAfterUpdate(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        SharingByAccountService.removeAccessToUsers(accounts, oldAccountsMap);
    }

    public static void onBeforeUpdate(List<Account> accounts, Map<Id, Account> oldAccountsMap) {
        SharingByAccountService.giveAccessToUsers(accounts, oldAccountsMap);
    }

    public static void onAfterUndelete(List<Account> accounts) {
        SharingByAccountService.giveAccessToUsers(accounts);
    }

    public static void onAfterDelete(List<Account> accounts) {
        SharingByAccountService.giveAccessToUsers(accounts);
    }
    public static void onBeforeDelete(List<Account> accounts) {
        SharingByAccountService.removeAccessToContacts(accounts);
    }
}