/**
 * Created by klevc on 2018-11-09.
 */

trigger TerritoryTrigger on Territory__c (before insert, before update, before delete, after insert, after delete, after update, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TerritoryHandler.onBeforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            TerritoryHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }

        if (Trigger.isDelete) {
            TerritoryHandler.onBeforeDelete(Trigger.old);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TerritoryHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            TerritoryHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            TerritoryHandler.onAfterDelete(Trigger.old);

        }
        if (Trigger.isUndelete) {
            TerritoryHandler.onAfterUndelete(Trigger.new);
        }
    }
}