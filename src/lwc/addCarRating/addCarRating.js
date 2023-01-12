import { api, LightningElement, track } from 'lwc';
import ID from '@salesforce/user/Id';
import addRating from '@salesforce/apex/CR_RatingController.addRating';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import isGuest from '@salesforce/user/isGuest';
import Submit from '@salesforce/label/c.Submit';
import TypeOpinion from '@salesforce/label/c.Type_here_your_opinion';
import ShareOpinion from '@salesforce/label/c.Please_share_a_short_opinion';
import PleaseLogIn from '@salesforce/label/c.To_add_comment_please_log_in';

export default class AddCarRating extends LightningElement {
    @api carId;
    @track comment = '';
    @track stars = 0;
    userId = ID;
    isGuestUser = isGuest;

    label = {
        Submit,
        TypeOpinion,
        ShareOpinion,
        PleaseLogIn
    }

    handleBodyChange(event) {
        this.comment = event.target.value
    }

    handleStarChange(event) {
        this.stars = event.detail.rating
    }

    handleAddComment() {
        if(!this.isGuestUser) {
            addRating({
                ownerId: this.userId,
                id: this.carId,
                description: this.comment,
                rating: this.stars
            }).then(()=>{
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Comment Created",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                const refreshAddEvent = new CustomEvent("commentadded",{});
                this.dispatchEvent(refreshAddEvent);
                this.comment = '';
                this.stars = 0;
            })
        } else {
            const errorEvt = new ShowToastEvent({
                title: 'Error',
                message: "You have to be logged in to add a comment!",
                variant: 'error'
            });
            this.dispatchEvent(errorEvt);
        }
        
    }
}