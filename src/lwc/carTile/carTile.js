import { api, LightningElement, track } from 'lwc';
import getMainPhoto from '@salesforce/apex/CR_GalleryController.getPhotoForTile';
import getAverageRating from '@salesforce/apex/CR_RatingController.getAverageRating';
import getCarPrice from '@salesforce/apex/ProductController.getPriceForProduct';
import getStandardCarPrice from '@salesforce/apex/ProductController.getStandardPrice';
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
    @track carStandardPrice;
    @track displayDefaultPrice = false;

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
        }).catch(err => {
            console.log(err);
        });
        getCarPrice({
            carId: this.car.Id
        }).then(result => {
            this.carPrice = result
            getStandardCarPrice({
                carId: this.car.Id
            }).then(result => {
                this.carStandardPrice = result.UnitPrice;
                if(this.carStandardPrice > this.carPrice) {
                    this.displayDefaultPrice = true;
                }
            }).catch(err => {
                console.log(err);
            })
        })
    }
}