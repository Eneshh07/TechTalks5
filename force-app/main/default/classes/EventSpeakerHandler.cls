public with sharing class EventSpeakerHandler {
    public static void rejectDuplicateBookings (List<Event_Speaker__c> newList) {
        List<Event_Speaker__c> esRecords = [select id,EventPro__c,Speaker__c from Event_Speaker__c];

        for(Event_Speaker__c each : newList){
            for(Event_Speaker__c existing : esRecords){

                if(each.EventPro__c == existing.EventPro__c && each.Speaker__c ==existing.Speaker__c){
                    each.addError('You cannot create duplicate record!!!Speaker has already same Event!!!');
                }
            }
        }

    }
}
