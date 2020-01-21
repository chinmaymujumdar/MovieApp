import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/model_classes/movie/Movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/Constants.dart';
import 'package:movies_app/model_classes/movie/Genre.dart';
import 'package:movies_app/model_classes/movie/GenreList.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/model_classes/movie/UpcomingMovies.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/model_classes/tv_shows/TVShows.dart';

class NetworkCall{

  Future<List<Results>> fetchPopularMovieList(int pageNo)async{
    await fetchGenreList();
    String url = '$kBaseURL/3/movie/popular?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      Movie movie=Movie.fromJson(json.decode(response.body));
      return movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<void> fetchGenreList() async{
    String url= '$kBaseURL/3/genre/movie/list?api_key=$kAPIKey&language=en-US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      GenreList genreList=GenreList.fromJson(json.decode(response.body));
      GenreListCache cache=GenreListCache();
      cache.setGenreList(genreList.genres.map((genre)=>Genres.fromJson(genre.toJson())).toList());
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<Results>> fetchTopRatedMovieList(int pageNo)async{
    String url = '$kBaseURL/3/movie/top_rated?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      Movie movie=Movie.fromJson(json.decode(response.body));
      return movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<Results>> fetchUpcomingMovieList(int pageNo)async{
    String url = '$kBaseURL/3/movie/upcoming?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      UpcomingMovies movie=UpcomingMovies.fromJson(json.decode(response.body));
      return movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<Movie> fetchMorePopularMovies(int pageNo) async{
    String url = '$kBaseURL/3/movie/popular?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Movie.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<Movie> fetchMoreTopRatedMovies(int pageNo) async{
    String url = '$kBaseURL/3/movie/top_rated?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Movie.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<UpcomingMovies> fetchMoreUpcomingMovieList(int pageNo) async{
    String url = '$kBaseURL/3/movie/upcoming?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return UpcomingMovies.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<Movie> fetchMoreSearchResultList(String query,int pageNo)async{
    await fetchGenreList();
    String url = '$kBaseURL/3/search/movie?api_key=$kAPIKey&language=en-US&query=$query&page=$pageNo&include_adult=false&region=US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Movie.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<Results>> fetchRecommendationsMovieList(int movieId)async{
    String url = '$kBaseURL/3/movie/$movieId/recommendations?api_key=$kAPIKey&language=en-US&page=1';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      Movie movie=Movie.fromJson(json.decode(response.body));
      return movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<dynamic> fetchRunTime(int movieId) async{
    String url='$kBaseURL/3/movie/$movieId?api_key=$kAPIKey&language=en-US&append_to_response=videos';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ResultsTV>> fetchOnAirTVShowList(int pageNo) async{
    await fetchTVGenreList();
    String url = '$kBaseURL/3/tv/on_the_air?api_key=$kAPIKey&language=en-US&page=1';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      TVShows tvShows=TVShows.fromJson(json.decode(response.body));
      return tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<void> fetchTVGenreList() async{
    String url= '$kBaseURL/3/genre/tv/list?api_key=$kAPIKey&language=en-US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      GenreList genreList=GenreList.fromJson(json.decode(response.body));
      GenreListCache cache=GenreListCache();
      cache.setTVGenreList(genreList.genres.map((genre)=>Genres.fromJson(genre.toJson())).toList());
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ResultsTV>> fetchPopularTVShowList(int pageNo) async{
    String url = '$kBaseURL/3/tv/popular?api_key=$kAPIKey&language=en-US&page=1';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      TVShows tvShows=TVShows.fromJson(json.decode(response.body));
      return tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ResultsTV>> fetchTopRatedTVShowList(int pageNo) async{
    String url = '$kBaseURL/3/tv/top_rated?api_key=$kAPIKey&language=en-US&page=1';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      TVShows tvShows=TVShows.fromJson(json.decode(response.body));
      return tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> fetchMorePopularTVShowList(int pageNo) async {
    String url = '$kBaseURL/3/tv/popular?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return TVShows.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> fetchMoreTopRatedTVShowList(int pageNo) async{
    String url = '$kBaseURL/3/tv/top_rated?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return TVShows.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> fetchMoreOnAirTVShowList(int pageNo) async{
    await fetchTVGenreList();
    String url = '$kBaseURL/3/tv/on_the_air?api_key=$kAPIKey&language=en-US&page=$pageNo';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return TVShows.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> fetchMoreSearchTVResultList(String query,int pageNo)async{
    await fetchGenreList();
    String url = '$kBaseURL/3/search/tv?api_key=$kAPIKey&language=en-US&query=$query&page=$pageNo&include_adult=false&region=US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return TVShows.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<dynamic> fetchTVDetail(int tvid) async{
    String url='$kBaseURL/3/tv/1396?api_key=$kAPIKey&language=en-US&append_to_response=videos';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }
}