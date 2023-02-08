import { LightningElement, track } from 'lwc';
import getCarPhotos from '@salesforce/apex/CR_GalleryController.getPhotosForProduct';
import getCarListSize from '@salesforce/apex/CR_GalleryController.getPhotoListSize';

export default class PhotoGallery extends LightningElement {
    @track
    photoLink = '';
    carId;
    @track
    offset = 0;
    @track listSize = 0;

    connectedCallback() {
        this.getProductIdFromURL();
        this.getPhotos();
    }

    getProductIdFromURL() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.carId = urlParams.get('Id');
    }

    getPhotos() {
        getCarPhotos({
            carId: this.carId,
            offset: this.offset
        }).then(result => {
            this.photoLink = result;
            getCarListSize({
                carId: this.carId
            }).then(result => {
                this.listSize = result;
            }).catch(err => {
                console.log(err);
            })
        }).catch(err => {
            console.log(err);
        })
    }

    getNextPhoto() {
        this.offset += 1;
        if(this.offset < this.listSize) {
            getCarPhotos({
                carId: this.carId,
                offset: this.offset
            }).then(result => {
                this.photoLink = result;
            })
        } else {
            this.offset = this.listSize - 1;
        }
    }

    getPrevPhoto() {
        this.offset = this.offset - 1;
        if(this.offset !== -1) {
            getCarPhotos({
                carId: this.carId,
                offset: this.offset
            }).then(result => {
                this.photoLink = result;
            })
        } else {
            this.offset = 0;
        }
    }
}