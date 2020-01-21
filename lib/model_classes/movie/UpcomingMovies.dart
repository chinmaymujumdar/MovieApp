import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/model_classes/movie/Dates.dart';

class UpcomingMovies {
  List<Results> results;
  int page;
  int totalResults;
  Dates dates;
  int totalPages;

  UpcomingMovies(
      {this.results,
        this.page,
        this.totalResults,
        this.dates,
        this.totalPages});

  UpcomingMovies.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
    page = json['page'];
    totalResults = json['total_results'];
    dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    if (this.dates != null) {
      data['dates'] = this.dates.toJson();
    }
    data['total_pages'] = this.totalPages;
    return data;
  }
}