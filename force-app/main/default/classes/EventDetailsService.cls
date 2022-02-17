public with sharing class EventDetailsService {


@AuraEnabled
public static List<EventPro__c> upcomingEvents(){
    return [SELECT Id, Name, Name__c, Event_Detail__c,Location__c,Location__r.Name,
    Organizer__c,Start_DateTime__c,Organizer__r.Name
    FROM EventPro__c
    WHERE Start_DateTime__c >= TODAY
    AND Live__c = true
    WITH SECURITY_ENFORCED
    ];
}


@AuraEnabled
public static List<EventPro__c> searchByKeyword(String name){
    String nameLike = '%' + name + '%';

    return [SELECT Id, Name, Name__c, Event_Detail__c,Location__c,Location__r.Name,
    Organizer__c,Start_DateTime__c,Organizer__r.Name
    FROM EventPro__c
    WHERE Start_DateTime__c >= TODAY
    AND Name__c LIKE :nameLike
    WITH SECURITY_ENFORCED
    ];
}



}