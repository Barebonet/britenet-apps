import { LightningElement, api, wire } from 'lwc';
import getDetails from '@salesforce/apex/FA_CalloutService.getActorDetails';
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/messageChannelName__c';

export default class ActorModal extends LightningElement {
    @api actor;
    @api showActor;
    birthday;
    knownAs;
    biography;
    @wire(MessageContext) messageContext;

    connectedCallback() {
        getDetails({
            actorId: this.actor.id
        }).then(result => {
            this.birthday = result.birthday;
            this.knownAs = result.also_known_as;
            this.biography = result.biography;
        })
    }

    handleOpenedModal() {
        const payload = { booleanForActorModal: false };

        publish(this.messageContext, recordSelected, payload);
    }

    closeAllOpenedModals() {
        const payload = { booleanForActorModal: false, booleanForMovieModal: false };
        publish(this.messageContext, recordSelected, payload);
    }
}