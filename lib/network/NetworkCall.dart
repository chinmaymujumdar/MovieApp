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
import 'package:movies_app/model_classes/tv_shows/Season.dart';
import 'package:movies_app/model_classes/tv_shows/Cast.dart';
import 'package:movies_app/model_classes/tv_shows/CastList.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String url='$kBaseURL/3/tv/$tvid?api_key=$kAPIKey&language=en-US&append_to_response=videos';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ResultsTV>> fetchRecommendationsTVList(int tvid)async{
    String url = '$kBaseURL/3/tv/$tvid/recommendations?api_key=$kAPIKey&language=en-US&page=1';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      TVShows tvShows=TVShows.fromJson(json.decode(response.body));
      return tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<Season> fetchSeasonDetails(int seasonId,int seasonNo) async{
    String url='$kBaseURL/3/tv/$seasonId/season/$seasonNo?api_key=$kAPIKey&language=en-US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Season.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<Cast>> fetchCastList(int showId) async{
    String url='$kBaseURL/3/tv/$showId/credits?api_key=$kAPIKey&language=en-US';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      CastList castList=CastList.fromJson(json.decode(response.body));
      return castList.cast.map((item)=>Cast.fromJson(item.toJson())).toList();
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<dynamic> createRequestToken() async{
    String url='$kBaseURL/3/authentication/token/new?api_key=$kAPIKey';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<http.Response> validateRequestViaLogin(String email,String password) async{
    String loginUrl='$kBaseURL/3/authentication/token/validate_with_login?api_key=$kAPIKey';
    dynamic res=await createRequestToken();
    Map<String,String> map=Map();
    map['username']=email;
    map['password']=password;
    map['request_token']=res['request_token'];
    http.Response loginRes=await http.post(loginUrl,body: map);
    if(loginRes.statusCode==200){
      http.Response sessionRes=await createSession(json.decode(loginRes.body)['request_token']);
      return sessionRes;
    }else{
      return loginRes;
    }
  }

  Future<dynamic> createSession(String reqToken) async{
    String url='$kBaseURL/3/authentication/session/new?api_key=$kAPIKey';
    Map<String,String> map=Map();
    map['request_token']=reqToken;
    http.Response response=await http.post(url,body: map);
    return response;
  }

  Future<Movie> getFavourites(int page) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/favorite/movies?api_key=$kAPIKey&session_id=$sessionId&language=en-US&sort_by=created_at.asc&page=$page';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Movie.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> getFavouritesTV(int page) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/favorite/tv?api_key=$kAPIKey&session_id=$sessionId&language=en-US&sort_by=created_at.asc&page=$page';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return TVShows.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<Movie> getWatchMovies(int page) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/watchlist/movies?api_key=$kAPIKey&session_id=$sessionId&language=en-US&sort_by=created_at.asc&page=$page';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return Movie.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<TVShows> getWatchTV(int page) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/watchlist/tv?api_key=$kAPIKey&session_id=$sessionId&language=en-US&sort_by=created_at.asc&page=$page';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return TVShows.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<dynamic> getUserDetail() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account?api_key=$kAPIKey&session_id=$sessionId';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<bool> logoutUser() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/authentication/session?api_key=$kAPIKey';
    Map<String,String> map=Map();
    map['session_id']=sessionId;
    var uri=Uri.parse(url);
    final client=http.Client();
    var request = http.Request("DELETE", uri);
    request.bodyFields=map;
    http.Response response=await client.send(request).then(http.Response.fromStream);
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }

  Future<dynamic> checkForFavWatch(int movieId) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/movie/$movieId/account_states?api_key=$kAPIKey&session_id=$sessionId';
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<bool> addToFavourite(int movieId,bool value) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/favorite?api_key=$kAPIKey&session_id=$sessionId';
    var map=jsonEncode({
      "media_type": "movie",
      "media_id": movieId,
      "favorite": value
    });
    Map<String,String> header=Map();
    header['Content-Type']='application/json;charset=utf-8';
    http.Response response=await http.post(url,body: map,headers:header);
    if((response.statusCode==200&&!value)||(response.statusCode==201&&value)){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> addToWatchlist(int movieId,bool value) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    String url='$kBaseURL/3/account/{account_id}/watchlist?api_key=$kAPIKey&session_id=$sessionId';
    var map=jsonEncode({
      "media_type": "movie",
      "media_id": movieId,
      "watchlist": value
    });
    Map<String,String> header=Map();
    header['Content-Type']='application/json;charset=utf-8';
    http.Response response=await http.post(url,body: map,headers:header);
    if((response.statusCode==200&&!value)||(response.statusCode==201&&value)){
      return true;
    }else{
      return false;
    }
  }
}