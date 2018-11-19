/**
 * Created by klevc on 2018-11-17.
 */

public with sharing class AccountContactHandler {
    public static void onAfterInsert(List<Account_Contact__c> accountContacts) {
        SharingByAccountContactService.giveAccessToUsers(accountContacts);
    }

    public static void onAfterDelete(List<Account_Contact__c> accountContacts) {
        SharingByAccountContactService.giveAccessToUsers(accountContacts);
    }

    public static void onBeforeDelete(List<Account_Contact__c> accountContacts) {
        SharingByAccountContactService.removeAccessFromUsers(accountContacts);
    }

    public static void onAfterUndelete(List<Account_Contact__c> accountContacts) {
        SharingByAccountContactService.giveAccessToUsers(accountContacts);
    }

    public static void onAfterUpdate(List<Account_Contact__c> accountContacts, Map<Id, Account_Contact__c> oldAccountContactsMap) {
        SharingByAccountContactService.recountAccess(accountContacts, oldAccountContactsMap);
    }

}