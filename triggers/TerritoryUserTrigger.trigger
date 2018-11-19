/**
 * Created by klevc on 2018-11-09.
 */

trigger TerritoryUserTrigger on TerrUser__c (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TerritoryUserHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            TerritoryUserHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            TerritoryUserHandler.onAfterDelete(Trigger.old);
        }
        if (Trigger.isUndelete) {
            TerritoryUserHandler.onAfterUndelete(Trigger.new);
        }
    }
}