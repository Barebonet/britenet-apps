import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCarToCompare from '@salesforce/apex/CR_ComparisonController.getCarToCompare';
import deleteFromComparison from '@salesforce/apex/CR_ComparisonController.deleteFromComparison';
import Id from '@salesforce/user/Id';
import Euro from '@salesforce/label/c.Euro';
import ComparisonDelete from '@salesforce/label/c.ComparisonDelete';
import Close from '@salesforce/label/c.Close';
import Delete from '@salesforce/label/c.Delete';
import ComparisonEmpty from '@salesforce/label/c.ComparisonEmpty';
import CarName from '@salesforce/label/c.CarName';
import Capacity from '@salesforce/label/c.Capacity';
import Power from '@salesforce/label/c.Power';
import Comparison from '@salesforce/label/c.Comparison';
import Remove from '@salesforce/label/c.Remove';
import AddToCart from '@salesforce/label/c.Add_to_cart';
import StartDate from '@salesforce/label/c.StartDate';
import EndDate from '@salesforce/label/c.EndDate';
import TotalPrice from '@salesforce/label/c.TotalPrice';
import SelectPeriod from '@salesforce/label/c.SelectPeriod';
import Gearbox from '@salesforce/label/c.Gearbox';
import Doors from '@salesforce/label/c.Doors';
import Seats from '@salesforce/label/c.Seats';
import hp from '@salesforce/label/c.Hp';
import cm from '@salesforce/label/c.cm';
import PricePerDay from '@salesforce/label/c.PricePerDay';
import ProdYear from '@salesforce/label/c.ProdYear';

export default class ProductComparison extends LightningElement {
    @track productList;
    userId = Id;
    @track
    displayItems = false;
    @track
    startDate;
    @track
    endDate;
    @track
    totalPrice = 0;
    @track carStandardPrice;
    @track
    cartModalOpen = false;
    carPrice = 0;
    @track tempCarId = '';

    label = {
        Euro,
        ComparisonDelete,
        Close,
        Delete,
        ComparisonEmpty,
        CarName,
        Capacity,
        Power,
        Comparison,
        Remove,
        AddToCart,
        StartDate,
        EndDate,
        TotalPrice,
        Gearbox,
        SelectPeriod,
        Doors,
        Seats,
        hp,
        cm,
        PricePerDay,
        ProdYear
    }

    connectedCallback() {
        this.getCarsToCompare()
    }

    getCarsToCompare() {
        getCarToCompare({
            userId: this.userId
        }).then(result => {
            this.productList = result;
            if(this.productList.length > 0) {
                this.displayItems = true;
            } else {
                this.displayItems = false;
            }
        })
    }

    handleDeleteFromComparison(event) {
        let carId = event.currentTarget.dataset.id
        deleteFromComparison({
            cmpId: carId
        }).then(result => {
            if(result === 'SUCCESS') {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: "Deleted from comparison.",
                    variant: 'success',
                });
                this.dispatchEvent(evt); 
                this.getCarsToCompare()
            } else {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                });
                this.dispatchEvent(event);
            } 
        })
    }

    navigateToDetails(event) {
        let carId = event.currentTarget.dataset.id
        console.log(carId);
        window.location.assign('/cars/s/car-details?Id=' + carId);
    }
}