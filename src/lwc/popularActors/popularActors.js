/**
 * Created by robar on 25.11.2022.
 */

import {LightningElement} from 'lwc';
import getPopularActors from '@salesforce/apex/FA_CalloutService.getPopularActors';

export default class PopularActors extends LightningElement {
    actorList;

    connectedCallback() {
        getPopularActors()
            .then(result => {
                this.actorList = result.results
            })
    }
}