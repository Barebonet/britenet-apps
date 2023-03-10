import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCartItems from '@salesforce/apex/CartController.getUserCart';
import makeNewOrder from '@salesforce/apex/OrdersController.makeNewOrder';
import Euro from '@salesforce/label/c.Euro';
import Id from '@salesforce/user/Id';
import Checkout from '@salesforce/label/c.Checkout';
import TotalPrice from '@salesforce/label/c.TotalPrice';
import Cart from '@salesforce/label/c.Cart';
import EmptyCart from '@salesforce/label/c.EmptyCart';

export default class UserCart extends LightningElement {
    @track cartItems;
    userId = Id;
    @track fullPrice = 0;
    @track displayItems = false;
    @track splitBill = false;

    label = {
        Euro,
        Checkout,
        TotalPrice,
        Cart,
        EmptyCart
    }

    connectedCallback() {
        this.getCartItem()
    }

    getCartItem() {
        getCartItems({
            userId: this.userId
        }).then(result => {
            this.cartItems = result
            if(this.cartItems.length > 0) {
                this.displayItems = true;
            } else {
                this.displayItems = false;
            }
            this.cartItems.forEach(cartItem => {
                this.fullPrice += cartItem.Totalprice__c
                if(this.fullPrice > 5000) {
                    this.splitBill = true;
                }
            })
        })
    }

    refreshCart() {
        this.getCartItem()
        this.fullPrice = 0;
    }

    orderProducts() {
        makeNewOrder({
            cartItems: this.cartItems,
            fullPrice: this.fullPrice
        }).then(result => {
            if(result === 'SUCCESS') {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Your order has been created. You can check it out in 'My orders' tab.",
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.getCartItem()
            } else {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Something went wrong.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
    }
}