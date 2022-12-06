/**
 * Created by bartosz.rozpara on 23.11.2022.
 */

public with sharing class FA_SoqlService {
    @AuraEnabled
    public static List<FA_ClassesForCallouts.Actor> getActors(String actorName) {
        String query = 'SELECT Id, Name, Adult__c, ProfilePath__c FROM Actor__c WHERE Name = \'%' + actorName + '%\'';
        List<Actor__c> actors = Database.query(query);
        List<FA_ClassesForCallouts.Actor> actorsWrap = new List<FA_ClassesForCallouts.Actor>();
        if(!actors.isEmpty()) {
            for(Actor__c actor : actors) {
                FA_ClassesForCallouts.Actor actorWrap = mapToActorWrapper(actor);
                actorsWrap.add(actorWrap);
            }
        }
        return actorsWrap;
    }

    @AuraEnabled
    public static List<FA_ClassesForCallouts.Movie> getMovies(String movieName) {
        String query = 'SELECT Id, Name, Adult__c, OriginalLanguage__c, OriginalTitle__c, Overview__c, ' +
                'PosterPath__c, ReleaseDate__c FROM Movie__c WHERE Name = \'%' + movieName + '%\'';
        List<FA_ClassesForCallouts.Movie> moviesToSend = new List<FA_ClassesForCallouts.Movie>();
        List<Movie__c> movies = Database.query(query);
        if(!movies.isEmpty()) {
            for(Movie__c movie : movies) {
                FA_ClassesForCallouts.Movie movieToList = mapToMovieWrapper(movie);
                moviesToSend.add(movieToList);
            }
        }
        return moviesToSend;
    }

    @AuraEnabled
    public static void addMovie(String movieName, String originalTitle, String originalLanguage,
            String overview, String posterPath, String releaseDate) {
        Movie__c movie = new Movie__c();
        movie.Name = movieName;
        movie.PosterPath__c = posterPath;
        movie.ReleaseDate__c = releaseDate;
        movie.OriginalTitle__c = originalTitle;
        movie.Overview__c = overview;
        movie.OriginalLanguage__c = originalLanguage;
        insert movie;
    }

    @AuraEnabled
    public static void addRating(String ownerId, Integer id, String description, Double rating) {
        List<Rating__c> checkRatings = [SELECT Id FROM Rating__c WHERE MovieId__c = :id AND OwnerId = :UserInfo.getUserId()];
        if(checkRatings.isEmpty()) {
            Rating__c ratingToInsert = new Rating__c();
            ratingToInsert.OwnerId = ownerId;
            ratingToInsert.Rating__c = String.valueOf(rating);
            ratingToInsert.Description__c = description;
            ratingToInsert.MovieId__c = id;
            insert ratingToInsert;
        }
    }

    @AuraEnabled
    public static void deleteRating(String id, String owner) {
        List<Rating__c> ratings = [SELECT Id FROM Rating__c WHERE Id = :id AND CreatedBy.Name = :owner];
        delete ratings;
    }

    @AuraEnabled
    public static Double getAverageRating(Integer id) {
        List<Rating__c> ratings = [SELECT Id, Rating__c FROM Rating__c WHERE MovieId__c = :id];
        Decimal avg = 0;
        Double sum = 0;
        Integer numRecs = ratings.size();
        if(!ratings.isEmpty()) {
            for(Integer i=0; i<numRecs; i++) {
                sum += Double.valueOf(ratings.get(i).Rating__c);
            }
        }
        FA_ClassesForCallouts.MovieReviews movieReviews = FA_CalloutService.getReviews(id);
        if((movieReviews.results != null) && (!movieReviews.results.isEmpty())) {
            numRecs += movieReviews.results.size();
            for(FA_ClassesForCallouts.ReviewAuthor author : movieReviews.results) {
                if((author.author_details.rating != null) && (author.author_details.rating != 0)) {
                    sum += author.author_details.rating;
                } else {
                    numRecs--;
                }
            }
        }
        if(numRecs != 0) {
            avg = (sum/numRecs);
        }
        Double returnAvg = avg.setScale(2);
        return returnAvg;
    }

    @AuraEnabled
    public static List<FA_ClassesForCallouts.ReviewAuthor> getReviews(Integer movieId) {
        List<Rating__c> ratings = [SELECT Id, CreatedBy.Name, CreatedDate, Rating__c, Description__c, OwnerId FROM Rating__c WHERE MovieId__c = :movieId];
        FA_ClassesForCallouts.MovieReviews movieReviews = new FA_ClassesForCallouts.MovieReviews();
        movieReviews.results = new List<FA_ClassesForCallouts.ReviewAuthor>();
        for(Rating__c rating : ratings) {
            FA_ClassesForCallouts.ReviewAuthor movieReview = mapToReviewWrapper(rating);
            movieReviews.results.add(movieReview);
        }
        return movieReviews.results;
    }

    @AuraEnabled
    public static void addToFavourites(Integer movieId, String poster_path,
            String releaseDate, String originalTitle, String overview, String title) {
        if(FA_SoqlService.checkIfBlacklist(movieId)) {
            FA_SoqlService.deleteFromBlacklist(movieId);
        }
        Favourite__c favourite = new Favourite__c();
        favourite.MovieId__c = String.valueOf(movieId);
        favourite.Name = title;
        favourite.poster_path__c = poster_path;
        favourite.ReleaseDate__c = releaseDate;
        favourite.OriginalTitle__c = originalTitle;
        favourite.Overview__c = overview;
        insert favourite;
    }

    @AuraEnabled
    public static void deleteFromFavorites(Integer movieId) {
        List<Favourite__c> favs = [SELECT Id FROM Favourite__c WHERE MovieId__c = :String.valueOf(movieId) AND OwnerId = :UserInfo.getUserId()];
        delete favs;
    }

    @AuraEnabled
    public static Boolean checkIfFavorite(Integer movieId) {
        List<Favourite__c> favs = [SELECT Id FROM Favourite__c WHERE MovieId__c = :String.valueOf(movieId) AND OwnerId = :UserInfo.getUserId()];
        Boolean isFavorite;
        if(favs.isEmpty()) {
            isFavorite = false;
        } else {
            isFavorite = true;
        }
        return isFavorite;
    }

    @AuraEnabled
    public static List<FA_ClassesForCallouts.Movie> getFavorites() {
        List<FA_ClassesForCallouts.Movie> movies = new List<FA_ClassesForCallouts.Movie>();
        List<Favourite__c> favs = [SELECT
                MovieId__c,
                poster_path__c,
                ReleaseDate__c,
                OriginalTitle__c,
                Overview__c,
                Name
        FROM Favourite__c WHERE OwnerId = :UserInfo.getUserId()];
        for(Favourite__c fav : favs) {
            FA_ClassesForCallouts.Movie movie = mapToFavsWrapper(fav);
            movies.add(movie);
        }
        return movies;
    }

    @AuraEnabled
    public static void addToBlacklist(Integer movieId, String poster_path,
            String releaseDate, String originalTitle, String overview, String title) {
        if(FA_SoqlService.checkIfFavorite(movieId)) {
            FA_SoqlService.deleteFromFavorites(movieId);
        }
        Blacklist__c blacklist = new Blacklist__c();
        blacklist.MovieId__c = String.valueOf(movieId);
        blacklist.Name = title;
        blacklist.PosterPath__c = poster_path;
        blacklist.ReleaseDate__c = releaseDate;
        blacklist.OriginalTitle__c = originalTitle;
        blacklist.Overview__c = overview;
        insert blacklist;
    }

    @AuraEnabled
    public static void deleteFromBlacklist(Integer movieId) {
        List<Blacklist__c> blacklists = [SELECT Id FROM Blacklist__c WHERE MovieId__c = :String.valueOf(movieId) AND OwnerId = :UserInfo.getUserId()];
        delete blacklists;
    }

    @AuraEnabled
    public static Boolean checkIfBlacklist(Integer movieId) {
        List<Blacklist__c> blacklists = [SELECT Id FROM Blacklist__c WHERE MovieId__c = :String.valueOf(movieId) AND OwnerId = :UserInfo.getUserId()];
        Boolean isBlacklist = false;
        if(blacklists.isEmpty()) {
            isBlacklist = false;
        } else {
            isBlacklist = true;
        }
        return isBlacklist;
    }

    @AuraEnabled
    public static List<FA_ClassesForCallouts.Movie> getBlacklisted() {
        List<FA_ClassesForCallouts.Movie> blacklistedMovies = new List<FA_ClassesForCallouts.Movie>();
        List<Blacklist__c> blacklists = [SELECT
                MovieId__c,
                PosterPath__c,
                ReleaseDate__c,
                OriginalTitle__c,
                Overview__c,
                Name FROM Blacklist__c WHERE OwnerId = :UserInfo.getUserId()];
        for(Blacklist__c black : blacklists) {
            FA_ClassesForCallouts.Movie movie = mapToBlackWrapper(black);
            blacklistedMovies.add(movie);
        }
        return blacklistedMovies;
    }

    public static FA_ClassesForCallouts.Actor mapToActorWrapper(Actor__c actor) {
        FA_ClassesForCallouts.Actor actorWrap = new FA_ClassesForCallouts.Actor();
        actorWrap.profile_path = actor.ProfilePath__c;
        actorWrap.adult = actor.Adult__c;
        actorWrap.popularity = actor.Popularity__c;
        return actorWrap;
    }

    public static FA_ClassesForCallouts.Movie mapToMovieWrapper(Movie__c movie) {
        FA_ClassesForCallouts.Movie movieWrap = new FA_ClassesForCallouts.Movie();
        movieWrap.adult = movie.Adult__c;
        movieWrap.poster_path = movie.PosterPath__c;
        movieWrap.original_language = movie.OriginalLanguage__c;
        movieWrap.original_title = movie.OriginalTitle__c;
        movieWrap.overview = movie.Overview__c;
        movieWrap.release_date = movie.ReleaseDate__c;
        movieWrap.title = movie.Name;
        return movieWrap;
    }

    public static FA_ClassesForCallouts.ReviewAuthor mapToReviewWrapper(Rating__c rating) {
        FA_ClassesForCallouts.ReviewAuthor movieReview = new FA_ClassesForCallouts.ReviewAuthor();
        movieReview.author_details = new FA_ClassesForCallouts.AuthorDetails();
        movieReview.author = rating.CreatedBy.Name;
        movieReview.content = rating.Description__c;
        movieReview.author_details.rating = Double.valueOf(rating.Rating__c);
        return movieReview;
    }

    public static FA_ClassesForCallouts.Movie mapToFavsWrapper(Favourite__c favourite) {
        FA_ClassesForCallouts.Movie movie = new FA_ClassesForCallouts.Movie();
        movie.id = Integer.valueOf(favourite.MovieId__c);
        movie.title = favourite.Name;
        movie.original_title = favourite.OriginalTitle__c;
        movie.overview = favourite.Overview__c;
        movie.poster_path = favourite.poster_path__c;
        movie.release_date = favourite.ReleaseDate__c;
        return movie;
    }

    public static FA_ClassesForCallouts.Movie mapToBlackWrapper(Blacklist__c blacklist) {
        FA_ClassesForCallouts.Movie movie = new FA_ClassesForCallouts.Movie();
        movie.id = Integer.valueOf(blacklist.MovieId__c);
        movie.title = blacklist.Name;
        movie.original_title = blacklist.OriginalTitle__c;
        movie.overview = blacklist.Overview__c;
        movie.poster_path = blacklist.PosterPath__c;
        movie.release_date = blacklist.ReleaseDate__c;
        return movie;
    }
}