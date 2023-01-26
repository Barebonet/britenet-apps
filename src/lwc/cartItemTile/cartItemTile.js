import { api, LightningElement, track } from 'lwc';
import deleteFromCart from '@salesforce/apex/CartController.deleteFromCart';
import getCarPrice from '@salesforce/apex/ProductController.getPriceForProduct';
import editCartItem from '@salesforce/apex/CartController.editCartItem';
import Euro from '@salesforce/label/c.Euro';
import Close from '@salesforce/label/c.Close';
import Edit from '@salesforce/label/c.Edit';
import Delete from '@salesforce/label/c.Delete';
import DeleteProductFromCart from '@salesforce/label/c.DeleteProductFromCart'

export default class CartItemTile extends LightningElement {
    @api cartItem;
    @track
    editDatesModal = false;
    @track
    carPrice = 0;
    @track totalPrice = 0;
    @track startDate;
    @track endDate;
    @track deletePrompt = false;

    label = {
        Euro,
        Close,
        Edit,
        Delete,
        DeleteProductFromCart
    }

    connectedCallback() {
        getCarPrice({
            carId: this.cartItem.ProductId__c
        }).then(result => {
            this.carPrice = result;
        })
        this.totalPrice = this.cartItem.Totalprice__c;
        this.startDate = this.cartItem.StartDate__c;
        this.endDate = this.cartItem.EndDate__c;
    }

    toggleDeletePrompt() {
        this.deletePrompt = !this.deletePrompt;
    }

    deleteFromCart() {
        deleteFromCart({
            cartItemId: this.cartItem.Id
        }).then(() => {
            const event = new CustomEvent('deleted', {
                detail: true
            })
            this.dispatchEvent(event);
        })
    }

    handleStartDateChange(event) {
        this.startDate = new Date(event.target.value);
        this.calculatePrice();
    }

    handleEndDateChange(event) {
        this.endDate = new Date(event.target.value);
        this.calculatePrice();
    }

    calculatePrice() {
        if((this.endDate > this.startDate) && (this.startDate !== undefined && this.endDate !== undefined)) {
            this.totalPrice = this.endDate - this.startDate;
            this.totalPrice = parseInt(this.totalPrice / (1000*60*60*24));
            if(this.totalPrice > 180) {
                this.totalPrice = this.totalPrice * this.carPrice * 0.85;
            } else {
                this.totalPrice = this.totalPrice * this.carPrice;
            }
        }
    }

    toggleDatesModal() {
        this.editDatesModal = !this.editDatesModal;
    }

    editDates() {
        editCartItem({
            cartItemId: this.cartItem.Id,
            startDate: this.startDate,
            endDate: this.endDate,
            totalPrice: this.totalPrice
        }).then(() => {
            const refreshAddEvent = new CustomEvent("cartitemedited",{
                detail: {}
            });
            this.dispatchEvent(refreshAddEvent);
            this.toggleDatesModal();
        })
    }
}