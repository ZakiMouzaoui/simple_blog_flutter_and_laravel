class User{
  int? id;
  String? name;
  String? email;
  String? image;
  String? token;

  User({this.id, this.name, this.email, this.image, this.token});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json["id"],
        image: json["image"],
        email: json["email"],
        name: json["name"],
        token: json["token"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "image": image,
      "token": token
    };
  }
}