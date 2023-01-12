import { api, LightningElement } from 'lwc';

export default class CarCommentTile extends LightningElement {
    @api
    comment = {};

    connectedCallback() {
        console.log(JSON.stringify(this.comment));
    }
}