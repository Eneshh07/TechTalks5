public with sharing class AttendeeEventsService {
    
@AuraEnabled
public static List<MemberWrapper> upcomingEvents(String attendeeId){

    List<EventPro__c> events = [SELECT Id, Location__c,Location__r.Name,Organizer__c,
    Organizer__r.Name,Name__c,Start_DateTime__c,
    (SELECT Id, Name FROM Event_Attendees__r WHERE Attendee__c =: attendeeId)
    FROM EventPro__c
    WHERE Start_DateTime__c >= TODAY
    AND Live__c = true
    WITH SECURITY_ENFORCED
    ];

    List<MemberWrapper> memberInfo = new List<MemberWrapper>();
    for(EventPro__c eve : events){
        MemberWrapper wrapper = new MemberWrapper();
        wrapper.isMember =  eve.Event_Attendees__r.size()  > 0;
        wrapper.event = eve;
        wrapper.eventId = eve.Id;
        wrapper.eventAttendeee = wrapper.isMember ? eve.Event_Attendees__r[0] : null;

        memberInfo.add(wrapper);
    }

return memberInfo;

/*
    return [SELECT Id,Name,Event__c,Event__r.Location__c,Event__r.Location__r.Name,
    Event__r.Organizer__c,Event__r.Organizer__r.Name,
    Event__r.Name__c,Event__r.Start_DateTime__c
    FROM Event_Attendee__c
    WHERE 	Attendee__c = :attendeeId
    AND Event__r.Start_DateTime__c >= TODAY
    AND Event__r.Live__c = true
    WITH SECURITY_ENFORCED
    ];
   */
}


@AuraEnabled
public static List<Event_Attendee__c> pastEvents(String attendeeId){
    return [SELECT Id, Name,Event__c,Event__r.Location__c,Event__r.Location__r.Name,
    Event__r.Organizer__c,Event__r.Organizer__r.Name,Event__r.Name__c,Event__r.Start_DateTime__c
    FROM Event_Attendee__c
    WHERE 	Attendee__c = :attendeeId
    AND Event__r.Start_DateTime__c < TODAY
    WITH SECURITY_ENFORCED
    ];
   
}

public class MemberWrapper{
    @AuraEnabled
    public Boolean isMember;

    @AuraEnabled
    public String eventId;

    @AuraEnabled
    public Event_Attendee__c eventAttendeee;

    @AuraEnabled
    public EventPro__c event;
}

}
