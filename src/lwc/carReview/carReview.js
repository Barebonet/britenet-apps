import { LightningElement, track } from 'lwc';
import getReviewLink from '@salesforce/apex/ProductController.getReviewLink';

export default class CarReview extends LightningElement {
    carId;
    @track
    reviewLink;

    connectedCallback() {
        this.getProductIdFromURL();
        this.getCarReview()
    }

    getProductIdFromURL() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.carId = urlParams.get('Id');
    }

    getCarReview() {
        getReviewLink({
            carId: this.carId
        }).then(result => {
            this.reviewLink = result.Review__c
        })
    }
}