/**
 * Created by bartosz.rozpara on 23.11.2022.
 */

import { LightningElement, track } from 'lwc';
import searchActors from '@salesforce/apex/FA_SearchService.searchActors';
import getPopularActors from '@salesforce/apex/FA_CalloutService.getPopularActors';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SearchActor extends LightningElement {
    actorName = '';
    @track actorList;

    connectedCallback(){
        getPopularActors()
            .then(result => {
                this.actorList = result
            })
    }

    searchActor(event) {
        this.actorName = event.target.value;
    }

    search() {
        if(this.actorName !== '') {
            searchActors({
                actorName: this.actorName
            })
                .then(result => {
                    this.actorList = result;
                })
                .catch(error => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                })
        } else {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Actor name blank!',
            });
            this.dispatchEvent(event);
        }
    }
}