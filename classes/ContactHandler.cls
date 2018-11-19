/**
 * Created by klevc on 2018-11-12.
 */

public with sharing class ContactHandler {
    public static void onBeforeInsert(List<Contact> contacts){
        ContactService.fillWithDummyAccount(contacts);
    }
}