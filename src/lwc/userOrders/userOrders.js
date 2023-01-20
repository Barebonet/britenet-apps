import { LightningElement, track } from 'lwc';
import getUserOrders from '@salesforce/apex/OrdersController.getUserOrders';
import Id from '@salesforce/user/Id';
import MyOrders from '@salesforce/label/c.MyOrders';

export default class UserOrders extends LightningElement {
    @track userOrders = [];
    userId = Id;
    @track viewOrders = false;

    label = {
        MyOrders
    }

    connectedCallback() {
        getUserOrders({
            userId: this.userId
        }).then(result => {
            this.userOrders = result
            if(this.userOrders.length > 0) {
                this.viewOrders = true;
            } else {
                this.viewOrders = false;
            }
        })
    }
}