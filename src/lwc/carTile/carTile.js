import { api, LightningElement, track } from 'lwc';
import getMainPhoto from '@salesforce/apex/CR_GalleryController.getPhotoForTile';
import getAverageRating from '@salesforce/apex/CR_RatingController.getAverageRating';
import getCarPrice from '@salesforce/apex/ProductController.getPriceForProduct';
import Capacity from '@salesforce/label/c.Capacity';
import Power from '@salesforce/label/c.Power';
import hp from '@salesforce/label/c.Hp';
import cm from '@salesforce/label/c.cm';
import Rating from '@salesforce/label/c.Rating';
import Euro from '@salesforce/label/c.Euro';
import PerDay from '@salesforce/label/c.PerDay';

export default class CarTile extends LightningElement {
    @api car;
    @track carPhoto;
    @track avgRating = 0;
    @track carPrice = 0;

    label = {
        Capacity,
        Power,
        hp,
        cm,
        Rating,
        Euro,
        PerDay
    }

    connectedCallback() {
        console.log('conCall');
        getMainPhoto({
            carId: this.car.Id
        }).then(result => {
            this.carPhoto = result;
        }).catch(err => {
            console.log(err);
        });
        getAverageRating({
            carId: this.car.Id
        }).then(avg => {
            this.avgRating = avg;
            console.log(avg);
            console.log(this.car.Id);
        }).catch(err => {
            console.log(err);
        });
        getCarPrice({
            carId: this.car.Id
        }).then(result => {
            this.carPrice = result
        })
    }
}