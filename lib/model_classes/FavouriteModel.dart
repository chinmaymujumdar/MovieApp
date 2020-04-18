class FavouriteModel{
  String posterPath;
  int id;
  String backdropPath;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  FavouriteModel(
      {this.posterPath,
        this.id,
        this.backdropPath,
        this.genreIds,
        this.title,
        this.voteAverage,
        this.overview,
        this.releaseDate});

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['id']=id;
    map['title']=title;
    map['voteAverage']=voteAverage;
    map['genreIds']=genreIds;
    map['releaseDate']=releaseDate;
    map['overview']=overview;
    map['posterPath']=posterPath;
    map['backdropPath']=backdropPath;
    return map;
  }
}