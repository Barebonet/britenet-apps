/**
 * Created by bartosz.rozpara on 28.11.2022.
 */

import { LightningElement, track, api } from 'lwc';
import ID from '@salesforce/user/Id';
import addComment from '@salesforce/apex/FA_SoqlService.addRating';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AddComment extends LightningElement {
    @api productId;
    @api currentCom;
    @track comment = '';
    @track stars;
    userId = ID;
    commentList;

    connectedCallback() {
        if(this.currentCom !== undefined) {
            this.comment = this.currentCom.Name;
            this.stars = this.currentCom.Rating__c;
        } else {
            this.stars = 0;
        }
    }

    handleBodyChange(event) {
        this.comment = event.target.value
    }

    handleStarChange(event) {
        this.stars = event.detail.rating
    }

    handleAddComment() {
        if (this.comment.length === 0) {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: 'You have to type in a comment first!'
            });
            this.dispatchEvent(event);
        } else if (this.stars === 0) {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: 'You have to add rating first!'
            });
            this.dispatchEvent(event);
        } else {
            let commentId = this.currentCom !== undefined ? this.currentCom.Id : '';

            addComment({
                commentId: commentId,
                ownerId: this.userId,
                id: this.productId,
                description: this.comment,
                rating: this.stars
            }).then(result => {
                this.commentList = result;
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Comment Created",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                const refreshAddEvent = new CustomEvent("commentadded",{
                    detail: result
                });
                this.dispatchEvent(refreshAddEvent);
                this.comment = '';
                this.stars = 0;
            }).catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });
                this.dispatchEvent(event);
            })
        }
    }
}