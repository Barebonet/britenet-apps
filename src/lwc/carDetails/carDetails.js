import { LightningElement, track } from 'lwc';
import getCarDetails from '@salesforce/apex/ProductController.getProductDetails';
import getCarPhotos from '@salesforce/apex/CR_GalleryController.getPhotosForProduct';

export default class CarDetails extends LightningElement {
    carId;
    @track
    car = {};

    connectedCallback() {
        this.getProductIdFromURL();
        getCarDetails({
            carId: this.carId
        }).then(result => {
            this.car = result;
        }).catch(err => {
            console.log(err);
        })
    }

    getProductIdFromURL() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.carId = urlParams.get('Id');
    }
}