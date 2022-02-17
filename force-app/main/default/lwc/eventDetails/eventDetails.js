import { LightningElement, api, track, wire } from 'lwc';
import {NavigationMixin } from "lightning/navigation";
import {encodeDefaultFieldValues} from "lightning/pageReferenceUtils";
import { getRecord } from 'lightning/uiRecordApi';


import getSpeakers from "@salesforce/apex/EventDetailsController.getSpeakers";
import getLocationDetails from "@salesforce/apex/EventDetailsController.getLocationDetails";
import getAttendees from "@salesforce/apex/EventDetailsController.getAttendees";

import userId from "@salesforce/user/Id";
import profile from "@salesforce/schema/User.Profile.Name";



const COLUMNS = [

    {
        label: "Name",
        fieldName: "Name",
        collAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },

    {
        label: "Email",
        fieldName: "Email",
        type: "email"
    },
    {
        label: "Company Name",
        fieldName: "CompanyName"
    },
    {
      label: "Location",
      fieldName: "Location",
      cellAttributes: {
          iconname: "utility:location",
          iconPosition: "left"
      }
    }
];

export default class EventDetails extends LightningElement {

@api recordId;


@track speakerList;
@track eventRec;
@track attendeesList;
@track isAdmin = false;


errors;
columnsList = COLUMNS;
user_id = userId;


@wire(getRecord, {recordId: "$user_id", fields: [profile]})
wiredMethod({error, data}){
    if(data){
        window.console.log("userRecord: ", JSON.stringify(data));
        let userProfileName = data.fields.Profile.displayValue;
        console.log("userProfileName:" + userProfileName);
        this.isAdmin = userProfileName === "System Administrator";
    }
    if(error){
        console.log("Error Occured ", JSON.stringify(error));
    }
}


handleSpeakerActive(){
    getSpeakers({
        eventId: this.recordId
    })
    .then((result) => {
        result.forEach((speaker) => {
            speaker.Name = speaker.Speaker__r.Name;
            speaker.Email = "**********@gmail.com";
            speaker.Phone = speaker.Speaker__r.Phone__c;
            speaker.Picture__c = speaker.Speaker__r.About_Me__c;
            speaker.CompanyName = speaker.Speaker__r.Company__c;
        });
        this.speakerList = result;
        window.console.log("result",JSON.stringify(this.result));

        this.errors = undefined;
    })
    .catch((err) => {
        this.errors = err;
        this.speakerList = undefined;
        window.console.log("Err:",this.errors);
    });
}


handleLocationDetails(){
    getLocationDetails({
        eventId: this.recordId
    })
    .then((result) => {
        if(result.Location__c){
            this.eventRec = result;
        } else {
            this.eventRec = undefined;
        }

        this.errors = undefined;
    })
    .catch((err) => {
        this.errors = err;
        this.speakerList = undefined;
    });
}


handleEventAttendee(){
    getAttendees({
        eventId: this.recordId
    })
    .then((result) => {
        result.forEach((att) => {
            att.Name = att.Attendee__r.Name;
            att.Email ="**********@gmail.com";
            att.CompanyName = att.Attendee__r.Company_Name__c;
            
            if(att.Attendee__r.Location__c){
                att.Location__c = att.Attendee__r.Location__r.Name;
            } else {
                att.Location = "Preferred Not to Say";
            }
        });

        this.attendeesList = result;
        this.errors = undefined;
    })
    .catch((err) => {
        this.errors = err;
        this.speakerList = undefined;
    });
    
}

createSpeaker(){
    const defaultValues = encodeDefaultFieldValues({
        EventPro__c: this.recordId
    });

    this[NavigationMixin.Navigate]({
        type: "standard__objectPage",
        attributes: {
            objectApiName: "Event_Speaker__c",
            actionName: "new"
        },
        state: {
            defaultFieldValues: defaultValues
        }
    });
}


createAttendee(){
    const defaultValues = encodeDefaultFieldValues({
        Event__c: this.recordId
    });

    this[NavigationMixin.Navigate]({
        type: "standard__objectPage",
        attributes: {
            objectApiName: "Event_Attendee__c",
            actionName: "new"
        },
        state: {
            defaultFieldValues: defaultValues
        }
    });
}






}