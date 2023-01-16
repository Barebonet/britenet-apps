import { LightningElement, track } from 'lwc';
import getCarDetails from '@salesforce/apex/ProductController.getProductDetails';
import getCarPrice from '@salesforce/apex/ProductController.getPriceForProduct';
import Capacity from '@salesforce/label/c.Capacity';
import Power from '@salesforce/label/c.Power';
import hp from '@salesforce/label/c.Hp';
import cm from '@salesforce/label/c.cm';
import ProductionYear from '@salesforce/label/c.ProductionYear';
import Description from '@salesforce/label/c.Description';
import Euro from '@salesforce/label/c.Euro';
import PerDay from '@salesforce/label/c.PerDay';
import RentNow from '@salesforce/label/c.RentNow';
import Close from '@salesforce/label/c.Close';
import AddToCart from '@salesforce/label/c.Add_to_cart';
import StartDate from '@salesforce/label/c.StartDate';
import EndDate from '@salesforce/label/c.EndDate';
import isGuest from '@salesforce/user/isGuest';
import addToCart from '@salesforce/apex/CartController.addToCart';
import Id from '@salesforce/user/Id';

export default class CarDetails extends LightningElement {
    carId;
    @track
    car = {};
    carPrice = 0;
    @track
    cartModalOpen = false;
    isGuest = isGuest;
    @track
    startDate;
    @track
    endDate;
    @track
    totalPrice = 0;
    userId = Id;

    label = {
        Capacity,
        Power,
        hp,
        cm,
        ProductionYear,
        Description,
        Euro,
        PerDay,
        RentNow,
        Close,
        AddToCart,
        StartDate,
        EndDate
    }

    connectedCallback() {
        this.getProductIdFromURL();
        getCarDetails({
            carId: this.carId
        }).then(result => {
            this.car = result;
        })
        getCarPrice({
            carId: this.carId
        }).then(result => {
            this.carPrice = result;
        })
    }

    getProductIdFromURL() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.carId = urlParams.get('Id');
    }

    toggleCarModal() {
        this.cartModalOpen = !this.cartModalOpen;
    }

    addToCart() {
        addToCart({
            startDate: this.startDate,
            endDate: this.endDate,
            userId: this.userId,
            totalPrice: this.totalPrice,
            productId: this.carId
        }).then(() => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: "Added to cart.",
                variant: 'success',
            });
            this.dispatchEvent(evt);
        }).catch(err => {
            console.log(err);
        })

        this.cartModalOpen = !this.cartModalOpen;
    }

    handleStartDateChange(event) {
        this.startDate = new Date(event.target.value);
    }

    handleEndDateChange(event) {
        this.endDate = new Date(event.target.value);
    }

    calculatePrice() {
        if((this.endDate > this.startDate) && (this.startDate !== undefined && this.endDate !== undefined)) {
            this.totalPrice = this.endDate - this.startDate;
            this.totalPrice = parseInt(this.totalPrice / (1000*60*60*24));
            this.totalPrice = this.totalPrice * this.carPrice;
        }
    }
}