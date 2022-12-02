/**
 * Created by bartosz.rozpara on 25.11.2022.
 */

import { LightningElement, api, track } from 'lwc';

export default class ViewModal extends LightningElement {
    @api actor;
    @api movie;
    @api showMovie = false;
    @api showActor = false;
    @track refreshValue;

    toggleDetails() {
        this.showMovie = false;
        this.showActor = false;
    }

    handleRefresh() {
        this.refreshValue = 'Refresh';
        const event = new CustomEvent('refresh', {
            detail: this.refreshValue,
            bubbles: true
        })
        this.dispatchEvent(event);
    }

    handleCloseMovieModal(event) {
        this.showMovie = event.detail;
    }

    handleCloseActorModal(event) {
        this.showActor = event.detail;
    }
}