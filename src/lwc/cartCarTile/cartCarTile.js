import { api, LightningElement, track } from 'lwc';
import getCarDetails from '@salesforce/apex/ProductController.getProductDetails';
import getMainPhoto from '@salesforce/apex/CR_GalleryController.getPhotoForTile';

export default class CartCarTile extends LightningElement {
    @api carId;
    @track car = {};
    @track carPhoto = '';

    connectedCallback() {
        getCarDetails({
            carId: this.carId
        }).then(result => {
            this.car = result;
        })
        getMainPhoto({
            carId: this.carId
        }).then(result => {
            this.carPhoto = result;
        }).catch(err => {
            console.log(err);
        })
    }
}