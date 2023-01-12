import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import searchCars from '@salesforce/label/c.Search_cars';
import CarName from '@salesforce/label/c.CarName';
import MinimumPower from '@salesforce/label/c.MinimumPower';
import MaximumPower from '@salesforce/label/c.MaximumPower';
import MinimumCapacity from '@salesforce/label/c.MinimumCapacity';
import MaximumCapacity from '@salesforce/label/c.MaximumCapacity';
import Search from '@salesforce/label/c.Search';

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

    label = {
        searchCars,
        CarName,
        MinimumPower,
        MaximumPower,
        MinimumCapacity,
        MaximumCapacity,
        Search
    }

    get power() {
        return [
            { label: '0', value: 0 },
            { label: '100 hp', value: 100 },
            { label: '300 hp', value: 300 },
            { label: '500 hp', value: 500 }
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
            { label: '1000 cm³', value: 1000 },
            { label: '2000 cm³', value: 2000 },
            { label: '3000 cm³', value: 3000 },
            { label: '4000 cm³', value: 4000 },
            { label: '5000 cm³', value: 5000 }
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
        if((this.minPower > this.maxPower) && this.maxPower !== 0) {
            const errorEvt = new ShowToastEvent({
                title: 'Error',
                message: "Minimum power has to be lower than or even max power!",
                variant: 'error'
            });
            this.dispatchEvent(errorEvt);
        } else if((this.minCapacity > this.maxCapacity) && this.maxCapacity !== 0) {
            const error = new ShowToastEvent({
                title: 'Error',
                message: "Minimum capacity has to be lower than or even max capacity!",
                variant: 'error'
            });
            this.dispatchEvent(error);
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