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
    deathDay;
    @wire(MessageContext) messageContext;

    connectedCallback() {
        getDetails({
            actorId: this.actor.id
        }).then(result => {
            this.birthday = result.birthday;
            this.knownAs = result.also_known_as;
            this.biography = result.biography;
            this.deathDay = result.deathday;
        })
    }

    handleCloseModal() {
        const event = new CustomEvent("closeactormodal", {
            detail: false
        });
        this.dispatchEvent(event);
    }

    closeAllOpenedModals() {
        const payload = { booleanForActorModal: false, booleanForMovieModal: false };
        publish(this.messageContext, recordSelected, payload);
    }
}