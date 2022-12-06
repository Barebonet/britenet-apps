/**
 * Created by bartosz.rozpara on 25.11.2022.
 */

import { LightningElement, api } from 'lwc';
import getActorMovies from '@salesforce/apex/FA_CalloutService.getActorMovies';

export default class ActorMoviesList extends LightningElement {
    @api actor;
    moviesList;

    connectedCallback() {
        getActorMovies({
            actorId: this.actor.id
        }).then(result => {
            this.moviesList = result;
        })
    }
}