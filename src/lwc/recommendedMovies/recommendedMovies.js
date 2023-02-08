/**
 * Created by bartosz.rozpara on 02.12.2022.
 */

import { LightningElement, track, api } from 'lwc';
import getSimilarMovies from '@salesforce/apex/FA_CalloutService.getSimilarMovies';

export default class RecommendedMovies extends LightningElement {
    @api movie;
    @track movieList;

    connectedCallback() {
        getSimilarMovies({
            movieId: this.movie.id
        }).then(result => {
            this.movieList = result;
            console.log(JSON.stringify(this.movieList));
        })
    }
}