
class UserModel {
  final String email;
  final String image;
  final String username;

  UserModel({required this.email, required this.image, required this.username});

  toJson() {
    return {
      'email': this.email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      image: json['image'],
      username: json['username'],
    );
  }
}
