import { LightningElement, track } from 'lwc';
import searchMovies from '@salesforce/apex/FA_SearchService.searchMovies';
import getPopularMovies from '@salesforce/apex/FA_CalloutService.getFullPopularMovies';
import searchActors from '@salesforce/apex/FA_SearchService.searchActors';
import getPopularActors from '@salesforce/apex/FA_CalloutService.getPopularActors';
import insertMovie from '@salesforce/apex/FA_SoqlService.addMovie';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import hideHeader from '@salesforce/resourceUrl/HideSalesforceHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class SearchMovies extends LightningElement {
    name = '';
    @track pageActorsNum = 1;
    @track pageMoviesNum = 1;
    totalMoviePages;
    totalActorPages;
    @track displayMovies = true;
    @track displayActors = true;
    @track newMovieModal = false;
    @track displayPaginateMovies = false;
    @track displayPaginateActors = false;
    @track movieList;
    @track actorList;
    movieName;
    originalTitle;
    originalLanguage;
    overview;
    posterPath;
    releaseDate;
    fileName;

    handleChangeFinished() {
        let file = input.files[0];
        let reader = new FileReader();
        reader.addEventListener('load',this.fileName);
        reader.readAsText(file);
    }

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
                this.pageActorsNum = 1;
                this.totalActorPages = 1;
            })
    }

    addMovie() {
        insertMovie({
            movieName: this.movieName,
            originalTitle: this.originalTitle,
            originalLanguage: this.originalLanguage,
            overview: this.overview,
            posterPath: this.posterPath,
            releaseDate: this.releaseDate,
            fileName: this.fileName,
            blobFile: this.handleChangeFinished
        }).then(result => {
            this.newMovieModal = false;
            this.movieName = '';
            this.originalLanguage = '';
            this.originalTitle = '';
            this.overview = '';
            this.releaseDate = '';
            this.fileName = '';
        }).catch(error => {
            console.log(JSON.stringify(error));
        })
    }

    searchMovie(event) {
        this.name = event.target.value;
    }

    addMovieName(event) {
        this.movieName = event.target.value;
    }

    addFileName(event) {
        let file = event.target.value;
        let lastIndexOf = file.lastIndexOf("\\");
        this.fileName = file.substring(lastIndexOf + 1);
    }

    addMovieOriginalTitle(event) {
        this.originalTitle = event.target.value;
    }

    addMovieOriginalLanguage(event) {
        this.originalLanguage = event.target.value;
    }

    addMovieOverview(event) {
        this.overview = event.target.value;
    }

    addMovieReleaseDate(event) {
        this.releaseDate = event.target.value;
    }

    search() {
        if (this.name !== '') {
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
            if (this.movieList.size === 0) {

            }
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
                this.pageActorsNum = result.page;
                this.displayPaginateActors = this.actorList.length !== 0;
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
        getPopularMovies({
            page: 3
        }).then(result => {
            this.movieList = result.results
            this.displayPaginateMovies = this.movieList.length !== 0;
            this.totalMoviePages = 1;
            this.pageMoviesNum = 1;
        })
    }

    handleRefresh() {
        if (this.name === '') {
            this.getPopularMovies();
        } else {
            this.search();
        }
    }

    firstActors() {
        if(this.pageActorsNum === 1) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page!',
            });
            this.dispatchEvent(event);
        } else {
            this.pageActorsNum = 1;
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            })
        }
    }

    firstMovies() {
        if(this.pageMoviesNum === 1) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page!',
            });
            this.dispatchEvent(event);
        } else {
            this.pageMoviesNum = 1;
            searchMovies({
                movieName: this.name,
                pageMoviesNUmber: this.pageMovieNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            })
        }
    }

    previousActors() {
        this.pageActorsNum = this.pageActorsNum - 1;
        if (this.pageActorsNum > 0) {
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            })
        } else {
            this.pageActorsNum = 1;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page!',
            });
            this.dispatchEvent(event);
        }
    }

    previousMovies() {
        this.pageMoviesNum = this.pageMoviesNum - 1;
        if (this.pageMoviesNum > 0) {
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            })
        } else {
            this.pageMoviesNum = 1;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the first page!',
            });
            this.dispatchEvent(event);
        }
    }

    nextActors() {
        this.pageActorsNum = this.pageActorsNum + 1;
        if (this.pageActorsNum <= this.totalActorPages) {
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            })
        } else {
            this.pageActorsNum = this.totalActorPages;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page!',
            });
            this.dispatchEvent(event);
        }
    }

    nextMovies() {
        this.pageMoviesNum = this.pageMoviesNum + 1;
        if (this.pageMoviesNum <= this.totalMoviePages) {
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            })
        } else {
            this.pageMoviesNum = this.totalMoviePages;
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page!',
            });
            this.dispatchEvent(event);
        }
    }

    lastActors() {
        if(this.pageActorsNum === this.totalActorPages) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page!',
            });
            this.dispatchEvent(event);
        } else {
            this.pageActorsNum = this.totalActorPages;
            searchActors({
                actorName: this.name,
                pageActorsNumber: this.pageActorsNum
            }).then(result => {
                this.actorList = result.results;
                this.totalActorPages = result.total_pages;
            })
        }
    }

    lastMovies() {
        if(this.pageMoviesNum === this.totalMoviePages) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'This is the last page!',
            });
            this.dispatchEvent(event);
        } else {
            this.pageMoviesNum = this.totalMoviePages;
            searchMovies({
                movieName: this.name,
                pageMoviesNumber: this.pageMoviesNum
            }).then(result => {
                this.movieList = result.results;
                this.totalMoviePages = result.total_pages;
            })
        }
    }
}