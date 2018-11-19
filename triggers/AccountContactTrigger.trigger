/**
 * Created by klevc on 2018-11-09.
 */

trigger AccountContactTrigger on Account_Contact__c (after insert, after update, after delete, after undelete, before delete ) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            AccountContactHandler.onBeforeDelete(Trigger.old);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountContactHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            AccountContactHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            AccountContactHandler.onAfterDelete(Trigger.old);
        }
        if (Trigger.isUndelete) {
            AccountContactHandler.onAfterUndelete(Trigger.new);
        }
    }
}