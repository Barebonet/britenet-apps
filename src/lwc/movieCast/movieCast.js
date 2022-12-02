/**
 * Created by bartosz.rozpara on 25.11.2022.
 */

import {api, LightningElement} from 'lwc';
import getCast from '@salesforce/apex/FA_CalloutService.getCast';

export default class MovieCast extends LightningElement {
    @api movie;
    castList;

    connectedCallback() {
        getCast({
            movieId: this.movie.id
        }).then(result => {
            this.castList = result.movieCast
        })
    }
}