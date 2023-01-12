import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';

export default class SearchCars extends LightningElement {
    carName = '';
    @track
    minPower = 0;
    @track
    maxPower = 0;
    minCapacity = 0;
    maxCapacity = 0;
    @track
    carList = [];

    get power() {
        return [
            { label: '0', value: 0 },
            { label: '100', value: 100 },
            { label: '300', value: 300 },
            { label: '500', value: 500 }
        ];
    }

    handleMinPowerChange(event) {
        this.minPower = Number(event.detail.value);
    }

    handleMaxPowerChange(event) {
        this.maxPower = Number(event.detail.value);
    }

    get capacity() {
        return [
            { label: '0', value: 0 },
            { label: '1000', value: 1000 },
            { label: '2000', value: 2000 },
            { label: '3000', value: 3000 },
            { label: '4000', value: 4000 },
            { label: '5000', value: 5000 }
        ];
    }

    handleMinCapacityChange(event) {
        this.minCapacity = Number(event.detail.value);
    }

    handleMaxCapacityChange(event) {
        this.maxCapacity = Number(event.detail.value);
    }

    connectedCallback() {
        getProducts({
            carName: '',
            minPower: this.minPower,
            maxPower: this.maxPower,
            minCapacity: this.minCapacity,
            maxCapacity: this.maxCapacity
        }).then(result => {
            this.carList = result
        })
    }

    handleNameChange(event) {
        this.carName = event.currentTarget.value;
    }

    searchCars() {
        if(this.minPower > this.maxPower && this.maxPower !== 0) {
            const errorEvt = new ShowToastEvent({
                title: 'Error',
                message: "Minimum power has to be lower than or even max power!",
                variant: 'error'
            });
            this.dispatchEvent(errorEvt);
        } else if(this.minCapacity > this.maxCapacity && this.maxCapacity !== 0) {
            const errorEvt = new ShowToastEvent({
                title: 'Error',
                message: "Minimum capacity has to be lower than or even max capacity!",
                variant: 'error'
            });
            this.dispatchEvent(errorEvt);
        } else {
            getProducts({
                carName: this.carName,
                minPower: this.minPower,
                maxPower: this.maxPower,
                minCapacity: this.minCapacity,
                maxCapacity: this.maxCapacity
            }).then(result => {
                this.carList = result
            })
        }
    }
}