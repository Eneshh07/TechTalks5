trigger EvenSpeakerTrigger on Event_Speaker__c (before insert,before update,after insert,after update) {

    if(trigger.isBefore && trigger.isInsert){
        List<Event_Speaker__c> newESList = trigger.new;
        EventSpeakerHandler.rejectDuplicateBookings(newESList);
    }

}