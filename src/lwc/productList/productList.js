import { api, LightningElement } from 'lwc';
import Cars from '@salesforce/label/c.Cars';

export default class ProductList extends LightningElement {
    @api
    carList;

    label = {
        Cars
    }

    handleOpenCarDetails(event) {
        let recordId=event.currentTarget.id;
        recordId=recordId.substring(0,18);
        window.location.assign('/cars/s/car-details?Id='+recordId);
    }
}