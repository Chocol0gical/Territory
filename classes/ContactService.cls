/**
 * Created by klevc on 2018-11-12.
 */

public with sharing class ContactService {
    private static final Id DUMMY_ACCOUNT_ID = '0011t000007moUjAAI';

    public static void fillWithDummyAccount(List<Contact> contacts){
        for(Contact contact: contacts){
            contact.AccountId = DUMMY_ACCOUNT_ID;
        }
    }
}