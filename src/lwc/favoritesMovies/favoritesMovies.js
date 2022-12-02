import { LightningElement, track } from 'lwc';
import getFavorites from '@salesforce/apex/FA_SoqlService.getFavorites';
import hideHeader from '@salesforce/resourceUrl/HideSalesforceHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class FavoritesMovies extends LightningElement {
    @track favouriteMovies;
    @track refreshValue;

    connectedCallback() {
        loadStyle(this, hideHeader);
        this.getFavs();
    }

    handleRefresh() {
        this.getFavs();
    }

    getFavs() {
        getFavorites().then(result => {
            this.favouriteMovies = result
        })
    }
}