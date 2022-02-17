@RestResource(urlMapping='/event-details/*')
global with sharing class WsEventDetails {
    

    @HttpGet
    global static List<EventDetail>  getEventDetails() {
        List<EventDetail> details = new List<EventDetail>();
        for(EventPro__c evt : [SELECT Id, Name, Event_Type__c, Frequency__c, Live__c, Start_DateTime__c, End_DateTime__c 
        FROM EventPro__c
        WHERE Live__c = true
        AND Start_DateTime__c >: Date.today()
        WITH SECURITY_ENFORCED
        ]
        ){
         
            details.add(new EventDetail(evt));
        }
      
        return details;
      
    }


    global class EventDetail{
        

        public String eventId;
        public String name;
        public String eventType;
        public String frequency;
        public Boolean live;
        public String startDate;
        public String endDate;

        public EventDetail(EventPro__c evt){
            this.eventId = evt.Id;
            this.name = evt.Name;
            this.eventType = evt.Event_Type__c;
            this.frequency = evt.Frequency__c;
            this.live = evt.Live__c;
            this.startDate = evt.Start_DateTime__c?.format('yyyy-MM-dd hh:MM');
            this.endDate = evt.End_DateTime__c?.format('yyyy-MM-dd hh:MM');
        }
    }


    }




//   for   workbench execution
// services/apexrest/event-details