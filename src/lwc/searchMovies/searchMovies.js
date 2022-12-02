import { LightningElement, track } from 'lwc';
import searchMovies from '@salesforce/apex/FA_SearchService.searchMovies';
import getPopularMovies from '@salesforce/apex/FA_CalloutService.getPopularMovies';
import searchActors from '@salesforce/apex/FA_SearchService.searchActors';
import getPopularActors from '@salesforce/apex/FA_CalloutService.getPopularActors';
import insertMovie from '@salesforce/apex/FA_SoqlService.addMovie';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import hideHeader from '@salesforce/resourceUrl/HideSalesforceHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class SearchMovies extends LightningElement {
    name = '';
    @track pageActorsNum;
    @track pageMoviesNum;
    totalMoviePages;
    totalActorPages;
    @track displayMovies = true;
    @track displayActors = true;
    @track newMovieModal = false;
    @track displayPaginateMovies = false;
    @track displayPaginateActors = false;
    @track movieList;
    @track actorList;
    @track movieName;
    @track originalTitle;
    @track originalLanguage;
    @track overview;
    @track posterPath;
    @track releaseDate;

    toggleMovies() {
        this.displayMovies = !this.displayMovies;
    }

    toggleActors() {
        this.displayActors = !this.displayActors;
    }

    openModalNewMovie() {
        this.newMovieModal = true;
    }

    closeNewMovieModal() {
        this.newMovieModal = false;
    }

    connectedCallback() {
        loadStyle(this, hideHeader);
        this.getPopularMovies();
        getPopularActors()
            .then(result => {
                this.actorList = result.results;
                this.displayPaginateActors = this.actorList.length !== 0;
            })
    }

    addMovie() {
        insertMovie({
            movieName: this.movieName,
            originalTitle: this.originalTitle,
            originalLanguage: this.originalLanguage,
            overview: this.overview,
            posterPath: this.posterPath,
            releaseDate: this.releaseDate
        }).then(result => {
            // this.movieName = '';
            // this.originalTitle = '';
            // this.originalLanguage = '';
            // this.overview = '';
            // this.posterPath = '';
            // this.releaseDate = '';
            this.newMovieModal = false;
        })
    }

    searchMovie(event) {
        this.name = event.target.value;
    }

    search() {
        if(this.name !== '') {
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                    this.movieList = result.results;
                    this.totalMoviePages = result.total_pages;
                    this.pageMoviesNum = result.page;
                    this.displayPaginateMovies = this.movieList.length !== 0;
                }).catch(error => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                })
            if(this.movieList.size === 0) {

            }
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                    this.actorList = result.results;
                    this.totalActorPages = result.total_pages;
                    this.pageActorsNum = result.page;
                    this.displayPaginateActors = this.actorList.length !== 0;
                }).catch(error => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message
                    });
                    this.dispatchEvent(event);
                })
        } else {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Name blank!',
            });
            this.dispatchEvent(event);
        }
    }

    getPopularMovies() {
        getPopularMovies()
            .then(result => {
                this.movieList = result.results
                this.displayPaginateMovies = this.movieList.length !== 0;
            })
    }

    handleRefresh() {
        if(this.name === '') {
            this.getPopularMovies();
        } else {
            this.search();
        }
    }

    firstActors() {
        this.pageActorsNum = 1;
        searchActors({
            actorName: this.name,
            pageActorsNumber: this.pageActorsNum
        }).then(result => {
            this.actorList = result.results;
            this.totalActorPages = result.total_pages;
        }).catch(error => {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(event);
        })
    }

    firstMovies() {
        this.pageMoviesNum = 1;
        searchMovies({
            movieName: this.name,
            pageMoviesNUmber: this.pageMovieNum
        }).then(result => {
            this.movieList = result.results;
            this.totalMoviePages = result.total_pages;
        }).catch(error => {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(event);
        })
    }

    previousActors() {
        this.pageActorsNum = this.pageActorsNum - 1;
        if(this.pageActorsNum > 0) {
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            }).catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message
                });
                this.dispatchEvent(event);
            })
        } else {
            this.pageActorsNum = 1;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page! Can\'t go further',
            });
            this.dispatchEvent(event);
        }
    }

    previousMovies() {
        this.pageMoviesNum = this.pageMoviesNum - 1;
        if(this.pageMoviesNum > 0) {
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            }).catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message
                });
                this.dispatchEvent(event);
            })
        } else {
            this.pageMoviesNum = 1;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page! Can\'t go further',
            });
            this.dispatchEvent(event);
        }
    }

    nextActors() {
        this.pageActorsNum = this.pageActorsNum + 1;
        if(this.pageActorsNum <= this.totalActorPages) {
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            }).catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message
                });
                this.dispatchEvent(event);
            })
        } else {
            this.pageActorsNum = this.totalActorPages;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page! Can\'t go further',
            });
            this.dispatchEvent(event);
        }
    }

    nextMovies() {
        this.pageMoviesNum = this.pageMoviesNum + 1;
        if(this.pageMoviesNum <= this.totalMoviePages) {
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            }).catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message
                });
                this.dispatchEvent(event);
            })
        } else {
            this.pageMoviesNum = this.totalMoviePages;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page! Can\'t go further',
            });
            this.dispatchEvent(event);
        }
    }

    lastActors() {
        this.pageActorsNum = this.totalActorPages;
        searchActors({
            actorName: this.name,
            pageActorsNumber: this.pageActorsNum
        }).then(result => {
            this.actorList = result.results;
            this.totalActorPages = result.total_pages;
        }).catch(error => {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(event);
        })
    }

    lastMovies() {
        this.pageMoviesNum = this.totalMoviePages;
        searchMovies({
            movieName: this.name,
            pageMoviesNumber: this.pageMoviesNum
        }).then(result => {
            this.movieList = result.results;
            this.totalMoviePages = result.total_pages;
        }).catch(error => {
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message
            });
            this.dispatchEvent(event);
        })
    }
}