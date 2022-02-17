import { LightningElement, api, track } from 'lwc';
import upcomingEvents from '@salesforce/apex/AttendeeEventsService.upcomingEvents';
import pastEvents from "@salesforce/apex/AttendeeEventsService.pastEvents";

const COLUMNS = [
    {
         label: "Event Name",
         fieldName: "detailsPage",
         type: "url",
         wrapText: "true",
         typeAttributes: {
             label: {
                 fieldName: "Name"
             }
         }
    },
    {
        label: "Name",
        fieldName: "EVNTORG",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label: "Event Date",
        fieldName: "StartDateTime",
        type: "date",
        typeAttributes: {
            weekday: "long",
            year: "numeric",
            month: "long"
        }
    },
    {
        label: "Location",
        fieldName: "Location",
        type: "text",
        cellAttributes : {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
];


export default class AttEvents extends LightningElement {

@api recordId;
selectedEvents;
events;
pastEvents;


columnsList = COLUMNS;
errors;
retrievedRecordId = false;


renderedCallback(){
    console.log("renderedCallback");
    if(!this.retrievedRecordId && this.recordId){
        //Escape case from recursion
        this.retrievedRecordId = true;
  
        console.log("found recordId:" +this.recordId);
         
        this.upcomingEventsFromApex();
        this.pastEventsFromApex();
    }
}

   upcomingEventsFromApex(){
       upcomingEvents({
           attendeeId: this.recordId
       })
       .then((result) => {
           console.log("result:" + JSON.stringify(result));

           this.events = [];
           this.selectedEvents = [];
           result.forEach((record) => {
               let obj = new Object();
               obj.Id = record.eventId;
               obj.name = record.event.Name__c;
               obj.detailsPage = "https://" + window.location.host + "/" + record.event.Id;
               obj.EVNTORG = record.event.Organizer__r.Name;
               obj.StartDateTime = record.event.Start_DateTime__c;


               if(record.Event__r.Location__c){
                   obj.Location = record.event.Location__r.Name;
               } else {
                   obj.Location = "This is a virtual event";
               }
               this.events.push(obj);

               if(record.isMember) this.selectedEvents.push(obj.Id);
           });

           //this.events = result;
           this.errors = undefined;
       })
       .catch((error) => {
           this.events = undefined;
           this.errors = JSON.stringify(error);
       });
   }


  pastEventsFromApex(){
    pastEvents({
        attendeeId: this.recordId
    })
    .then((result) => {
           result.forEach((record) => {
            record.name = record.Event__r.Name__c;
            record.detailsPage = "https://" + window.location.host + "/" + record.Event__c;
            record.EVNTORG = record.Event__r.Organizer__r.Name;
            record.StartDateTime = record.Event__r.Start_DateTime__c;


            if(record.Event__r.Location__c){
                record.Location = record.Event__r.Location__r.Name;
            } else {
                record.Location = "This is a virtual event";
            }
        });
        this.pastEvents = result;
        this.errors = undefined;
    })
    .catch((error) => {
        this.pastEvents = undefined;
        this.errors = JSON.stringify(error);
    });
}
}