/**
 * Created by bartosz.rozpara on 23.11.2022.
 */

public with sharing class FA_ClassesForCallouts {

    public class Genres {
        @AuraEnabled public Integer id;
        @AuraEnabled public String name;
    }

    public class Countries {
        @AuraEnabled public String iso_3166_1;
        @AuraEnabled public String english_name;
    }

    public class Movie {
        @AuraEnabled public String poster_path;
        @AuraEnabled public Boolean adult;
        @AuraEnabled public String overview;
        @AuraEnabled public String release_date;
        @AuraEnabled public List<Integer> genre_ids;
        @AuraEnabled public Integer id;
        @AuraEnabled public String original_title;
        @AuraEnabled public String original_language;
        @AuraEnabled public String title;
        @AuraEnabled public String backdrop_path;
        @AuraEnabled public Double popularity;
        @AuraEnabled public Integer vote_count;
        @AuraEnabled public Boolean video;
        @AuraEnabled public Double vote_average;
        @AuraEnabled public Attachment attachment;
    }

    public class ActorMovies {
        @AuraEnabled public String character;
        @AuraEnabled public String credit_id;
        @AuraEnabled public String release_date;
        @AuraEnabled public Integer vote_count;
        @AuraEnabled public Boolean video;
        @AuraEnabled public Boolean adult;
        @AuraEnabled public Double vote_average;
        @AuraEnabled public String title;
        @AuraEnabled public List<Integer> genre_ids;
        @AuraEnabled public String original_language;
        @AuraEnabled public String original_title;
        @AuraEnabled public Double popularity;
        @AuraEnabled public Integer id;
        @AuraEnabled public String backdrop_path;
        @AuraEnabled public String overview;
        @AuraEnabled public String poster_path;
    }

    public class MovieResponse {
        @AuraEnabled public Integer page;
        @AuraEnabled public List<Movie> results;
        @AuraEnabled public Integer total_results;
        @AuraEnabled public Integer total_pages;
    }

    public class Actor {
        @AuraEnabled public String profile_path;
        @AuraEnabled public Boolean adult;
        @AuraEnabled public Integer id;
        @AuraEnabled public List<Movie> known_for;
        @AuraEnabled public String name;
        @AuraEnabled public Double popularity;
    }

    public class ActorMoviesResponse {
        @AuraEnabled public List<ActorMovies> actorMovies;
        @AuraEnabled public List<ActorMovieCrew> crew;
        @AuraEnabled public Integer id;
    }

    public class ActorResponse {
        @AuraEnabled public Integer page;
        @AuraEnabled public List<Actor> results;
        @AuraEnabled public Integer total_results;
        @AuraEnabled public Integer total_pages;
    }

    public class MovieCast {
        @AuraEnabled public Boolean adult;
        @AuraEnabled public Integer gender;
        @AuraEnabled public Integer id;
        @AuraEnabled public String known_for_department;
        @AuraEnabled public String name;
        @AuraEnabled public String original_name;
        @AuraEnabled public Double popularity;
        @AuraEnabled public String profile_path;
        @AuraEnabled public Integer cast_id;
        @AuraEnabled public String character;
        @AuraEnabled public String credit_id;
        @AuraEnabled public Integer order;
    }

    public class MovieCrew {
        @AuraEnabled public Boolean adult;
        @AuraEnabled public Integer gender;
        @AuraEnabled public Integer id;
        @AuraEnabled public String known_for_department;
        @AuraEnabled public String name;
        @AuraEnabled public String original_name;
        @AuraEnabled public Double popularity;
        @AuraEnabled public String profile_path;
        @AuraEnabled public String credit_id;
        @AuraEnabled public String department;
        @AuraEnabled public String job;
    }

    public class ActorMovieCrew {
        @AuraEnabled public Integer id;
        @AuraEnabled public String department;
        @AuraEnabled public String original_language;
        @AuraEnabled public String original_title;
        @AuraEnabled public String job;
        @AuraEnabled public String overview;
        @AuraEnabled public Integer vote_count;
        @AuraEnabled public Boolean video;
        @AuraEnabled public String poster_path;
        @AuraEnabled public String backdrop_path;
        @AuraEnabled public String title;
        @AuraEnabled public Double popularity;
        @AuraEnabled public List<Integer> genre_ids;
        @AuraEnabled public Double vote_average;
        @AuraEnabled public Boolean adult;
        @AuraEnabled public String release_date;
        @AuraEnabled public String credit_id;
    }

    public class CastResponse {
        @AuraEnabled public Integer id;
        @AuraEnabled public List<MovieCast> movieCast;
        @AuraEnabled public List<MovieCrew> crew;
    }

    public class ActorDetails {
        @AuraEnabled public String birthday { get; set; }
        @AuraEnabled public String known_for_department { get; set; }
        @AuraEnabled public String deathday { get; set; }
        @AuraEnabled public Integer id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public List<String> also_known_as { get; set; }
        @AuraEnabled public Integer gender { get; set; }
        @AuraEnabled public String biography { get; set; }
        @AuraEnabled public Double popularity { get; set; }
        @AuraEnabled public String place_of_birth { get; set; }
        @AuraEnabled public String profile_path { get; set; }
        @AuraEnabled public String adult { get; set; }
        @AuraEnabled public String imdb_id { get; set; }
        @AuraEnabled public String homepage { get; set; }
    }

    public class AuthorDetails {
        @AuraEnabled public String name;
        @AuraEnabled public String username;
        @AuraEnabled public String avatar_path;
        @AuraEnabled public Double rating;
    }

    public class ReviewAuthor {
        @AuraEnabled public String author;
        @AuraEnabled public AuthorDetails author_details;
        @AuraEnabled public String content;
        @AuraEnabled public String created_at;
        @AuraEnabled public String id;
        @AuraEnabled public String updated_at;
        @AuraEnabled public String url;
    }

    public class MovieReviews {
        @AuraEnabled public Integer id;
        @AuraEnabled public Integer page;
        @AuraEnabled public List<ReviewAuthor> results;
        @AuraEnabled public Integer total_pages;
        @AuraEnabled public Integer total_results;
    }
}