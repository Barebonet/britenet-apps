/**
 * Created by bartosz.rozpara on 25.11.2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/messageChannelName__c';
import getRatings from '@salesforce/apex/FA_SearchService.searchReviews';
import avgRating from '@salesforce/apex/FA_SoqlService.getAverageRating';
import addToFav from '@salesforce/apex/FA_SoqlService.addToFavourites';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import checkIfFav from '@salesforce/apex/FA_SoqlService.checkIfFavorite';
import deletFav from '@salesforce/apex/FA_SoqlService.deleteFromFavorites';
import addToBlacklist from '@salesforce/apex/FA_SoqlService.addToBlacklist';
import deleteFromBlacklist from '@salesforce/apex/FA_SoqlService.deleteFromBlacklist';
import checkIfBlacklist from '@salesforce/apex/FA_SoqlService.checkIfBlacklist';

export default class MovieModal extends LightningElement {
    @api movie;
    @track rating = 0.0;
    @track showComments = false;
    @track commentList;
    @wire(MessageContext) messageContext;
    @track isFavourite = false;
    @track isBlacklisted = false;
    @track refreshValue = '';

    connectedCallback() {
        this.handleDeleteCommand()
        console.log(this.movie.id);
        checkIfFav({
            movieId: this.movie.id
        }).then(result => {
            this.isFavourite = result
        })
        checkIfBlacklist({
            movieId: this.movie.id
        }).then(result => {
            this.isBlacklisted = result
        })
    }

    handleDeleteCommand() {
        this.getAvgRatings()
        this.refreshRatings()
    }

    refreshRatings() {
        getRatings({
            movieId: this.movie.id
        }).then(result => {
            this.commentList = result.results;
            this.showComments = this.commentList.length !== 0;
        })
    }

    getAvgRatings() {
        avgRating({
            id: this.movie.id
        }).then(result => {
            this.rating = result;
            console.log(this.rating);
        })
    }

    handleOpenedModals() {
        const payload = {booleanForModal: false, booleanForActorModal: false};
        publish(this.messageContext, recordSelected, payload);
    }

    handleAddComment() {
        this.refreshRatings();
        this.getAvgRatings();
    }

    handleAddToFav() {
        addToFav({
            movieId: this.movie.id,
            poster_path: this.movie.poster_path,
            releaseDate: this.movie.release_date,
            originalTitle: this.movie.original_title,
            overview: this.movie.overview,
            title: this.movie.title
        }).then(result => {
            this.isFavourite = true;
            this.isBlacklisted = false;
            this.handleRefreshComponents();
            const event = new ShowToastEvent({
                variant: 'success',
                message: 'Added to favorites.'
            });
            this.dispatchEvent(event);
        })
    }

    handleDeleteFromFav() {
        deletFav({
            movieId: this.movie.id
        }).then(result => {
            this.isFavourite = false;
            this.handleRefreshComponents();
            const event = new ShowToastEvent({
                variant: 'success',
                message: 'Deleted from favorites.'
            });
            this.dispatchEvent(event);
        })
    }

    handleAddToBlacklist() {
        addToBlacklist({
            movieId: this.movie.id,
            poster_path: this.movie.poster_path,
            releaseDate: this.movie.release_date,
            originalTitle: this.movie.original_title,
            overview: this.movie.overview,
            title: this.movie.title
        }).then(result => {
            this.isFavourite = false;
            this.isBlacklisted = true;
            this.handleRefreshComponents();
            const event = new ShowToastEvent({
                variant: 'success',
                message: 'Added to blacklist.'
            });
            this.dispatchEvent(event);
        })
    }

    async handleDeleteFromBlacklist() {
        deleteFromBlacklist({
            movieId: this.movie.id
        }).then(result => {
            this.isBlacklisted = false;
            this.handleRefreshComponents();
            const event = new ShowToastEvent({
                variant: 'success',
                message: 'Deleted from blacklist.'
            });
            this.dispatchEvent(event);
        })
    }

    handleRefreshComponents() {
        this.refreshValue = 'Refresh';
        const event = new CustomEvent('refresh', {
            detail: this.refreshValue,
            bubbles: true
        })
        this.dispatchEvent(event);
    }
}