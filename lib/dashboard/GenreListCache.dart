import 'package:movies_app/model_classes/movie/Genre.dart';

class GenreListCache{
  static final GenreListCache _genreList=GenreListCache._internal();
  List<Genres> _genre=[];
  List<Genres> _TvGenre=[];

  factory GenreListCache(){
    return _genreList;
  }

  GenreListCache._internal();

  void setGenreList(List<Genres> list){
    this._genre=list;
  }

  List<Genres> getGenreList(){
    return _genre;
  }

  void setTVGenreList(List<Genres> list){
    this._TvGenre=list;
  }

  List<Genres> getTVGenreList(){
    return _TvGenre;
  }

  String getGenre(List<int> id) {
    if (id.length > 0) {
      StringBuffer str = StringBuffer();
      for (int i = 0; i < _genre.length; i++) {
        if (id.contains(_genre[i].id)) {
          str.write(_genre[i].name + '/');
        }
      }
      return str.length==0?'':str.toString().replaceRange(str.length - 1, str.length, '');
    }else{
      return '';
    }
  }

  String getTVGenre(List<int> id) {
    if (id.length > 0) {
      StringBuffer str = StringBuffer();
      for (int i = 0; i < _TvGenre.length; i++) {
        if (id.contains(_TvGenre[i].id)) {
          str.write(_TvGenre[i].name + '/');
        }
      }
      return str.length==0?'':str.toString().replaceRange(str.length - 1, str.length, '');
    }else{
      return '';
    }
  }

  List<String> getTvGenreList(List<int> id){
    List<String> list = [];
    if (id.length > 0) {
      for (int i = 0; i < _genre.length; i++) {
        if (id.contains(_genre[i].id)) {
          list.add(_genre[i].name);
        }
      }
    }
    return list;
  }
}