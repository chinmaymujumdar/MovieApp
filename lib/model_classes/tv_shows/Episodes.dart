import 'Crew.dart';
import 'GuestStars.dart';

class Episodes {
  String airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  double voteAverage;
  int voteCount;
  List<Crew> crew;
  List<GuestStars> guestStars;

  Episodes(
      {this.airDate,
        this.episodeNumber,
        this.id,
        this.name,
        this.overview,
        this.productionCode,
        this.seasonNumber,
        this.showId,
        this.stillPath,
        this.voteAverage,
        this.voteCount,
        this.crew,
        this.guestStars});

  Episodes.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeNumber = json['episode_number'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    productionCode = json['production_code'];
    seasonNumber = json['season_number'];
    showId = json['show_id'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    if (json['crew'] != null) {
      crew = new List<Crew>();
      json['crew'].forEach((v) {
        crew.add(new Crew.fromJson(v));
      });
    }
    if (json['guest_stars'] != null) {
      guestStars = new List<GuestStars>();
      json['guest_stars'].forEach((v) {
        guestStars.add(new GuestStars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air_date'] = this.airDate;
    data['episode_number'] = this.episodeNumber;
    data['id'] = this.id;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['production_code'] = this.productionCode;
    data['season_number'] = this.seasonNumber;
    data['show_id'] = this.showId;
    data['still_path'] = this.stillPath;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    if (this.crew != null) {
      data['crew'] = this.crew.map((v) => v.toJson()).toList();
    }
    if (this.guestStars != null) {
      data['guest_stars'] = this.guestStars.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

