import 'ResultsTV.dart';

class TVShows {
  int page;
  int totalResults;
  int totalPages;
  List<ResultsTV> results;

  TVShows({this.page, this.totalResults, this.totalPages, this.results});

  TVShows.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = new List<ResultsTV>();
      json['results'].forEach((v) {
        results.add(new ResultsTV.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}