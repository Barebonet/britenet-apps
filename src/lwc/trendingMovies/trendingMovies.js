import {LightningElement} from 'lwc';
import getTrendingMovies from '@salesforce/apex/FA_CalloutService.getTrendingMovies';
import hideHeader from '@salesforce/resourceUrl/HideSalesforceHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class TrendingMovies extends LightningElement {
    movieList;
    refreshValue;

    connectedCallback() {
        loadStyle(this, hideHeader);
        this.getTrending();
    }

    getTrending() {
        getTrendingMovies()
            .then(result => {
                this.movieList = result.results
            })
    }

    handleRefresh() {
        this.getTrending();
    }
}