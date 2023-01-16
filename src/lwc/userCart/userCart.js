import { LightningElement, track } from 'lwc';
import getCartItems from '@salesforce/apex/CartController.getUserCart';
import Id from '@salesforce/user/Id';

export default class UserCart extends LightningElement {
    @track cartItems;
    userId = Id;

    connectedCallback() {
        getCartItems({
            userId: this.userId
        }).then(result => {
            this.cartItems = result
        })
    }
}