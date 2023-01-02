/**
 * Created by bartosz.rozpara on 23.11.2022.
 */

public with sharing class FA_SearchService {
    @AuraEnabled
    public static FA_ClassesForCallouts.ActorResponse searchActors(String actorName, Integer pageActorsNumber) {
        FA_ClassesForCallouts.ActorResponse calloutActors = FA_CalloutService.searchActor(actorName, pageActorsNumber);
//        List<FA_ClassesForCallouts.Actor> soqlActors = FA_SoqlService.getActors(actorName);
//        finalActors.addAll(soqlActors);
        return calloutActors;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieResponse searchMovies(String movieName, Integer pageMoviesNumber) {
        FA_ClassesForCallouts.MovieResponse calloutMovies = FA_CalloutService.searchMovies(movieName, pageMoviesNumber);
//        if(calloutMovies.results.size() < 20) {
//            List<FA_ClassesForCallouts.Movie> soqlMovies = FA_SoqlService.getMovies(movieName);
//            for(Integer i=calloutMovies.results.size(); i<=20; i++) {
//                calloutMovies.results.add(soqlMovies.get(i));
//            }
//        }
        return calloutMovies;
    }

    @AuraEnabled
    public static FA_ClassesForCallouts.MovieReviews searchReviews(Integer movieId) {
        List<FA_ClassesForCallouts.ReviewAuthor> reviewAuthors = FA_SoqlService.getReviews(movieId);
        FA_ClassesForCallouts.MovieReviews movieReviews = FA_CalloutService.getReviews(movieId);
        movieReviews.results.addAll(reviewAuthors);
        return movieReviews;
    }
}