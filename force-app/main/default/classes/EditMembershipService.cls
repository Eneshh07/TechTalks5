public with sharing class EditMembershipService {
  
@AuraEnabled
public static List<MemberWrapper>  findEvents(String attendeeId ,String selection){
    List<MemberWrapper> memberInfo = new List<MemberWrapper>();

    List<EventPro__c> events = [SELECT Id, Location__c,Location__r.Name,Organizer__c,
                                  Organizer__r.Name,Name__c,Start_DateTime__c,
                                  (SELECT Id, Name FROM Event_Attendees__r WHERE Attendee__c =: attendeeId)
                                  FROM EventPro__c
                                  WHERE  Live__c = true
                                   WITH SECURITY_ENFORCED
    ];

    for(EventPro__c eve : events){
        MemberWrapper wrapper = new MemberWrapper();
        wrapper.isMember =  eve.Event_Attendees__r.size()  > 0;
        wrapper.event = eve;
        wrapper.eventId = eve.Id;
        wrapper.eventAttendeee = wrapper.isMember ? eve.Event_Attendees__r[0] : null;
        if(selection.equalsIgnoreCase('delete')){
            memberInfo.add(wrapper);
        }
        else if(selection.equalsIgnoreCase('insert')){
            memberInfo.add(wrapper);
        }
    }
    return memberInfo;
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
