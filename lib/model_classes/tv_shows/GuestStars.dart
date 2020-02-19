class GuestStars {
  int id;
  String name;
  String creditId;
  String character;
  int order;
  int gender;
  String profilePath;

  GuestStars(
      {this.id,
        this.name,
        this.creditId,
        this.character,
        this.order,
        this.gender,
        this.profilePath});

  GuestStars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creditId = json['credit_id'];
    character = json['character'];
    order = json['order'];
    gender = json['gender'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['credit_id'] = this.creditId;
    data['character'] = this.character;
    data['order'] = this.order;
    data['gender'] = this.gender;
    data['profile_path'] = this.profilePath;
    return data;
  }
}