/**
 * Created by bartosz.rozpara on 24.11.2022.
 */

import { LightningElement, api, track, wire } from 'lwc';
import {
    publish,
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/messageChannelName__c';

export default class ActorTile extends LightningElement {
    @api actor;
    @track actorDetailsVisible = false;
    subscription = null;
    @wire(MessageContext)
    messageContext;

    toggleActorDetails() {
        this.actorDetailsVisible = !this.actorDetailsVisible;
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
        this.actorDetailsVisible = message.booleanForActorModal;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }
}