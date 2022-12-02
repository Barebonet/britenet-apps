import { LightningElement } from 'lwc';
import getPopularMovies from '@salesforce/apex/FA_CalloutService.getPopularMovies';

export default class PopularMovies extends LightningElement {
    movieList;
    refreshValue;

    connectedCallback() {
        this.getPopular()
    }

    getPopular() {
        getPopularMovies()
            .then(result => {
                this.movieList = result.results
            })
    }

    refreshList() {
        this.getPopular();
    }
}