import { api, LightningElement } from 'lwc';

export default class ProductList extends LightningElement {
    @api
    carList;

    handleOpenCarDetails(event) {
        let recordId=event.currentTarget.id;
        recordId=recordId.substring(0,18);
        window.location.assign('/cars/s/car-details?Id='+recordId);
    }
}