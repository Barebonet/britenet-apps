import { LightningElement, track } from 'lwc';
import getTrendingProducts from '@salesforce/apex/ProductController.getTrendingProducts';
import MostPopularCars from '@salesforce/label/c.MostPopularCars';

export default class TrendingProducts extends LightningElement {
    @track
    carList;

    label = {
        MostPopularCars
    }

    connectedCallback() {
        getTrendingProducts()
        .then(result => {
            this.carList = result
        });
    }

    handleOpenCarDetails(event) {
        let recordId=event.currentTarget.id;
        recordId=recordId.substring(0,18);
        window.location.assign('/cars/s/car-details?Id='+recordId);
    }
}