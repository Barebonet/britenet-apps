import { api, LightningElement } from 'lwc';
import Price from '@salesforce/label/c.Price';
import OrderNumber from '@salesforce/label/c.OrderNumber';
import DateOfOrder from '@salesforce/label/c.DateOfOrder';
import Euro from '@salesforce/label/c.Euro';

export default class OrderTile extends LightningElement {
    @api order;

    label = {
        Price,
        OrderNumber,
        DateOfOrder,
        Euro
    }
}