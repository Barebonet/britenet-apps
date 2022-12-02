/**
 * Created by bartosz.rozpara on 24.11.2022.
 */

import {LightningElement, api, track, wire } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/messageChannelName__c';
import getAvgRating from '@salesforce/apex/FA_SoqlService.getAverageRating';

export default class MovieTile extends LightningElement {
    @api movie;
    @track movieDetailsVisible = false;
    @track buttonVisible = false;
    @wire(MessageContext)
    messageContext;
    @track refreshValue;
    @track avgRating;

    toggleMovieDetails() {
        this.movieDetailsVisible = !this.movieDetailsVisible;
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                recordSelected,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        this.movieDetailsVisible = message.booleanForMovieModal;
    }

    handleRefresh() {
        this.refreshValue = 'Refresh';
        const event = new CustomEvent('refresh', {
            detail: this.refreshValue,
            bubbles: true
        })
        this.dispatchEvent(event);
    }

    getAvgRating() {
        getAvgRating({
            id: this.movie.id
        }).then(result => {
            this.avgRating = result;
        })
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.getAvgRating();
    }
}