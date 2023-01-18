import { api, LightningElement } from 'lwc';
import deleteFromCart from '@salesforce/apex/CartController.deleteFromCart';
import Euro from '@salesforce/label/c.Euro';

export default class CartItemTile extends LightningElement {
    @api cartItem;

    label = {
        Euro
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
}