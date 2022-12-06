import {LightningElement, track, wire} from 'lwc';
import getPopularMovies from '@salesforce/apex/FA_CalloutService.getFullPopularMovies';

export default class PopularMovies extends LightningElement {
    @track movieList;
    @track currentPage = 1;
    @track lastPage = 4;

    constructor() {
        super();
        this.getPopular();
    }

    getPopular() {
        getPopularMovies({
            page: 2
        }).then(result => {
            this.movieList = result.results
        })
    }

    refreshList() {
        this.getPopular();
    }
}