/**
 * Created by klevc on 2018-11-12.
 */

trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactHandler.onBeforeInsert(Trigger.new);
        }
    }
}