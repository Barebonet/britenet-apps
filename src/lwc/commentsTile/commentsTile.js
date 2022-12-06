/**
 * Created by bartosz.rozpara on 28.11.2022.
 */

import { LightningElement, api, track } from 'lwc';
import deleteComment from '@salesforce/apex/FA_SoqlService.deleteRating';
import userName from '@salesforce/schema/User.Name';

export default class CommentsTile extends LightningElement {
    @api comment;
    @track commentList;
    @track showComments = false;
    @track buttonVisible = false;
    @track temp = true;

    connectedCallback() {
        this.buttonVisible = this.comment.author === userName;
    }

    handleDeleteCommand() {
        deleteComment({
            id: this.comment.Id,
            owner: this.comment.author
        }).then(result => {
            const refreshEvents = new CustomEvent("deletedOpinion",{
                detail:result
            });
            this.dispatchEvent(refreshEvents);
        })
    }
}