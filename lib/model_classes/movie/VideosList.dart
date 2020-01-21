import 'package:movies_app/model_classes/movie/Video.dart';

class VideosList {
  List<Video> results;

  VideosList({this.results});

  VideosList.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Video>();
      json['results'].forEach((v) {
        results.add(new Video.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}