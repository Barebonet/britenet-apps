import { LightningElement, track, wire } from 'lwc';
import getBlacklisted from '@salesforce/apex/FA_SoqlService.getBlacklisted';
import hideHeader from '@salesforce/resourceUrl/HideSalesforceHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class BlacklistedMovies extends LightningElement {
    @track blacklistedMovies;
    @track refreshValue;

    connectedCallback() {
        loadStyle(this, hideHeader);
        this.getBlacklisted();
    }

    handleRefresh() {
        this.getBlacklisted();
    }

    getBlacklisted() {
        getBlacklisted().then(result => {
            this.blacklistedMovies = result
        })
    }
}