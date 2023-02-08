import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getOrderItems from '@salesforce/apex/OrdersController.getOrderItems';
import submitNewCase from '@salesforce/apex/CR_CaseController.submitNewCase';
import Price from '@salesforce/label/c.Price';
import CarName from '@salesforce/label/c.CarName';
import StartDate from '@salesforce/label/c.StartDate';
import EndDate from '@salesforce/label/c.EndDate';
import ReportIssue from '@salesforce/label/c.ReportIssue';
import Subject from '@salesforce/label/c.Subject';
import Description from '@salesforce/label/c.Description';
import CaseReason from '@salesforce/label/c.CaseReason';
import Submit from '@salesforce/label/c.Submit';
import Close from '@salesforce/label/c.Close';

export default class OrderProductsList extends LightningElement {
    @api orderId;
    @track orderProducts = [];
    productId = '';
    @track openCaseModal = false;
    @track subject = '';
    @track description = '';
    @track reason = '';

    label = {
        Price,
        CarName,
        StartDate,
        EndDate,
        ReportIssue,
        Subject,
        Description,
        CaseReason,
        Submit,
        Close
    }

    caseReason = [
        { label: 'Performance', value: 'Performance' },
        { label: 'Breakdown', value: 'Breakdown' },
        { label: 'Other', value: 'Other' }
    ]

    connectedCallback() {
        getOrderItems({
            orderId: this.orderId
        }).then(result => {
            this.orderProducts = result
        })
    }

    handleCaseCreation(event) {
        this.productId = event.currentTarget.dataset.id;
        this.toggleCaseModal();
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleReasonChange(event) {
        this.reason = event.target.value
    }

    handleDescriptionChange(event) {
        this.description = event.target.value
    }

    toggleCaseModal() {
        this.openCaseModal = !this.openCaseModal;
    }

    createCase() {
        submitNewCase({
            productId: this.productId,
            subject: this.subject,
            reason: this.reason,
            description: this.description
        }).then(result => {
            if(result === 'SUCCESS') {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Case submitted',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
            } else {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        })
    }
}