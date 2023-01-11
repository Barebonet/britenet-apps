import { api, LightningElement, track } from 'lwc';
import getMainPhoto from '@salesforce/apex/CR_GalleryController.getPhotoForTile'

export default class CarTile extends LightningElement {
    @api
    car;
    @track
    carPhoto;

    connectedCallback() {
        getMainPhoto({
            carId: this.car.Id
        }).then(result => {
            this.carPhoto = result
            console.log(this.carPhoto);
        })
    }
}