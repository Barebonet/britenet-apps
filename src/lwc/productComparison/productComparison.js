import { LightningElement, track } from 'lwc';
import getAllProducts from '@salesforce/apex/ProductController.getAllProducts';

export default class ProductComparison extends LightningElement {
    @track productList;
    @track compareProductList = [];
    @track displayAllProducts = true;
    @track displayComparison = false;

    columnsComparison = [
        { label: 'Product Name', fieldName: 'Name' },
        { label: 'Capacity', fieldName: 'Capacity__c' },
        { label: 'Power', fieldName: 'Power__c' },
        { label: 'Production Year', fieldName: 'ProductionYear__c' },
        { label: 'Gearbox', fieldName: 'Gearbox__c' },
        { label: 'Doors', fieldName: 'Doors__c' },
        { label: 'Seats', fieldName: 'Seats__c'}
    ]

    columnsAllProds = [
        { label: 'Product Name', fieldName: 'Name' },
        { label: 'Production Year', fieldName: 'ProductionYear__c' }
    ]

    connectedCallback() {
        getAllProducts().then(result => {
            this.productList = result;
        })
    }

    getSelectedRec() {
        this.compareProductList = [];
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            selectedRecords.forEach(product => {
                this.compareProductList.push(product);
            });
            this.displayComparison = true;
        } else {
            this.displayComparison = false;
        }
      }
}