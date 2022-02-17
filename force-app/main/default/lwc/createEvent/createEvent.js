import { LightningElement, track } from 'lwc';
import {createRecord} from 'lightning/uiRecordApi';

import EVENT_OBJECT from '@salesforce/schema/EventPro__c';
import Name__c from '@salesforce/schema/EventPro__c.Name__c';
import Event_Organizer__c from '@salesforce/schema/Event_Organizer__c';
import Start_DateTime__c from '@salesforce/schema/EventPro__c.Start_DateTime__c';
import End_DateTime__c from  '@salesforce/schema/EventPro__c.End_DateTime__c';
import 	Max_Seats__c from  '@salesforce/schema/EventPro__c.Max_Seats__c';
import 	Location_Address_Book__c from '@salesforce/schema/Location_Address_Book__c';
import Event_Detail__c from '@salesforce/schema/EventPro__c.Event_Detail__c';


import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class CreateEvent extends LightningElement {


@track eventRecord = {
    Name__c: '',
    Event_Organizer__c: '',
    Start_DateTime__c: null,
    End_DateTime__c: null,
    Max_Seats__c: null,
    Location_Address_Book__c: '',
    Event_Detail__c: ''
    }


    @track errors;

    handleChange(event){
        let value = event.target.value;
        let name = event.target.name;
        this.eventRecord[name] = value;
    }


    handleLookup(event){
        let selectRecId = event.detail.selectedRecordId;
        let parentField = event.detail.parentField;
        this.eventRecord[parentField] = selectRecId;
    }


    handleClick(){
        const fields = {};
        fields[Name__c.fieldApiName] = this.eventRecord.Name__c;
        fields[Event_Organizer__c.fieldApiName] = this.eventRecord.Event_Organizer__c;
        fields[Start_DateTime__c.fieldApiName] = this.eventRecord.Start_DateTime__c;
        fields[End_DateTime__c.fieldApiName] = this.eventRecord.End_DateTime__c;
        fields[Max_Seats__c.fieldApiName]= this.eventRecord.Max_Seats__c;
        fields[Location_Address_Book__c.fieldApiName] = this.eventRecord.Location_Address_Book__c;
        fields[Event_Detail__c.fieldApiName] = this.eventRecord.Event_Detail__c;

        const eventRecord = {
            apiName: EVENT_OBJECT.objectApiName,
            fields
        };


        createRecord(eventRecord)
        .then((eventRec) => {
            this.dispatchEvent(new ShowToastEvent({
              title: 'Record Saved',
              message: 'Event Draft is Ready',
              variant: 'success'
            }));

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    recordId: eventRec.id
                }
            });

        }).catch((err) => {
            this.errors = JSON.stringify(err);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error Occured',
                message: this.errors,
                variant: 'error'
            }));
        });
    }



    handleCancel(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                actionName: "home",
                objectApiName: "EventPro__c"
            }
        });
    }
}


