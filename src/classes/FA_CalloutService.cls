/**
 * Created by bartosz.rozpara on 21.11.2022.
 */

public with sharing class FA_CalloutService {
    public static Http http;
    public static HttpRequest request;
    public static HttpResponse response;
    public static List<FA_ClassesForCallouts.Movie> popularMovies;
    public static List<FA_ClassesForCallouts.Movie> trendingMovies;

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieResponse getFullPopularMovies(Integer page) {
        FA_ClassesForCallouts.MovieResponse movResp = new FA_ClassesForCallouts.MovieResponse();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/movie/popular?api_key=' + ApiKey__c.getInstance().Key__c + '&language=en-US&page=' + page);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                movResp = (FA_ClassesForCallouts.MovieResponse) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.MovieResponse.class);
                for (Integer i = 0; i < movResp.results.size(); i++) {
                    if (FA_SoqlService.checkIfBlacklist(movResp.results.get(i).id)) {
                        movResp.results.remove(i);
                    }
                }
            }
            for (FA_ClassesForCallouts.Movie movie : movResp.results) {
                if (String.isEmpty(movie.poster_path)) {
                    movie.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    movie.poster_path = 'https://image.tmdb.org/t/p/w500' + movie.poster_path;
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return movResp;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieResponse getTrendingMovies() {
        FA_ClassesForCallouts.MovieResponse movResp = new FA_ClassesForCallouts.MovieResponse();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/trending/movie/day?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                movResp = (FA_ClassesForCallouts.MovieResponse) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.MovieResponse.class);
                for (Integer i = 0; i < movResp.results.size(); i++) {
                    if (FA_SoqlService.checkIfBlacklist(movResp.results.get(i).id)) {
                        movResp.results.remove(i);
                    }
                }
            }
            for (FA_ClassesForCallouts.Movie movie : movResp.results) {
                if (String.isEmpty(movie.poster_path)) {
                    movie.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    movie.poster_path = 'https://image.tmdb.org/t/p/w500' + movie.poster_path;
                }
            }
            trendingMovies = movResp.results;
        } catch (Exception e) {
            throw e;
        }
        return movResp;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieResponse searchMovies(String movieName, Integer page) {
        FA_ClassesForCallouts.MovieResponse movResp = new FA_ClassesForCallouts.MovieResponse();
        movieName = movieName.replace(' ', '+');
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/search/movie?api_key=' + ApiKey__c.getInstance().Key__c + '&query=' + movieName + '&page=' + page + '&include_adult=false');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                movResp = (FA_ClassesForCallouts.MovieResponse) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.MovieResponse.class);
            }
            for (Integer i = 0; i < movResp.results.size(); i++) {
                if (FA_SoqlService.checkIfBlacklist(movResp.results.get(i).id)) {
                    movResp.results.remove(i);
                }
            }
            for (FA_ClassesForCallouts.Movie movie : movResp.results) {
                if (String.isEmpty(movie.poster_path)) {
                    movie.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    movie.poster_path = 'https://image.tmdb.org/t/p/w500' + movie.poster_path;
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return movResp;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.ActorResponse getPopularActors() {
        FA_ClassesForCallouts.ActorResponse actorResp = new FA_ClassesForCallouts.ActorResponse();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/person/popular?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                actorResp = (FA_ClassesForCallouts.ActorResponse) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.ActorResponse.class);
            }
            for (FA_ClassesForCallouts.Actor actor : actorResp.results) {
                if (String.isEmpty(actor.profile_path)) {
                    actor.profile_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    actor.profile_path = 'https://image.tmdb.org/t/p/w500' + actor.profile_path;
                }
                for (FA_ClassesForCallouts.Movie movie : actor.known_for) {
                    if (String.isEmpty(movie.poster_path)) {
                        movie.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                    } else {
                        movie.poster_path = 'https://image.tmdb.org/t/p/w500' + movie.poster_path;
                    }
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return actorResp;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.ActorResponse searchActor(String actorName, Integer page) {
        FA_ClassesForCallouts.ActorResponse actorResp = new FA_ClassesForCallouts.ActorResponse();
        actorName = actorName.replace(' ', '+');
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/search/person?api_key=' + ApiKey__c.getInstance().Key__c + '&query=' + actorName + '&page=' + page + '&include_adult=false');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                actorResp = (FA_ClassesForCallouts.ActorResponse) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.ActorResponse.class);
            }
            for (FA_ClassesForCallouts.Actor actor : actorResp.results) {
                if (String.isEmpty(actor.profile_path)) {
                    actor.profile_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    actor.profile_path = 'https://image.tmdb.org/t/p/w500' + actor.profile_path;
                }
                for (FA_ClassesForCallouts.Movie movie : actor.known_for) {
                    if (String.isEmpty(movie.poster_path)) {
                        movie.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                    } else {
                        movie.poster_path = 'https://image.tmdb.org/t/p/w500' + movie.poster_path;
                    }
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return actorResp;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.CastResponse getCast(Integer movieId) {
        FA_ClassesForCallouts.CastResponse castResponse = new FA_ClassesForCallouts.CastResponse();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/movie/' + movieId + '/credits?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                responseBody = responseBody.replace('"cast":', '"movieCast":');
                castResponse = (FA_ClassesForCallouts.CastResponse) JSON.deserialize(responseBody, FA_ClassesForCallouts.CastResponse.class);
            }
            for (FA_ClassesForCallouts.MovieCast movieCast : castResponse.movieCast) {
                if (String.isEmpty(movieCast.profile_path)) {
                    movieCast.profile_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    movieCast.profile_path = 'https://image.tmdb.org/t/p/w500' + movieCast.profile_path;
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return castResponse;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.ActorDetails getActorDetails(Integer actorId) {
        FA_ClassesForCallouts.ActorDetails actorDetails = new FA_ClassesForCallouts.ActorDetails();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/person/' + actorId + '?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                actorDetails = (FA_ClassesForCallouts.ActorDetails) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.ActorDetails.class);
            }
        } catch (Exception e) {
            throw e;
        }
        return actorDetails;
    }

    @AuraEnabled
    public static List<FA_ClassesForCallouts.ActorMovies> getActorMovies(Integer actorId) {
        FA_ClassesForCallouts.ActorMoviesResponse actMovResp = new FA_ClassesForCallouts.ActorMoviesResponse();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/person/' + actorId + '/movie_credits?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                responseBody = responseBody.replace('"cast":', '"actorMovies":');
                actMovResp = (FA_ClassesForCallouts.ActorMoviesResponse) JSON.deserialize(responseBody, FA_ClassesForCallouts.ActorMoviesResponse.class);
            }
            for (FA_ClassesForCallouts.ActorMovies actorMovies : actMovResp.actorMovies) {
                if (String.isEmpty(actorMovies.poster_path)) {
                    actorMovies.poster_path = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJkEiYPrQDReV2MsB3l-h1GRqqV7DZBd_oRQ&usqp=CAU';
                } else {
                    actorMovies.poster_path = 'https://image.tmdb.org/t/p/w500' + actorMovies.poster_path;
                }
            }
        } catch (Exception e) {
            throw e;
        }
        return actMovResp.actorMovies;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieReviews getReviews(Integer movieId) {
        FA_ClassesForCallouts.MovieReviews movieReviews = new FA_ClassesForCallouts.MovieReviews();
        request = new HttpRequest();
        http = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://api.themoviedb.org/3/movie/' + movieId + '/reviews?api_key=' + ApiKey__c.getInstance().Key__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        try {
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                movieReviews = (FA_ClassesForCallouts.MovieReviews) JSON.deserialize(response.getBody(), FA_ClassesForCallouts.MovieReviews.class);
            }
        } catch (Exception e) {
            throw e;
        }
        return movieReviews;
    }
}