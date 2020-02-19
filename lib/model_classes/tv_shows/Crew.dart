class Crew {
  int id;
  String creditId;
  String name;
  String department;
  String job;
  int gender;
  String profilePath;

  Crew(
      {this.id,
        this.creditId,
        this.name,
        this.department,
        this.job,
        this.gender,
        this.profilePath});

  Crew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditId = json['credit_id'];
    name = json['name'];
    department = json['department'];
    job = json['job'];
    gender = json['gender'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['credit_id'] = this.creditId;
    data['name'] = this.name;
    data['department'] = this.department;
    data['job'] = this.job;
    data['gender'] = this.gender;
    data['profile_path'] = this.profilePath;
    return data;
  }
}