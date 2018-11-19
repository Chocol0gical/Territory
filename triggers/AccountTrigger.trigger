/**
 * Created by klevc on 2018-11-09.
 */

trigger AccountTrigger on Account (before update, before delete, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            AccountTriggerHandler.onBeforeDelete(Trigger.old);
        }
        if (Trigger.isUpdate) {
            AccountTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }


    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isDelete) {
            AccountTriggerHandler.onAfterDelete(Trigger.old);
        }
        if (Trigger.isUpdate) {
            AccountTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isUndelete) {
            AccountTriggerHandler.onAfterUndelete(Trigger.new);
        }

    }
}