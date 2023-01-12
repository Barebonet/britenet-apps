import { LightningElement, track } from 'lwc';
import getCarRatings from '@salesforce/apex/CR_RatingController.getCarRatings';
import getAvgRating from '@salesforce/apex/CR_RatingController.getAverageRating';

export default class CommentList extends LightningElement {
    @track
    carId;
    @track
    commentsList =[];
    @track
    avgRating = 0;

    connectedCallback() {
        this.getProductIdFromURL();
        this.getRatings();
    }

    getProductIdFromURL() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.carId = urlParams.get('Id');
    }

    getRatings() {
        getCarRatings({
            carId: this.carId
        }).then(result => {
            this.commentsList = result;
            console.log(JSON.stringify(this.commentsList));
            getAvgRating({
                carId: this.carId
            }).then(avg => {
                this.avgRating = avg;
            })
        })
    }

    handleCommentAdded() {
        this.getRatings;
    }
}