import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import editRating from '@salesforce/apex/CR_RatingController.editRating';
import deleteRating from '@salesforce/apex/CR_RatingController.deleteRating';
import Id from '@salesforce/user/Id';
import DeleteAffirmation from '@salesforce/label/c.DeleteAffirmation';
import Edit from '@salesforce/label/c.Edit';
import Delete from '@salesforce/label/c.Delete';
import Close from '@salesforce/label/c.Close';

export default class CarCommentTile extends LightningElement {
    @api
    comment = {}
    commentDescription = '';
    commentStars = 0;
    @track sameUser = false;
    userId = Id;
    @track deletePrompt = false;
    @track editRating = false;

    label = {
        DeleteAffirmation,
        Edit,
        Delete,
        Close
    }

    connectedCallback() {
        if(this.comment.CreatedById === this.userId) {
            this.sameUser = true;
            this.commentStars = this.comment.Rating__c;
            this.commentDescription = this.comment.Description__c;
        }
    }

    handleDeleteRating() {
        deleteRating({
            commentId: this.comment.Id
        }).then(result => {
            if(result === 'SUCCESS') {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Comment Deleted",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                const refreshAddEvent = new CustomEvent("commentdeleted",{
                    detail: {}
                });
                this.dispatchEvent(refreshAddEvent);
            } else {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
    }

    handleEditComment() {
        console.log(this.comment.Id);
        console.log(this.commentDescription);
        console.log(this.commentStars);
        editRating({
            id: this.comment.Id,
            description: this.commentDescription,
            rating: this.commentStars
        }).then(result => {
            console.log(result);
            if(result === 'SUCCESS') {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Comment Edited",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                const refreshComments = new CustomEvent("commentedited",{
                    detail: {}
                });
                this.dispatchEvent(refreshComments);
                this.toggleEditRating();
            } else {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        }).catch(err => {
            console.log(err);
        })
    }

    toggleDeletePrompt() {
        this.deletePrompt = !this.deletePrompt;
    }

    toggleEditRating() {
        this.editRating = !this.editRating;
    }

    handleBodyChange(event) {
        this.commentDescription = event.target.value
    }

    handleStarChange(event) {
        this.commentStars = event.detail.rating
    }
}