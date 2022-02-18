import { LightningElement,api } from 'lwc';
import findEvents from "@salesforce/apex/EditMembershipService.findEvents";


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


export default class EditMembership extends LightningElement {

    @api recordId;
    @api selection;    //add or clear meaning insert or delete

    events;
    columnsList = COLUMNS;

    retrievedRecordId = false;

    renderedCallback(){
        if(!this.retrievedRecordId && this.recordId){
            console.log("recordId:" + this.recordId);
            console.log("selection:" + this.selection);
            //Escape case from recursion
            this.retrievedRecordId = true;
      
            console.log("found recordId:" +this.recordId);
             
            this.workOnEvent();
        }
    }
    workOnEvent(){
        findEvents({
            attendeeId: this.recordId,
            selection: this.selection
        })
        .then((result) => {
            console.log("result:" + JSON.stringify(result));
 
            this.events = [];
            result.forEach((record) => {
                let obj = new Object();
                obj.Id = record.eventId;
                obj.name = record.event.Name__c;
                obj.detailsPage = "https://" + window.location.host + "/" + record.event.Id;
                obj.EVNTORG = record.event.Organizer__r.Name;
                obj.StartDateTime = record.event.Start_DateTime__c;
 
 
                if(record.event.Location__c){
                    obj.Location = record.event.Location__r.Name;
                } else {
                    obj.Location = "This is a virtual event";
                }
                this.events.push(obj);
            });
 
            //this.events = result;
            this.errors = undefined;
        })
        .catch((error) => {
            this.events = undefined;
            this.errors = JSON.stringify(error);
        });
    }
}