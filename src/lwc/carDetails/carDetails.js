import { LightningElement, track } from 'lwc';
import getCarDetails from '@salesforce/apex/ProductController.getProductDetails';
import Capacity from '@salesforce/label/c.Capacity';
import Power from '@salesforce/label/c.Power';
import hp from '@salesforce/label/c.Hp';
import cm from '@salesforce/label/c.cm';
import ProductionYear from '@salesforce/label/c.ProductionYear';
import Description from '@salesforce/label/c.Description';

export default class CarDetails extends LightningElement {
    carId;
    @track
    car = {};

    label = {
        Capacity,
        Power,
        hp,
        cm,
        ProductionYear,
        Description
    }

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